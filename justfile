pandoc input="README.md":
	pandoc {{input}} -o pandoc_test.typ --template ./zHaus.typst
	pandoc {{input}} -o pandoc_test.pdf --pdf-engine typst --template ./zHaus.typst

install:
	utpm workspace link --force
	mkdir -p ~/.local/share/pandoc/templates
	cp zHaus.typst ~/.local/share/pandoc/templates/
