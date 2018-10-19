dist:
	latexmk -norc -pdf problemset.tex
	mkdir problemset
	cp -t problemset problemset.cls problemset.tex problemset-doc.sty \
		problemset.pdf README.md
	tar -czf problemset.tar.gz problemset

tidy:
	# copied files
	rm -r problemset
	# all generated files but the pdf
	latexmk -norc -c

clean:
	rm -r problemset
	rm problemset.tar.gz
	latexmk -norc -C
