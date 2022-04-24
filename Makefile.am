# NOTE: Syntax relies on GNU Make; YMMV with other implementations

# Also relies on GNU `ln -fsr` options, for historic sub-site publication
LN = ln
#LN = gln

# Tell aclocal in what directory it should look for macros
ACLOCAL_AMFLAGS = -I nut/m4

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

SCRIPT_FILES =	\
	scripts/asciidoc.js	\
	scripts/filter_png.js	\
	scripts/jquery.js	\
	scripts/nut_jquery.js

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

# CSS based simulated frames layout.
LAYOUT = web-layout

ADOC_PARAMS_COMMON =	\
	--backend=xhtml11	\
	--conf-file="$(srcdir)/$(LAYOUT).conf"	\
	--attribute icons	\
	--attribute linkcss	\
	--attribute=badges	\
	--attribute=website	\
	--attribute=quirks	\
	--attribute=revision="$(PACKAGE_VERSION)"	\
	--attribute=webrevision="$(WEBSITE_VERSION)"	\
	--attribute tree_version="@TREE_VERSION@"	\
	--attribute localdate="`TZ=UTC date +%Y-%m-%d`"	\
	--attribute localtime="`TZ=UTC date +%H:%M:%S`"	\
	--attribute=date="`TZ=UTC date`"

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

all:	\
	prerequisites	\
	$(WEBSITE_FILES)	\
	$(FAVICON_FILES)	\
	$(IMAGE_FILES)	\
	$(CABLE_IMAGE_FILES)	\
	$(LAYOUT_FILES)	\
	$(SCRIPT_FILES)	\
	$(HISTORIC_DEPS)	\
	$(HISTORIC_DIR)/index.html	\
	scripts/ups_data.js	\
	ups-html.txt	\
	.git-commit-website	\
	$(OUTDIR)
	@echo "SUCCESS: The website content in output directory is now prepared for deployment." >&2
	@echo "Please see the README for instructions about publishing to master site and" >&2
	@echo "    occasionally updating the news (index.html) on the main site" >&2
	@echo "Comment the commits to master site like this:"
	@cat .git-commit-website
# Regenerate site 2020-12-21 vs nut commit 46c7da76 and nut-website commit f1992f6f

release: dist-files all

# Generate WEBSITE_DEPS & HTML versions of man pages
prerequisites:
	cd nut/docs/man && $(MAKE) $(AM_MAKEFLAGS) html-man
	cd nut/docs && $(MAKE) $(AM_MAKEFLAGS) html-chunked pdf FAQ.html solaris-usb.html

# Generate distribution files and GPG fingerprint (really needed?)
# and copy them in source dir, once (keep old published releases
# immutable by default - let maintainer clean away corrupt attempts)!
dist-files: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz

# Separate chore for maintainers with a key
dist-sig-files: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz.sig

