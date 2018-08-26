#!/bin/bash
sh clean.sh;
pdflatex phdthesis;
bibtex phdthesis;
pdflatex phdthesis;
makeglossaries phdthesis;
pdflatex phdthesis;

# sh clean.sh; pdflatex phdthesis; bibtex phdthesis; pdflatex phdthesis; makeglossaries phdthesis; pdflatex phdthesis