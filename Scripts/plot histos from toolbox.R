
# This script illustrates how weighted mean works in the LI Toolbox
# It reads in a file from single subject with all the estimates of LI from all the thresholds
# (This needs to be created with additional code added to li_boot.m)
# It then makes density plots showing the LI distribution for the unweighted and weighted means.

# You can also see the relationship between threshold and LI estimates with plots g1 and g2, where threshold is colour-coded
# Plot g1 is similar to Wilke histogram, except that we used density plot rather than histogram.

require(tidyverse)
require(dplyr)
require(ggpubr)
require(here)

# readDir has address of file called jn_all1.txt, which is output from LI toolbox with all the estimates from all thresholds

readDir <- '/Users/dorothybishop/Dropbox/My Mac (Dorothy’s MacBook Air)/Documents/MATLAB/spm12/toolbox/LI/'

jn<-read.csv(paste0(readDir,'jn_all.csv'),header=TRUE)
jnt<-as.data.frame(t(jn)) #transpose data


#we turn it into a long file
data_long <- gather(jnt, threshlevel, LI, V1:V20, factor_key=TRUE) #threshlevel is a factor
data_long$threshold <- as.numeric(data_long$threshlevel) #add threshold as a number
data_long <- filter(data_long,LI!=0)

#We select an arbitrarily large N of random values from file to plot (here N = 2000)
Nselect = 6000
selectrows1<-sample(1:nrow(data_long),Nselect,replace=FALSE) #no probability set
d1 <- data_long[selectrows1,]
# Now do selection weighted by thresholds. R does this using the prob term with sample
selectrows2<-sample(1:nrow(data_long),Nselect,replace=FALSE,prob=data_long$threshold)
d2 <- data_long[selectrows2,]

#This plot shows density plots for each threshold (similar to Wilke histograms)
g1<-ggplot() + 
  geom_density(data = d1, 
               mapping = aes(LI, group = threshlevel, color = threshold, fill = threshold),
               alpha = 0.5,bw=.01)+
  theme(legend.position='none')


g1a<-ggplot() + 
  geom_density(data = d1, 
               mapping = aes(LI, group = threshold, color = threshold, fill = threshold),
               alpha = 0.5,bw=.01)+
  scale_fill_gradient(low="blue", high="red")+
  theme(legend.position="top")
filename=here('_Optimal_writeup/images/densitythreshplot.tiff') #eps version does not work - no fill with this version
ggsave(filename,width=7,height=4,dpi=300)


g2<-ggplot() + 
  geom_density(data = d2, 
               mapping = aes(LI, group = threshlevel, color = threshlevel, fill = threshlevel),
               alpha = 0.5,bw=.01)

#View plots one above the other
ggarrange(g1,g2,nrow=2)

#try overlaying weighted and unweighted -
#works if bandwidth set to .01, so all peaks are shown 
#make long file with both


d1$Method <-'Unweighted'
d2$Method<-'Weighted'
alld<-rbind(d1,d2)
alld$method<-as.factor(alld$Method)

mean1<-round(mean(d1$LI),2)
mean2<-round(mean(d2$LI),2)
trimmean <-round( mean(d1$LI,trim=.25),2)
CI1<-round(quantile(d1$LI, probs = c(0.025,.975)),2)
CI2<-round(quantile(d2$LI, probs = c(0.025,.975)),2)
xlabpos = min(alld$LI+.2)
gtot<-ggplot() + 
  geom_density(data = alld, 
               mapping = aes(LI, group = Method, color = Method, fill = Method),
               alpha = 0.4,bw=.010) #bw is bandwidth - the lower it is, the finer the detail

label1<-paste0('Unweighted mean = ',mean1,': 95% CI = [',CI1[1],', ',CI1[2],']')
label2<-paste0('Weighted mean = ',mean2,': 95% CI = [',CI2[1],', ',CI2[2],']')
label3<-paste0('25% trimmed mean = ',trimmean)
gtot+  annotate("text", x = xlabpos, y = 4.8, label = label1,hjust=0) +
       annotate("text", x = xlabpos, y = 4.4, label = label2,hjust=0) +
       annotate("text", x= xlabpos, y = 4.0, label=label3,hjust=0)+
  labs(x='Laterality index',y ='Density (arbitrary units)')+
  theme(legend.position="top")


filename=here('_Optimal_writeup/images/histoplot.eps') #eps version - no fill with this version
  ggsave(filename,width=8,height=5,dpi=300)

  filename=here('_Optimal_writeup/images/histoplot.png') #png version
  ggsave(filename,width=8,height=5,dpi=300)
  
  filename=here('_Optimal_writeup/images/histoplot.tiff') #tiff version (size modified as too big in Mb)
  ggsave(filename,width=7,height=4,dpi=300)
  
  
