#!/bin/sh -x
if [ "$NOCOMPRESSION" = "true" ];
then   
   rack files object upload-dir --container $CONTAINER --dir $DIRECTORY
else
   tar -zcvf backup.tar.gz $DIRECTORY
   rack files object upload --container $CONTAINER --name backup.tar.gz --file backup.tar.gz
fi
