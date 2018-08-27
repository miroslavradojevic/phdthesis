#!/bin/bash
sh clean.sh;
rm -rf ./phdthesis.pdf
pdflatex phdthesis;
bibtex phdthesis;
pdflatex phdthesis;
makeglossaries phdthesis;
pdflatex phdthesis;
sh clean.sh;
# one-line command
# sh clean.sh; pdflatex phdthesis; bibtex phdthesis; pdflatex phdthesis; makeglossaries phdthesis; pdflatex phdthesis