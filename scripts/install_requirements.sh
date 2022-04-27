#!/usr/bin/bash

if [[ -f "requirements.txt" ]] 
then
    echo "Installing custom packages"
    pip install -r requirements.txt --no-cache-dir
else
    echo "File requirements.txt not found"
fi