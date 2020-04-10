#!/bin/bash

function netinfo() {
    echo "--------------- Network Information ---------------"
    external_ip=$(curl -s checkip.dyndns.org | sed -e 's/.*Current IP Address: //' -e 's/<.*$//')
    local_ip=$(ip -c -br a)

    echo -e "External IP address:\n${external_ip}\n"
    echo -e "Local IP addresses:\n${local_ip}\n"
    echo "---------------------------------------------------"
}
