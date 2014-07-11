#Write a shell script to count down from two hours to zero seconds using the 
#hour, minute, second display format
#utilizing the shell's SECONDS variable

function show_seconds { # COUNT DELAY SAME_LINE
  COUNT=$1
  DELAY=$2
  SAME_LINE=$3

  while (( SECONDS < COUNT ))
  do
    (( i = COUNT - SECONDS ))
    FOR_PRINT=$( printf "%2d hours %2d minutes %2d seconds"  $(( i / 3600 ))  $(( (i % 3600) / 60 )) $(( (i % 3600) % 60 )) )

    if (( SAME_LINE == 1 )) 
    then
      BACK=""
      for (( i = 0; i < ${#FOR_PRINT} ; i = i + 1 ))
      do
        BACK+="\b"
      done
      BACK+="\c"
    fi

    echo -e "$FOR_PRINT$BACK"
    sleep $DELAY
  done
}

show_seconds 7200 1 0 #first solution
show_seconds 7200 1 1 #second solution


