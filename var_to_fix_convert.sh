#SORT_ORDER
#COMMON_NAME
#FORMAL_NAME
#TYPE
#SUB_TYPE
#SOVEREIGNITY
#CAPITAL
#CURRENCY_CODE
#CURRENCY_NAME
#PHONE_CODE
#LETTER_CODE
#NUMBER
#IANA_COUNTRY_CODE


FROM_FILE=countrylist.csv
TO_FILE=countrylist_fixed.csv
>$TO_FILE #clear all from file

OLD_IFS=$IFS
IFS=,

I=0
while read SORT_ORDER COMMON_NAME FORMAL_NAME TYPE SUB_TYPE \
           SOVEREIGNITY CAPITAL CURRENCY_CODE CURRENCY_NAME \
           PHONE_CODE LETTER_CODE_12 LETTER_CODE_13 NUMBER IANA_COUNTRY_CODE
do
  (( I = I + 1 ))

  #skip first line
  if (( I == 1 ))
  then
    continue
  fi

  SORT_ORDER=$(echo $SORT_ORDER | sed -r -e ':a' -e "s/^.{1,5}$/#&/;ta")
  COMMON_NAME=$(echo "$COMMON_NAME" | sed -r -e ':a' -e "s/^.{1,60}$/#&/;ta")
  FORMAL_NAME=$(echo "$FORMAL_NAME" | sed -r -e ':a' -e "s/^.{1,100}$/#&/;ta")
  TYPE=$(echo "$TYPE" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  SUB_TYPE=$(echo "$SUB_TYPE" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  SOVEREIGNITY=$(echo "$SOVEREIGNITY" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  CAPITAL=$(echo "$CAPITAL" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  CURRENCY_CODE=$(echo "$CURRENCY_CODE" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  CURRENCY_NAME=$(echo "$CURRENCY_NAME" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  PHONE_CODE=$(echo "$PHONE_CODE" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  LETTER_CODE_12=$(echo "$LETTER_CODE_12" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  LETTER_CODE_13=$(echo "$LETTER_CODE_13" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  NUMBER=$(echo "$NUMBER" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  IANA_COUNTRY_CODE=$(echo "$IANA_COUNTRY_CODE" | sed -r -e ':a' -e "s/^.{1,30}$/#&/;ta")
  echo $SORT_ORDER$COMMON_NAME$FORMAL_NAME$TYPE$SUB_TYPE$SOVEREIGNITY$CAPITAL$CURRENCY_CODE$CURRENCY_NAMEPHONE_CODE$LETTER_CODE_12$LETTER_CODE_13$NUMBER$IANA_COUNTRY_CODE | tee -a $TO_FILE
done < $FROM_FILE

#restore IFS
IFS=$OLD_IFS
