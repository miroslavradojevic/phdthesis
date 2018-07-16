echo off
title Build PhD Thesis
:: See the title at the top
pdflatex phdthesis
bibtex phdthesis
makeglossaries phdthesis
pdflatex phdthesis
pdflatex phdthesis
echo done
pause