#We can also generate the upper plot from LI Toolbox output.
  #Relevant data are in threshvals.csv
  
  threshvals <-read.csv(paste0(readDir,'threshvals.csv'),header=TRUE)
  names(threshvals)[4:6]<-c('mean_LI','lowCI','highCI')
  #make y value to plot Nvoxels
  threshvals$yval <- (20-row_number(threshvals))/20
  #remove values where fewer than 10 voxels on either side
  w <- unique(which(threshvals$voxl<10),which(threshvals$voxr<10))
  threshvals<-threshvals[-w,]
  

  #make long file with L and R stacked
  threshvals$side<-'L'
  thresh1 <- threshvals
  thresh1$side<-'R'
  thresh1$voxl<-thresh1$voxr
  thresh1$yval<- -threshvals$yval
  thresh2 <-rbind(threshvals,thresh1)
  
  thresh2<-thresh2[,-3]
  names(thresh2)[2]<-'Nvoxels'
  
  

 myg <- ggplot(data=thresh2, aes(x=thrs, y=yval, group=side,label=Nvoxels)) +
    geom_text(size=2.5)+
    geom_line(aes(x=thrs, y=mean_LI))+
    geom_line(aes(x=thrs, y=lowCI,col='red',linetype='dashed'))+
    geom_line(aes(x=thrs, y=highCI,col='red',linetype='dashed'))+
    geom_hline(yintercept=0,col='gray',linetype='dashed')+
    labs(x='Threshold (t-value)',y='LI (95% CI in red)')+
    theme(legend.position='none')
 
 filename=here('_Optimal_writeup/images/LIplot.png') #png version
 ggsave(filename,width=5,height=3,dpi=300)
 filename=here('_Optimal_writeup/images/LIplot.eps') #eps version
 ggsave(filename,width=5,height=3.5,dpi=300)
 
 
 # Another attempt at densitythreshplot, this time with new colours for histos
 #https://library.virginia.edu/data/articles/setting-up-color-palettes-in-r
 
 
#set up a colour scale with 18 colors
 ggplotColors <- function(g){
   d <- 360/g
   h <- cumsum(c(15, rep(d,g - 1)))
   hcl(h = h, c = 100, l = 65)
 }
 
 myn = 18
 mypalette <- ggplotColors(myn)
 mypalette[1]="#FFFF00" #yellow
 mypalette[2]="#FFCC66" #yellowish
mypalette[9]="#339966"
 mypalette[10]="#33ffff"
 mypalette[11]="#33cccc"
 mypalette[17]="#990099"
 mypalette[18]="#FF3333" #red
 #plot the colours and tweak if you want to -this can be used for legend
 palette=mypalette
 
 # this is base r plot for legend that can be stuck on
 # Just saved this via menu on plots pane
 plot(1:myn, rep(5,myn), col=mypalette[1:myn], pch=15, cex=2.1, xlab="", ylab="")
 text(x=1:myn, y=rep(4.6,myn), labels=1:myn, pos=3,cex=.7)
 
 #to see overlaps need to set alpha to .5,(after bw=.01) but then you get faint colours
 g1a<-ggplot() + 
   geom_density(data = d1, 
                mapping = aes(LI, group = as.factor(threshlevel),fill=as.factor(threshlevel)),
                bw=.01)+
                labs(x='Laterality index',y='N estimates')+
   theme(legend.position="none") #we'll make our own legend and add it later
 
 g1b <- g1a+   scale_fill_manual(values=mypalette)
 
 filename=here('_Optimal_writeup/images/densitythreshplot_color.png') #png version
 ggsave(filename,width=5,height=3.5,dpi=300)

 
#we now have densitythreshplot
 # the colour scale is saved by menu as colourbar_for_histos.png
 
 #Now we will use magick to combine them.
 
 require(magick)
 require(here)
 
 
 myfolder <- here('_optimal_writeup','images')
 
mainimage <- image_read(paste0(myfolder,'/','densitythreshplot_color.png'))
mainimage2 <- image_resize(mainimage,"540x300")
colbar <- image_read(paste0(myfolder,'/','colourbar_for_histos.png'))
blankbit <- image_blank(width=510,height=12,color="white")
nucol<-image_crop(colbar,"295x32+80+143") #crops off top, R hand axis, lower scale
#geom first 2 numbers define size of remaining image; the last 2 numbers specify starting point for crop L and ht

mycanvas <- image_blank(width = 500, height = 340, color = "white")
#offsets are distances for horiz and vertical
nuimage <- image_composite(mycanvas,mainimage2, offset = "+0+30")
nuimage <- image_composite(nuimage, nucol,offset = "+50+15")
nuimage<-image_composite(nuimage, blankbit, offset = "+0+35")
nuimage<-image_annotate(nuimage, "Threshold", size=14,location="+50+0")
nuimage<-image_trim(nuimage)
writefolder <- here('_optimal_writeup','images')
image_write(nuimage,paste0(writefolder,'/',"densitythreshplot2.png"))
image_write(nuimage,paste0(writefolder,'/',"densitythreshplot2.tiff"))