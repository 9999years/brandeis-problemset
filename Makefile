dist:
	latexmk -norc -quiet problemset.tex
	mkdir problemset
	cp -t problemset problemset.cls problemset.tex problemset-doc.sty \
		problemset.pdf README.md
	tar -czf problemset.tar.gz problemset

clean:
	rm -r problemset
	rm problemset.tar.gz
