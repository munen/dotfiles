#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Error: No output filename provided"
    echo "Usage: $0 output_filename.gif"
    exit 1
fi

geometry=$(slop -f "-video_size %wx%h -i :0.0+%x,%y")
ffmpeg -framerate 30 -f x11grab $geometry "$1"
