#!/bin/bash

# Ask user for input with tofi
query=$(tofi --prompt-text "Search (yt:/g:): ")

# If something was typed
if [ -n "$query" ]; then
    # YouTube search if prefixed with yt:
    if [[ $query == yt:* ]]; then
        search=${query#yt:}
        brave "https://www.youtube.com/results?search_query=${search// /+}"

    # Google search if prefixed with g:
    elif [[ $query == g:* ]]; then
        search=${query#g:}
        brave "https://www.google.com/search?q=${search// /+}"

    # Default = Google search
    else
        brave "https://www.google.com/search?q=${query// /+}"
    fi
fi
