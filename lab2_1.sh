#Evalutate the following function:
#while_true_read_echo_line() {
#  while true
#  do
#    read LINE
#    echo "$LINE" > $OUTFILE
#    :
#  done < $INFILE
#}
#
#Does it work?
#If it works, how long does it atake to process a 1 MB file?
#It it works, by what percentage can you improve the timing by using file descriptors for
#1. input file?
#2. outputfile?
#3. both input and output files?

while_true_read_echo_line() {
  while true
  do
    read LINE
    [ -z $LINE ] && break 
    echo "$LINE" >> $OUTFILE
    :
  done < $INFILE
}

#file descriptor for input file
while_true_read_echo_line_IN() {
  exec 4<&0
  exec 0< $INFILE 
  while true
  do
    read LINE
    [ -z $LINE ] && break 
    echo "$LINE" >> $OUTFILE
    :
  done 

  exec 0<&4
  exec 4>&-
}

#file descriptor for output file
while_true_read_echo_line_OUT() {
  exec 3<&1
  exec 1>> $OUTFILE 
  while true
  do
    read LINE
    [ -z $LINE ] && break 
    echo "$LINE" 
    :
  done < $INFILE

  exec 1<&3
  exec 3>&-
}

#file descriptor for both
while_true_read_echo_line_IN_OUT() {
  exec 4<&0
  exec 0< $INFILE

  exec 3<&1
  exec 1>> $OUTFILE 

  while true
  do
    read LINE
    [ -z $LINE ] && break 
    echo "$LINE" 
    :
  done < $INFILE

  exec 0<&4
  exec 4>&-

  exec 1<&3
  exec 3>&-
}

INFILE=largefile.random.txt
OUTFILE=out.random.txt

declare -A ar            #   while_true_read_echo_line
declare -A in_ar         #while_true_read_echo_line_IN
declare -A out_ar       #while_true_read_echo_line_OUT()
declare -A in_out_ar

###################################
#   while_true_read_echo_line_IN_OUT statistic
##################################
  regex="([a-z]+)[[:blank:]]+0*?([0-9]+)m0*?([0-9]+)\.0*?([0-9]+)s"
  while read LINE
  do
    [[ -z $LINE ]] && continue

    [[ $LINE =~ $regex ]]
    name=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    sec=${BASH_REMATCH[3]}
    mili=${BASH_REMATCH[4]}
    #echo "name: $name"
    (( in_out_ar[$name] = min * 60 * 1000 + sec * 1000 + mili ))
  done < <((time while_true_read_echo_line_IN_OUT) 2>&1)
#######################################


###################################
#   while_true_read_echo_line statistic
##################################
  regex="([a-z]+)[[:blank:]]+0*?([0-9]+)m0*?([0-9]+)\.0*?([0-9]+)s"
  while read LINE
  do
    [[ -z $LINE ]] && continue

    [[ $LINE =~ $regex ]]
    name=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    sec=${BASH_REMATCH[3]}
    mili=${BASH_REMATCH[4]}
    #echo "name: $name"
    (( out_ar[$name] = min * 60 * 1000 + sec * 1000 + mili ))
  done < <((time while_true_read_echo_line_OUT) 2>&1)
#######################################


###################################
#   while_true_read_echo_line statistic
##################################
  regex="([a-z]+)[[:blank:]]+0*?([0-9]+)m0*?([0-9]+)\.0*?([0-9]+)s"
  while read LINE
  do
    [[ -z $LINE ]] && continue

    [[ $LINE =~ $regex ]]
    name=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    sec=${BASH_REMATCH[3]}
    mili=${BASH_REMATCH[4]}
    #echo "name: $name"
    (( ar[$name] = min * 60 * 1000 + sec * 1000 + mili ))
  done < <((time while_true_read_echo_line) 2>&1)
#######################################

###################################
#   while_true_read_echo_line_IN statistic
##################################
  regex="([a-z]+)[[:blank:]]+0*?([0-9]+)m0*?([0-9]+)\.0*?([0-9]+)s"
  while read LINE
  do
    [[ -z $LINE ]] && continue

    [[ $LINE =~ $regex ]]
    name=${BASH_REMATCH[1]}
    min=${BASH_REMATCH[2]}
    sec=${BASH_REMATCH[3]}
    mili=${BASH_REMATCH[4]}
    #echo "name: $name"
    (( in_ar[$name] = min * 60 * 1000 + sec * 1000 + mili ))
  done < <((time while_true_read_echo_line_IN) 2>&1)
#######################################

clear

echo -e "\nInput percentage: \n"
echo -e "\nreal: $(( (ar['real'] * 100) / in_ar['real']  ))%"
echo -e "\nuser: $(( (ar['user'] * 100) / in_ar['user']  ))%"
echo -e "\nsys: $(( (ar['sys']  * 100) / in_ar['sys']  ))%"

echo -e "\n\n\nOutput percentage: \n"
echo -e "\nreal: $(( (ar['real'] * 100) / out_ar['real']  ))%"
echo -e "\nuser: $(( (ar['user'] * 100) / out_ar['user']  ))%"
echo -e "\nsys: $(( (ar['sys']  * 100) / out_ar['sys']  ))%"

echo -e "\n\n\nInput Output percentage: \n"
echo -e "\nreal: $(( (ar['real'] * 100) / in_out_ar['real']  ))%"
echo -e "\nuser: $(( (ar['user'] * 100) / in_out_ar['user']  ))%"
echo -e "\nsys: $(( (ar['sys']  * 100) / in_out_ar['sys']  ))%"
