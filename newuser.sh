#!/bin/bash


############ USAGE ############
usage() {
      echo "usage: [FILE] [FIRSTNAME LASTNAME <NUMBER>]"
      echo
      echo "PARAMETER"
      echo -e "\tFILE - must be LASTNAME comma FIRSTNAME on each line e.g. john,smith. Additional comma can be added if duplicated names e.g. john,smith,1"
      echo -e "\tFIRSTNAME LASTNAME <NUMBER> - first argument must be FIRSTNAME and second argument must be LASTNAME. Third argument can be a number if duplicated names"
}

if [[ $* == "-h" || $* == "--help" || $* == "-usage" ]]; then
      usage
      exit 1
fi

############ ERROR HANDLING ############
if [[ $(id -u) -ne 0 ]] ; then

      # Check for root priviledges
      echo "Please run as root"
      exit 1

elif [[ $# -eq 1 ]]; then

      # If file argument
      USER_FILE=$1

      # If file does not exist, exit
      if [[ ! -e $USER_FILE ]]; then
            echo "File does not exist"
            exit 1
      fi

elif [[ $# -eq 2 || $# -eq 3 ]]; then

      # If add single user argument
      ADD_SINGLE_USER=true
      FIRSTNAME=$1
      LASTNAME=$2
      NUM=$3
else

      # Wrong usage
      usage
      exit 1

fi

############ CREATE SSH KEY FUNCTION ############
setup_SSH_Auth() {
      su -l -c "ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa -q" $1
      su -l -c "cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys" $1 
      su -l -c "chmod 600 ~/.ssh/authorized_keys" $1
}

############ ADD USER(S) ############
if [[ $ADD_SINGLE_USER ]]; then

      # Add a single user

      # Create the username ( John Smith --> jsmith )
      USERNAME=$(echo "${FIRSTNAME:0:1}${LASTNAME}${NUM}" | tr [:upper:] [:lower:])

      # Add the user else exit
      useradd $USERNAME -m -s /bin/bash || exit

      # Create user's ssh key
      setup_SSH_Auth $USERNAME

      echo "ADDED: ${FIRSTNAME^} ${LASTNAME^} ($USERNAME)"

else

      # Read from file line by line - comma seprated lines (john,smith)
      while IFS=',' read FIRSTNAME LASTNAME NUM || [[ -n "$line" ]]; do

            # Create the username ( John Smith --> jsmith )
            USERNAME=$(echo "${FIRSTNAME:0:1}${LASTNAME}${NUM}" | tr [:upper:] [:lower:])

            # Add the user else skip
            useradd $USERNAME -m -s /bin/bash || continue

            # Create user's ssh key
            setup_SSH_Auth $USERNAME

            echo "ADDED: ${FIRSTNAME^} ${LASTNAME^} ($USERNAME)"

      done < $USER_FILE

fi