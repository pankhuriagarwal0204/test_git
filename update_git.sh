#!/bin/bash
CWD=$(pwd)

function parse_git_branch() {
    $branch=git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
    echo $branch
}

function pullupdatedcode() {
   cd $CWD
   git pull origin master | sed "s/\(https:\/\/\)\(.*\)$/\1${username}:${password}@\2/" 
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
   git push origin master | sed "s/\(https:\/\/\)\(.*\)$/\1${username}:${password}@\2/" 
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

function getcredentials() {
    local u p msg
    echo -n "Enter github username:"
    read u
    echo -n "Enter commit message:"
    read -r msg
    echo -n "Enter github password:"
    read -s p
    username=$(rawurlencode $u)
    password=$(rawurlencode $p)
    message=$msg
    echo
}

getcredentials
pullupdatedcode
commitcurrentcode
