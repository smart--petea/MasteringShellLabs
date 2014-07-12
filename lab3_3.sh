#Mastering unix shell
#Chapter 3, exercise 3
#Expand the elapsed_time function to calculate days, hours, minutes, and seconds
ECHO="echo -e "

elapsed_time_original() {
  SEC=$1

  (( SEC < 60 )) && $ECHO "[Elapsed time: $SEC seconds]\c"

  (( SEC >= 60 && SEC < 3600 )) && $ECHO  "[Elapsed time: $(( SEC / 60 )) min $(( SEC % 60 )) sec]\c"

  (( SEC > 3600 )) && $ECHO "[Elapsed time: $(( SEC / 3600 )) hr $(( (SEC % 3600) / 60 )) min $(( (SEC % 3600) % 60 )) sec]\c"
}

elapsed_time_extended() {
  SEC=$1

  (( SEC < 60 )) && $ECHO "[Elapsed time: $SEC seconds]"

  (( SEC >= 60 && SEC < 3600 )) && $ECHO  "[Elapsed time: $(( SEC / 60 )) min $(( SEC % 60 )) sec]"

  (( SEC > 3600 )) && $ECHO "[Elapsed time: $(( SEC / 3600 )) hr $(( (SEC % 3600) / 60 )) min $(( (SEC % 3600) % 60 )) sec]"
  
  (( SEC > 12 * 3600 )) && $ECHO "[Elapsed time: $(( SEC / (12 * 3600) )) days $(( (SEC % (12 * 3600)) / 3600 )) hr $(( ((SEC % (12 * 3600)) % 3600) / 60 )) min $(( ( (SEC % (12* 3600)) % 3600) % 60 )) sec]"
}

SEC=30
elapsed_time_extended $SEC

(( SEC += 60 ))
elapsed_time_extended $SEC

(( SEC+=3600 ))#plus one hour
elapsed_time_extended $SEC

(( SEC+=( 12 * 3600) )) #plus one day
elapsed_time_extended $SEC
