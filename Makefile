VERSION := 2019\/03\/11 0.5.2
PACKAGE := brandeis-problemset

ROOT_DIR := $(CURDIR)
DIST_FILES := ${PACKAGE}.cls ${PACKAGE}.sty
DOC_FILES := ${PACKAGE}.tex \
	example.tex \
	LICENSE.txt README.md
NEEDS_ESCAPE := ${PACKAGE}.cls ${PACKAGE}.sty ${PACKAGE}.tex
ESCAPE_VERSION := sed -e "s/\$${VERSION}/${VERSION}/" -i

# Simple OS detection for Make on Cygwin...
UNAME := $(shell uname -o)
ifeq ($(UNAME), Cygwin)
	# use the windows home folder rather than the cygwin one
	HOME := $(shell cygpath ${USERPROFILE})
endif

TEXMF_ROOT := ${HOME}/texmf
INSTALL_DIR := $(TEXMF_ROOT)/tex/latex/${PACKAGE}
LATEXMK := latexmk -aux-directory=extra -pdf -r $(ROOT_DIR)/.latexmkrc -pvc- -pv-

${PACKAGE}/${PACKAGE}.pdf: ${PACKAGE}/${PACKAGE}.tex
	cd ${PACKAGE} && $(LATEXMK) ${PACKAGE}.tex

example.pdf: example.tex
	$(LATEXMK) $?

${PACKAGE}: $(DIST_FILES) $(DOC_FILES) example.pdf
	mkdir -p $(PACKAGE)
	cp -t ${PACKAGE} $^
	cd ${PACKAGE} && $(ESCAPE_VERSION) $(NEEDS_ESCAPE)
	make ${PACKAGE}/${PACKAGE}.pdf
	chmod -x,+r ${PACKAGE}/*

.PHONY: dist
dist: ${PACKAGE}.tar.gz
${PACKAGE}.tar.gz: ${PACKAGE}
	cd ${PACKAGE} && $(LATEXMK) -c && rm -rf extra
	tar -czf $@ $?
	make tidy
	tar -tvf $@

tidy:
	# all generated files but the pdf and .tar.gz
	$(LATEXMK) -c
	rm -rf extra
	# copied files
	rm -rf ${PACKAGE}

distclean: clean
clean:
	$(LATEXMK) -C
	make tidy
	rm -f ${PACKAGE}.tar.gz

install: ${PACKAGE}
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
