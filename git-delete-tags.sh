#!/bin/bash

# check for input filename argument
if [ -n "$1" ]
then
  filename=$1
  if [ ! -r "$filename" ]
  then
    echo "File does not exist or is not readable: $filename"
    exit;
  fi
else
  echo "Please indicate a filename path as the argument, e.g.:" 
  echo "git-tags-delete.sh PATH/TO/FILE_WITH_LIST_OF_TAGS"
  exit; 
fi

# try to delete tags listed in file
while read tag; do
  # push updates to origin
  git tag -d $tag 
  git push origin :refs/tags/$tag
done < $filename 

exit;
