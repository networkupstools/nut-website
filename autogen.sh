#!/usr/bin/env bash
#
# Autoreconf wrapper script to ensure that the source tree is in a buildable state
# To automatically commit references to regenerated content, first:
#   export CI_AUTOCOMMIT=true
# To skip re-generation if there were no git changes in this or component repos:
#   export CI_AVOID_RESPIN=true
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

	# To make life hard, some man pages have only a NAME section and
	# others also SYNOPSIS chapter (must be next after NAME)...
	# We should add the historic note as a section after all of these.
	# Technically, we want it as high at top as possible, so we either
	# add the NOTE block just after SYNOPSIS title, or add a new named
	# section with the block just after the NAME section (if there is
	# no SYNPOSIS in that file).
	local ISMAN=false
	local HAS_SYNOPSIS=false
	if head -1 "$F" | grep -E '\([0-9]\)$' >/dev/null ; then
		ISMAN=true
	fi
	if grep -E '^SYNOPSIS$' "$F" >/dev/null ; then
		ISMAN=true
		HAS_SYNOPSIS=true
	fi

	local i=0
	local title=false
	local noted=false
	# In a manpage txt source, the NAME and its body must be first
	# meaningful lines after the TITLE(NUM) heading; any metacommands
	# for asciidoc markup should come later; any sections after an
	# optional SYNOPSIS (if present):
	local manname=false
	local mannamebody=false
	local mansynopsis=false

	local canprint=false

	local PREVLINE=''
	while IFS='' read -r LINE ; do
		printf '%s\n' "$LINE"
		if $noted ; then
			continue
		fi
		case "$LINE" in
			ifndef::*|ifdef::*) i="`expr $i + 1`" ;;
			endif::*) i="`expr $i - 1`" ;;
			NAME) if $ISMAN ; then manname=true; fi ;;
			SYNOPSIS) if $ISMAN ; then mansynopsis=true; fi ;;
			====*|----*|'~~~~'*)
				if ! $ISMAN ; then
					# NOTE: Here we assume we have no blocks up in the file before titles
					canprint=true
				else
					if ! $HAS_SYNOPSIS && $manname ; then
						title=true
					elif $HAS_SYNOPSIS && $mansynopsis ; then
						title=true
					fi
				fi
				;;
			"") # blank lines are separators
				if $ISMAN && $title ; then
					if ! $HAS_SYNOPSIS && $manname && $mannamebody ; then
						canprint=true
					elif $HAS_SYNOPSIS && $mansynopsis ; then
						canprint=true
					fi
				fi
				;;
			*) # Other text/markup/metacommands...
				if $ISMAN && $manname && $title && ! $mannamebody ; then
					mannamebody=true
				fi
				;;
		esac
		if [ "$i" = 0 ] && $canprint ; then
			echo ""
			if $ISMAN && ! $HAS_SYNOPSIS ; then
				echo "NOTE ABOUT HISTORIC NUT RELEASE"
				echo "-------------------------------"
				echo ""
			fi
			echo "include::${HN}[]"
			echo ""
			noted=true
		fi
		PREVLINE="$LINE"
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
git submodule foreach 'git checkout -f' || true
echo "Initializing the submodules..."
git submodule init || quit
echo "Updating the submodules..."
git submodule update || quit
git submodule update --remote --recursive || quit
git submodule foreach 'git fetch --tags' || true
echo_spacer

