#!/bin/bash
pdflatex phdthesis
bibtex phdthesis
pdflatex phdthesis
makeglossaries phdthesis
pdflatex phdthesis