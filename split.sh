if [ -f $1 ] 
then
  FILE_SPLIT=$1
else
  echo "Can't find file $1";
  exit 1
fi

LINE_COUNT=$( cat $FILE_SPLIT | wc -l)
(( LINE_COUNT = LINE_COUNT / 2 ))

DIRNAME=$(dirname $1)
FILENAME=$(basename $1)
NAME=$(echo $FILENAME | sed s/[.][^.]*$//)
EXT=$(echo $FILENAME | sed s/.*[.]/./)

DIRNAME_NAME=$(echo "$DIRNAME/$NAME")
awk -v linecount=$LINE_COUNT -v filename=$DIRNAME_NAME -v ext=$EXT '{if( NR <= linecount ) print > filename "_first" ext; else print > filename "_second" ext}' $FILE_SPLIT
