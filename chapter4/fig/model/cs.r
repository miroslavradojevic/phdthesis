rm(list = ls()); # clear variables 
this.dir <- dirname(parent.frame(2)$ofile) # get script's parent dir
library(shape)
library(plot3D)

sigma<-1.0

x<-seq(-3*sigma, 3*sigma, by=.1)
y<-seq(-3*sigma, 3*sigma, by=.1)

f <- function(x, y) { 
  r <- sqrt(x^2+y^2); 
  return( exp(-r^2/(2*1^2))) # (exp(kappa*dotp)/(2*3.14*besselI(kappa,0)))
}

cs3d <- outer(x, y, f)

pdf(file.path(this.dir, "cs3d_new.pdf"), width=4, height=4, useDingbats=F, family="Times")
par(mar=c(2.8,2.8,2.8,2.8), mgp=c(1, .5, 0))
image2D(cs3d, x, y, rasterImage=F, xlab=NA, ylab=NA, las=1, colkey = FALSE, col=gray((0:16)/16), xaxt = "n", yaxt = "n", asp=1)
contour(x, y, cs3d, add = TRUE, drawlabels = FALSE, col=rgb(1,1,1,0.5), lwd=0.1, asp=1)

axis(1, at=c(-3,0,3), tick=T, labels=NA)
axis(2, at=c(-3,0,3), tick=T, labels=NA)

text(x=c(-3,0,3),  par("usr")[3]-0.1, labels = c(expression(-3*sigma), expression(0), expression(3*sigma)), 
     srt = 0, pos = 1, xpd=T, cex=1.2)
text(par("usr")[1]-0.1, c(-3,0,3), labels = c(expression(-3*sigma), expression(0), expression(3*sigma)), 
     srt = 0, pos = 2, xpd=T, cex=1.2)
grid()
mtext(expression(italic(k)), side=1, line = 1.6, cex=1.6) 
mtext(expression(italic(l)), side=2, line = 1.6, cex=1.6, las=2)
dev.off()

a<-seq(-3,3,0.01)

pdf(file.path(this.dir, "cs2d.pdf"), width=4, height=4, useDingbats=F, family="Times")
par(mar=c(2.8,2.8,2.8,2.8), mgp=c(1, .5, 0))
plot(a, exp(-(a^2)/(2*1^2)), type="l", xaxt = "n", yaxt = "n", xlab=NA, ylab=NA)
axis(1, at=c(-3,0,3), tick=T, labels=NA)
axis(2, at=c(0,1),    tick=T, labels=NA)
text(x=c(-3,0,3),  par("usr")[3]-0.02, labels = c(expression(-3*sigma), expression(0), expression(3*sigma)), 
     srt = 0, pos = 1, xpd=T, cex=1.2)
text(par("usr")[1]-0.02, c(0,1), labels = c(expression(0), expression(1)), srt = 0, pos = 2, xpd=T)
grid()
mtext(expression(italic(k)), side=1, line = 1.6, cex=1.5) 
mtext(expression(italic(G)[sigma]), side=2, line = .7,  cex=1.5, las=2)
dev.off()