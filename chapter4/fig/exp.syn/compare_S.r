rm(list = ls()); ## clear
this.dir <- dirname(parent.frame(2)$ofile) # script's parent dir
out.dir <- file.path(this.dir, "compare_S")
dir.create(out.dir, showWarnings = FALSE)
##################################################

## Read
methods <- c("app2",   "gps",   "mst",   "pnr",   "phd") 

S_param <- data.frame() # concatenate S$param dataframes for all the methods
S_y <- matrix(NA, nrow=0, ncol = 0)
S_y1 <- matrix(NA, nrow=0, ncol = 0)

for (method in methods) {
  
  load(file.path(this.dir, method, paste("summary_", method, sep=""), "S.RData")) # S ($param, $y, $y1), Sx, Sx1
  
  if (nrow(S_param)==0) {
    S_param <- S$param
    S_y     <- S$y
    S_y1    <- S$y1
  }
  else {
    S_param <- rbind(S_param, S$param)
    S_y     <- rbind(S_y, S$y)
    S_y1    <- rbind(S_y1, S$y1)
  }
}

cols <- rainbow(nlevels(S_param$ALGORITHM));

for(i in 1 : length(cols)) {
  cols[i] <- adjustcolor(cols[i], alpha.f=0.8)
}

# "app2" "gps"  "mst"  "pnr"  "phd"
cols1 <- c(rgb(0,0,0,0.8), rgb(0,0,0,0.6), rgb(0,0,0,0.7), rgb(1,0,0,1.0), rgb(0,0,0,0.9))

# pie(rep(1,length(cols)), col=cols, labels = levels(S_param$ALGORITHM))

#### pchs
pchs <- c(6,15,4,16,18)

###
for(cor in levels(S_param$COR)) {
  for(snr in levels(S_param$SNR)) {
    for(measure in levels(S_param$MEASURE)){
      
      ########################
      ## poly lines per method
      Sy <- matrix(NA, nrow=0, ncol=50)
      
      for (method in levels(S_param$ALGORITHM)) {
        
        Sy <- rbind(Sy, 
                    S_y[
                        S_param$ALGORITHM == method &  
                        S_param$COR == cor & 
                        S_param$SNR == snr & 
                        S_param$MEASURE == measure,])
      }

      ymin      <- 0;#if(measure=="SSD") min(Sy) else 0
      ymax      <- if(measure=="SSD") max(Sy) else 1
      legendpos <- if(measure=="SSD") "topleft" else "bottomright"
      
      pdf(file.path(out.dir, sprintf("%s(S,cor=%s,snr=%s).pdf", measure, cor, snr)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(Sy)) {
        if (i==1)
          plot( Sx, Sy[i,], type = "l", col=cols[i], lwd = 2,
                ylim = c(ymin,ymax), 
                las=1, 
                cex.axis=1, 
                cex.lab=1, 
                cex=1.0, xlab="S", 
                ylab=toupper(measure))
        else 
          lines(Sx, Sy[i,], type = "l", col=cols[i], lwd = 2)
      }
      
      legend(legendpos, toupper(levels(S_param$ALGORITHM)), bty="n", col=cols, lty=1, lwd = 2)
      grid()
      dev.off()
      
      ########################
      ## avg lines per method
      Sy1 <- matrix(NA, nrow=0, ncol=ncol(S_y1))
      
      for (method in levels(S_param$ALGORITHM)) {
        Sy1 <- rbind(Sy1, 
                       S_y1[
                         S_param$ALGORITHM == method &  
                           S_param$COR == cor & 
                           S_param$SNR == snr & 
                           S_param$MEASURE == measure,])
      }
      
      ymin      <- 0;#if(measure=="SSD") min(Sy1) else 0
      ymax      <- if(measure=="SSD") max(Sy1) else 1
      
      legendpos <- "topleft"
      
      #### used in the figure plots for pnr
      if(measure=="SSD" && cor=="1.0") legendpos <-  "bottomright" # else "topleft" 
      if (measure=="F" & cor=="0.0") legendpos <- "bottomright"
      
      # if (measure=="F" & cor=="0.0") {print(Sx1);
      #   for (method in levels(S_param$ALGORITHM)) {
      #     print(method);
      #   }
      #   print(Sy1);
      # }
      ####
      
      pdf(file.path(out.dir, sprintf("_%s(S,cor=%s,snr=%s).pdf", measure, cor, snr)), width=4, height=4, useDingbats=F, family="Times")
      par(mar=c(3.5,3.5,0.1,0.1)+0.1, mgp=c(2.5, 0.8, 0))
      
      for (i in 1:nrow(Sy1)) {
        if (i==1)
          plot( Sx1, Sy1[i,], type = "o", col=cols1[i], pch = pchs[i],
                lwd = 1,
                ylim = c(ymin,ymax), 
                las=1, 
                cex.axis=1, 
                cex.lab=1, 
                cex=1.0, xlab="S", 
                ylab=toupper(measure))
        else 
          lines(Sx1, Sy1[i,], type = "o", col=cols1[i], pch=pchs[i], lwd = 1)
      }
      
      legendhorizontal <- FALSE # maybe change for some scenarios
      
      # old legend
      #legend(legendpos, toupper(levels(S_param$ALGORITHM)), bty="n", col=cols1, pch = pchs, lty=1, lwd = 1, horiz=legendhorizontal)
      
      # new legend
      legend_titles <- toupper(levels(S_param$ALGORITHM))
      legend_colors <- cols1
      legend_shapes <- pchs
      legend_titles_order <- order(legend_titles)
      legend(legendpos, 
             legend_titles[legend_titles_order], 
             col=legend_colors[legend_titles_order], 
             pch = pchs[legend_titles_order], 
             lty=1, lwd = 1, bty="n", horiz=legendhorizontal)
      
      grid()
      dev.off()
      
    }
  }
}
