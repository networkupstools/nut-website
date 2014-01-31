#! /bin/sh
#
# Autoreconf wrapper script to ensure that the source tree is in a buildable state

spacer="----------------------------------------------------------------------"

function quit () {
	echo "$spacer"
	echo "Unable to build website"
	exit
}

# Initialize submodules and get NUT
echo "Getting NUT"
echo "$spacer"
echo "Initializing the submodules..."
git submodule init || quit
echo "Updating the submodules..."
git submodule update || quit
echo "$spacer"

# Call NUT's autogen.sh to regenerate files needed by NUT's configure:
# - scripts/augeas/nutupsconf.aug.in
# - scripts/hal/ups-nut-device.fdi.in
# - scripts/udev/nut-usbups.rules.in
echo "Readying NUT"
echo "$spacer"
cd nut && ./autogen.sh || quit
cd ..
echo "$spacer"

# Call autoreconf
echo "Readying NUT Website"
echo "$spacer"
echo "Calling autoreconf..."
autoreconf -i || quit
echo "$spacer"

echo "You can now safely configure and build website!"
