PACKAGE := brandeis-problemset
DIST_FILES := ${PACKAGE}.cls ${PACKAGE}.sty ${PACKAGE}.tex ${PACKAGE}.pdf \
	example.tex example.pdf LICENSE.txt README.md

# Simple OS detection for Make on Cygwin...
UNAME := $(shell uname -o)
ifeq ($(UNAME), Cygwin)
	# use the windows home folder rather than the cygwin one
	HOME := $(shell cygpath ${USERPROFILE})
endif

TEXMF_ROOT := ${HOME}/texmf
INSTALL_DIR := $(TEXMF_ROOT)/tex/latex/${PACKAGE}
LATEXMK = latexmk -aux-directory=extra -pdf -r ./.latexmkrc -pvc- -pv-

${PACKAGE}.pdf: ${PACKAGE}.tex
	$(LATEXMK) $?

example.pdf: example.tex
	$(LATEXMK) $?

${PACKAGE}: $(DIST_FILES)
	mkdir -p ${PACKAGE}
	cp -t ${PACKAGE} $?
	chmod -x,+r ${PACKAGE}/*

${PACKAGE}.tar.gz: ${PACKAGE}
	tar -czf $@ $?
	tar -tvf $@

dist: ${PACKAGE}.tar.gz

tidy:
	# all generated files but the pdf
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
