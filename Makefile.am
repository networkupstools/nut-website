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
	--conf-file=$(srcdir)/$(LAYOUT).conf	\
	--attribute icons	\
	--attribute linkcss	\
	--attribute=badges	\
	--attribute=website	\
	--attribute=quirks	\
	--attribute=revision=$(PACKAGE_VERSION)	\
	--attribute tree_version=@TREE_VERSION@	\
	--attribute localdate=`TZ=UTC date +%Y-%m-%d`	\
	--attribute localtime=`TZ=UTC date +%H:%M:%S`	\
	--attribute=date="`TZ=UTC date`"

ASCIIDOC_PARAMS =	\
	$(ADOC_PARAMS_COMMON)	\
	--attribute iconsdir=$(srcdir)/images	\
	--attribute scriptsdir=$(srcdir)/scripts

OUTDIR = output

all:	\
	prerequisites	\
	$(WEBSITE_FILES)	\
	$(FAVICON_FILES)	\
	$(IMAGE_FILES)	\
	$(CABLE_IMAGE_FILES)	\
	$(LAYOUT_FILES)	\
	$(SCRIPT_FILES)	\
	$(DDL_DIR)/index.html	\
	scripts/ups_data.js	\
	ups-html.txt	\
	$(OUTDIR)

# Generate WEBSITE_DEPS & man pages
prerequisites:
	cd nut/docs; $(MAKE) $(AM_MAKEFLAGS) html-chunked pdf
	cd nut/docs/man; $(MAKE) $(AM_MAKEFLAGS) html-man

$(WEBSITE_FILES): $(LAYOUT).conf

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
	$(MKDIR_P) $(OUTDIR)/$(DDL_DIR)
	cp -f $(DDL_DIR)/index.html $(OUTDIR)/$(DDL_DIR)
	manufacturers="$(patsubst $(DDL_DIR)/%/,%,$(MANUFACTURERS))";	\
	for mfr in $${manufacturers}; do	\
		$(MKDIR_P) "$(OUTDIR)/$(DDL_DIR)/$${mfr}/raw";	\
		cp -f $(DDL_DIR)/$${mfr}/*.html $(OUTDIR)/$(DDL_DIR)/$${mfr}/;	\
	done
	rawfiles="$(wildcard $(DDL_DIR)/*/*.dev $(DDL_DIR)/*/*.seq $(DDL_DIR)/*/*.nds)";	\
	for rawfile in $${rawfiles}; do	\
		cp -f "$${rawfile}" "$(OUTDIR)/$${rawfile%/*}/raw/$${rawfile##*/}";	\
	done


clean-local:
	cd nut && $(MAKE) $(AM_MAKEFLAGS) clean
	ddlfiles="$(MFR_TARGETS)	\
		$(MODELS_TARGETS)	\
		$(MODELS_TARGETS_RAW)	\
		$(REPORTS_TARGETS)";	\
	rm -rf	\
		$${ddlfiles}	\
		$(DDL_DIR)/index.{txt,html}	\
		$(WEBSITE_FILES)	\
		$(OUTDIR)	\
		images/	\
		ups-html.txt	\
		scripts/ups_data.js

# HCL depends on:
# - NUT's data/driver.list.in
# - HCL generation tool
# - NUT's manpages
# - DDL manufacturers and models
ups-html.txt scripts/ups_data.js: nut/data/driver.list.in $(srcdir)/tools/nut-hclinfo.py $(MFR_TARGETS) | prerequisites
	cd nut/data && $(MAKE) $(AM_MAKEFLAGS) driver.list
	@if python -c "import json,simplejson,lxml"; then	\
		echo "Regenerating the HTML and JSON formated HCL tables.";	\
		cd tools/ && ./nut-hclinfo.py;	\
	else	\
		echo "----------------------------------------------------------------------";	\
		echo "Warning: either Python, or a required module (json, simplejson, lxml) ";	\
		echo "is not available.";	\
		echo "Skipping the HTML and JSON formated HCL tables regeneration.";	\
		echo "----------------------------------------------------------------------";	\
	fi

index.html: website.txt news.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a index-only $<

acknowledgements.html: nut/docs/acknowledgements.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

cables.html: nut/docs/cables.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

download.html: nut/docs/download.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

documentation.html: nut/docs/documentation.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

features.html: nut/docs/features.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

nut-qa.html: nut/docs/nut-qa.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<

projects.html: projects.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a toc $<

stable-hcl.html: stable-hcl.txt ups-html.txt
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ -a hcl $<

support.html: nut/docs/support.txt
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

# For DDL generation, we need secondary expansion; enable it from now on:
.SECONDEXPANSION:

# File function for backward compatibility (before make 3.82.90); new versions of make won't use this variable since a built-in function with the same name is already defined
# - $(1): operand (> or >>) + file name
# - $(2): text
file = $(shell echo "$(2)" $(firstword $(1)) "$(wordlist 2,$(words $(1)),$(1))")

## DLL settings
# Device Dumps Library directory
DDL_DIR := ddl
# Directories to ignore in DDL
IGNORE_DDL_DIR := .git

## Manufacturers
# -> DDL_DIR/mfr_1/ DDL_DIR/mfr_2/ ... DDL_DIR/mfr_n/
MANUFACTURERS := $(shell export LC_ALL=C && echo -e "$(subst $(SP),\n,$(filter-out $(patsubst %,%/,$(DDL_DIR) $(IGNORE_DDL_DIR)),$(sort $(dir $(wildcard $(DDL_DIR)/*/)))))" | sort -f -)

