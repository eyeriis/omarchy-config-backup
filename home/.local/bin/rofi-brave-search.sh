#!/bin/bash

query=$(rofi -dmenu -p "Search:")

if [[ "$query" == yt:* ]]; then
    brave "https://www.youtube.com/results?search_query=${query#yt:}"
elif [[ "$query" == g:* ]]; then
    brave "https://www.google.com/search?q=${query#g:}"
else
    brave "https://www.google.com/search?q=$query"
fi
