#1. Modify the findlarge.ksh shell script in Listing 9-1 to add a second commandline 
#argument so that you can specify a search path other than the current
#directory. You shoul add this user-supplied search path as an option, and if a search 
#path is omitted, you use the current directory to start the search. 
#This adds a little more flexibility to the original shell script

#2. When searching large filesystems, the search may take a very long time co complete
#To give the user feedback that the search process is continuing, add one of 
#the progress indicators studied in Chapter 4. 'Progress Indicators Using a Series 
#of Dots, a Rotating Line, or Elapsed Time." Each of the three progress indicators
#would be appropriate; refer to Chapter 4 for details. Name the modified file so that the method selected is intuitively obvious.

function usage {
  echo "\n*******************************************************"
  echo "\n\nUSAGE:  findlarge.ksh   [Number_Of_meg_Bytes] [search_path]"
  echo "\n\nWill find Files Larger Than 5 Mb in, and Below, the  Current Directory..."
  echo "\n\nEXITING...\n"
  echo "\n*******************************************************"
  exit
}

function cleanup {
  echo "\n*********************************************************"
  echo "\n\nEXITING ON A TRAPPED SIGNAL..."
  echo "\n\n*******************************************************"
  exit
}

trap 'cleanup' 1 2 3 15

case $# in
  0)
    usage
    ;;
  1)
    SEARCH_PATH=`pwd`
    ;;
  2)
    SEARCH_PATH=$2
    if [ ! -d $SEARCH_PATH ]
      echo "ERROR: search path $SEARCH_PATH is not a directory"
      usage
    fi
    ;;
  *)
    usage
esac

echo "search path $SEARCH_PATH"

exit 0

THISHOST=`hostname`
DATESTAMP=`date +"%h%d:%Y:%T"`
MEG_BYTES=$1
DATAFILE="/tmp/filesize_datafile.out"

>$DATAFILE
OUTFILE="/tmp/largefiles.out"
>$OUTFILE

HOLDFILE="/tmp/temp_hold_file.out"
>$HOLDFILE

echo "\n\nSearching for Files Larger Than ${MEG_BYTES}MB starting in:"
echo "\n==> $SEARCH_PATH"
echo "\n\nPlease Standby for the Search Results..."
echo "\n\nLarge Files Search RESULTS:" >> $OUTFILE
echo "\nHostname o Machine: $THISHOST" >> $OUTFILE
echo "\nTop Level Directory of Search:" >> $OUTFILE
echo "\n=> $SEARCH_PATH" >> $OUTFILE
echo "\nDate/Time of Search: 'date'" >> $OUTFILE
echo "\n\nSearch Results Sorted by Time:" >> $OUTFILE

find $SEARCH_PATH -type f -size +${MEG_BYTES}000000c -print > $HOLDFILE

if [ -s $HOLDFILE ]
then
  NUMBER_OF_FILES=$( cat $HOLDFILE | wc -l )

  echo "\n\nNumber of Files Found: ==> $NUMBER_OF_FILES\n\n" >> $OUTFILE

  ls -lt `cat $HOLDFILE` >> $OUTFILE

  more $OUTFILE

  echo "\n\nThese Search Results are Stored in ==> $OUTFILE"
  echo "\n\nSearch Complete...EXITING...\n\n\n"
else
  cat $OUTFILE
  echo "\n\nNo FILES were Found in the Search Path that"
  echo "are Larger than ${MEG_BYTES}Mb\n\n"
  echo "\nEXITING...\n\n"
fi
