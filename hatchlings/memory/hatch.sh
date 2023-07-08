#!/bin/bash

function check_required() {
    # free check
    if [[ -z "$(free --version)" ]]; then
      echo "'free' is not installed"
      exit 1
    fi

    #head check
    if [[ -z "$(head --version)" ]]; then
      echo "'head' is not installed"
      exit 1
    fi

    #grep check
    if [[ -z "$(grep --version)" ]]; then
      echo "'grep' is not installed"
      exit 1
    fi

    #awk check
    if [[ -z "$(awk --version)" ]]; then
      echo "'awk' is not installed"
      exit 1
    fi
}

function accepted_args() {
  ACCEPTED_ARGS="bytes kilo mega giga tera peta kibi gibi mebi tebi pebi human"
  if [[ -n $( grep -w $(printf "$1" | sed 's/ //g') < <(printf "$ACCEPTED_ARGS") 2> /dev/null) ]] 
  then 
    echo "--$1" 
  fi

}

function get_memory_total() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $2}')\"}"
}

function get_memory_used() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $3}')\"}"
}

function get_memory_free() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $4}')\"}"
}

function get_memory_shared() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $5}')\"}"
}

function get_memory_cache() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $6}')\"}"
}

function get_memory_avail() {
  printf "{\"response\": \"$(free $(accepted_args "$1") | grep -E '^Mem:' | awk '{print $7}')\"}"
}

## Main ##
check_required
"$1" "$2"
