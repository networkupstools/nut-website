# NOTE: Syntax relies on GNU Make; YMMV with other implementations
#
# WARNING: Due to lines which "# HIDE FROM AUTOMAKE #" some GNU syntax which
# conflicts with automake syntax, you must use autogen.sh to re-generate the
# Makefile during development cycles. If you rely on automatic regeneration
# of Makefile.am->Makefile.in->Makefile the resulting file can have crucial
# parts commented away. Alternately, `make unhide-from-automake` after edits.

# CSS based simulated frames layout. The "web-layout" is old design
# used for NUT releases 2.8.0 and before. The "bootstrap" is newer.
LAYOUT = web-layout
# New Bootstrap project based layout, proposed for NUT release 2.8.1
# and later, see https://github.com/networkupstools/nut-website/pull/31
#LAYOUT = bootstrap

# Also relies on GNU `ln -fsr` options, for historic sub-site publication
LN = ln
#LN = gln

# Tell aclocal in what directory it should look for macros
ACLOCAL_AMFLAGS = -I nut/m4

CLEANFILES =

SUBDIRS = protocols

IMAGE_FILES =	\
	images/advanced.png	\
	images/asciidoc.png	\
	images/bigbox.png	\
	images/bizarre.png	\
	images/blue-arrow.png	\
	images/hostedby.png	\
	images/note.png	\
	images/nut-logo.png	\
	images/simple.png	\
	images/warning.png

# Copied below from asciidoc resource location, if available
IMAGE_FILES_ASCIIDOC_ICONS =	\
	images/tip.png

CABLE_IMAGE_FILES =	\
	images/cables/73-0724.png	\
	images/cables/940-0024C.jpg	\
	images/cables/belkin-f6cx-rkm-xu-cable.jpg	\
	images/cables/Lansafecable.jpg	\
	images/cables/mac-940-0024C.png	\
	images/cables/mge-66049.png	\
	images/cables/mge-db9-rj12.jpg	\
	images/cables/mge-db9-rj45.jpg	\
	images/cables/mge-usb-rj45.jpg	\
	images/cables/SOLA-330.png

FAVICON_FILES =	\
	faviconut.ico	\
	faviconut.png

LAYOUT_FILES =	\
	css/ie-overrides.css	\
	css/web-layout.css	\
	css/xhtml11-quirks.css	\
	css/xhtml11.css

BOOTSTRAP_LAYOUT_FILES =	\
	css/nut.css	\
	css/asciidoc-bootstrap.min.css

WEBLAYOUT_SCRIPT_FILES =	\
	scripts/asciidoc.js	\
	scripts/filter_png.js	\
	scripts/jquery.js	\
	scripts/nut_jquery.js

BOOTSTRAP_SCRIPT_FILES =	\
	scripts/nut.js	\
	scripts/bootstrap.min.js	\
	scripts/jquery.min.js \
	scripts/asciidoc.js

# TODO: do we actually need the following?
BOOTSTRAP_SCRIPT_FILES_EXTRA =
	js/html5shiv.min.js	\
	js/respond.min.js
	js/ie8-responsive-file-warning.js
	js/ie-emulation-modes-warning.js
	js/npm.js

SCRIPT_FILES =
# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),bootstrap)
# HIDE FROM AUTOMAKE #SCRIPT_FILES += $(BOOTSTRAP_SCRIPT_FILES)
# HIDE FROM AUTOMAKE #endif
# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),web-layout)
# HIDE FROM AUTOMAKE #SCRIPT_FILES += $(WEBLAYOUT_SCRIPT_FILES)
# HIDE FROM AUTOMAKE #endif

WEBSITE_FILES =	\
	acknowledgements.html	\
	cables.html	\
	documentation.html	\
	download.html	\
	features.html	\
	index.html	\
	nut-qa.html	\
	old-news.html	\
	projects.html	\
	stable-hcl.html	\
	support.html	\
	ups-protocols.html

WEBSITE_DEPS =	\
	index-jumboinfo.html \
	index-jumboinfo-header-$(LAYOUT).html \
	nut/docs/solaris-usb.html	\
	nut/docs/cables.pdf	\
	nut/docs/developer-guide.chunked	\
	nut/docs/developer-guide.pdf	\
	nut/docs/FAQ.html	\
	nut/docs/FAQ.pdf	\
	nut/docs/packager-guide.chunked	\
	nut/docs/packager-guide.pdf	\
	nut/docs/user-manual.chunked	\
	nut/docs/user-manual.pdf

if WITH_NUT_HISTORIC_RELEASE
else
# Since run-up to NUT v2.8.1 [#1953]
WEBSITE_DEPS +=	\
	nut/docs/release-notes.chunked	\
	nut/docs/release-notes.pdf	\
	nut/docs/ChangeLog.chunked	\
	nut/docs/ChangeLog.pdf
endif

BOOTSTRAP_WEBSITE_DEPS = \
	navinfo.html

BOOTSTRAP_WEBSITE_FONTS = \
	fonts/glyphicons-halflings-regular.eot \
	fonts/glyphicons-halflings-regular.svg \
	fonts/glyphicons-halflings-regular.ttf \
	fonts/glyphicons-halflings-regular.woff \
	fonts/glyphicons-halflings-regular.woff2

# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),bootstrap)
# HIDE FROM AUTOMAKE #WEBSITE_DEPS += $(BOOTSTRAP_WEBSITE_DEPS)
# HIDE FROM AUTOMAKE #endif

ADOC_PARAMS_COMMON =	\
	--conf-file="$(srcdir)/$(LAYOUT).conf"	\
	--attribute icons	\
	--attribute linkcss	\
	--attribute=badges	\
	--attribute=website	\
	--attribute=quirks	\
	--attribute=websitelayout="$(LAYOUT)"		\
	--attribute=revision="$(PACKAGE_VERSION)"	\
	--attribute=webrevision="$(WEBSITE_VERSION)"	\
	--attribute tree_version="@TREE_VERSION@"	\
	--attribute localdate="`TZ=UTC date +%Y-%m-%d`"	\
	--attribute localtime="`TZ=UTC date +%H:%M:%S`"	\
	--attribute=date="`TZ=UTC date`"

ADOC_PARAMS_WEB_LAYOUT = \
	--backend=xhtml11

ADOC_PARAMS_BOOTSTRAP = \
	--backend=html5	\
	--attribute lang=en	\
	--attribute totop!	\
	--attribute brand="Network UPS Tools"	\
	--attribute brandref=./	\
	--attribute stylesdir=css	\
	--attribute navbar=fixed	\
	--attribute navinfo1	\
	--attribute favicon	\
	--attribute script=nut.js \
	--attribute bootstrapdir=.

# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),bootstrap)
# HIDE FROM AUTOMAKE #ADOC_PARAMS_COMMON += $(ADOC_PARAMS_BOOTSTRAP)
# HIDE FROM AUTOMAKE #endif
# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),web-layout)
# HIDE FROM AUTOMAKE #ADOC_PARAMS_COMMON += $(ADOC_PARAMS_WEB_LAYOUT)
# HIDE FROM AUTOMAKE #endif

