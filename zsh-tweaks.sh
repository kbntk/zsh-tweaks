#!/bin/zsh

#save full path  of current directory  in the zsh history 
dir_list_file=$HOME/".dir-list-file"
function savedirectory(){
	# grep - print lines not matching the dir
	# and save it to the file
	# result: delete the dir from the file
	# append the dir to the end of file
	dir_name=$(echo 'cd '`pwd`);
	echo $dir_name | add2history;
	grep -v "`pwd`" $dir_list_file | sponge $dir_list_file;
	echo $dir_name >> $dir_list_file;
}

alias mkdirsave-in-history="savedirectory"
alias pwd2dirsave="savedirectory"
alias directory2dirsave="savedirectory"
alias adddirectory="savedirectory"

#list directory stored in the file
# in the variable dir_list_file (about 15 lines up :) )
# and let the user choose the dir and switch to the chosen dir
function lsdirectories(){
	dir_index=""

	#cat -n $dir_list_file
	# awk is better than cat -n because it doesn't make such big intent
	awk '{print NR " " $0}' $dir_list_file
	dir_list_size=$(wc -l $dir_list_file | awk -F" " '{print $1}')
	#echo "dir_list_size: $dir_list_size" 
	if [[ "$#" -gt 0 ]] ; then
		dir_index=$1
		if [ -n "${dir_index}" ] && [ ! "${dir_index}" = "${dir_index%%[!0-9]*}" ] ; then
			vared -p 'Please choose a directory index ' -c dir_index
		fi
	else
		vared -p 'Please choose a directory index ' -c dir_index
	fi
	#echo "dir_index=$dir_index"
	#http://www.zsh.org/mla/users/2007/msg00111.html
	#check if variable contains numeric
	if [ -n "${dir_index}" ] && [ "${dir_index}" = "${dir_index%%[!0-9]*}" ] ; then
		if [[ $dir_index -le $dir_list_size ]]; then
			dir_selected_directory=""
			dir_selected_directory=$(sed -n $dir_index'p' $dir_list_file | awk -F";" '{print $1}')
			#echo $dir_selected_directory
			eval ${dir_selected_directory}
		fi
	fi
}


#format
#: 1439046380:1;./data.txt
#  timestamp
#a="'"`date +%s | tr -d '\r'`"'"
#store date as timestamp with deleted newline
#; printf ": %s",a; print ":1;"$0}'  
# print first ':' than the a variable and then add ":1"
# required by histfile format and then output
add2history(){
awk '{ a="'"`date +%s | tr -d '\r'`"'"; printf ": %s",a; print ":1;"$0}'  >> ~/.histfile
}
