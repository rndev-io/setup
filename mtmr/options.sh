#!/bin/bash

value=$(curl "https://yandex.ru/search/?text=yndx" 2>/dev/null | xmllint --html --xpath "//div[contains(@class,'fact-answer')]/descendant::*/text()" - 2>/dev/null)
echo 💰YNDX ${value/ USD/$}