ASCIIDOC_PARAMS =	\
	$(ADOC_PARAMS_COMMON)	\
	--attribute iconsdir=$(srcdir)/images	\
	--attribute scriptsdir=$(srcdir)/scripts

OUTDIR_BASE = @OUTDIR_BASE@
NUT_HISTORIC_RELEASE = @NUT_HISTORIC_RELEASE@

if WITH_NUT_HISTORIC_RELEASE
# Do not build/publish DDL or the HISTORIC_DIR inside historic sub-sites
HISTORIC_DEPS =
OUTDIR = $(OUTDIR_BASE)/$(HISTORIC_DIR)/$(NUT_HISTORIC_RELEASE)

# Embedding a leading space as an HTML entity, otherwise asciidoc strips it:
ADOC_PARAMS_COMMON +=	\
	--attribute=nuttitlesuffix='&\#32;(as of $(NUT_HISTORIC_RELEASE))'
else
HISTORIC_DEPS = \
	$(PACKAGE_DIR_TARGETS)	\
	$(SOURCE_DIR_TARGETS)	\
	$(DDL_DIR)/index.html	\
	$(HISTORIC_DIR)/index.html
OUTDIR = $(OUTDIR_BASE)
ADOC_PARAMS_COMMON +=	\
	--attribute=nuttitlesuffix=""
endif

if WITH_NUT_HISTORIC_RELEASE
.git-commit-website:
	@echo ":; git commit -m 'Regenerate historic $(NUT_HISTORIC_RELEASE) sub-site `date -u +%Y%m%dT%H%M%SZ` vs nut commit `(cd nut && git log -1 --format=%h)`, nut-ddl commit `(cd ddl && git log -1 --format=%h)` and nut-website commit `(git log -1 --format=%h)`'" > .git-commit-website
else
.git-commit-website:
	@echo ":; git commit -m 'Regenerate site `date -u +%Y%m%dT%H%M%SZ` vs nut commit `(cd nut && git log -1 --format=%h)`, nut-ddl commit `(cd ddl && git log -1 --format=%h)` and nut-website commit `(git log -1 --format=%h)`'" > .git-commit-website
endif

# NOTE: These targets are evaluated every time we "make all-files-deps"!
all-files-deps:	\
	.prerequisites_nut_ManHtmlPdf	\
	$(WEBSITE_FILES)	\
	$(FAVICON_FILES)	\
	$(IMAGE_FILES)	\
	$(IMAGE_FILES_ASCIIDOC_ICONS)	\
	$(CABLE_IMAGE_FILES)	\
	$(LAYOUT_FILES)	\
	$(SCRIPT_FILES)	\
	$(HISTORIC_DEPS)	\
	$(HISTORIC_DIR)/index.html	\
	scripts/ups_data.js	\
	ups-html.txt

# ".all-files" is a touch-file used to evaluate if something changed due to a
# run of "make all-files-deps" (or it was a first run since configure/clean).
# A "make .all-files" should always process "make all-files(-deps)" by chain
# of dependencies, but the file itself is not necessarily updated if there
# was in fact nothing new to do in the workspace.
# NOTE: It does expect to be the only writing process running in the workspace
# FIXME: Ensure sequentiality for rules that call this to avoid misfires; but
# impact is low - should not be worse than before this setup was introduced.
CLEANFILES += .all-files.started .all-files
.all-files: | all-files
all-files:
	touch .all-files.started
	+$(MAKE) $(AM_MAKEFLAGS) all-files-deps
	@FOUND="`find '$(abs_top_srcdir)' '$(abs_top_builddir)' -type f -newer .all-files.started | grep -v '$(abs_top_builddir)/output/' | sort | uniq`" || exit ; \
	 if [ ! -e .all-files ] || \
	    [ x"$${FOUND}" != x ] \
	 ; then \
		echo "Touching .all-files: FOUND=$${FOUND}" | tr '\n' ' ' ; echo "" ; \
		touch .all-files ; \
	 fi
	rm -f .all-files.started

# NOTE: OUTDIR depends on "all-files" above, so no extra dependency here
all:	\
	.git-commit-website \
	$(OUTDIR)
	@echo "SUCCESS: The website content in output directory is now prepared for deployment." >&2
	@echo "Please see the README for instructions about publishing to master site and" >&2
	@echo "    occasionally updating the news (index.html) on the main site" >&2
	@echo "Comment the commits to master site like this:"
	@cat .git-commit-website
# Regenerate site 2020-12-21 vs nut commit 46c7da76 and nut-website commit f1992f6f

if WITH_HTMLPROOFER

# NOTE: We do not depend below on "all" or "OUTDIR" because that begins
# rebuilds of the site we have possibly just made. Instead, these rules
# just check whatever exists in the filesystem.

# * --disable_external
#   By default, we avoid looking at remote website availability.
#   This is something we may want to do occasionally (replace dead links
#   by references to new incarnations or archive.org) but not take the
#   performance hit (and annoy others) for every CI run - in that case
#   consider a run with --external_only option to explicitly test that.
# * --allow_hash_href
#   We also allow <a href="#" ...> commonly used in javascript etc.
# * --assume_extension
#   allow extensionles urls (Jekyll3)
HTMLPROOFER_OPTIONS_DEFAULT = \
	--disable_external \
	--allow_hash_href \
	--assume_extension

# CONSIDER:
# * --empty_alt_ignore
#   Temporarily allow empty alt tags on images
# HTMLPROOFER_OPTIONS_DEFAULT += --empty_alt_ignore

# Hide possible externally-rendered references to our own site (treat
# them as relative starting with the slash):
HTMLPROOFER_OPTIONS_URLSWAP = --url-swap='https?\://networkupstools\.github\.io:,https?\://networkupstools\.org:,https?\://www\.networkupstools\.org:'
### HTMLPROOFER_OPTIONS_URLSWAP +=',https?\://[a-zA-Z0-9_.-]+\.networkupstools\.org:'

# Allow the caller an easy override:
HTMLPROOFER_OPTIONS = $(HTMLPROOFER_OPTIONS_DEFAULT) $(HTMLPROOFER_OPTIONS_URLSWAP)

# In newer versions, the nokogiri library complains about US-ASCII locale
HTMLPROOFER_ENV = LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

check-htmlproofer:
	+@case "$(OUTDIR)" in \
		"$(OUTDIR_BASE)"|"$(OUTDIR_BASE)/"*) $(MAKE) $(AM_MAKEFLAGS) check-htmlproofer-OUTDIR_BASE ;; \
		*) $(MAKE) $(AM_MAKEFLAGS) check-htmlproofer-OUTDIR_BASE check-htmlproofer-OUTDIR ;; \
	  esac

check-htmlproofer-OUTDIR:
	test -d $(OUTDIR)
	$(HTMLPROOFER_ENV) $(HTMLPROOFER) $(HTMLPROOFER_OPTIONS) $(OUTDIR)

check-htmlproofer-OUTDIR_BASE:
	test -d $(OUTDIR_BASE)
	$(HTMLPROOFER_ENV) $(HTMLPROOFER) $(HTMLPROOFER_OPTIONS) $(OUTDIR_BASE)

