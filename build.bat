echo off
title Build PhD Thesis
:: See the title at the top
pdflatex.exe phdthesis
bibtex.exe phdthesis
pdflatex.exe phdthesis
makeglossaries.exe phdthesis
pdflatex.exe phdthesis
echo done
pause