#!/bin/bash

JSON="{"

while read -r HATCH; do
  JSON="${JSON}$(bash $HATCH),"
done < "hatchlings/*.hatch.sh"

JSON="${JSON}}"

printf "$JSON"