# Fetched/updated via git checkout, e.g. by ci_build.sh
OUTDIR_PUBLISHED = $(abs_top_builddir)/networkupstools.github.io
check-htmlproofer-OUTDIR_PUBLISHED:
	test -d $(OUTDIR_PUBLISHED)
	$(HTMLPROOFER_ENV) $(HTMLPROOFER) $(HTMLPROOFER_OPTIONS) $(OUTDIR_PUBLISHED)

else !WITH_HTMLPROOFER

check-htmlproofer check-htmlproofer-OUTDIR check-htmlproofer-OUTDIR_BASE:
	@echo "Do not have HTMLPROOFER on this system, skipped make target $@" >&2

endif !WITH_HTMLPROOFER

release: dist-files all

if WITH_NUT_HISTORIC_RELEASE
# Only recycle ChangeLog forcefully if an existing file is older than .git
# (leave it up to checked-out version of NUT sources to "make" it or skip
# otherwise). Anyhow, avoid further work if the newly generated ChangeLog
# is identical to the (retained) previous one. The difference is important
# due to time cost of rendering the huge PDF file (perhaps needlessly when
# we "Finalize make" in the end) of 2-10 minutes depending on how busy the
# NUT CI farm agent is.
.prerequisites_nut_ChangeLog_raw:
	+cd nut && \
	    rm -f ChangeLog.bak-nut-website || true ; \
	    if [ -d .git -a -s .git/HEAD ] ; then rm -f `find ChangeLog -not -newer .git/HEAD` || true ; fi && { \
	        if [ -s ChangeLog ] ; then cp -pf ChangeLog ChangeLog.bak-nut-website ; fi ; \
	        $(MAKE) $(AM_MAKEFLAGS) ChangeLog || { rm -f ChangeLog.bak-nut-website ; exit 1 ; } ; \
	        if [ -s ChangeLog.bak-nut-website ] ; then \
	            diff -q ChangeLog ChangeLog.bak-nut-website 2>/dev/null >/dev/null \
	            && mv -f ChangeLog.bak-nut-website ChangeLog \
	            || rm -f ChangeLog.bak-nut-website ; \
	        fi ; \
	    }
else
# Current NUT sources are expected to be smart enough to decide on update
# of the ChangeLog file or its reuse as part of "pdf" etc. targets below.
.prerequisites_nut_ChangeLog_raw:
	@echo "SKIP $@ trickery for current NUT codebase"
endif

# Generate WEBSITE_DEPS & HTML versions of man pages
.prerequisites_nut_ManHtmlPdf: .prerequisites_nut_ChangeLog_raw
	+cd nut/docs/man && $(MAKE) $(AM_MAKEFLAGS) html-man
	+cd nut/docs && $(MAKE) $(AM_MAKEFLAGS) html-chunked pdf FAQ.html solaris-usb.html

# Generate distribution files and GPG fingerprint (really needed?)
# and copy them in source dir, once (keep old published releases
# immutable by default - let maintainer clean away corrupt attempts)!
dist-files: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz

# Separate chore for maintainers with a key
dist-sig-files: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz.sig

