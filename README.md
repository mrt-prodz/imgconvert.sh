Batch Image Converter
=====================

Convert all images inside a folder into another given format.

Dependencies: imagemagick

Usage and Example
-----------------

Usage:

        ./imgconvert.sh -s [PATH] -d [PATH] -i [EXTENSION] -o [EXTENSION]	
        ./imgconvert.sh --source [PATH] --destination [PATH] --input [EXTENSION] --output [EXTENSION]


To convert all your jpg images inside your folder $HOME/Wallpaper to png and save them inside /tmp run:

        ./imgconvert.sh -s ~/Wallpaper -d /tmp -i jpg -o png
	

Arguments and Options
---------------------

        -h, --help           show script usage
        -s, --source         source path of folder where images are stored
                             [optional] if not specified current dir will be selected
        -d, --destination    destination path for the converted images
                             [optional] if not specified current dir will be selected
        -i, --input          input image format to convert
        -o, --output         output image format to save as
        
        

Created by Themistokle Benetatos (http://www.mrt-prodz.com)

