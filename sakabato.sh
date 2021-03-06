#!/bin/bash

#Sakabatō script checks the hardening level in GNU/Linux server

#This first version only have a basic checks with 5 individual test:
#     1)If root is the only user.
#     2)If remote connection as root is enable (all OPENssh package).
#     3)If remote connection with password is available.
#     4)If the port number is default.
#     5)If firewall system is enable and only the minimum ports are allow.
#     For the next version:
#     6)If there are tasks in crontab. If that's the case, checks who are the
#       users and their file permissions.

cat <<!TITLE!
  ___ ___ __ ____ ___ ___________
  | _\|  \| V \  \| .\|  \_ _\   |
  [__ \ . \  <| . \ .<| . \||| . |
  |___//\_//\_//\_/___//\_/|/|___/

             by bronxi
    https://github.com/bronxi47

  *Sakabatō script checks the hardening
   level in GNU/Linux server.
  *This first version only have a basic
   checks with 4 individual test.

!TITLE!



#1
if echo "The following users exist in the system. Use them to log in remotely (do not use root for this):" &&
 eval getent passwd {$(awk '/^UID_MIN/ {print $2}' /etc/login.defs)..$(awk '/^UID_MAX/ {print $2}' /etc/login.defs)} | cut -d: -f1; then
  :
else
  echo "In this system only the root user exists, add a new user immediately and use it for remote connections"
fi

search(){
  grep $1 /etc/ssh/sshd_config -m 1
}

firstCharacter(){
  echo ${1:0:1}
}

lastString(){
  echo $2
}

commentOrYes(){
  [[ $1 == '#' ]] || [[ $2 == yes ]]
}


if [[ -f /etc/ssh/sshd_config ]]; then #Check if the configuration file exists.
#2
  loginRoot=$(search "PermitRootLogin")
  firstCharacterRoot=$(firstCharacter $loginRoot)
  lastStringRoot=$(lastString $loginRoot)
  if [[ $lastStringRoot == no ]]; then
    echo "Your Login as root is not available, great job!"
  elif [[ $lastStringRoot == without-password ]]; then
    echo "Your Login as root is available only public and private keys"
  elif commentOrYes $firstCharacterRoot $lastStringRoot; then
    echo "Your Login as root is available, change to NO this line: PermitRootLogin yes to PermitRootLogin no"
  else
    echo "Something is wrong with the configuration of Login Root :("
  fi
#3
  passAuth=$(search "PasswordAuthentication")
  firstCharacterPassAuth=$(firstCharacter $passAuth)
  lastStringPassAuth=$(lastString $passAuth)
  if [[ $lastStringPassAuth == no ]]; then
    echo "Your Password Authentication is not available, great job!"
    echo "This assumes that there are a public and private keys in use ;)"
  elif commentOrYes $firstCharacterPassAuth $lastStringPassAuth; then
    echo "Your Password Authentication is available, set to NO"
  else
    echo "Something is wrong with the configuration of Password Authentication :("
  fi

#4
  port=$(search "Port")
  firstCharacterPort=$(firstCharacter $port)
  lastStringPort=$(lastString $port)
  if [[ $firstCharacterPort == '#' ]] || [[ $lastStringPort == '22' ]]; then
    echo 'The port is set in default 22; Change this, uncomment and write another port number'

  elif [[ $lastStringPort != '22' ]]; then
    echo 'The port is not default, great job!'
  else
    echo 'Something is wrong with the configuration of Port'
  fi
else
  echo "The /etc/ssh/sshd_config file is not there, is ssh installed?"
fi
