#!/bin/bash

case "$flavor" in
  "base")
    echo "suffix=" >> $GITHUB_OUTPUT;;
  *nvidia)
    echo "suffix=-$flavor-open" >> $GITHUB_OUTPUT;;
  *)
    echo "suffix=-$flavor" >> $GITHUB_OUTPUT;;
esac
