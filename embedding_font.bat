@echo off

echo Embedding fonts...

SET FIG_EXT=.pdf
SET FIG_SUFFIX=_embeddedf
echo:
if not exist "out" mkdir out

echo %cd%

for %%s in (
chapter2\L_fuzzification_1 
chapter2\L_fuzzification_2 
chapter2\U_fuzzification_1 
chapter2\U_fuzzification_2) do (
	echo %%s%FIG_EXT%
	echo \out\%%s%FIG_SUFFIX%%FIG_EXT%
	gswin64c -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=\out\%%s%FIG_SUFFIX%%FIG_EXT% -f %%s%FIG_EXT%
	echo:
)
