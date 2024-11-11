#!/bin/bash

if [[ "${{ matrix.flavor }}" = "nvidia" ]]; then
  echo "suffix=-nvidia-open" >> $GITHUB_OUTPUT
elif [[ "${{ matrix.flavor }}" = "base" ]]; then
  echo "suffix=" >> $GITHUB_OUTPUT
fi