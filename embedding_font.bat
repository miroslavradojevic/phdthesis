@echo off

echo Embedding fonts...

SET FIG_EXT=.pdf
SET FIG_SUFFIX=_embedded
echo:

for %%s in (
chapter2\L_fuzzification_1 
chapter2\L_fuzzification_2 
chapter2\U_fuzzification_1 
chapter2\U_fuzzification_2
chapter2\C_fuzzification_1
chapter2\C_fuzzification_2
chapter2\fig9a
chapter2\fig9b
chapter2\fig10a
chapter2\fig10b
chapter2\triplets_fjun_fend_vs_pratio
chapter2\triplets_fboth_vs_snr
chapter2\overview_real
chapter2\compareJUN_all
chapter2\compareEND_all
chapter2\compareBOTH_all
) do (
	echo:
	echo %%s
	echo %%s%FIG_EXT%
	echo %%s%FIG_SUFFIX%%FIG_EXT%
	echo:
	gswin64c -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=%%s%FIG_SUFFIX%%FIG_EXT% -f %%s%FIG_EXT%
)
