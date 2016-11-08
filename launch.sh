#!/usr/bin/env bash
FILENAME=$1
OFFSET_FILE="$FILENAME.offset"
N="0";
if [ -a $OFFSET_FILE ]
    then
    N=$(<"$OFFSET_FILE")
   else
      `echo "1" > $OFFSET_FILE`;
fi
echo $N  "$OFFSET_FILE"
tail -f -n +$N "$FILENAME" | { stack exec -- lship-exe --offset-out $OFFSET_FILE; pkill -P$$ tail; }