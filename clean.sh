#!/bin/bash
echo "Clean auxiliary files..."

extensions='aux log bbl blg glo gz ist toc glg gls nlo bib.sav dvi fls fdb_latexmk' # array with the extensions

for ext in $extensions # go through the extensions
do
	echo "- "$ext
	# clean all files with given extensions
	find . -type f -iname "*.${ext}" -exec sh -c 'echo $0; rm -rf $0;' {} \;
done
