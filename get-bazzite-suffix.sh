#!/bin/bash

if [[ "$flavor" = "nvidia" ]]; then
  echo "suffix=-nvidia-open" >> $GITHUB_OUTPUT
elif [[ "$flavor" = "base" ]]; then
  echo "suffix=" >> $GITHUB_OUTPUT
fi