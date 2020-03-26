
datadir=data
address1=`awk  '{print $6}' $datadir/00"/account1.txt"`
address2=`awk  '{print $6}' $datadir/00"/account2.txt"`

address1=${address1:3:42}
address2=${address2:3:42}

echo $address1
echo $address2
