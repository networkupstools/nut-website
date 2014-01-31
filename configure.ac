dnl +------------------------------------------------------------------+
dnl | Network UPS Tools - Website: configure.in                        |
dnl +------------------------------------------------------------------+

AC_INIT(nut_website, m4_esyscmd_s(cd nut && git describe --tags 2>/dev/null | sed -e 's/^v//' -e 's/-.*//'))
AC_CONFIG_MACRO_DIR([nut/m4])
echo "Network UPS Tools - Website (NUT version ${PACKAGE_VERSION})"
AM_INIT_AUTOMAKE([foreign no-dist])
AC_CONFIG_SUBDIRS([nut])

dnl ----------------------------------------------------------------------

dnl Check for AsciiDoc

NUT_CHECK_ASCIIDOC

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
