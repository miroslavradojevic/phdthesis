rm(list = ls()); ## clear 
this.dir <- dirname(parent.frame(2)$ofile) # get current directory
out.dir <- file.path(this.dir, "_f1") # output directory
dir.create(out.dir, showWarnings = FALSE)

load(file.path(this.dir, "pnr",      "summary", "eval.RData")); pnr <- eval;      remove(eval);
load(file.path(this.dir, "app2",     "summary", "eval.RData")); app2 <- eval;     remove(eval);
load(file.path(this.dir, "gps",      "summary", "eval.RData")); gps <- eval;      remove(eval);
load(file.path(this.dir, "mst",      "summary", "eval.RData")); mst <- eval;      remove(eval);
load(file.path(this.dir, "phd",      "summary", "eval.RData")); phd <- eval;      remove(eval);

##################################################
# define colors and pch for different methods
pch_pnr <- 19
pch_phd <- 18
pch_app2 <- 6
pch_gps <- 15
pch_mst <- 4

col_pnr <- rgb(1,0,0,1.0)
col_phd <- rgb(0,0,0,0.7)
col_app2 <- rgb(0,0,0,0.7)
col_gps <- rgb(0,0,0,0.7)
col_mst <- rgb(0,0,0,0.7)
##################################################
## F
med.s<-data.frame() # store medians for each S
avg.s<-data.frame() # store averages for each S

for (s in levels(factor(pnr$S))) { ## for each S  levels(factor(pnr$S))
  
  t0 <- app2[app2$S %in% s,] # evaluation subset for particular s
  val <- do.call(rbind, lapply(split(t0, t0[,"NAME"]), function(x) x[which.max(x[,"F"]),c("NAME","F")]))
  names(val)[names(val)=="F"] <- "APP2"

  t0 <- gps[gps$S %in% s,]
  t <- do.call(rbind, lapply(split(t0, t0[,"NAME"]), function(x) x[which.max(x[,"F"]),c("NAME","F")]))
  names(t)[names(t)=="F"] <- "GPS"
  val<-merge(val,t,by="NAME")

  t0 <- mst[mst$S %in% s,]
  t <- do.call(rbind, lapply(split(t0, t0[,"NAME"]), function(x) x[which.max(x[,"F"]),c("NAME","F")]))
  names(t)[names(t)=="F"] <- "MST"
  val<-merge(val,t,by="NAME")

  # grab phd method results...
  t0 <- phd[phd$S %in% s,]
  # parameter subset
  # t0 <- t0[t0$th %in% "10.00", ]
  # t0 <- t0[t0$no %in% "20", ]
  # t0<-t0[which(as.numeric(as.character(t0$e))<=10), ]
  ########   
  t <- do.call(rbind, lapply(split(t0, t0[,"NAME"]), function(x) x[which.max(x[,"F"]), c("NAME","F")]))
  names(t)[names(t)=="F"] <- "PHD"
  val<-merge(val,t,by="NAME")

  t0 <- pnr[pnr$S %in% s,]
  t <- do.call(rbind, lapply(split(t0, t0[,"NAME"]), function(x) x[which.max(x[,"F"]),c("NAME","F")]))
  names(t)[names(t)=="F"] <- "PNR"
  val<-merge(val,t,by="NAME")
  
  rownames(val) <- NULL

  ##################################################
  file_name <- file.path(out.dir, paste("f_s=", format(as.double(s), nsmall=1, decimal.mark="_"),".pdf", sep=""))
  pdf(file_name, width=4, height=4, useDingbats=F, family="Times")
  #par(mar=c(2,2.8,.8,.4)+0.1, mgp=c(1.2, 0.5, 0))
  par(mar=c(2.5,2.7,.8,.2)+0.1, mgp=c(1.6, 0.5, 0))
  
  bp<-boxplot(val$APP2, val$GPS, val$MST, val$PHD, val$PNR, 
    col=c(NA, NA, NA, NA, col_pnr), 
    cex.axis=1.2, xpd=F, las=2, cex=1.5, cex.lab=1.3,
    xaxt = "n",  xlab = "", ylab= "F", ylim=c(0,1))
  
  axis(1, labels = FALSE)
  xmin <- par("usr")[1]
  xmax <- par("usr")[2]
  ymin <- par("usr")[3]
  ymax <- par("usr")[4]
  
  #text(xmin-.45, (ymin+ymax)*.5, labels=c("F"), pos=2, xpd=T, cex=1.3)
  
  mtext(paste("S=",s, sep=""), side=3, line=0, cex=1.1)
  
  text(1:5, par("usr")[3], offset=.75, srt = 15, adj = 1, labels = c("APP2","GPS","MST","PHD","PNR"), xpd = TRUE, pos=1, cex=1.2)
  
  grid()
  dev.off()
  cat(file_name, sep = "\n")
  
  med.s<-rbind(med.s, data.frame(
    S=as.numeric(s),
    APP2=median(val$APP2),
    GPS=median(val$GPS),
    MST=median(val$MST),
    PNR=median(val$PNR),
    PHD=median(val$PHD)
  ))

  avg.s<-rbind(avg.s, data.frame(
    S=as.numeric(s),
    APP2=mean(val$APP2),
    GPS=mean(val$GPS),
    MST=mean(val$MST),
    PNR=mean(val$PNR),
    PHD=mean(val$PHD)
  ))
  
}

