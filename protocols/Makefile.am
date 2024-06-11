PROTOCOLS_FILES =	\
	apcsmart.html	\
	belkin.html	\
	belkin-protocol.html	\
	belkin-universal.html	\
	fortress.html	\
	huawei-ups2000-modbus.html	\
	megatec.html	\
	minicol.html	\
	oneac.html	\
	optiups.html	\
	sec.html	\
	sec-protocol.html	\
	sec-standard.html	\
	sola.html	\
	us9003.html	\
	voltronic.html	\
	voltronic-qs.html

# CSS based simulated frames layout.
LAYOUT = web-layout

# 'root' attribute declares the relative path of the root directory of the website
ASCIIDOC_PARAMS =	\
	--conf-file=$(top_srcdir)/$(LAYOUT).conf \
	--backend=xhtml11	\
	--attribute icons	\
	--attribute iconsdir=../images	\
	--attribute root=../	\
	--attribute linkcss	\
	--attribute scriptsdir=../scripts	\
	--attribute stylesdir=../css	\
	--attribute=badges	\
	--attribute toc

all: $(PROTOCOLS_FILES)

$(PROTOCOLS_FILES): $(top_srcdir)/$(LAYOUT).conf

clean-local:
	rm -rf $(PROTOCOLS_FILES)

SUFFIXES = .txt .html

.txt.html:
	$(ASCIIDOC) $(ASCIIDOC_PARAMS) -o $@ $<
