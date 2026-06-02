#!/bin/bash

# Define the bar characters
bars="  ▂▃▄▅▆▇█"
dict="s/;//g;"

# Create sed dictionary to replace numbers with bar characters
for i in {0..8}; do
    char="${bars:$i:1}"
    dict+="s/$i/$char/g;"
done

# Path to cava config
config_file="/home/bub/.config/polybar/scripts/cava.config"

# Run cava and pipe through sed for character replacement
cava -p "$config_file" | stdbuf -o0 sed "$dict"
