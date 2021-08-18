#!/usr/bin/env bash

server=$1 # server IP
status=$(nmap "$server" -Pn -p 22 | egrep -io 'open|closed|filtered')

while [ "$status" != "open" ]; do
  status=$(nmap "$server" -Pn -p 22 | egrep -io 'open|closed|filtered')

  if [ "$status" == "open" ]; then
    echo "SSH Connection to $server over port 22 is possible"
  elif [ "$status" == "filtered" ]; then
    echo "SSH Connection to $server over port 22 is possible but blocked by firewall"
  elif [ "$status" == "closed" ]; then
    echo "SSH connection to $server over port 22 is not possible"
  else
    echo "Unable to get port 22 status from $server"
  fi
  sleep 10
done