## Reports
# .{nds,dev} files (DDL_DIR/mfr_n/<manufacturer>__<model>__<driver-name>__<nut-version>__<report-number>.{dev,nds})
# -> DDL_DIR/mfr_n/<manufacturer>__<model>__<driver-name>__<driver-name>__<nut-version>__<report-numver>.{dev,nds}.txt ...
REPORTS_TARGETS := $(addsuffix .txt,$(wildcard $(DDL_DIR)/*/*.dev $(DDL_DIR)/*/*.nds))

# For .dev files, take in consideration also .seq files with the same name, if available
# For both .dev and .nds files, also consider manpages ('prerequisites')
$(REPORTS_TARGETS): $$(patsubst %.txt,%,$$@) $$(wildcard $$(patsubst %.dev.txt,%.seq,$$(filter %.dev.txt,$$@))) $(srcdir)/tools/nut-ddl.py | prerequisites
	$(srcdir)/tools/nut-ddl.py "$<" "$@"

## Pages to build for each model
# DDL_DIR/mfr_n/<model>.txt ...
MODELS_TARGETS_RAW := $(addsuffix .txt,$(foreach MFR,$(MANUFACTURERS),$(addprefix $(MFR),\
$(sort $(foreach RAWFILE,$(basename $(notdir $(wildcard $(MFR)*.dev $(MFR)*.nds))),$(word 2,$(subst __,$(SP),$(RAWFILE)))))\
)))

# Raw asciidoc pages (.txt):
# DDL_DIR/mfr_n/<*model*>.txt: DDL_DIR/mfr_n/<manufacturer>__<*model*>__<driver-name>__<nut-version>__<report-number>.{dev,nds}.txt ...
# note: reports are ordered by NUT's version number (reverse) and then by report number (straight)
$(MODELS_TARGETS_RAW): $$(patsubst %,$$(dir $$@)%.txt,$$(subst @,__,$$(shell export LC_ALL=C && echo -e "$$(subst $$(SP),\n,$$(subst __,@,$$(notdir $$(wildcard $$(dir $$@)*__$$(basename $$(notdir $$@))__*.dev $$(dir $$@)*__$$(basename $$(notdir $$@))__*.nds))))" | sort -f -k 4.1,4.5rV -k 5n -t @ -)))
	$(call file,> $@,= $(subst _,$(SP),$(basename $(notdir $@))))
	$(call file,>> $@,)
	$(call file,>> $@,link:.[Click here] to see reports of other supported models from _$(subst _,$(SP),$(patsubst $(DDL_DIR)/%/,%,$(dir $@)))_.)
	$(call file,>> $@,)
	$(foreach REPORT,$^,$(call file,>> $@,) $(call file,>> $@,include::$(notdir $(REPORT))[]) $(call file,>> $@,))

# DDL_DIR/mfr_n/<model>.html ...
MODELS_TARGETS := $(patsubst %.txt,%.html,$(MODELS_TARGETS_RAW))

# Compiled asciidoc pages (.html):
$(MODELS_TARGETS): $$(patsubst %.html,%.txt,$$@) $(LAYOUT).conf
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L2) --attribute toc -o "$@" "$<"

## Pages to build for each manufacturer
# -> DDL_DIR/mfr_1/index.html ... DDL_DIR/mfr_n/index.html
MFR_TARGETS := $(addsuffix index.html,$(MANUFACTURERS))

# Raw asciidoc pages (.txt)
$(DDL_DIR)/%/index.txt: $$(shell export LC_ALL=C && echo -e "$$(subst $$(SP),\n,$$(addsuffix .html,$$(addprefix $$(DDL_DIR)/$$*/,$$(sort $$(foreach RAWFILE,$$(notdir $$(wildcard $$(DDL_DIR)/$$*/*.dev $$(DDL_DIR)/$$*/*.nds)),$$(word 2,$$(subst __,$$(SP),$$(RAWFILE))))))))" | sort -f -)
	$(call file,> $@,= $(subst _,$(SP),$*))
	$(call file,>> $@,)
	$(call file,>> $@,link:../#_supported_devices[Click here] to see a list of other manufacturers for which reports are available.)
	$(call file,>> $@,)
	$(call file,>> $@,)
	$(call file,>> $@,== Supported models)
	$(call file,>> $@,)
	$(foreach MODEL,$^,$(call file,>> $@,- link:+++$(basename $(notdir $(MODEL))).html+++[$(subst _,$(SP),$(basename $(notdir $(MODEL))))]))

# Compiled asciidoc pages (.html)
$(DDL_DIR)/%/index.html: $(DDL_DIR)/%/index.txt $(LAYOUT).conf
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
	$(foreach MFR,$(MFR_TARGETS),$(call file,>> $@,- link:+++$(patsubst $(DDL_DIR)/%,%,$(MFR))+++[$(subst _,$(SP),$(patsubst $(DDL_DIR)/%/,%,$(dir $(MFR))))]))
	$(call file,>> $@,)
	$(call file,>> $@,)
	$(call file,>> $@,:preamble-only!:)
	$(call file,>> $@,include::$(notdir $<)[])

# Compiled asciidoc page (.html)
$(DDL_DIR)/index.html: $(DDL_DIR)/index.txt $(LAYOUT).conf
	$(ASCIIDOC) $(ADOC_PARAMS_DDL_L1) --attribute toc -o $@ $<

###
