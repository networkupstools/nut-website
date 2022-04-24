dnl +------------------------------------------------------------------+
dnl | Network UPS Tools - Website: configure.in                        |
dnl +------------------------------------------------------------------+

AC_INIT(nut_website, m4_esyscmd_s(cd nut && git describe --tags 2>/dev/null | sed -e 's/^v//' -e 's/-\(1\|2\|3\|4\|5\|6\|7\|8\|9\)\(1\|2\|3\|4\|5\|6\|7\|8\|9\|0\)*-g.*//'))
dnl we use macros like AC_CONFIG_MACRO_DIRS (multiple) introduced in 2.70
dnl but apparently backported to 2.69 in some distros (with aclocal-1.16)
AC_PREREQ([2.69])

AC_CONFIG_MACRO_DIRS([m4 nut/m4])
echo "Network UPS Tools - Website (most recently tagged NUT version ${PACKAGE_VERSION})"
AM_INIT_AUTOMAKE([foreign no-dist])

dnl NOTE: Macro seems to have some issues carrying over whitespace after
dnl the "--with-doc" entry if pretty whitespace is applied to finish the
dnl code block (end of line, indentations etc). So we use none here!
AX_SUBDIRS_CONFIGURE([nut],
		[[--without-all], [--without-dev], [--without-cgi], [--without-ssl], [--with-doc]])

dnl ----------------------------------------------------------------------

OUTDIR_BASE="output"
AC_ARG_WITH(outdir-base,
	[AS_HELP_STRING([--with-outdir-base=PATH], [base location for current website build (e.g. 'output'), note NUT_HISTORIC_RELEASE would be in a subdirectory])],
	[AS_CASE(["${withval}"],
		[''], [OUTDIR_BASE="output"],
		[OUTDIR_BASE="${withval}"]
	)],
	[]
)
AC_SUBST([OUTDIR_BASE])
AM_CONDITIONAL([WITH_CUSTOM_OUTDIR_BASE], [test x"${OUTDIR_BASE}" != "xoutput"])

# Not defaulting NUT_HISTORIC_RELEASE as it may be just exported by caller
AC_ARG_WITH(NUT_HISTORIC_RELEASE,
	[AS_HELP_STRING([--with-NUT_HISTORIC_RELEASE=GITTAG], [enable page marking for old release (e.g. 'v2.7.4') and impact actual sub-location for current website build])],
	[AS_CASE(["${withval}"],
		[''], [],
		[NUT_HISTORIC_RELEASE="${withval}"]
	)],
	[]
)
AC_SUBST([NUT_HISTORIC_RELEASE])
AM_CONDITIONAL([WITH_NUT_HISTORIC_RELEASE], [test x"${NUT_HISTORIC_RELEASE}" != x])

dnl Check for AsciiDoc

NUT_CHECK_ASCIIDOC

AS_IF([test -z "${nut_have_asciidoc}"],[
AC_MSG_CHECKING([if asciidoc version can build website (minimum required 8.6.3)])
AX_COMPARE_VERSION([${ASCIIDOC_VERSION}], [ge], [8.6.3], [
	AC_MSG_RESULT(yes)
], [
	AC_MSG_RESULT(no)
	AC_MSG_ERROR(["Unable to build website: check asciidoc!"])
])

AC_MSG_CHECKING([if a2x version can build website (minimum required 8.6.3)])
AX_COMPARE_VERSION([${A2X_VERSION}], [ge], [8.6.3], [
	AC_MSG_RESULT(yes)
], [
	AC_MSG_RESULT(no)
	AC_MSG_ERROR(["Unable to build website: check a2x!"])
])

AC_MSG_CHECKING([if dblatex version can build website (minimum required 0.2.5)])
AX_COMPARE_VERSION([${DBLATEX_VERSION}], [ge], [0.2.5], [
	AC_MSG_RESULT(yes)
], [
	AC_MSG_RESULT(no)
	AC_MSG_ERROR(["Unable to build website: check dblatex!"])
])
], [AC_MSG_NOTICE([Newer NUT sources are in use and suitability of asciidoc and other tools was already tested])
    AS_IF([test "${nut_have_asciidoc}" = "no"],[
	AC_MSG_ERROR(["Unable to build website: check asciidoc and other tools versions!"])
    ])
])

dnl ----------------------------------------------------------------------

AC_PATH_PROGS([ASCIIDOC], [asciidoc], [none])
AC_PATH_PROGS([A2X], [a2x], [none])

dnl ----------------------------------------------------------------------

dnl Note AC_INIT defines a constrained PACKAGE_VERSION based on last tag
dnl in NUT codebase, not its configure.ac version or detailed revision.
dnl For the rolling web-site we want to track origins more precisely:
NUT_VERSION="$(cd nut && git describe --tags 2>/dev/null)"
DDL_VERSION="$(cd ddl && git describe --tags 2>/dev/null)"
WEB_VERSION="$(git describe --tags 2>/dev/null)"
WEB_BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
WEBSITE_VERSION="${PACKAGE_VERSION}"
AS_CASE(["${NUT_VERSION}"],
	[''], [AC_MSG_NOTICE(Seems there was a problem getting NUT_VERSION)],
	[*-*-g*], [dnl e.g. "v2.7.4-130-g20ff10c2" with last tag, count of commits since it in current branch, and latest commit
		WEBSITE_VERSION="nut:${NUT_VERSION} ddl:${DDL_VERSION} web:${WEB_VERSION}-${WEB_BRANCH}"
	],
	[dnl Default: exact tag hit, e.g. "v2.7.4" or "v2.8.0-rc1" for the release site
	 dnl This is a problem for publishing a non-historic site when master HEAD is the most recently tagged commit
	 AS_IF([test -z "${NUT_HISTORIC_RELEASE-}"], [
		WEBSITE_VERSION="nut:${NUT_VERSION} ddl:${DDL_VERSION} web:${WEB_VERSION}-${WEB_BRANCH}"
	 ])
	]
)
AC_SUBST(WEBSITE_VERSION)
AC_SUBST(NUT_VERSION)
AC_SUBST(DDL_VERSION)
AC_SUBST(WEB_VERSION)

dnl ----------------------------------------------------------------------

TREE_VERSION="`echo "$PACKAGE_VERSION" | awk '{ print substr($0,1,3) }'`"
AC_SUBST(TREE_VERSION)

TARBALL_VERSION="`echo "$NUT_VERSION" | sed 's,^v,,'`"
AC_SUBST(TARBALL_VERSION)

dnl ----------------------------------------------------------------------

AC_CONFIG_FILES([
	protocols/Makefile
	Makefile
])

AC_OUTPUT
