@echo off

echo Embedding fonts...

SET FIG_EXT=.pdf
SET FIG_SUFFIX=_embedded
echo:

for %%s in (
chapter2\L_fuzzification_1 chapter2\L_fuzzification_2 
chapter2\U_fuzzification_1 chapter2\U_fuzzification_2
chapter2\C_fuzzification_1 chapter2\C_fuzzification_2
chapter2\fig9a chapter2\fig9b 
chapter2\fig10a chapter2\fig10b
chapter2\triplets_fjun_fend_vs_pratio
chapter2\triplets_fboth_vs_snr
chapter2\overview_real
chapter2\compareJUN_all
chapter2\compareEND_all
chapter2\compareBOTH_all
chapter3\fig3a chapter3\fig3b chapter3\fig3c 
chapter3\fig4a chapter3\fig4b chapter3\fig4c chapter3\fig4d
chapter3\fig6a1 chapter3\fig6a2 
chapter3\fig6b1 chapter3\fig6b2
chapter3\fig6c1 chapter3\fig6c2
chapter3\fig6d1 chapter3\fig6d2
chapter3\fig6e1 chapter3\fig6e2
chapter3\fig6f1 chapter3\fig6f2
chapter3\fig6g1 chapter3\fig6g2
chapter3\fig6h1 chapter3\fig6h2
chapter3\fig7a chapter3\fig7b
chapter3\fig8a chapter3\fig8b chapter3\fig8c chapter3\fig8d chapter3\fig8e chapter3\fig8f 
chapter3\fig9a chapter3\fig9b chapter3\fig9c chapter3\sd_saria chapter3\ssd_saria chapter3\pssd_saria 
chapter3\fig12a chapter3\fig12b chapter3\fig12c chapter3\fig12d chapter3\fig12e chapter3\fig12f 
chapter4\fig2a chapter4\fig2b
chapter4\fig6a chapter4\fig6b chapter4\fig6c chapter4\fig6d 
chapter4\fig7a chapter4\fig7b chapter4\fig7c chapter4\fig7d 
chapter4\fig8a chapter4\fig8b chapter4\fig8c chapter4\fig8d chapter4\fig8e chapter4\fig8f chapter4\fig8g chapter4\fig8h 
chapter4\fig9a_shift chapter4\fig9b chapter4\fig9c chapter4\fig9d chapter4\fig9e chapter4\fig9f chapter4\fig9g chapter4\fig9h 
chapter4\fig10a chapter4\fig10b chapter4\fig10c chapter4\fig10d chapter4\fig10e chapter4\fig10f chapter4\fig10g chapter4\fig10h 
chapter4\fig11a chapter4\fig11b chapter4\fig11c chapter4\fig11d chapter4\fig11e chapter4\fig11f chapter4\fig11g chapter4\fig11h
chapter4\fig14a chapter4\fig14b chapter4\fig14c chapter4\fig14d 
chapter4\fig15a chapter4\fig15b chapter4\fig15c chapter4\fig15d 
chapter4\fig16a chapter4\fig16b chapter4\fig16c chapter4\fig16d 
) do (
	echo:
	echo %%s
	echo %%s%FIG_EXT%
	echo %%s%FIG_SUFFIX%%FIG_EXT%
	echo:
	gswin64c -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=%%s%FIG_SUFFIX%%FIG_EXT% -f %%s%FIG_EXT%
)
