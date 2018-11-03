#!/usr/local/bin/bash

# Name
# remove_alpha_channel.sh - ディレクトリ内の画像からアルファチャンネルを削除する
#
# remove_alpha_channel.sh
#

readonly SCRIPT_NAME=${0##*/}

if !(type cnvert) > /dev/null 2>&1; then
  printf '%s\n' "${SCRIPT_NAME}: imagemagick is not installed"
  exit 1
fi

files=`\find . -maxdepth 1 -name '*.png'`
if [[ -z $files ]]; then
  printf '%s\n' "${SCRIPT_NAME}: No png file in this directory"
  exit 1
fi


for file in $files; do
  convert $file \
          -background white \
          -alpha remove \
          -quality 100 \
          removed-${file##*/}
  #removed-${file##*/}
  #          ${file##*/}
done