$(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz:
	cd nut && rm -f nut-*.tar.gz*
	cd nut && $(MAKE) $(AM_MAKEFLAGS) dist dist-hash
	$(MKDIR_P) $(SOURCE_DIR)/@TREE_VERSION@
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz $(SOURCE_DIR)/@TREE_VERSION@/
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.md5 $(SOURCE_DIR)/@TREE_VERSION@/
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.sha256 $(SOURCE_DIR)/@TREE_VERSION@/
	cd $(SOURCE_DIR)/@TREE_VERSION@/ && md5sum -c nut-@TARBALL_VERSION@.tar.gz.md5
	cd $(SOURCE_DIR)/@TREE_VERSION@/ && sha256sum -c nut-@TARBALL_VERSION@.tar.gz.sha256
	cp -f nut/NEWS $(SOURCE_DIR)/@TREE_VERSION@/new-$(PACKAGE_VERSION).txt
	cp -f nut/ChangeLog $(SOURCE_DIR)/@TREE_VERSION@/

# Separate chore for maintainers with a key
$(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz.sig: $(SOURCE_DIR)/@TREE_VERSION@/nut-@TARBALL_VERSION@.tar.gz
	cd nut && $(MAKE) $(AM_MAKEFLAGS) dist-sig
	cp -f nut/nut-@TARBALL_VERSION@.tar.gz.sig $(SOURCE_DIR)/@TREE_VERSION@/
	gpg --export -a 0x55CA5976 > $(SOURCE_DIR)/nut-key.gpg

$(WEBSITE_FILES): $(LAYOUT).conf historic-release.txt

images/:
	$(MKDIR_P) images

$(IMAGE_FILES): images/
	cp -f nut/docs/$@ images/

images/cables/:
	$(MKDIR_P) images/cables

$(CABLE_IMAGE_FILES): images/cables/
	cp -f nut/docs/$@ images/cables/

$(OUTDIR):
	$(RM) -r $(OUTDIR)
	$(MKDIR_P) $(OUTDIR)
	cp -fR $(WEBSITE_FILES) images $(FAVICON_FILES) $(OUTDIR)
	$(MKDIR_P) $(OUTDIR)/css
	cp -f $(LAYOUT_FILES) $(OUTDIR)/css/
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
	cd nut && $(MAKE) $(AM_MAKEFLAGS) clean
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
	rm -f *-spellchecked protocols/*-spellchecked
	rm -f tools/nut-ddl.py tools/nut-hclinfo.py
	rm -f historic-release.txt
	rm -f .git-commit-website

# HCL depends on:
# - NUT's data/driver.list.in
# - HCL generation tool
# - NUT's manpages
# - DDL manufacturers and models
ups-html.txt scripts/ups_data.js: nut/data/driver.list.in $(srcdir)/tools/nut-hclinfo.py $(MFR_TARGETS) | prerequisites
	cd nut/data && $(MAKE) $(AM_MAKEFLAGS) driver.list
	@if \
	    python3 -c "import json,lxml"	\
	 || python -c "import simplejson,lxml"	\
	 || python -c "import json,lxml"	\
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
	fi

# Report each rebuild by depending on the Makefile
index.html: website.txt news.txt Makefile $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a index-only $<

acknowledgements.html: nut/docs/acknowledgements.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

cables.html: nut/docs/cables.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

# React to newly published sources
download.html: nut/docs/download.txt source/*/*.tar.gz* $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

documentation.html: nut/docs/documentation.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

features.html: nut/docs/features.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

nut-qa.html: nut/docs/nut-qa.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

projects.html: projects.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

stable-hcl.html: stable-hcl.txt ups-html.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a hcl $<

support.html: nut/docs/support.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

SUFFIXES = .txt .html

.txt.html:
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

.PHONY:	\
	prerequisites	\
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
# For both .dev and .nds files, also consider manpages ('prerequisites')
$(REPORTS_TARGETS): $$(patsubst %.txt,%,$$@) $$(wildcard $$(patsubst %.dev.txt,%.seq,$$(filter %.dev.txt,$$@))) $(srcdir)/tools/nut-ddl.py | prerequisites
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
$(DDL_DIR)/index.html: $(DDL_DIR)/index.txt $(LAYOUT).conf historic-release.txt
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L1) --attribute toc -o $@ $<

###

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
	news.txt  old-news.txt  projects.txt  stable-hcl.txt  ups-protocols.txt  website.txt \
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

### Note: currently the NUT makefiles' implementation of spellcheck rules
### assumes use of its own nut.dict. When it becomes possible to split it
### out, consider adding  NUT_SPELL_DICT="$(NUT_SPELL_DICT)"  to command
### and uncommenting the line below. If you use spellcheck-interactive and
### add some more exceptions, be ready to commit a pull request from the
### "nut" submodule as well (and do revise the changed dictionary so you
### only add words and roll back anything your aspell might remove) and
### to promote the submodule reference from nut-website later on.
#NUT_SPELL_DICT = nut.dict

spellcheck spellcheck-interactive spellcheck-sortdict:
	$(MAKE) -f $(top_builddir)/nut/docs/Makefile SPELLCHECK_SRC="$(SPELLCHECK_SRC)" $@

###
