#!/bin/bash

token='<bottoken>'
chat="$1"
subj="$2"
message="$3"

/usr/bin/curl -s --header 'Content-Type: application/json' --request 'POST' --data "{\"chat_id\":\"${chat}\",\"text\":\"${subj}\n${message}\",\"parse_mode\":\"html\"}" "https://api.telegram.org/bot${token}/sendMessage"
