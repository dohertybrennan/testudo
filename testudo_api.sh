#!/bin/bash

function check_required() {
    #nc check
    if [[ -z "$(which nc)" ]]; then
      echo "'nc' is not installed"
      exit 1
    fi
}

function api() {
  rm -f out
  mkfifo out
  trap "rm -f out" EXIT
  while true
  do
    cat out | nc -w1 -l 1500 > >( # parse the netcat output, to build the answer redirected to the pipe "out".
      export REQUEST=
      while read line
      do
        line=$(echo "$line" | tr -d '[\r\n]')

        if echo "$line" | grep -qE '^GET /' # if line starts with "GET /"
        then
          REQUEST=$(echo "$line" | cut -d ' ' -f2) # extract the request
        elif [ "x$line" = x ] # empty line / end of request
        then
          HTTP_200="HTTP/1.1 200 OK"
          HTTP_LOCATION="Location:"
          HTTP_404="HTTP/1.1 404 Not Found"
          # call a script here
          # Note: REQUEST is exported, so the script can parse it (to answer 200/403/404 status code + content)
          if echo $REQUEST | grep -qE '^/hatchling/'
          then
              HATCHLING=$(echo "$REQUEST" | cut -d '/' -f3)
              FUNCTION=$(echo "$REQUEST" | cut -d '/' -f4)
              OPTION=$(echo "$REQUEST" | cut -d '/' -f5)
              if [[ -n $(ls -1 "hatchlings/$HATCHLING/hatch.sh") ]];
              then
                echo "Found! $HATCHLING"
                printf "%s\n%s %s\n\n%s\n" "$HTTP_200" "$HTTP_LOCATION" "$REQUEST" "$(bash hatchlings/$HATCHLING/hatch.sh $FUNCTION $OPTION)"  > out
              else
                printf "%s\n%s %s\n\n%s\n" "$HTTP_404" "$HTTP_LOCATION" $REQUEST "{\"error\": \"Hatchling not found\"}" > out
              fi
          else
              printf "%s\n%s %s\n\n%s\n" "$HTTP_404" "$HTTP_LOCATION" $REQUEST "{\"error\": \"Invalid endpoint\"}" > out
          fi
        fi
      done
    )
  done
}

check_required
api

