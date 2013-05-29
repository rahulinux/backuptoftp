#!/usr/bin/evn bash
#----------------------------------------------------------------------------
# Name          :- ftpbkp.sh    v 0.1   Copyright (c) 20013-2014
# Pupose        :- Uploading Backup files to FTP Server
# Author        :- Rahul Patil<http://www.linuxian.com>
# Created       :- 28 May 2013
# Version       :- 0.1
# License       :- GPL
# Report `ftpbkp.sh` bugs to loginrahul90@gmail.com
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# | How Script will work |
# This Script will first try to login with mention username password
# in the script , if login fail then it will try to loing with anoymous
# after login successfully it will upload file to ftp server
#----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Variables=
#----------------------------------------------------------------------------
Uname=''                        # Set ftp Username
Passwd=''                       # Set ftp password
Ftp_Server='192.168.226.1'      # Ftp Server IP

: ${Uname:=anonymous}   # if username is not define then make it anonymous
: ${Passwd:=anonymous}  # if Password is not define then make it anonymous


#----------------------------------------------------------------------------
# Functions()
#----------------------------------------------------------------------------
Show_Help(){
cat <<_EOF
Usage: $0 [OPTION]... [FILE]...

Mandatory arguments to long options are mandatory for short options too.

  -f, --file  <filename1...>         Input files which you want to upload

Report $0 bugs to loginrahul90@gmail.com
_EOF
}

Upload_files() {

ftp -inv $Ftp_Server <<-_EOF
        user $Uname $Passwd
        bin  # Enable Binary Mode
        mput ${data[@]:1}
        bye
        _EOF

}


Main(){

        case $1 in
                -f) data=( $* )
                    Upload_files
                    ;;
                 *) Show_Help
                    ;;
        esac

}

Main $*
