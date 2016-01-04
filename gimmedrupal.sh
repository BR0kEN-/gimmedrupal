#!/usr/bin/env bash

# Dependencies:
# - Tr
# - Git
# - Bash
# - Drush

# Could be changed using FIRST argument for this script.
# Directory in "sites/".
SUBDIR="all"
# Could be changed using SECOND argument for this script.
# Directory with all sources (relative to current directory).
PROJECT="DRUPAL_PROJECT"

GITHUB_SUBDIR="custom"
GITHUB_COMMAND="git clone https://github.com/<ITEM> <DEST>"
GITHUB_THEMES="BR0kEN-/parallel"
GITHUB_MODULES="BR0kEN-/ctools_api"
GITHUB_FEATURES=""

DRUSH_SUBDIR="contrib"
DRUSH_THEMES="shiny"
DRUSH_MODULES="features ctools panels views libraries"
DRUSH_COMMAND="drush dl <ITEM> --destination=<DEST> -y"

# Get value of variable using it name.
#
# @param name
#   The name of variable.
variable()
{
    local VAR=$(echo ${1} | tr '[:lower:]' '[:upper:]')
    echo ${!VAR}
}

# Allow override of site subdirectory.
if [ -n "${1}" ]; then
    SUBDIR=${1}
fi

# Allow override of project name.
if [ -n "${2}" ]; then
    PROJECT=${2}
fi

# Download lates version of Drupal 7.
drush dl drupal-7 --drupal-project-rename=${PROJECT} -y
# Go to downloaded sources (required by Drush).
cd $(pwd)/${PROJECT}
# Change project directory name by full path.
PROJECT=$_

for system in github drush; do
    for type in themes modules; do
        for item in $(variable "${system}_${type}"); do
            DEST=${PROJECT}/sites/${SUBDIR}/${type}/$(variable "${system}_SUBDIR")/${item##*/}

            if [ ! -d ${DEST} ]; then
                COMMAND=$(variable "${system}_COMMAND")
                COMMAND=${COMMAND//\<ITEM\>/${item}}
                COMMAND=${COMMAND//\<DEST\>/${DEST}}

                eval ${COMMAND}
            fi
        done
    done
done
