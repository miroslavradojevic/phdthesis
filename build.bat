echo off
title Build PhD Thesis
:: See the title at the top
pdflatex phdthesis
bibtex phdthesis
pdflatex phdthesis
makeglossaries phdthesis
pdflatex phdthesis
echo done
pause