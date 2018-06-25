rm(list = ls()); ## clear
this.dir <- dirname(parent.frame(2)$ofile) # script's parent dir
out.dir <- file.path(this.dir, "compare_snr")
dir.create(out.dir, showWarnings = FALSE)
##################################################

## Read into SNR_param, SNR_y, SNR_y1
methods <- c("app2",   "gps",   "mst",   "pnr",   "phd") 

SNR_param <- data.frame() # concatenate S$param dataframes for all the methods
SNR_y <- matrix(NA, nrow=0, ncol = 0)
SNR_y1 <- matrix(NA, nrow=0, ncol = 0)

for (method in methods) {
  
  load(file.path(this.dir, method, paste("summary_", method, sep=""), "SNR.RData")) # SNR ($param, $y, $y1), SNRx, SNRx1
  
  if (nrow(SNR_param)==0) {
    SNR_param <- SNR$param
    SNR_y     <- SNR$y
    SNR_y1    <- SNR$y1
  }
  else {
    SNR_param <- rbind(SNR_param, SNR$param)
    SNR_y     <- rbind(SNR_y,  SNR$y)
    SNR_y1    <- rbind(SNR_y1, SNR$y1)
  }
}


#### cols
cols <- rainbow(nlevels(SNR_param$ALGORITHM));

for(i in 1 : length(cols)) {
  cols[i] <- adjustcolor(cols[i], alpha.f=0.8)
}

# "app2" "gps"  "mst"  "pnr"  "phd"
cols1 <- c(rgb(0,0,0,0.8), rgb(0,0,0,0.6), rgb(0,0,0,0.7), rgb(1,0,0,1.0), rgb(0,0,0,0.9)) # used for the average

# pie(rep(1,length(cols)), col=cols, labels = levels(SNR_param$ALGORITHM))

#### pchs
pchs <- c(6,15,4,16,18)
#stop("")
###
for(s in levels(SNR_param$S)) { # 
  for(cor in levels(SNR_param$COR)) { # 
    for(measure in levels(SNR_param$MEASURE)){ # 
      
      ########################
      ## poly lines per method
      SNRy <- matrix(NA, nrow=0, ncol=ncol(SNR_y))
      
      for (method in levels(SNR_param$ALGORITHM)) {
        SNRy <- rbind(SNRy, 
                      SNR_y[
                        SNR_param$ALGORITHM == method &  
                          SNR_param$S == s & 
                          SNR_param$COR == cor & 
                          SNR_param$MEASURE == measure,])
      }
      
      ymin      <- 0;# if(measure=="SSD") min(SNRy) else 0
      ymax      <- if(measure=="SSD") max(SNRy) else 1
      legendpos <- if(measure=="SSD") "topleft" else "topright"
      
      pdf(file.path(out.dir, sprintf("%s(snr,S=%s,cor=%s).pdf", measure, s, cor)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(SNRy)) {
        if (i==1) {
          plot( SNRx, SNRy[i,], type = "l", col=cols[i], pch=pchs[i], lwd = 2,
                ylim = c(ymin,ymax),  
                las=1, 
                xaxt = "n",                                  # https://stackoverflow.com/questions/5182238/r-replace-x-axis-with-own-values
                cex.axis=1, 
                cex.lab=1, 
                cex=1.0, xlab="SNR", 
                ylab=toupper(measure))
          
          axis(1, at=1:length(SNR_xaxis), labels=SNR_xaxis) # https://stackoverflow.com/questions/5182238/r-replace-x-axis-with-own-values
        }
        else 
          lines(SNRx, SNRy[i,], type = "l", col=cols[i], pch=pchs[i], lwd = 2)
      }
      
      legend(legendpos, toupper(levels(SNR_param$ALGORITHM)), bty="n", col=cols, lty=1, lwd = 2)
      grid()
      dev.off()
      
      ########################
      ## avg lines per method
      SNRy1 <- matrix(NA, nrow=0, ncol=ncol(SNR_y1))
      
      for (method in levels(SNR_param$ALGORITHM)) {
        SNRy1 <- rbind(SNRy1, 
                       SNR_y1[
                         SNR_param$ALGORITHM == method &  
                           SNR_param$S == s & 
                           SNR_param$COR == cor & 
                           SNR_param$MEASURE == measure,])
      }
      
      ymin      <- 0; # if(measure=="SSD") min(SNRy1) else 0
      ymax      <- if(measure=="SSD") max(SNRy1) else 1
      legendpos <- if(measure=="SSD") "topleft" else "topright"
      
      #### used in the figure plots for pnr
      if(measure=="F" & cor=="0") legendpos <- "bottomright" 
      if(measure=="F" & cor=="1") legendpos <- "topleft"
      if(measure=="SSD" & cor=="0") legendpos <- "topright"
      if(measure=="SSD" & cor=="1") legendpos <- "bottomleft"
      ####
      
      pdf(file.path(out.dir, sprintf("_%s(snr,S=%s,cor=%s).pdf", measure, s, cor)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(SNRy1)) {
        if (i==1) {

          plot( SNRx1, SNRy1[i,], type = "o", col=cols1[i], pch = pchs[i],
                lwd = 1,
                ylim = c(ymin,ymax), 
                las=1, 
                cex.axis=1, 
                cex.lab=1, 
                xaxt = "n",                                  # https://stackoverflow.com/questions/5182238/r-replace-x-axis-with-own-values      
                cex=1.0, xlab="SNR", 
                ylab=toupper(measure))
          
          axis(1, at=1:length(SNR_xaxis), labels=SNR_xaxis) # https://stackoverflow.com/questions/5182238/r-replace-x-axis-with-own-values

        }
        else 
          lines(SNRx1, SNRy1[i,], type = "o", col=cols1[i], pch=pchs[i], lwd = 1)
      }
      
      # old legend version
      #legend(legendpos, toupper(levels(SNR_param$ALGORITHM)), bty="n", col=cols1, pch = pchs, lty=1, lwd = 1)
      
      # new legend with alphabetically sorted titles
      legend_titles <- toupper(levels(SNR_param$ALGORITHM))
      legend_colors <- cols1
      legend_shapes <- pchs
      legend_titles_order <- order(legend_titles)
      
      legend(legendpos, 
             legend_titles[legend_titles_order], 
             col=legend_colors[legend_titles_order], 
             pch = pchs[legend_titles_order], 
             lty=1, lwd = 1, bty="n")
      grid()
      dev.off()
      
    }
  }
}