#!/bin/bash

docker run -d \
    --name=jdownloader-2 \
    --rm \
    -p 5800:5800 \
    -v ~/.config/jdownloader-2:/config:rw \
    -v $HOME/Downloads:/output:rw \
    jlesage/jdownloader-2