# Call NUT's autogen.sh to regenerate files needed by NUT's configure:
# - scripts/augeas/nutupsconf.aug.in
# - scripts/hal/ups-nut-device.fdi.in
# - scripts/udev/nut-usbups.rules.in
if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
	echo "Readying NUT historic release ${NUT_HISTORIC_RELEASE}"
	( cd nut && git checkout "${NUT_HISTORIC_RELEASE}" ) || quit

	grep -E "link:.*${NUT_HISTORIC_RELEASE}" historic/index.txt >/dev/null \
	|| {
		echo ''
		echo "WARNING: Prepared historic release ${NUT_HISTORIC_RELEASE} is not listed in historic/index.txt and would not be publicly exposed on the site!"
		echo ''
		sleep 3
	} >&2

	sed -e 's/\(AC_INIT([^,]*\),\([^,]*\),/\1,['"`echo "${NUT_HISTORIC_RELEASE}" | sed 's,^v,,'`"'],/' \
		-i nut/configure.ac

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

	# TODO: This injects the NOTE above into each file, so there
	# would likely be many copies in single-file docs (non-chunked
	# HTML, and PDF). Fiddle with `ifdef::SOMETHING[]` to manage
	# that visibility only into starting documents of big stacks.
	( cd nut/docs && for TF in *.txt ; do
		inject_historic_note "$TF" "../../historic-release.txt" || exit
	  done ) || exit
	( cd nut/docs/man && for TF in *.txt ; do
		# Common text included into other man page files:
		case "$TF" in
			blazer-common.txt) continue ;;
		esac
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
	# Nullify it, but only if not empty yet (spurious make dependencies):
	if [ -s historic-release.txt ] || [ ! -e historic-release.txt ]; then
		cat /dev/null > historic-release.txt
	fi
fi
echo_spacer
echo "Description of checked-out NUT codebase since latest Git tag, and derived PACKAGE_VERSION:"
(cd nut && git describe --tags 2>/dev/null)
(cd nut && git describe --tags 2>/dev/null | sed -e 's/^v//' -e 's/-\(1\|2\|3\|4\|5\|6\|7\|8\|9\)\(1\|2\|3\|4\|5\|6\|7\|8\|9\|0\)*-g.*//')
( cd nut && ./autogen.sh ) || quit
echo_spacer

# Call autoreconf
echo "Readying NUT Website"
echo_spacer
echo "Calling autoreconf..."
autoreconf -ifv || quit
echo_spacer

if [ -n "`git status -uno -s`" ] ; then
	echo "NOTE: Git sources for this repository have changed:"
	git status -s -uno

	if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
		echo "NOTE: You were building website for NUT historic release ${NUT_HISTORIC_RELEASE}"
	else
		if [ x"${CI_AUTOCOMMIT-}" = xtrue ]; then
			echo "Committing updated submodule references before building the site for publication:"
		else
			echo "If you are a website maintainer, please commit updated submodule"
			echo "references first, before building the site for publication:"
		fi

		echo ":; git add nut ddl source package && git commit -m 'Updated submodule references as of `date -u +%Y%m%dT%H%M%SZ`: nut:`(cd nut && git log -1 --format=%h)` nut-ddl:`(cd ddl && git log -1 --format=%h)` source:`(cd source && git log -1 --format=%h)` package:`(cd package && git log -1 --format=%h)`'"
		if [ x"${CI_AUTOCOMMIT-}" = xtrue ]; then
			git add nut ddl source package \
			&& git commit -m "Updated submodule references as of `date -u +%Y%m%dT%H%M%SZ`: nut:`(cd nut && git log -1 --format=%h)` nut-ddl:`(cd ddl && git log -1 --format=%h)` source:`(cd source && git log -1 --format=%h)` package:`(cd package && git log -1 --format=%h)`" \
			|| quit
		fi
	fi
else
	# No git changes
	if [ "${CI_AVOID_RESPIN-}" = "true" ]; then
		echo "SKIP: Git sources for this repository (or submodules) have not changed" >&2
		exit 42
	fi
fi

echo "You can now safely configure and build website!"
if [ -n "${NUT_HISTORIC_RELEASE-}" ]; then
	echo "...with: ./configure --with-NUT_HISTORIC_RELEASE=${NUT_HISTORIC_RELEASE} && { (cd nut && git stash -- docs) ; make -k dist-sig-files || make dist-files; } && { (cd nut && git stash pop); make -k ; make ; }"
else
	echo "...with: ./configure && { make -k -j 8 ; make ; }"
fi