$(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz:
	cd nut && rm -f nut-*.tar.gz*
	+cd nut && $(MAKE) $(AM_MAKEFLAGS) dist dist-hash
	$(MKDIR_P) $(SOURCE_DIR)/@TREE_VERSION@
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz $(SOURCE_DIR)/@TREE_VERSION@/
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.md5 $(SOURCE_DIR)/@TREE_VERSION@/
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.sha256 $(SOURCE_DIR)/@TREE_VERSION@/
	cd $(SOURCE_DIR)/@TREE_VERSION@/ && md5sum -c nut-@TARBALL_VERSION@.tar.gz.md5
	cd $(SOURCE_DIR)/@TREE_VERSION@/ && sha256sum -c nut-@TARBALL_VERSION@.tar.gz.sha256
	if test -s nut/NEWS.adoc ; then \
	    cp -f nut/NEWS.adoc $(SOURCE_DIR)/@TREE_VERSION@/new-$(PACKAGE_VERSION).txt ; \
	else \
	    cp -f nut/NEWS $(SOURCE_DIR)/@TREE_VERSION@/new-$(PACKAGE_VERSION).txt ; \
	fi
	cp -f nut/ChangeLog $(SOURCE_DIR)/@TREE_VERSION@/
	if test -s nut/docs/release-notes.pdf ; then \
	    cp -f nut/docs/release-notes.pdf $(SOURCE_DIR)/@TREE_VERSION@/release-notes-$(PACKAGE_VERSION).pdf ; \
	fi
	if test -s nut/docs/ChangeLog.pdf ; then \
	    cp -f nut/docs/ChangeLog.pdf $(SOURCE_DIR)/@TREE_VERSION@/ChangeLog-$(PACKAGE_VERSION).pdf ; \
	fi

# Separate chore for maintainers with a key
$(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz.sig: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz
	+cd nut && $(MAKE) $(AM_MAKEFLAGS) dist-sig
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.sig $(SOURCE_DIR)/@TREE_VERSION@/

# Requires that local system keychain has the needed keys
# TODO: Update with current set of identifiers?
# NOTE: Since 2023 the file in probably maintained manually,
# including older used release keys and ones introduced by JK.
$(SOURCE_DIR)/nut-key.gpg:
	gpg --export -a 0x55CA5976 > $@

$(WEBSITE_FILES): $(LAYOUT).conf historic-release.txt

images/:
	$(MKDIR_P) images

# FIXME: Detect location via configure script?
# The file would be published at least once to the ultimate site...
$(IMAGE_FILES_ASCIIDOC_ICONS): images/
	if [ -d /usr/share/asciidoc ]; then \
		find /usr/share/asciidoc -name "$(@F)" -exec cp -f '{}' images/ \; ; \
	else \
		echo "Can not find ASCIIDOC resource location, skipped $@" ; \
	fi

$(IMAGE_FILES): images/
	cp -f nut/docs/$@ images/

images/cables/:
	$(MKDIR_P) images/cables

$(CABLE_IMAGE_FILES): images/cables/
	cp -f nut/docs/$@ images/cables/

$(OUTDIR): .all-files
	$(RM) -r $(OUTDIR)
	$(MKDIR_P) $(OUTDIR)
	cp -fR $(WEBSITE_FILES) images $(FAVICON_FILES) $(OUTDIR)
	$(MKDIR_P) $(OUTDIR)/css
	cp -f $(LAYOUT_FILES) $(OUTDIR)/css/
	if test x"$(LAYOUT)" = xbootstrap ; then \
		cp -f $(BOOTSTRAP_LAYOUT_FILES) $(OUTDIR)/css/ && \
		$(MKDIR_P) $(OUTDIR)/fonts && \
		cp -f $(BOOTSTRAP_WEBSITE_FONTS) $(OUTDIR)/fonts/ ; \
	fi
	$(MKDIR_P) $(OUTDIR)/docs/man
	cp -fR $(WEBSITE_DEPS) $(OUTDIR)/docs/
	cp -f nut/docs/man/*.html $(OUTDIR)/docs/man/
	$(MKDIR_P) $(OUTDIR)/scripts
	cp -f $(SCRIPT_FILES) scripts/ups_data.js $(OUTDIR)/scripts/
	$(MKDIR_P) $(OUTDIR)/protocols
	cp -f protocols/*.html $(OUTDIR)/protocols/
	cp -fR protocols/images $(OUTDIR)/protocols
	cp -fR protocols/static/* $(OUTDIR)/protocols/
	if [ x"$(NUT_HISTORIC_RELEASE)" = x ]; then	\
		$(MKDIR_P) "$(OUTDIR)/$(HISTORIC_DIR)" &&	\
		cp -f "$(HISTORIC_DIR)/index.html" "$(OUTDIR)/$(HISTORIC_DIR)/index.html" || exit ;	\
		$(MKDIR_P) $(OUTDIR)/$(DDL_DIR) || exit ;	\
		cp -f $(DDL_DIR)/index.html $(OUTDIR)/$(DDL_DIR) || exit ;	\
		manufacturers="$(patsubst $(DDL_DIR)/%/,%,$(MANUFACTURERS))";	\
		for mfr in $${manufacturers}; do	\
			$(MKDIR_P) "$(OUTDIR)/$(DDL_DIR)/$${mfr}/raw" || exit;	\
			cp -f $(DDL_DIR)/$${mfr}/*.html $(OUTDIR)/$(DDL_DIR)/$${mfr}/ || exit;	\
		done ;	\
		rawfiles="$(wildcard $(DDL_DIR)/*/*.dev $(DDL_DIR)/*/*.seq $(DDL_DIR)/*/*.nds)";	\
		for rawfile in $${rawfiles}; do	\
			cp -f "$${rawfile}" "$(OUTDIR)/$${rawfile%/*}/raw/$${rawfile##*/}" || exit;	\
		done || exit ;	\
		$(MKDIR_P) $(patsubst %,"$(OUTDIR)/%",$(PACKAGE_DIRS)) || exit;	\
		for item in $(PACKAGE_DIR_TARGETS) $(PACKAGE_DIR_FILES); do	\
			cp -f "$${item}" "$(OUTDIR)/$${item}";	\
		done || exit ;	\
		$(MKDIR_P) $(patsubst %,"$(OUTDIR)/%",$(SOURCE_DIRS)) || exit;	\
		for item in $(SOURCE_DIR_TARGETS) $(SOURCE_DIR_FILES); do	\
			cp -f "$${item}" "$(OUTDIR)/$${item}";	\
		done || exit ;	\
	else	\
		( cd $(OUTDIR) && $(LN) -fsr $(abs_top_builddir)/$(OUTDIR_BASE)/$(DDL_DIR)/ . ) || exit ; \
		( cd $(OUTDIR) && $(LN) -fsr $(abs_top_builddir)/$(OUTDIR_BASE)/package/ . ) || exit ; \
		( cd $(OUTDIR) && $(LN) -fsr $(abs_top_builddir)/$(OUTDIR_BASE)/source/ . ) || exit ; \
	fi

clean-local:
	+cd nut && $(MAKE) $(AM_MAKEFLAGS) clean
	ddlfiles="$(MFR_TARGETS)	\
		$(subst \%,%,$(MODELS_TARGETS))	\
		$(subst \%,%,$(MODELS_TARGETS_RAW))	\
		$(subst \%,%,$(REPORTS_TARGETS))";	\
	rm -rf	\
		$${ddlfiles}	\
		$(DDL_DIR)/index.txt	\
		$(DDL_DIR)/index.html	\
		$(HISTORIC_DIR)/index.html	\
		$(PACKAGE_DIR_TARGETS_RAW)	\
		$(PACKAGE_DIR_TARGETS)	\
		$(SOURCE_DIR_TARGETS_RAW)	\
		$(SOURCE_DIR_TARGETS)	\
		$(WEBSITE_FILES)	\
		$(OUTDIR)	\
		.git-commit-website     \
		images/	\
		ups-html.txt	\
		scripts/ups_data.js
	git checkout -f images || true
	rm -f *-spellchecked protocols/*-spellchecked nut-website.dict *.usage-report
	rm -f nut-website.dict.bak-pre-sorting nut-website.dict.sorted .nut-website.dict.sorted nut-website.dict.tmp nut-website.bak-pre-interactive
	rm -f tools/nut-ddl.py tools/nut-hclinfo.py
	rm -f historic-release.txt
	rm -f .git-commit-website

# HCL depends on:
# - NUT's data/driver.list.in
# - HCL generation tool
# - NUT's manpages => .prerequisites_nut_ManHtmlPdf
# - DDL manufacturers and models
# Using one intermediate target to avoid two builds of same files
# (and use of corrupted intermediate data) when running parallel.
# The touch-files are used to ensure updates only if something *really* changed
# in the filesystem (always-running a .prerequisites_nut_ManHtmlPdf evaluation
# causes always-running this target too):
CLEANFILES += .prerequisites_hcl .prerequisites_hcl.start
.prerequisites_hcl: nut/data/driver.list.in $(srcdir)/tools/nut-hclinfo.py $(MFR_TARGETS) Makefile | .prerequisites_nut_ManHtmlPdf
	@touch "$@.start"
	@if [ -e .prerequisites_hcl ] ; then \
		FOUND="`find $? nut/docs/man/*.html -newer .prerequisites_hcl -ls`" || exit 0 ; \
		if [ -z "$${FOUND}" ] ; then \
			rm -f "$@.start" ; \
		else \
			echo "Touching $@.start: FOUND=$${FOUND}" | tr '\n' ' ' ; echo "" ; \
		fi ; \
	 fi
	@+if [ -e "$@.start" ] ; then \
		( cd nut/data && $(MAKE) $(AM_MAKEFLAGS) driver.list ) || exit ; \
		if \
		   python3 -c "import json,lxml"	\
		|| python  -c "import simplejson,lxml"	\
		|| python  -c "import json,lxml"	\
		|| python2 -c "import simplejson,lxml"	\
		|| python2 -c "import json,lxml"	\
		; then	\
			echo "Regenerating the HTML and JSON formated HCL tables.";	\
			cd tools/ && ./nut-hclinfo.py;	\
		else	\
			echo "----------------------------------------------------------------------";	\
			echo "Warning: either Python, or a required module (json, simplejson, lxml) ";	\
			echo "is not available.";	\
			echo "Skipping the HTML and JSON formated HCL tables regeneration.";	\
			echo "----------------------------------------------------------------------";	\
		fi ; \
	else \
		echo "SKIP $@: no input files are actually newer than the existing .prerequisites_hcl" >&2 ; \
	fi

# These should be actually generated by nut-hclinfo.py above
# so here we only check they appeared and seem valid (not empty).
# The touch-file ".prerequisites_hcl" would appear AFTER the
# first check for existence and generation of these files, with
# a filesystem timestamp of a moment before they were made (so
# not causing their further re-generation on subsequent runs as
# long as they still exist, or the input files were not updated):
ups-html.txt scripts/ups_data.js: .prerequisites_hcl
	test -s "$(@)"
	@if [ -f .prerequisites_hcl.start ] ; then \
		mv -f .prerequisites_hcl.start .prerequisites_hcl 2>/dev/null || true ; \
	 fi
#touch "$@"

# Report each rebuild by depending on the Makefile
# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),bootstrap)
# HIDE FROM AUTOMAKE #index.html: index.txt news.txt Makefile $(LAYOUT).conf historic-release.txt index-jumboinfo.html index-jumboinfo-header-$(LAYOUT).html
# HIDE FROM AUTOMAKE #	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a index-only -a jumbotron -a jumboinfo $<
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE #ASCIIDOC_TOC_PARAMS = -a toc2 -a toc-placement=right -a toclevels=3
# HIDE FROM AUTOMAKE #endif
# HIDE FROM AUTOMAKE #ifeq ($(strip $(LAYOUT)),web-layout)
# HIDE FROM AUTOMAKE #index.html: index.txt news.txt Makefile $(LAYOUT).conf historic-release.txt index-jumboinfo.html index-jumboinfo-header-$(LAYOUT).html
# HIDE FROM AUTOMAKE #	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a index-only $<
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE #ASCIIDOC_TOC_PARAMS = -a toc
# HIDE FROM AUTOMAKE #endif

acknowledgements.html: nut/docs/acknowledgements.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

cables.html: nut/docs/cables.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $(ASCIIDOC_TOC_PARAMS) $<

# React to newly published sources
download.html: nut/docs/download.txt source/*/*.tar.gz* $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $(ASCIIDOC_TOC_PARAMS) $<

documentation.html: nut/docs/documentation.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

features.html: nut/docs/features.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

nut-qa.html: nut/docs/nut-qa.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

projects.html: projects.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $(ASCIIDOC_TOC_PARAMS) $<

stable-hcl.html: stable-hcl.txt ups-html.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a hcl $<

support.html: nut/docs/support.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

SUFFIXES = .txt .html

.txt.html:
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

.PHONY:	\
	.prerequisites_nut_ManHtmlPdf	\
	.prerequisites_hcl	\
	$(OUTDIR)

### Devices Dumps Library

## AsciiDoc params for DDL
# Docs in DDL dir
ADOC_PARAMS_DDL_L1 =	\
	$(ADOC_PARAMS_COMMON)	\
	--attribute iconsdir=../images	\
	--attribute scriptsdir=../scripts	\
	--attribute stylesdir=../css	\
	--attribute root=../

# Docs in children directories of DDL dir
ADOC_PARAMS_DDL_L2 =	\
	$(ADOC_PARAMS_COMMON)	\
	--attribute iconsdir=../../images	\
	--attribute scriptsdir=../../scripts	\
	--attribute stylesdir=../../css	\
	--attribute root=../../

## Handy things..
# Empty string
EMPTY :=
# A space..
SP := $(EMPTY) $(EMPTY)
# A comma..
COMMA := ,
# Percent sign
PCT := %
# A dollar
DOLLAR := $$

# For DDL generation, we need secondary expansion; enable it from now on:
.SECONDEXPANSION:

# File function for backward compatibility (before make 3.82.90); new versions of make won't use this variable since a built-in function with the same name is already defined
# - $(1): operand (> or >>) + file name
# - $(2): text
file = $(shell echo "$(subst ",\",$(2))" $(firstword $(1)) "$(wordlist 2,$(words $(1)),$(1))")

HISTORIC_DIR := historic

## DDL settings
# Device Dumps Library directory
DDL_DIR := ddl
# Directories to ignore in DDL
IGNORE_DDL_DIR := .git

## Manufacturers
# -> DDL_DIR/mfr_1/ DDL_DIR/mfr_2/ ... DDL_DIR/mfr_n/
MANUFACTURERS := $(shell export LC_ALL=C && printf "%s\n" $(patsubst %,"%",$(filter-out $(patsubst %,%/,$(DDL_DIR) $(IGNORE_DDL_DIR)),$(sort $(dir $(wildcard $(DDL_DIR)/*/))))) | sort -f -)

## Reports
# .{nds,dev} files (DDL_DIR/mfr_n/<manufacturer>__<model>__<driver-name>__<nut-version>__<report-number>.{dev,nds})
# -> DDL_DIR/mfr_n/<manufacturer>__<model>__<driver-name>__<driver-name>__<nut-version>__<report-numver>.{dev,nds}.txt ...
# note: '%'s are backslash-escaped ('\%')
REPORTS_TARGETS := $(subst %,\%,$(addsuffix .txt,$(wildcard $(DDL_DIR)/*/*.dev $(DDL_DIR)/*/*.nds)))

# For .dev files, take in consideration also .seq files with the same name, if available
# For both .dev and .nds files, also consider manpages ('.prerequisites_nut_ManHtmlPdf')
$(REPORTS_TARGETS): $$(patsubst %.txt,%,$$@) $$(wildcard $$(patsubst %.dev.txt,%.seq,$$(filter %.dev.txt,$$@))) $(srcdir)/tools/nut-ddl.py | .prerequisites_nut_ManHtmlPdf
	$(srcdir)/tools/nut-ddl.py "$<" "$@"

## Pages to build for each model
# DDL_DIR/mfr_n/<model>.txt ...
# note: '%'s are backslash-escaped ('\%')
MODELS_TARGETS_RAW := $(subst %,\%,$(addsuffix .txt,$(foreach MFR,$(MANUFACTURERS),$(addprefix $(MFR),\
$(sort $(foreach RAWFILE,$(basename $(notdir $(wildcard $(MFR)*.dev $(MFR)*.nds))),$(word 2,$(subst __,$(SP),$(RAWFILE)))))\
))))

# Raw asciidoc pages (.txt):
# DDL_DIR/mfr_n/<*model*>.txt: DDL_DIR/mfr_n/<manufacturer>__<*model*>__<driver-name>__<nut-version>__<report-number>.{dev,nds}.txt ...
# note: reports are ordered by NUT's version number (reverse) and then by report number (straight)
$(MODELS_TARGETS_RAW): $$(patsubst %,$$(subst %,\%,$$(dir $$@))%.txt,$$(subst @,__,$$(shell export LC_ALL=C && printf "%s\n" $$(patsubst %,"%",$$(subst __,@,$$(notdir $$(wildcard $$(dir $$@)*__$$(basename $$(notdir $$@))__*.dev $$(dir $$@)*__$$(basename $$(notdir $$@))__*.nds)))) | sort -f -k 4.1,4.5r -k 5n -t @ -)))
	$(call file,> $@,= $(subst _,$(SP),$(basename $(notdir $@))))
	$(call file,>> $@,)
	$(call file,>> $@,link:.[Click here] to see reports of other supported models from _$(subst _,$(SP),$(patsubst $(DDL_DIR)/%/,%,$(dir $@)))_.)
	$(call file,>> $@,)
	$(call file,>> $@,[NOTE])
	$(call file,>> $@,====)
	$(call file,>> $@,When a user reports that a variable/command is not right then it will be highlighted by a [nut-ddl-bad-var]#red underline#.)
	$(call file,>> $@,)
	$(call file,>> $@,Bad values/ranges/etc... will get a [nut-ddl-bad-var-value-example]#red dashed outline# or [nut-ddl-bad-string-example]#red solid left border#.)
	$(call file,>> $@,)
	$(call file,>> $@,The accompanying explaining comment - if provided - will be emphasized through a [nut-ddl-bad-var-text-example]#red dotted border# on the left.)
	$(call file,>> $@,====)
	$(call file,>> $@,)
	$(foreach REPORT,$^,$(call file,>> $@,) $(call file,>> $@,include::$(notdir $(REPORT))[]) $(call file,>> $@,))

# DDL_DIR/mfr_n/<model>.html ...
# note: '%'s are backslash-escaped ('\%')
MODELS_TARGETS := $(patsubst %.txt,%.html,$(MODELS_TARGETS_RAW))

# Compiled asciidoc pages (.html):
# FIXME: may need " -a toc2 -a toc-placement=right -a toclevels=3" instead of "-a toc" - see $(ASCIIDOC_TOC_PARAMS)
$(MODELS_TARGETS): $$(patsubst %.html,%.txt,$$@) $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L2) --attribute toc -o "$@" "$<"

## Pages to build for each manufacturer
# -> DDL_DIR/mfr_1/index.html ... DDL_DIR/mfr_n/index.html
MFR_TARGETS := $(addsuffix index.html,$(MANUFACTURERS))

# Raw asciidoc pages (.txt)
$(DDL_DIR)/%/index.txt: $$(shell export LC_ALL=C && printf "$$(PCT)s\n" $$(addsuffix .html",$$(addprefix "$$(DDL_DIR)/$$*/,$$(sort $$(foreach RAWFILE,$$(notdir $$(wildcard $$(DDL_DIR)/$$*/*.dev $$(DDL_DIR)/$$*/*.nds)),$$(word 2,$$(subst __,$$(SP),$$(RAWFILE))))))) | sort -f -)
	$(call file,> $@,= $(subst _,$(SP),$*))
	$(call file,>> $@,)
	$(call file,>> $@,link:../#_supported_devices[Click here] to see a list of other manufacturers for which reports are available.)
	$(call file,>> $@,)
	$(call file,>> $@,)
	$(call file,>> $@,== Supported models)
	$(call file,>> $@,)
	$(foreach MODEL,$^,$(call file,>> $@,- link:+++$(subst %,%25,$(basename $(notdir $(MODEL)))).html+++[$(subst _,$(SP),$(basename $(notdir $(MODEL))))]))

# Compiled asciidoc pages (.html)
$(DDL_DIR)/%/index.html: $(DDL_DIR)/%/index.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L2) -o "$@" "$<"

## DDL home
# Raw asciidoc page (.txt)
$(DDL_DIR)/index.txt: $(DDL_DIR)/README.adoc $(MFR_TARGETS)
	$(call file,> $@,= Devices Dumps Library)
	$(call file,>> $@,:nut-website-root: ../)
	$(call file,>> $@,)
	$(call file,>> $@,:preamble-only:)
	$(call file,>> $@,include::$(notdir $<)[])
	$(call file,>> $@,)
	$(call file,>> $@,)
	$(call file,>> $@,== Supported devices)
	$(call file,>> $@,)
	$(foreach MFR,$(MFR_TARGETS),$(call file,>> $@,- link:+++$(subst %,%25,$(patsubst $(DDL_DIR)/%,%,$(MFR)))+++[$(subst _,$(SP),$(patsubst $(DDL_DIR)/%/,%,$(dir $(MFR))))]))
	$(call file,>> $@,)
	$(call file,>> $@,)
	$(call file,>> $@,:preamble-only!:)
	$(call file,>> $@,include::$(notdir $<)[])

# Compiled asciidoc page (.html)
# FIXME: may need " -a toc2 -a toc-placement=right -a toclevels=3" instead of "-a toc" - see $(ASCIIDOC_TOC_PARAMS)
$(DDL_DIR)/index.html: $(DDL_DIR)/index.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L1) --attribute toc -o $@ $<

###

# FIXME: may need " -a toc2 -a toc-placement=right -a toclevels=3" instead of "-a toc" - see $(ASCIIDOC_TOC_PARAMS)
$(HISTORIC_DIR)/index.html: $(HISTORIC_DIR)/index.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L1) --attribute toc -o $@ $<

### Package and source directories indexer

## Settings
# Package and source directories
PACKAGE_DIR := package
SOURCE_DIR := source
# Directories and files to be ignored in package and source directories and in all their subdirectories recursively
IGNORE_PACKAGESOURCE_DIRS := .git
IGNORE_PACKAGESOURCE_FILES := .gitignore index.html index.txt README.adoc

## Some functions..
# Function that lists subdirectories of a given directory, ignoring any defined subdirectories
# - $(1): directory whose children directories are to be listed
# - $(2): space-separated list of directories to be ignored among children directories
# note: both $(1) and items in $(2) shall not end with a '/'
list_subdirs = $(filter-out $(1)/ $(patsubst %,$(subst %,\%,$(1))/%/,$(2)),$(sort $(dir $(wildcard $(1)/*/))))

# Function that recursively lists all subdirectories (at any nested level) of a given directory, recursively ignoring any defined subdirectories
# - $(1): directory whose subdirectories are to be listed
# - $(2): space-separated list of directories to be recursively ignored among subdirectories
# note: both $(1) and items in $(2) shall not end with a '/'
list_subdirs_recursively = $(sort $(foreach DIR,$(call list_subdirs,$(1),$(2)),$(DIR) $(call list_subdirs_recursively,$(patsubst %/,%,$(DIR)),$(2))))

# Function that lists children files of a directory, ignoring any defined files
# - $(1): directory whose children files are to be listed
# - $(2): space-separated list of file names to be ignored among children files
# note: $(1) shall not end with a '/'
list_children_files = $(addprefix $(1)/,$(filter-out $(2),$(notdir $(wildcard $(1)/*/))))

## Source and package directories and all their subdirectories
# -> PACKAGE_DIR/ PACKAGE_DIR/*/ PACKAGE_DIR/*/*/ ...
# -> SOURCE_DIR/ SOURCE_DIR/*/ SOURCE_DIR/*/*/ ...
PACKAGE_DIRS := $(PACKAGE_DIR)/ $(call list_subdirs_recursively,$(PACKAGE_DIR),$(IGNORE_PACKAGESOURCE_DIRS))
SOURCE_DIRS := $(SOURCE_DIR)/ $(call list_subdirs_recursively,$(SOURCE_DIR),$(IGNORE_PACKAGESOURCE_DIRS))

## All files (NOT directories) that reside under source and package directories and all their subdirectories
# -> PACKAGE_DIR/* PACKAGE_DIR/*/* PACKAGE_DIR/*/*/* ...
# -> SOURCE_DIR/* SOURCE_DIR/*/* SOURCE_DIR/*/*/* ...
PACKAGE_DIR_FILES := $(foreach DIR,$(patsubst %/,%,$(PACKAGE_DIRS)),$(call list_children_files,$(DIR),$(IGNORE_PACKAGESOURCE_FILES)))
SOURCE_DIR_FILES := $(foreach DIR,$(patsubst %/,%,$(SOURCE_DIRS)),$(call list_children_files,$(DIR),$(IGNORE_PACKAGESOURCE_FILES)))

## Index of each directory
# Raw asciidoc indices (.txt)
# -> PACKAGE_DIR/index.txt PACKAGE_DIR/*/index.txt PACKAGE_DIR/*/*/index.txt ...
# -> SOURCE_DIR/index.txt SOURCE_DIR/*/index.txt SOURCE_DIR/*/*/index.txt ...
PACKAGE_DIR_TARGETS_RAW := $(addsuffix index.txt,$(PACKAGE_DIRS))
SOURCE_DIR_TARGETS_RAW := $(addsuffix index.txt,$(SOURCE_DIRS))

# Compiled asciidoc indices (.html)
# -> PACKAGE_DIR/index.html PACKAGE_DIR/*/index.html PACKAGE_DIR/*/*/index.html ...
# -> SOURCE_DIR/index.html SOURCE_DIR/*/index.html SOURCE_DIR/*/*/index.html ...
PACKAGE_DIR_TARGETS := $(addsuffix index.html,$(PACKAGE_DIRS))
SOURCE_DIR_TARGETS := $(addsuffix index.html,$(SOURCE_DIRS))

# Raw asciidoc indices (.txt) for locations not caught by rules above
# Note: if a file named README{.adoc,.txt,} exists in the same directory (precedence in case there are more than one file with different suffixes: README.adoc -> README.txt -> README), it is included in index.txt

# For the sorted listing below, assuming we have the "dir" and "dir/"
# showing up in such order, leave only the slashed variant in place;
# separated because somehow its markup (or length?) in-place confused
# "make":
FILTER_DIRONCE = awk 'BEGIN {o=""} ; { if ($(DOLLAR)0 == o"/") { print $(DOLLAR)0 } else { print o } ; o=$(DOLLAR)0; next; }'

%/index.txt: $$(shell export LC_ALL=C && printf "$$(PCT)s\n" $$(patsubst $$(PCT),"$$(PCT)",$$(filter-out $$(sort $$*/ $$(addprefix $$*/,$$(IGNORE_PACKAGESOURCE_FILES) $$(addsuffix /,$$(IGNORE_PACKAGESOURCE_DIRS)))),$$(wildcard $$*/*/ $$*/*))) | sort -f - | $$(FILTER_DIRONCE) )
	@echo "Generating $@ due to: $^"
	$(call file,> $@,= Index of /$*)
	$(call file,>> $@,:root:		$(subst $(SP),$(EMPTY),$(patsubst %,../,$(subst /,$(SP),$*))))
	$(call file,>> $@,:iconsdir:	{root}images)
	$(call file,>> $@,:scriptsdir:	{root}scripts)
	$(call file,>> $@,:stylesdir:	{root}css)
	$(call file,>> $@,)
	$(call file,>> $@,TIP:	An always up-to-date version of this directory can be found following link:$(subst %,%25,https://github.com/networkupstools/nut-$(firstword $(subst /,$(SP),$*))-archive/tree/master$(patsubst $(subst %,\%,$(firstword $(subst /,$(SP),$*)))%,%,$*))[this link].)
	$(call file,>> $@,)
	$(foreach README,$(if $(wildcard $*/README.adoc),README.adoc,$(if $(wildcard $*/README.txt),README.txt,$(if $(wildcard $*/README),README))),$(call file,>> $@,include::$(README)[]))
	$(call file,>> $@,)
	$(call file,>> $@,[cols="1^m$(COMMA)99m"$(COMMA)grid="rows"$(COMMA)frame="none"])
	$(call file,>> $@,|====)
	$(if $(findstring /,$*),$(call file,>> $@,|..	|link:..[Parent directory]))
	$(foreach ITEM,$(patsubst $(subst %,\%,$*)/%,%,$^),$(call file,>> $@,|$(if $(notdir $(ITEM)),,+)	|link:+++$(subst %,%25,$(ITEM))+++[$(ITEM)]))
	$(call file,>> $@,|====)

# Compiled asciidoc indices (.html)
%/index.html: %/index.txt $$(if $$(wildcard $$*/README.adoc),$$*/README.adoc,$$(if $$(wildcard $$*/README.txt),$$*/README.txt,$$(if $$(wildcard $$*/README),$$*/README))) $(LAYOUT).conf historic-release.txt
	@echo "Generating $@ due to: $^"
	$(ASCIIDOC) $(ADOC_PARAMS_COMMON) -o "$@" "$<"

SPELLCHECK_SRC = \
	README.asciidoc \
	news.txt \
	old-news.txt \
	projects.txt \
	stable-hcl.txt \
	ups-protocols.txt \
	protocols/sec.txt \
	protocols/us9003.txt \
	protocols/sec-protocol.txt \
	protocols/megatec.txt \
	protocols/fortress.txt \
	protocols/voltronic-qs.txt \
	protocols/apcsmart.txt \
	protocols/voltronic.txt \
	protocols/sec-standard.txt \
	protocols/belkin-universal.txt \
	protocols/sola.txt \
	protocols/optiups.txt \
	protocols/belkin-protocol.txt \
	protocols/belkin.txt \
	protocols/minicol.txt \
	protocols/oneac.txt

SPELLCHECK_SRC += index.txt

# NOTE: It is possible that in historic releases "nut" source recipes
# only spell-check *.txt filename patterns. Specifying this input file
# does not hurt but may have no effect then.
SPELLCHECK_SRC += index-jumboinfo.html.in
#SPELLCHECK_SRC += index-jumboinfo-header-$(LAYOUT).html

### Note: historically the NUT makefiles' implementation of spellcheck rules
### assumes use of its own nut.dict. When it became possible to split it
### out, we can add NUT_SPELL_DICT="$(NUT_SPELL_DICT)" to the sub-"make"
### commands below.
### If you use spellcheck-interactive and add some more exceptions, be ready
### to commit a pull request from the "nut" submodule as well (if the custom
### nut-website.dict is not used), and do revise the changed dictionary so
### you only add words and roll back anything your aspell might remove) and
### to promote the submodule reference from nut-website later on.
NUT_SPELL_DICT =
NUT_SPELL_DICT_DEBUGTAG =

# No-op for older releases, use only NUT dict of that era
# (set in stone for old releases anyway)
#
# WARNING: It seems the spellcheck rules were too uncapable
# in NUT v2.7.4 (and the dictionary was just starting)!
#
# FIXME: Might check if 2.8.0 is already capable for this
#  purpose? Not pressing since its nut.dict sufficed at
#  the time of historic website build...
#
# NOTE: Nut source recipes have the variable for quite a
# while, so maybe even older releases can be covered here:
#  20149af7fc (Arnaud Quette   2012-10-10 21:23:15 +0000  91) NUT_SPELL_DICT = nut.dict
#
# GNUmake "if/else/endif" indented to not conflict with automake;
# assignments should be indented too but not with TAB characters!

# HIDE FROM AUTOMAKE # ifeq (,$(strip $(NUT_HISTORIC_RELEASE)))
# HIDE FROM AUTOMAKE #    # Current NUT source du-jour is assumed modern enough
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT +=nut-website.dict
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT_DEBUGTAG +=no-release-$(NUT_HISTORIC_RELEASE)
# HIDE FROM AUTOMAKE # else ifneq (,$(findstring 2.7.,$(strip $(NUT_HISTORIC_RELEASE))))
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT_DEBUGTAG +=2.7.x-$(NUT_HISTORIC_RELEASE)
# HIDE FROM AUTOMAKE # else ifneq (,$(findstring 2.8.0,$(strip $(NUT_HISTORIC_RELEASE))))
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT_DEBUGTAG +=2.8.0-$(NUT_HISTORIC_RELEASE)
# HIDE FROM AUTOMAKE # else
# HIDE FROM AUTOMAKE #    # ...else this historic NUT source (2.8.x or newer) is assumed modern enough
# HIDE FROM AUTOMAKE #    # Practically tested since the NUT v2.8.2 release
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT +=nut-website.dict
# HIDE FROM AUTOMAKE #    NUT_SPELL_DICT_DEBUGTAG +=modern-$(NUT_HISTORIC_RELEASE)
# HIDE FROM AUTOMAKE # endif

# NOTE: Relies on NUT source modern enough to have "spellcheck-sortdict"
# or uses the fallback below upon failure.
# Make rules in many NUT releases included explicit path to NUT sources,
# so we use relative path here and can use absolute for actual aspell calls.
nut-website.dict: $(top_builddir)/nut/docs/nut.dict nut-website.dict.addon
	cat $^ > "$@"
	+(cd "$(abs_top_builddir)/nut/docs/" && $(MAKE) $(AM_MAKEFLAGS) NUT_SPELL_DICT="../../$(@F)" spellcheck-sortdict) \
		|| ( grep -vE '^personal_ws' < "$@" | sort -n | uniq > "$@.tmp" \
			&& ( (echo "personal_ws-1.1 en `wc -l < "$@.tmp"` utf-8"; cat "$@.tmp"; ) > "$@" ) )

# Indented GNUmake "if/else/endif"
# HIDE FROM AUTOMAKE # ifeq (,$(strip $(NUT_SPELL_DICT)))
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE ## Pass to original NUT recipe and its dict file alone
# HIDE FROM AUTOMAKE #NUT_SPELL_DICT_OPTION =
# HIDE FROM AUTOMAKE #spellcheck-sortdict spellcheck-interactive:
# HIDE FROM AUTOMAKE #	@echo "$@ for NUT-source-only NUT_SPELL_DICT (NUT_SPELL_DICT_DEBUGTAG=$(NUT_SPELL_DICT_DEBUGTAG))" >&2
# HIDE FROM AUTOMAKE #	+cd "$(abs_top_builddir)/nut/docs/" && $(MAKE) $(AM_MAKEFLAGS) SPELLCHECK_SRC="$(addprefix ../../,$(SPELLCHECK_SRC))" $@
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE # else
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE #export NUT_SPELL_DICT
# HIDE FROM AUTOMAKE #NUT_SPELL_DICT_OPTION = NUT_SPELL_DICT="../../$(notdir $(strip $(NUT_SPELL_DICT)))" NUT_SPELL_DICT_ABS="$(abs_top_builddir)/$(notdir $(strip $(NUT_SPELL_DICT)))"
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE ## Find unique words in the sorted merged dictionary here vs. (pre-)sorted
# HIDE FROM AUTOMAKE ## dictionary file in NUT source - this difference is the sorted nut-website
# HIDE FROM AUTOMAKE ## specific dictionary.
# HIDE FROM AUTOMAKE #spellcheck-sortdict: nut-website.dict.addon nut-website.dict
# HIDE FROM AUTOMAKE #	@echo "$@ for NUT_SPELL_DICT=$< (NUT_SPELL_DICT_DEBUGTAG=$(NUT_SPELL_DICT_DEBUGTAG))" >&2
# HIDE FROM AUTOMAKE #	LANG=C LC_ALL=C diff -bu nut-website.dict $(top_builddir)/nut/docs/nut.dict \
# HIDE FROM AUTOMAKE #		| grep -E '^-' | grep -Ev '^-(-- |personal_ws)' | sed 's/^-//' \
# HIDE FROM AUTOMAKE #		> nut-website.dict.addon.sorted
# HIDE FROM AUTOMAKE #	@test -s nut-website.dict.addon.sorted || { echo "ERROR: $@ for NUT_SPELL_DICT=$< yielded an empty file; we expect some unique words here!" >&2; exit 1; }
# HIDE FROM AUTOMAKE #	@mv -f nut-website.dict.addon.sorted "$(abs_top_srcdir)/nut-website.dict.addon"
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE #spellcheck-interactive: $(NUT_SPELL_DICT)
# HIDE FROM AUTOMAKE #	@echo "$@ for NUT_SPELL_DICT=$< (NUT_SPELL_DICT_DEBUGTAG=$(NUT_SPELL_DICT_DEBUGTAG))" >&2
# HIDE FROM AUTOMAKE #	cp -f "$(NUT_SPELL_DICT)" "$(NUT_SPELL_DICT).bak-pre-interactive"
# HIDE FROM AUTOMAKE #	+cd "$(abs_top_builddir)/nut/docs/" && $(MAKE) $(AM_MAKEFLAGS) SPELLCHECK_SRC="$(addprefix ../../,$(SPELLCHECK_SRC))" $(NUT_SPELL_DICT_OPTION) $@
# HIDE FROM AUTOMAKE #	diff -bu "$(NUT_SPELL_DICT).bak-pre-interactive" "$(NUT_SPELL_DICT)" | grep -E '^\+[^\+]' | sed 's/^\+//' | grep -vE '^personal_ws' >> "$(abs_top_srcdir)/nut-website.dict.addon"
# HIDE FROM AUTOMAKE #	rm -f "$(NUT_SPELL_DICT).bak-pre-interactive"
# HIDE FROM AUTOMAKE #	+$(MAKE) $(AM_MAKEFLAGS) spellcheck-sortdict-addon
# HIDE FROM AUTOMAKE #
# HIDE FROM AUTOMAKE # endif

# Whether we have a custom dictionary or not:
spellcheck spellcheck-report-dict-usage: $(NUT_SPELL_DICT)
	@echo "$@ for NUT_SPELL_DICT=$< (NUT_SPELL_DICT_DEBUGTAG=$(NUT_SPELL_DICT_DEBUGTAG))" >&2
	+cd "$(abs_top_builddir)/nut/docs/" && $(MAKE) $(AM_MAKEFLAGS) SPELLCHECK_SRC="$(addprefix ../../,$(SPELLCHECK_SRC))" $(NUT_SPELL_DICT_OPTION) $@

# Just sort the addon file, e.g. after dumping key words into it - ported from main NUT
spellcheck-sortdict-addon: nut-website.dict.addon
	@echo "$@ for NUT_SPELL_DICT=$< (NUT_SPELL_DICT_DEBUGTAG=$(NUT_SPELL_DICT_DEBUGTAG))" >&2
	@LANG=C LC_ALL=C sort -n < "$(abs_top_srcdir)/nut-website.dict.addon" > nut-website.dict.addon.sorted
	@mv -f nut-website.dict.addon.sorted "$(abs_top_srcdir)/nut-website.dict.addon"

###

unhide-from-automake: Makefile
	sed -e 's/^# HIDE FROM AUTOMAKE #//' < "$<" > "$<.tmp" && mv -f "$<.tmp" "$<"
