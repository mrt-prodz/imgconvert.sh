Batch Image Converter
=====================

Convert all images inside a folder into another given format using convert from the imagemagick package.

Dependencies: imagemagick

Usage and Example
-----------------

Usage:

        ./imgconvert.sh -s [PATH] -d [PATH] -i [EXTENSION] -o [EXTENSION] [EXTRAS]
        ./imgconvert.sh --source [PATH] --destination [PATH] --input [EXTENSION] --output [EXTENSION]


To convert all your jpg images inside your folder $HOME/Wallpaper to png and save them inside /tmp run:

        ./imgconvert.sh -s ~/Wallpaper -d /tmp -i jpg -o png
	
To convert only jpg images with a filename starting with box\* (escape the wildcard) and save in /tmp:

        ./imgconvert.sh -s ~/Wallpaper -n box\* -d /tmp -i jpg -o png
	
To convert all your png images inside your folder $HOME/icons to xbm while keeping transparency, you can
add convert specific arguments/options at the end of the command like the following:

        ./imgconvert.sh -s ~/icons -d /tmp -i jpg -o png -background white -alpha Background
        
You can also use the variable $pic running inside imgconvert.sh, this is the filename of the
current file being processed if you need it in your command:

        ./imgconvert.sh -s ~/icons -i png -o xbm -alpha extract -negate $pic

Which should produce a more accurate transparency into the xmb file.

For more information about convert arguments/options run: man convert
	

Arguments and Options
---------------------

        -h, --help           show script usage
        -s, --source         source path of folder where images are stored
                             [optional] if not specified current dir will be selected
        -d, --destination    destination path for the converted images
                             [optional] if not specified source dir will be selected
        -i, --input          input image format to convert
        -o, --output         output image format to save as
        -n, --name           name filter for source files

You can set convert (imagemagick) arguments and options at the end of the command.
For more information run: man convert
        

Screenshot
----------
![Screenshot](https://raw.github.com/mrt-prodz/imgconvert.sh/master/screenshot.png)

Created by Themistokle Benetatos (http://www.mrt-prodz.com)
