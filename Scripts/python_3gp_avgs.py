
# Basic set-up 
import gl
gl.resetdefaults()
gl.backcolor(255, 255, 255) #white background (black is default)

# Open background image
gl.loadimage('spm152')

tasks = ["WG1", "AN5","PP1","PP3","PP5"] 
#tasks=["PP3","PP5"] #uncomment to run 2 PPT conditions
groups  = ["lefts", "bilaterals","rights"]
readdir = '/Volumes/Extreme_Pro/_fmri_data/bruckert_raw/avgs_by_latgroup/'
writedir = readdir

# Open overlay
for t in tasks:
     for g in groups:

# Open background image
       gl.loadimage('spm152')

#name of file to read and write is assembled from task/group combination

       readfile = readdir +g+'_'+t+.nii'
       writefile = writedir +t+'_'+g+'.png'
       gl.overlayload(readfile)

# first we colour positive points red

       gl.colorname (1,"1red")
       gl.minmax(1,2, 2)
       gl.opacity(1,150)

# then we overlay another version of same file with neg points blue
       gl.overlayload(readfile)

       gl.colorname (2,"3blue")
       gl.minmax(2, -2, -2)
       gl.opacity(2,150)

       gl.colorbarposition(0)

       gl.azimuthelevation(90,10)

       gl.savebmp(writefile)
