# I collect current ip of machine
# and save it in .htaccess to allow for conexions only from current machine
#
HTACCESS=".htaccess"

cat /dev/null > $HTACCESS
ifconfig | sed -r -n '/inet addr/p'  \
          | sed -r 's/.*addr://' \
          | sed -r 's/([0-9.]*).*/allow from \1/' \
          | sed '1 i order deny,allow\ndeny from all' >> $HTACCESS
