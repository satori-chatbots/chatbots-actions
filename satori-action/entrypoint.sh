#!/bin/sh 

echo "Running action with:"
echo "  - format: [$INPUT_FORMAT]"
echo "  - files: [$INPUT_FILES]"

if [ "$INPUT_FORMAT" = "conga" ]; then
#  echo `ls /`
  java -jar /asymob_runSample.jar $INPUT_FILES
fi
