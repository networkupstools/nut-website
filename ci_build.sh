#!/bin/sh

# To publish automatically use:
#   export CI_AUTOCOMMIT=true
#   export CI_AUTOPUSH=true
#   export CI_AVOID_RESPIN=true
# By default we do spellcheck so manually prepared site updates are nice and
# clean (as much as nut/docs/nut.dict file in checked-out version permits)
# but for CI we want that as a separately diagnosed (and non-prohibitive)
# action:
#   export CI_AVOID_SPELLCHECK=true
# Optionally:
#   export NUT_HISTORIC_RELEASE=v2.7.4

[ x"${CI_AUTOCOMMIT-}" = xtrue ] || CI_AUTOCOMMIT=false
[ x"${CI_AUTOPUSH-}" = xtrue ] || CI_AUTOPUSH=false
[ x"${CI_AVOID_RESPIN-}" = xtrue ] || CI_AVOID_RESPIN=false
[ x"${CI_AVOID_SPELLCHECK-}" = xtrue ] || CI_AVOID_SPELLCHECK=false
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
	if [ "${CI_AVOID_SPELLCHECK-}" != true ] ; then
		echo "===== Running spellcheck against modern nut.dict" >&2
		{ make -k -s -j 8 spellcheck 2>/dev/null ; make -sk spellcheck ; } || exit
	fi
	echo "===== Running make of docs" >&2
	{ make -k -j 8 ; echo "===== Finalize make:" >&2; make -s ; } || exit
	;;
0.*|1.*|2.[0123456].*|2.7.[01234].*)
	# NOTE: v2.7.5+ should be okay with parallelized builds of docs etc
	echo "===== Running make dist-files" >&2
	(cd nut && git stash -- docs)
	{ make -k dist-sig-files || make dist-files; } || { (cd nut && git stash pop); exit 1; }
	echo "===== Running make of docs" >&2
	(cd nut && git stash pop)
	{ make -k ; echo "===== Finalize make:" >&2; make -s ; } || exit
	;;
2.8.*|*)
	echo "===== Running make dist-files" >&2
	(cd nut && git stash -- docs)
	{ make -k -j 8 dist-sig-files || make -k -j 8 dist-files || make dist-files; } || { (cd nut && git stash pop); exit 1; }
	echo "===== Running make of docs" >&2
	(cd nut && git stash pop)
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
	rsync -qavPHK ./output/ ./networkupstools.github.io/ || exit
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

	NUT_HISTORIC_RELEASE_NOV="`echo "$NUT_HISTORIC_RELEASE" | sed 's,^v,,'`"
	PUBSRC="`find ./networkupstools.github.io/source/ -type f -name "*${NUT_HISTORIC_RELEASE_NOV}*.tar.gz*" -o -name "*${NUT_HISTORIC_RELEASE_NOV}*.txt"`" \
	&& [ -n "$PUBSRC" ] \
	&& { echo "INFO: Found published source files:" ; echo "$PUBSRC"; } >&2 \
	|| {
		echo "WARNING: Did not find published source files for ${NUT_HISTORIC_RELEASE_NOV}! Copy some under ./networkupstools.github.io/source/ then git add, git commit and git push!" >&2
		find ./source/ ./nut/ -type f -name "*${NUT_HISTORIC_RELEASE_NOV}*.tar.gz*" -o -name "*${NUT_HISTORIC_RELEASE_NOV}*.txt" >&2
		(cd source && git status -u) >&2 || true
	}
fi