ymn<-min(med.s[,-1])
ymx<-max(med.s[,-1])

##################################################
file_name <- file.path(out.dir, paste("f_med.pdf", sep=""))
pdf(file_name, width=4, height=4, useDingbats=F, family="Times")
par(mar=c(2.5,2.7,.2,.2)+0.1, mgp=c(1.6, 0.5, 0))
plot( med.s$S, med.s$MST,    type="o", lty=1, lwd=1,  pch= pch_mst,  col=col_mst, 
      ylab =NA, xlab="S", ylim=c(0,1), xaxt="n", yaxt="n", cex=1.5, cex.lab=1.3)
axis(1, las=1, cex.axis=1.2)
axis(2, las=2, cex.axis=1.2)
lines(med.s$S, med.s$PHD,    type="o", lty=1, lwd=1,  pch=pch_phd,  col=col_phd)
lines(med.s$S, med.s$APP2,   type="o", lty=1, lwd=1,  pch=pch_app2, col=col_app2)
lines(med.s$S, med.s$GPS,    type="o", lty=1, lwd=1,  pch=pch_gps,  col=col_gps)
lines(med.s$S, med.s$PNR,    type="o", lty=1, lwd=1,  pch=pch_pnr,  col=col_pnr)

xmin <- par("usr")[1]
xmax <- par("usr")[2]
ymin <- par("usr")[3]
ymax <- par("usr")[4]

text(xmin-.7, (ymin+ymax)*.5, labels=c("F"), pos=4, xpd=T, cex=1.3)
legend("bottomright",
       c("PNR","PHD","APP2","MST","GPS"),
       col = c(col_pnr, col_phd, col_app2, col_mst, col_gps),
       pch = c(pch_pnr, pch_phd, pch_app2, pch_mst, pch_gps),
       bty="n", lty=1, lwd=1,  
       horiz=F, text.width=.5, x.intersp=.5, cex=1.2)
grid()
dev.off()
cat(file_name, sep = "\n")

ymn<-min(avg.s[,-1])
ymx<-max(avg.s[,-1])

##################################################
file_name <- file.path(out.dir, paste("f_avg.pdf", sep=""))
pdf(file_name, width=4, height=4, useDingbats=F, family="Times")
par(mar=c(2.5,2.7,.2,.2)+0.1, mgp=c(1.6, 0.5, 0))

plot( avg.s$S, avg.s$MST,    type="o", lty=1, lwd=1,  pch= pch_mst,  col=col_mst,
      ylab = "F", xlab = "S", ylim=c(0,1), xaxt="n", yaxt="n", cex=1.5, cex.lab=1.3)

axis(1, las=1, cex.axis=1.2)
axis(2, las=2, cex.axis=1.2)

lines(avg.s$S, avg.s$PHD,    type="o", lty=1, lwd=1,  pch=pch_phd,   col=col_phd)
lines(avg.s$S, avg.s$APP2,   type="o", lty=1, lwd=1,  pch=pch_app2,  col=col_app2)
lines(avg.s$S, avg.s$GPS,    type="o", lty=1, lwd=1,  pch=pch_gps,   col=col_gps)
lines(avg.s$S, avg.s$PNR,    type="o", lty=1, lwd=1,  pch=pch_pnr,   col=col_pnr)

xmin <- par("usr")[1]
xmax <- par("usr")[2]
ymin <- par("usr")[3]
ymax <- par("usr")[4]

#text(xmin-.7, (ymin+ymax)*.5, labels=c("F"), pos=4, xpd=T, cex=1.3)

legend_labels <- c("PNR","PHD","APP2","MST","GPS")
legend_cols <- c(col_pnr, col_phd, col_app2, col_mst, col_gps)
legend_pchs<- c(pch_pnr,pch_phd,pch_app2,pch_mst, pch_gps)
ord <- order(legend_labels)  

legend("bottomright", 
       legend_labels[ord],#c("PNR","PHD","APP2","MST","GPS"), 
       col = legend_cols[ord],#c(col_pnr, col_phd, col_app2, col_mst, col_gps), 
       pch = legend_pchs[ord],#c(pch_pnr,pch_phd,pch_app2,pch_mst, pch_gps),
       bty="n", lty=1, lwd=1, 
       horiz=F, text.width=.5, x.intersp=.5, cex=1.2)
grid()
dev.off()
cat(file_name, sep = "\n")