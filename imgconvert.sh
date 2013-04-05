#!/bin/bash
#
# Batch Image Converter
#
# Convert all images inside a folder to another given format
#
# Usage:         imgconvert -s [PATH] -d [PATH] -i [EXTENSION] -o [EXTENSION]
# Usage Example: ./imgconvert.sh -s ~/Wallpaper -d /tmp -i jpg -o png
#
# Dependencies:  imagemagick
#
# Created by Themistokle Benetatos (http://www.mrt-prodz.com)

# global variables - strings
title='Batch Image Converter'
errorargs='Not enough arguments supplied.'
errorconvert='Cannot find or access convert from the imagemagick package.'
msg_error="\e[1;31mERROR\e[0m"
msg_ok="\e[1;92mOK\e[0m"
usage="
Usage: imgconvert -s [PATH] -d [PATH] -i [EXTENSION] -o [EXTENSION] [EXTRAS]

  -h, -help             show script usage
  -s, -source           source path of folder where images are stored
                        [optional] if not specified current dir will be selected
  -d, -destination      destination path for the converted images
                        [optional] if not specified source dir will be selected
  -i, -input            input image format to convert
  -o, -output           output image format to save as

Example: ./imgconvert.sh -s ~/Wallpaper -d /tmp -i jpg -o png
  
To convert all your png images inside your folder $HOME/icons to xbm while
keeping transparency, you can add convert specific arguments/options at the end
of the command like the following:

./imgconvert.sh -s ~/icons -i png -o xbm -background white -alpha Background

For more information about convert arguments/options run: \$man convert
"

# global variables - source destination input output
s='' # source
d='' # destination
i='' # input
o='' # output
e='' # extra argument/option for imagemagick

# checking for dependencies
if ! which "convert" &>/dev/null; then
    echo -e "\n$title error:\n  $errorconvert\n"
    exit 1
fi

# no arguments? show help and exit
if [ $# -eq 0 ]
then
    echo -e "\n$title error: $errorargs\n$usage\n"
    exit 1
fi  

# check if directory is valid
function checkDir () {
	local loc_directory="$1"
	local loc_action="$2"
	if [ ! -d "$loc_directory" ]; then
		echo -e " [$msg_error] - directory doesn't exists.\n"
		exit 1
	elif [[ ! -r "$loc_directory" && "$loc_action" -eq "read" ]]; then
		echo -e " [$msg_error] - read permission denied.\n"
		exit 1
	elif [[ ! -w "$loc_directory" && "$loc_action" -eq "write" ]]; then
		echo -e " [$msg_error] - write permission denied.\n"
		exit 1
	else
		echo -e " [$msg_ok]"
	fi
}

function f_process_args () {
	while (( $# )) ; do
		case "$1" in
			-h | --help)
				printf '%s' "$usage"
				exit 0
				;;
			-s | --source)
				# check if argument is valid
				if [[ $2 == -* ]] || [ -z $2 ]; then
					shift 1
					s=$(pwd)
					printf '  \e[1;33m--source\e[0m         not specified, using current: %s' "$s"
				else
					s=$2
					# check if path ends with / if not add it
					[[ $s != */ ]] && s="$s"/
					shift 2
					printf '  \e[1;33m--source\e[0m         %s' "$s"
				fi
			
				# check if folder exists for reading
				checkDir "$s" "read"
				;;
			-d | --destination)
				# check if argument is valid
				if [[ $2 == -* ]] || [ -z $2 ]; then
					# if destination has no option let f_check_parameters assign source to it
					shift 1
				else
					d=$2
					# check if path ends with / if not add it
					[[ $d != */ ]] && d="$d"/
					shift 2
					printf '  \e[1;33m--destination\e[0m    %s' "$d"
					# check if folder exists for writing
					checkDir "$d" "write"
				fi
				;;
			-i | --input)
				# check if argument is valid
				if [[ $2 == -* ]] || [ -z $2 ]; then
					echo -e "  \e[1;33m--input\e[0m          [$msg_error] - not specified."
					exit 1
				else
					i=$2
					shift 2
					echo -e "  \e[1;33m--input\e[0m          $i"
				fi
				;;
			-o | --output)
				# check if argument is valid
				if [[ $2 == -* ]] || [ -z $2 ]; then
					echo -e "  \e[1;33m--output\e[0m        [$msg_error] - not specified."
					exit 1
				else
					o=$2
					shift 2
					echo -e "  \e[1;33m--output\e[0m         $o"
				fi
				;;
			*)
				# other options are sent to convert
				e+="$@"
				break
				;;
		esac 
	done;
}

function f_check_parameters () {
	# no source has been set, use current directory
	if [ -z $s ]; then
		s=$(pwd)
		printf '  \e[1;33m--source\e[0m         not specified, using current: %s\n' "$s"
	fi

	# no destination has been set, use current directory
	if [ -z $d ]; then
		d="$s"
		printf '  \e[1;33m--destination\e[0m    not specified, using source: %s\n' "$d"
	fi

	# no input format has been set, throw error
	if [ -z $i ]; then
		echo -e "  \e[1;33m--input\e[0m          not specified. [$msg_error]\n"
		exit 1;
	fi

	# no output format has been set, throw error
	if [ -z $o ]; then
		echo -e "  \e[1;33m--output\e[0m         not specified. [$msg_error]\n"
		exit 1;
	fi
}

function f_convert_files() {
	echo
	# save all images with specific format in a variable
	local loc_pics=$(ls $s*.$i 2>/dev/null)
	# check if pics list is empty
	if [ -z "$loc_pics" ]; then
		echo -e "No $i files were found.\n"
		exit 1;
	fi
	local loc_picsnum=$(echo "$loc_pics" | wc -l)
	local loc_idx=0
	local loc_progress=0

	# request confirmation to convert x number of files
	read -p "You are about to convert $loc_picsnum files, continue? (y/n) " choice
	echo
	case "$choice" in
		y|Y)
			# for each pic convert and show progress
			for pic in $loc_pics
			do
					# increment current index
					let "loc_idx += 1"
					# update progress current/total
					loc_progress="$loc_idx/$loc_picsnum"
					# print pic name and convert the file
					printf '\e[1;33mconverting\e[0m %s\n  \e[1;33mprogress\e[0m %s\r' "$pic" "$loc_progress"
					convert $pic $e $d$(basename $pic .$i)."$o" >/dev/null 2>&1
			done
			echo -e "\n\nFinished.\n"
			;;
		n|N)
			echo -e "Aborted.\n"
			;;
		*)
			exit 0
			;;
	esac
}


# ----
# main
# ------------

# echo title of the script
echo -e "\n$title:"

# process arguments and set global variables
f_process_args "$@"

# check and validate parameters
f_check_parameters

# convert files
f_convert_files "$@"
