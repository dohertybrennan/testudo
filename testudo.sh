#!/bin/bash

# /*
#  * Filename: /home/brennan/build_root/testudo/testudo.sh
#  * Path: /home/brennan/build_root/testudo
#  * Created Date: Saturday, March 4th 2023, 12:50:18 am
#  * Author: brennan
#  *
#  * Copyright (c) 2023
#  */

#### Functions ####

## Initial Check - Sees if we actually have this setup

# User Check - Do we have the appropriate user setup on this machine
testudo_user_check() {
    USER_EXISTS=$(cat /etc/passwd | cut -d ':' -f 1 | grep testudo)

    if [[ -z "$USER_EXISTS" ]]; then
        read -p "Looks like we don't have a user setup for Testudo. If you're daring, type \"I am brave\": " RESPONSE
        if [[ "$RESPONSE" != "I am brave" ]]; then exit 1; fi
    fi
}
#

# Main
testudo_init_checks() {
    testudo_user_check
}
#

##

## Scripts

# Main
## TODO Write logic for calling scripts. Trying to avoid nesting mulitple cases. Maybe more functions? :s
scripts() {
    for ARG in "$@"; do
        case $ARG in
        scripts)
            :
            ;;
        --*)
            echo "Double Option ${ARG}"
            ;;
        -?)
            echo "Option ${ARG}"
            ;;

        *)
            echo "Assuming Script ${ARG}"
            ;;
        esac
    done
}

main() {
    testudo_init_checks

    case $1 in

    scripts)
        scripts "$@"
        ;;
    *)
        echo help
        ;;

    esac

}

#### Entrypoint ####
main "$@"
