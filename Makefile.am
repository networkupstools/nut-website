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

ASCIIDOC_PARAMS =	\
	--backend=xhtml11	\
	--conf-file=$(srcdir)/$(LAYOUT).conf	\
	--attribute icons	\
	--attribute iconsdir=$(srcdir)/images	\
	--attribute linkcss	\
	--attribute scriptsdir=$(srcdir)/scripts	\
	--attribute=badges	\
	--attribute=website	\
	--attribute=quirks	\
	--attribute=revision=$(PACKAGE_VERSION)	\
	--attribute tree_version=@TREE_VERSION@	\
	--attribute localdate=`TZ=UTC date +%Y-%m-%d`	\
	--attribute localtime=`TZ=UTC date +%H:%M:%S`	\
	--attribute=date="`TZ=UTC date`"

OUTDIR = output

all:	\
	prerequisites	\
	$(WEBSITE_FILES)	\
	$(FAVICON_FILES)	\
	$(IMAGE_FILES)	\
	$(CABLE_IMAGE_FILES)	\
	$(LAYOUT_FILES)	\
	$(SCRIPT_FILES)	\
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
	cp -fRT protocols/static/ $(OUTDIR)/protocols/

clean-local:
	cd nut && $(MAKE) $(AM_MAKEFLAGS) clean
	rm -rf	\
		$(WEBSITE_FILES)	\
		$(OUTDIR)	\
		images/	\
		ups-html.txt	\
		scripts/ups_data.js

ups-html.txt scripts/ups_data.js: nut/data/driver.list.in
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
