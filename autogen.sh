#! /bin/sh
#
# Autoreconf wrapper script to ensure that the source tree is in a buildable state

spacer="----------------------------------------------------------------------"
echo_spacer() {
	echo "$spacer"
}

quit() {
	echo_spacer
	echo "Unable to build website"
	exit 1
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
echo "Readying NUT"
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
fi

echo "You can now safely configure and build website!"
