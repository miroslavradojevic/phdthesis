rm(list = ls()); ## clear
this.dir <- dirname(parent.frame(2)$ofile) # script's parent dir
out.dir <- file.path(this.dir, "compare_cor")
dir.create(out.dir, showWarnings = FALSE)
##################################################

## Read into COR_param, COR_y, COR_y1
methods <- c("app2",   "gps",   "mst",   "pnr",   "phd") 

COR_param <- data.frame() # concatenate S$param dataframes for all the methods
COR_y <- matrix(NA, nrow=0, ncol = 0)
COR_y1 <- matrix(NA, nrow=0, ncol = 0)

for (method in methods) {
  
  load(file.path(this.dir, method, paste("summary_", method, sep=""), "COR.RData")) # COR ($param, $y, $y1), CORx, CORx1
  
  if (nrow(COR_param)==0) {
    COR_param <- COR$param
    COR_y     <- COR$y
    COR_y1    <- COR$y1
  }
  else {
    COR_param <- rbind(COR_param, COR$param)
    COR_y     <- rbind(COR_y, COR$y)
    COR_y1    <- rbind(COR_y1, COR$y1)
  }
}


#### cols
cols <- rainbow(nlevels(COR_param$ALGORITHM));

for(i in 1 : length(cols)) {
  cols[i] <- adjustcolor(cols[i], alpha.f=0.8)
}

# "app2" "gps"  "mst"  "pnr"  "phd"
cols1 <- c(rgb(0,0,0,0.8), rgb(0,0,0,0.6), rgb(0,0,0,0.7), rgb(1,0,0,1.0), rgb(0,0,0,0.9))

# pie(rep(1,length(cols)), col=cols, labels = levels(COR_param$ALGORITHM))

#### pchs
pchs <- c(6,15,4,16,18)

###
for(s in levels(COR_param$S)) {
  for(snr in levels(COR_param$SNR)) {
    for(measure in levels(COR_param$MEASURE)){
      
      ########################
      ## poly lines per method
      CORy <- matrix(NA, nrow=0, ncol=ncol(COR_y))
      
      for (method in levels(COR_param$ALGORITHM)) {
        CORy <- rbind(CORy, 
                    COR_y[
                        COR_param$ALGORITHM == method &  
                        COR_param$S == s & 
                        COR_param$SNR == snr & 
                        COR_param$MEASURE == measure,])
      }

      ymin      <- 0;#if(measure=="SSD") min(CORy) else 0
      ymax      <- if(measure=="SSD") max(CORy) else 1.5 # pnr paper print
      legendpos <- if(measure=="SSD") "topleft" else "topright"
      
      pdf(file.path(out.dir, sprintf("%s(cor,S=%s,snr=%s).pdf", measure, s, snr)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(CORy)) {
        if (i==1)
          plot( CORx, CORy[i,], type = "l", col=cols[i], pch=pchs[i], lwd = 1,
                ylim = c(ymin,ymax), 
                las=1, 
                cex.axis=1, 
                cex.lab=1, 
                cex=1.0, xlab="S", 
                ylab=toupper(measure))
        else 
          lines(CORx, CORy[i,], type = "l", col=cols[i], pch=pchs[i], lwd = 1)
      }
      
      legend(legendpos, toupper(levels(COR_param$ALGORITHM)), bty="n", col=cols, lty=1, lwd = 1)
      grid()
      dev.off()
      
      ########################
      ## avg lines per method
      CORy1 <- matrix(NA, nrow=0, ncol=ncol(COR_y1))
      
      for (method in levels(COR_param$ALGORITHM)) {
        CORy1 <- rbind(CORy1, 
                      COR_y1[
                        COR_param$ALGORITHM == method &  
                          COR_param$S == s & 
                          COR_param$SNR == snr & 
                          COR_param$MEASURE == measure,])
      }
      
      ymin      <- 0;#if(measure=="SSD") min(CORy1) else 0
      ymax      <- if(measure=="SSD") max(CORy1) else 1.5 # pnr paper print
      legendpos <- if(measure=="SSD") "topleft" else "topright"
      
      pdf(file.path(out.dir, sprintf("_%s(cor,S=%s,snr=%s).pdf", measure, s, snr)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(CORy1)) {
        if (i==1)
          plot( CORx1, CORy1[i,], type = "o", col=cols1[i], pch = pchs[i],
                lwd = 1,
                ylim = c(ymin,ymax), 
                las=1, 
                cex.axis=1, 
                cex.lab=1, 
                cex=1.0, xlab="COR", 
                ylab=toupper(measure))
        else 
          lines(CORx1, CORy1[i,], type = "o", col=cols1[i], pch=pchs[i], lwd = 1)
      }
      
      # old legend
      #legend(legendpos, toupper(levels(COR_param$ALGORITHM)), bty="n", col=cols1, pch = pchs, lty=1, lwd = 1)
      # new legend
      legend_titles <- toupper(levels(COR_param$ALGORITHM))
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