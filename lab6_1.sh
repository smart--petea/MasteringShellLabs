#Modifyt the put_ftp_files_pw_var.ksh shell script in listing 6-13 to use
#getopts to parse command-line switches -l, ocal file, and -r, remote file. Both
#-l and -r switches require a string value
#
#The script syntax will be
#
#   put_ftp-files_pw_var.skh -l LocalFile -r RemoteFile

LOCALFILES=$1

THISSCRIPT=$(basename $0)
USER="randy"

usage(){
  echo "\nUSAGE: $THISSCRIPT \" -l local_dir -r remote_dir -f 'file_list'\" \n" 
  exit 1
}

usage_error() {
  echo "\nERROR: This shell script requires a list of one or more files to donwnload from the remote site.\n"
  usage
}

while getopts "f:l:r:" name
do
  case $name in
    l) LOCALDIR=$OPTARG
      ;;
    r) REMOTEDIR=$OPTARG
      ;;
    f) RNODE=$OPTARG
      ;;
    ?) usage
      ;;
    *) usage_error
      ;;
  esac
done

([[ -z $LOCALDIR ]] || [[ -z $REMOTEDIR ]] || [[ -z $RNODE ]]) && usage_error

case $SHELL in
  */bin/[bB]ash) alias echo="echo -e"
    ;;
esac

pre_event() {
  :
}

post_event(){
  :
}


. /usr/sbin/setlink.ksh

pre_event

ftp -i -v -n $RNODE <<END_FTP

user $USER $RANDY
binary
lcd $LOCALDIR
cd $REMOTEDIR
mput $LOCALFILES
bye

END_FTP

post_event
}
