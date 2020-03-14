#!/bin/bash

# Change it to the default firmware file path in hex format.
FIRMWARE_HEX='./firmware.hex'

# Query whether commandline-arguments have been set
if [ "$#" -gt "1" ]; then
  echo "Usage: ./flash.sh or ./flash.sh /path/to/firmware.hex"
  exit
elif [ "$#" -eq "1" ]; then
  echo "File-argument was set to \""$1"\""
    FIRMWARE_HEX=$1
else
  echo "No file-argument was set -> taking default \""$FIRMWARE_HEX"\""
fi

if [[ ! $(which avrdude) ]]; then
  echo "avrdude missing. exiting."
  exit
fi

if [ "${FIRMWARE_HEX##*.}" != "hex" ]; then
  echo "Invalid file extension!"
  exit
fi

if [[ ! -e $FIRMWARE_HEX ]]; then
  echo "$FIRMWARE_HEX not found. exiting."
  exit
fi


while true; do
  avrdude -v -p atmega2560 -c wiring -P $(ls /dev/ttyUSB*) -b 115200 -D -U flash:w:$FIRMWARE_HEX:i;
  if [ "$?" -eq "0" ]; then
    break;
  fi;
done;

