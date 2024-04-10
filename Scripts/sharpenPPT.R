

```{r PPTfig}
sharpenPPT <-0
if (sharpenPPT == 1){
myfile <- here('_optimal_writeup','images','PPT stimuli_orig.png')
 thisimage <- image_read(myfile)
  thisimage<-image_scale(thisimage,600)
 #Make canvas with space on top for label
 mycanvas <- image_blank(width = 600, height = 250, color = "white")
 
 ppimage <- image_composite(mycanvas,thisimage, offset = "+0+40")
 ppimage<-image_annotate(ppimage, "Semantic", size=20,location="+120+15")
 ppimage<-image_annotate(ppimage, "Perceptual", size=20,location="+420+15")

 image_write(ppimage,myfile)
}
```
