#!/usr/bin/env bash
#----------------------------------------------------------------------------
# Name :- ftpbkp.sh v 0.1 Copyright (c) 20013-2014
# Pupose :- Uploading Backup files to FTP Server
# Author :- Rahul Patil<http://www.linuxian.com>
# Created :- 28 May 2013
# Version :- 0.1
# License :- free
# Report `ftpbkp.sh` bugs to loginrahul90@gmail.com
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# | How Script will work |
# This Script will first try to login with mention username password
# in the script , if login fail then it will try to loing with anoymous
# after login successfully it will upload file to ftp server
# stored logs in /tmp/ftpbkp.log
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Variables=
#----------------------------------------------------------------------------
Uname='' # Set ftp Username
Passwd='' # Set ftp password
Ftp_Server='' # Ftp Server IP

: ${Uname:=anonymous} # if username is not define then make it anonymous
: ${Passwd:=anonymous} # if Password is not define then make it anonymous


#----------------------------------------------------------------------------
# Functions()
#----------------------------------------------------------------------------
Show_Help(){
cat <<_EOF
Usage: $0 [OPTION]... [FILE]...

Mandatory arguments to long options are mandatory for short options too.

-f, --file <filename1...> Input files which you want to upload

Report $0 bugs to loginrahul90@gmail.com
_EOF
}

check_connection(){

  if [[ -z $Ftp_Server ]]; then
		 echo "Please Specify FTP server in `basename $0`"
	elif ! nc -vzw2 ${Ftp_Server} 21 >/dev/null; then
		 echo "Unable to connect $Ftp_Server"
		 exit 1
	fi
  
}

Upload_files() {

ftp -inv $Ftp_Server <<-_EOF
user $Uname $Passwd
bin # Enable Binary Mode
mput ${data[@]:1}
bye
_EOF

}


Main(){

        case $1 in
                -f) data=( $* )
					         {
					           echo "---@@@--{ Ftp Backup Start at $( date ) }--@@@---"
					           check_connection
					           Upload_files  
					           echo "---@@@--{ Ftp Backup End at $( date ) }--@@@---"
					         } tee -a /tmp/ftpbkp.log
					
                    ;;
                 *) Show_Help
                    ;;
        esac

}

Main $*
