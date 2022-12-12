#!/bin/sh 

echo "Running action with:"
echo "  - format: [$INPUT_FORMAT]"
echo "  - files: [$INPUT_FILES]"

if [ "$INPUT_FORMAT" = "conga" ]; then
#  echo `ls /`
    java -jar /asymob_runSample.jar $INPUT_FILES | tee /tmp/output.txt
    COUNT=`grep "INP = 0" /tmp/output.txt | wc --lines`
    if [ $COUNT -gt 2 ]; then
	echo "More than two intents with INP > 2"
	exit 1
    fi
fi

exit 0
