DIST_FILES := problemset.cls problemset.tex problemset-doc.sty problemset.pdf README.md
TEXMF_ROOT := "${HOME}/texmf"
INSTALL_DIR := "$(TEXMF_ROOT)/tex/latex/problemset"

problemset.pdf: problemset.tex
	latexmk -norc -pdf problemset.tex

problemset: problemset.pdf
	mkdir problemset
	cp -t problemset $(DIST_FILES)

problemset.tar.gz: problemset
	tar -czf problemset.tar.gz problemset

tidy:
	# copied files
	rm -r problemset
	# all generated files but the pdf
	latexmk -norc -c

clean:
	make tidy
	rm problemset.tar.gz
	latexmk -norc -C

install: problemset
	install -d ${INSTALL_DIR}
	install $(DIST_FILES) ${INSTALL_DIR}
