#!/bin/sh

# Use curl to fetch kitten images from https://placekitten.com/

set -e
if git rev-parse --is-inside-work-tree > /dev/null 2>&1 ; then
  cd "$(git rev-parse --show-toplevel)"
  mkdir -p images
  curl --retry 2 --fail -s -L -o images/kitten1.jpeg https://placekitten.com/512/512
  curl --retry 2 --fail -s -L -o images/kitten2.jpeg https://placekitten.com/1024/512
  curl --retry 2 --fail -s -L -o images/kitten3.jpeg https://placekitten.com/512/1024
  curl --retry 2 --fail -s -L -o images/kitten4.jpeg https://placekitten.com/1024/1024
  printf "Fetched %d kittens from {placekitten} into %s:\n " 4 ./images 1>&2
  ls images 1>&2
else
  printf "error: outside Git work tree\n" 1>&2
  exit 1
fi
