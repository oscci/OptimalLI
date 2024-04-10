
# Basic set-up 
import gl
gl.resetdefaults()
gl.backcolor(255, 255, 255) #white background (black is default)

# Open background image
gl.loadimage('spm152')

tasks = ["WG1"] 
#
groups  = ["lefts"]
readdir = '/Volumes/Extreme_Pro/_fmri_data/bruckert_raw/avgs_by_latgroup/'
writedir = '/Volumes/Extreme_Pro/_fmri_data/bruckert_raw/png_avgs_by_latgroup/'


# Open overlay
for t in tasks:
     for g in groups:

# Open background image
       gl.loadimage('spm152')

#name of file to read and write is assembled from task/group combination

       readfile = readdir +'lefts_WG1.nii'
       gl.overlayloadsmooth(1);
       gl.overlayload(readfile)

# first we colour positive points red

      gl.colorname (1,"4hot")
       gl.minmax(1,2, 5)
       gl.opacity(1,25)

       gl.overlayload(readfile)
       gl.colorname (1,"electric_blue")
       gl.minmax(1,-2, -5)
       gl.opacity(1,25)

       gl.colorbarposition(1)
       writefile = writedir +t+'_'+g+'Ltry.png'
       gl.azimuthelevation(90,10)
       gl.savebmp(writefile)

  
