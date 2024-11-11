#!/bin/bash

case "$flavor" in
  "base")
    echo "suffix=" >> $GITHUB_OUTPUT;;
  "nvidia")
    echo "suffix=-nvidia-open" >> $GITHUB_OUTPUT;;
esac
