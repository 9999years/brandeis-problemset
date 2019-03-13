VERSION := 2019\/03\/13 0.5.2
PACKAGE := brandeis-problemset

ROOT_DIR := $(CURDIR)
DIST_FILES := ${PACKAGE}.cls ${PACKAGE}.sty
DOC_FILES := ${PACKAGE}.tex \
	example.tex \
	LICENSE.txt README.md
DIST_PDF := example.pdf ${PACKAGE}.pdf
NEEDS_LATEXMK := example.tex ${PACKAGE}.tex

NEEDS_ESCAPE := ${PACKAGE}.cls ${PACKAGE}.sty ${PACKAGE}.tex
ESCAPE_VERSION := sed -e 's/\$${VERSION}\$$/${VERSION}/' -i

# Simple OS detection for Make on Cygwin...
UNAME := $(shell uname -o)
ifeq ($(UNAME), Cygwin)
	# use the windows home folder rather than the cygwin one
	HOME := $(shell cygpath ${USERPROFILE})
endif

TEXMF_ROOT := ${HOME}/texmf
INSTALL_DIR := $(TEXMF_ROOT)/tex/latex/${PACKAGE}
LATEXMK := latexmk -pdf -r $(ROOT_DIR)/.latexmkrc -pvc- -pv-
LATEXMK_CLEAN := $(LATEXMK) -c

${PACKAGE}/${PACKAGE}.pdf: ${PACKAGE}/${PACKAGE}.tex
	cd ${PACKAGE} && $(LATEXMK) ${PACKAGE}.tex

example.pdf: example.tex
	$(LATEXMK) $?

.PHONY: dir-no-pdf
dir-no-pdf: $(DIST_FILES) $(DOC_FILES)
	# copies files over, escapes versions
	mkdir -p $(PACKAGE)
	cp -t ${PACKAGE} $^
	cd ${PACKAGE} && $(ESCAPE_VERSION) $(NEEDS_ESCAPE)

dir-pdf: dir-no-pdf ${PACKAGE}/example.tex ${PACKAGE}/${PACKAGE}.tex
	cd ${PACKAGE} && $(LATEXMK) $(NEEDS_LATEXMK)

${PACKAGE}: $(DIST_FILES) $(DOC_FILES)
	make dir-no-pdf dir-pdf
	chmod -x,+r ${PACKAGE}/*

.PHONY: dist
dist: ${PACKAGE}.tar.gz
${PACKAGE}.tar.gz: ${PACKAGE}
	cd ${PACKAGE} && $(LATEXMK_CLEAN) && rm -rf extra *.fls
	tar -czf $@ $?
	make tidy
	tar -tvf $@

tidy:
	# all generated files but the pdf and .tar.gz
	$(LATEXMK_CLEAN)
	# copied files
	rm -rf ${PACKAGE} extra

distclean: clean
clean:
	$(LATEXMK) -C
	make tidy
	rm -f ${PACKAGE}.tar.gz

install: ${PACKAGE}
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
