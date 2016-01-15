if [ -z "$NOCOMPRESSION" ]
then   
   rack files object upload-dir --container $CONTAINER --dir $DIRECTORY
else
   tar -zcvf backup.tar.gz $DIRECTORY
   rack files object upload --container $CONTAINER --name backup.tar.gz
fi
