#!/usr/local/bin/bash

# Name
# sumlines.sh - 数数数数値の合計を計算する。
#
# Format
# sumlines.sh
#
# Description
# 標準入力から数値を読み取って、その合計値を標準出力に出力する。
# 数値は1行に1つ書かれているものとする。
# 指定出来る数値は整数(0または負の値も含む)。小数は指定できない。
#
# Usage
# 数字の箇条書きのテキストファイルを用意する
# cat numbers.txt | ./sumlines.sh
# => 8
# ファイルサイズの合計を計算する
# ls -l | tail -n +2 | sed 's/ \{2,\}/ /g' | cut -d ' ' -f 5 | ./sumlines.sh



readonly SCRIPT_NAME=${0##*/}

result=0

while IFS= read -r number
do
  if [[ ! $number =~ ^-?[0-9]+$ ]]; then
    printf '%s\n' "${SCRIPT_NAME}: '$number': non-integer number" 1>&2
    exit 1
  fi

  ((result+=number))
done

printf '%s\n' "$result"
