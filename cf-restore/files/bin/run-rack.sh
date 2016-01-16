if [ "$NOCOMPRESSION" = "true" ];
then
   for i in $(rack files object list --container $CONTAINER --no-header --output csv | cut -d ',' -f 1); do 
      rack files object download --container $CONTAINER --name $i > $DIRECTORY/$i; 
   done
else
   rack files object download --container $CONTAINER --name backup.tar.gz > backup.tar.gz
   tar -zxvf backup.tar.gz -C $DIRECTORY
fi
