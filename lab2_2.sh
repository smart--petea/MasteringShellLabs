#Write a shell script that will display every line in the /etc/hosts file that is not
#comented out with a #(hash mark), using command, not file, input redirection

if (( $# != 1 ))
then
  echo 'there must be specified the file name'
  exit 1
fi

if [[ ! -r $1 ]]
then
  echo "file $1 is not readable"
  exit 1
fi

while read LINE
do
  [[ $LINE =~ ^[^#].*$ ]] && echo $LINE
done < <(cat $1)
