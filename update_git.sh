#!/bin/bash
CWD=$(pwd)

function pullupdatedcode() {
   cd $CWD
   git pull origin master 
   if [ $? -ne 0 ] ; then
        echo "Unable to pull repo";
        exit 1;
    fi
}

function commitcurrentcode() {
   cd $CWD
   git add . && \
   git add -u && \
   git commit -m "${message}"
}

function pushcommitedcode() {
   cd $CWD
   git push origin master
   if [ $? -ne 0 ] ; then
        echo "Unable to push repo";
        exit 1;
    fi
}

function rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )               printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}" 
}

function getcommitmessage() {
    local msg
    echo -n "Enter commit message:"
    read -r msg
    message=$msg
    echo
}

getcommitmessage
pullupdatedcode
commitcurrentcode
pushcommitedcode
