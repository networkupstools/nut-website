#!/bin/sh

# To publish automatically use:
#   export CI_AUTOCOMMIT=true
#   export CI_AUTOPUSH=true
#   export CI_AVOID_RESPIN=true
# Optionally:
#   export NUT_HISTORIC_RELEASE=v2.7.4

[ x"${CI_AUTOCOMMIT-}" = xtrue ] || CI_AUTOCOMMIT=false
[ x"${CI_AUTOPUSH-}" = xtrue ] || CI_AUTOPUSH=false
[ x"${CI_AVOID_RESPIN-}" = xtrue ] || CI_AVOID_RESPIN=false
[ x"${NUT_HISTORIC_RELEASE-}" != x ] || NUT_HISTORIC_RELEASE=""
export CI_AUTOCOMMIT CI_AUTOPUSH CI_AVOID_RESPIN NUT_HISTORIC_RELEASE

LANG=C
LC_ALL=C
TZ=UTC
export LANG LC_ALL TZ

rm -f .git-commit-website || true
# NOTE: This can honour CI_AUTOCOMMIT=true for updating the local git workspace
# and CI_AVOID_RESPIN=true to avoid rebuilds in cases when Git sources did not
# change after a pull of all nut-website and submodule HEADs (returns exit code
# "42" then, to be handled by the caller).
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
case "${NUT_HISTORIC_RELEASE-}" in
"")
	# Not historic, no source files to publish
	{ make -k -j 8 ; echo "===== Finalize make:" >&2; make -s ; } || exit
	;;
0.*|1.*|2.[0123456].*|2.7.[01234].*)
	# NOTE: v2.7.5+ should be okay with parallelized builds of docs etc
	echo "===== Running make dist-files" >&2
	{ make -k dist-sig-files || make dist-files; } || exit
	echo "===== Running make of docs" >&2
	{ make -k ; echo "===== Finalize make:" >&2; make -s ; } || exit
	;;
2.8.*|*)
	echo "===== Running make dist-files" >&2
	{ make -k -j 8 dist-sig-files || make -k -j 8 dist-files || make dist-files; } || exit
	echo "===== Running make of docs" >&2
	{ make -k -j 8 ; echo "===== Finalize make:" >&2; make -s ; } || exit
	;;
esac

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
		# May also be a symlink, making later relative reference to
		# a ../.git-commit-website problematic, hence BUILDDIR below
		# Note that existing custom checkout may have a different
		# origin to "git push" to, which may be good for website PRs :)
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
	BUILDDIR="$PWD"
	( cd networkupstools.github.io || exit
		git add . || exit
		[ -s "$BUILDDIR"/.git-commit-website ] && . "$BUILDDIR"/.git-commit-website || exit
		if $CI_AUTOPUSH ; then
			echo "=== Pushing local copy of networkupstools.github.io to upstream" >&2
			git push || exit
		fi
	)
fi

if [ -n "${NUT_HISTORIC_RELEASE-}" ] ; then
	grep -E "link:.*${NUT_HISTORIC_RELEASE}" historic/index.txt >/dev/null \
	|| echo "WARNING: Prepared historic release ${NUT_HISTORIC_RELEASE} is not listed in historic/index.txt and would not be publicly exposed on the site!" >&2

	PUBSRC="`find ./networkupstools.github.io/source/ -type f -name "*${NUT_HISTORIC_RELEASE}*.tar.gz" -o -name "*${NUT_HISTORIC_RELEASE}*.txt"`" \
	&& [ -n "$PUBSRC" ] \
	&& { echo "INFO: Found published source files:" ; echo "$PUBSRC"; } >&2 \
	|| {
		echo "WARNING: Did not find published source files for ${NUT_HISTORIC_RELEASE}! Copy some under ./networkupstools.github.io/source/ then git add, git commit and git push!" >&2
		find ./source/ -type f -name "*${NUT_HISTORIC_RELEASE}*.tar.gz" -o -name "*${NUT_HISTORIC_RELEASE}*.txt" >&2
		(cd source && git status -u) >&2 || true
	}
fi
