#! /bin/sh
#
# Autoreconf wrapper script to ensure that the source tree is in a buildable state
# To prepare (usually once) a sub-site for a historic release, tell it so:
#   export NUT_HISTORIC_RELEASE=v2.7.4
#   ./autogen.sh && ./configure --with-NUT_HISTORIC_RELEASE="${NUT_HISTORIC_RELEASE}"
# Note: currently this only impacts the checkout of NUT sources - the manpages
# and other docs provided there; the nut-website, nut-ddl and other repos are
# used with their current versions.

spacer="----------------------------------------------------------------------"
echo_spacer() {
	echo "$spacer"
}

quit() {
	echo_spacer
	echo "Unable to build website" >&2
	exit 1
}

inject_historic_note() {
	# Note: only called for singular publishes of static "old release"
	# sites, so not much tested
	local F="$1"
	local HN="$2"

	cat "$F" > "$F.bak" || exit
	i=0
	title=false
	noted=false
	while IFS='' read LINE ; do
		printf '%s\n' "$LINE"
		if $noted ; then
			continue
		fi
		case "$LINE" in
			ifndef::*|ifdef::*) i="`expr $i + 1`" ;;
			endif::*) i="`expr $i - 1`" ;;
			======*|-----*|'~~~~~'*)
				# NOTE: Here we assume we have no blocks up in the file before titles
				title=true
				;;
		esac
		if [ "$i" = 0 ] && $title ; then
			echo ""
			echo "include::${HN}[]"
			echo ""
			noted=true
		fi
	done < "$F.bak" > "$F"
	rm -f "$F.bak"
}

# Some scripts can be used to generate other data, and with python2
# obsoleted (and in some distros, "python" filename as well) we may
# need to explicitly point to the interpreter.
if [ -n "${PYTHON-}" ] ; then
	# May be a name/path of binary, or one with args - check both
	(command -v "$PYTHON") \
	|| $PYTHON -c "import re,glob,codecs" \
	|| {
		echo "----------------------------------------------------------------------"
		echo "WARNING: Caller-specified PYTHON='$PYTHON' is not available."
		echo "----------------------------------------------------------------------"
		# Do not die just here, we may not need the interpreter
	}
else
	PYTHON=""
	for P in python python3 python2 ; do
		if (command -v "$P" >/dev/null) && $P -c "import re,glob,codecs" ; then
			PYTHON="$P"
			break
		fi
	done
fi

case "$PYTHON" in
	*2|*2.*)	PYTHON_VER=2 ;;
	*3|*3.*)	PYTHON_VER=3 ;;
	*python)	PYTHON_VER='' ;;
esac

# Empty PYTHON_VER here leaves "python" in place for the files
( cd tools && \
	find . -type f -name '*.py.in' | \
	while read F ; do
		sed 's,^\(#!/.*pytho\)n$,\1n'"${PYTHON_VER}"',' < "$F" > "`basename "$F" .in`" \
		&& chmod +x "`basename "$F" .in`" || exit
	done
) || exit

# Initialize submodules and get NUT
echo "Getting NUT"
echo_spacer
# Preparation of historic releases (injected notes in docs *.txt)
# could leave the "nut" directory not-init'able. If it exists -
# reset it to some clean commit state.
echo "Rewinding the submodules (if any)..."
git submodule foreach 'git reset --hard' || true
echo "Initializing the submodules..."
git submodule init || quit
echo "Updating the submodules..."
git submodule update || quit
git submodule update --remote --recursive || quit
echo_spacer

# Call NUT's autogen.sh to regenerate files needed by NUT's configure:
# - scripts/augeas/nutupsconf.aug.in
# - scripts/hal/ups-nut-device.fdi.in
# - scripts/udev/nut-usbups.rules.in
if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
	echo "Readying NUT historic release ${NUT_HISTORIC_RELEASE}"
	( cd nut && git checkout "${NUT_HISTORIC_RELEASE}" ) || quit
	cat > historic-release.txt << EOF

[NOTE]
.Two NUT websites
====
This version of the page reflects NUT release '${NUT_HISTORIC_RELEASE}'
with codebase `(cd nut && git log -1 --format='commited %h at %aI')`

Options, features and capabilities in current development (and future
releases) are detailed on the main site and may differ from ones
described here.
====

EOF
	( cd nut/docs && for TF in *.txt ; do
		inject_historic_note "$TF" "../../historic-release.txt" || exit
	  done ) || exit
	( cd nut/docs/man && for TF in *.txt ; do
		inject_historic_note "$TF" "../../../historic-release.txt" || exit
	  done ) || exit
	# Newer asciidoc cares about CLI syntax more than the old one:
	( cd nut/docs && \
	  sed 's/--xsltproc-opts "/--xsltproc-opts="/' \
	    -i Makefile.am
	) || exit

	# NOTE: NUT 2.7.5+ should detect this on its own; older ones need help
	case "${NUT_HISTORIC_RELEASE}" in
	v2.7.{5,6,7,8,9}|v{3,4,5,6,7,8,9}.*|master) ;;
	*)
		if ! command -v python ; then
			if [ -n "$PYTHON_VER" ] ; then
				( cd nut && \
					find . -type f -name '*.py' -o -name '*.py.in' \
					-exec sed 's,^\(#!/.*pytho\)n$,\1n'"${PYTHON_VER}"',' -i '{}' \; \
				) || exit
			fi
		fi
		;;
	esac
else
	echo "Readying NUT (current development)"
	# This file is included in a few nut-website "root" templates as well,
	# e.g. into "stable-hcl.txt" listing the nut/data/device.list contents.
	cat /dev/null > historic-release.txt
fi
echo_spacer
( cd nut && ./autogen.sh ) || quit
echo_spacer

# Call autoreconf
echo "Readying NUT Website"
echo_spacer
echo "Calling autoreconf..."
autoreconf -i || quit
echo_spacer

if [ -n "`git status -uno -s`" ]; then
	echo "NOTE: Git sources for this repository have changed:"
	git status -s -uno
	echo "If you are a website maintainer, please commit updated submodule"
	echo "references first, before building the site for publication:"
	echo ":; git add nut ddl source package && git commit -m 'Updated submodule references as of `date -u +%Y%m%dT%H%M%SZ`: nut:`(cd nut && git log -1 --format=%h)` nut-ddl:`(cd ddl && git log -1 --format=%h)` source:`(cd source && git log -1 --format=%h)` package:`(cd package && git log -1 --format=%h)`'"
	if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
		echo "NOTE: You were building website for NUT historic release ${NUT_HISTORIC_RELEASE}"
	fi
fi

echo "You can now safely configure and build website!"
if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
	echo "...with: ./configure --with-NUT_HISTORIC_RELEASE=${NUT_HISTORIC_RELEASE} && { make -k ; make ; }"
else
	echo "...with: ./configure && { make -k -j 8 ; make ; }"
fi
