#!/bin/bash

token=$(security find-generic-password -a ${USER} -s staff.yandex-team.ru -w)
value=$(curl https://staff.yandex-team.ru/profile-api/edoc/${USER} -H "Authorization: OAuth $token" 2>/dev/null | python -c 'import sys, json; print(json.load(sys.stdin)["target"]["food_balance_value"])')
echo 🍗 $value ₽

