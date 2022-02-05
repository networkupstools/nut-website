#!/bin/sh

# To publish automatically use:
#   export CI_AUTOCOMMIT=true
#   export CI_AUTOPUSH=true
# Optionally:
#   export NUT_HISTORIC_RELEASE=v2.7.4

[ x"${CI_AUTOCOMMIT-}" = xtrue ] || CI_AUTOCOMMIT=false
[ x"${CI_AUTOPUSH-}" = xtrue ] || CI_AUTOPUSH=false
[ x"${NUT_HISTORIC_RELEASE-}" != x ] || NUT_HISTORIC_RELEASE=""
export CI_AUTOCOMMIT CI_AUTOPUSH NUT_HISTORIC_RELEASE

LANG=C
LC_ALL=C
TZ=UTC
export LANG LC_ALL TZ

rm -f .git-commit-website || true
# NOTE: This can honour CI_AUTOCOMMIT=true for updating the local git workspace
echo "=== Running autogen.sh" >&2
./autogen.sh || exit

echo "=== Running configure" >&2
if [ -n "${NUT_HISTORIC_RELEASE}" ]; then
	./configure --with-NUT_HISTORIC_RELEASE="${NUT_HISTORIC_RELEASE}" || exit
else
	./configure || exit
fi

echo "=== Running make" >&2
# NOTE: Initial "make" is not "-s" because it goes silent for too long, uneasy
if [ -n "${NUT_HISTORIC_RELEASE}" ]; then
	# NOTE: v2.7.5+ should be okay with parallelized builds of docs etc
	{ make -k ; echo "===== Finalize make:" >&2; make -s ; } || exit
else
	{ make -k -j 8 ; echo "===== Finalize make:" >&2; make -s ; } || exit
fi

# If we are here, there should be a populated "output" directory
# and there were no build issues
if $CI_AUTOCOMMIT && $CI_AUTOPUSH ; then
	# Did we (try to) change the workspace AND wanted to upstream that?
	# NOTE: Currently relies on interactive mode or saved/env credentials
	# and pushes into the default remote
	echo "=== Pushing local copy of nut-website to upstream" >&2
	git push || exit
fi

if $CI_AUTOPUSH || $CI_AUTOCOMMIT ; then
	if [ -d networkupstools.github.io ] ; then
		echo "=== Updating local copy of networkupstools.github.io from upstream" >&2
		( cd networkupstools.github.io || exit
			git reset --hard || exit
			git pull --all || exit
		)
	else
		echo "=== Creating local copy of networkupstools.github.io from upstream" >&2
		rm -rf networkupstools.github.io || exit
		git clone https://github.com/networkupstools/networkupstools.github.io || exit
	fi

	# Note: no "delete", to avoid dropping e.g. historic sub-site
	# data or ddl/Koenig symlinks
	echo "=== Updating content in local copy of networkupstools.github.io" >&2
	rsync -avPHK ./output/ ./networkupstools.github.io/ || exit
	( cd networkupstools.github.io || exit
		git add . || exit
		[ -s ../.git-commit-website ] && . ../.git-commit-website || exit
		if $CI_AUTOPUSH ; then
			echo "=== Pushing local copy of networkupstools.github.io to upstream" >&2
			git push || exit
		fi
	)
fi
