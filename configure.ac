dnl +------------------------------------------------------------------+
dnl | Network UPS Tools - Website: configure.in                        |
dnl +------------------------------------------------------------------+

AC_INIT(nut_website, m4_esyscmd_s(cd nut && git describe --tags 2>/dev/null | sed -e 's/^v//' -e 's/-.*//'))
dnl we use macros like AC_CONFIG_MACRO_DIRS (multiple) introduced in 2.70
AC_PREREQ([2.70])

AC_CONFIG_MACRO_DIRS([m4 nut/m4])
echo "Network UPS Tools - Website (NUT version ${PACKAGE_VERSION})"
AM_INIT_AUTOMAKE([foreign no-dist])

dnl NOTE: Macro seems to have some issues carrying over whitespace after
dnl the "--with-doc" entry if pretty whitespace is applied to finish the
dnl code block (end of line, indentations etc). So we use none here!
AX_SUBDIRS_CONFIGURE([nut],
		[[--without-all], [--without-dev], [--without-cgi], [--without-ssl], [--with-doc]])

dnl ----------------------------------------------------------------------

OUTDIR="output"
AC_ARG_WITH(outdir,
	[AS_HELP_STRING([--with-outdir=PATH], [location for current website build (e.g. 'output/historic/v1.2.3')])],
	[AS_CASE(["${withval}"],
		[''], [OUTDIR="output"],
		[OUTDIR="${withval}"]
	)],
	[]
)
AC_SUBST([OUTDIR])

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

TREE_VERSION="`echo "$PACKAGE_VERSION" | awk '{ print substr($0,1,3) }'`"
AC_SUBST(TREE_VERSION)

dnl ----------------------------------------------------------------------

AC_OUTPUT([
	protocols/Makefile
	Makefile
])
