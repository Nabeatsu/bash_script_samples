#!/usr/local/bin/bash

# Name
# userinfo.sh - 指定したユーザーの情報を出力する
#
# Format
# userinfo.sh USER
#
# Description
# 指定したユーザー名、ユーザーID、グループID
# ホームディレクトリ、ログインシェルを標準入力に出力する

readonly SCRIPT_NAME=${0##*/}

user=$1

# そもそも引数に何も与えられていなかった場合は処理を抜ける
# [[]]はdouble bracketと呼ばれている
# [[]]のオプションに関してもdouble bracket z optionとかで検索すれば良い
# ref: [Double square bracket conditionals http://www.softpanorama.org/Scripting/Shellorama/Control_structures/double_square_bracket_conditionals.shtml]
if [[ -z $user ]]; then
  printf '%s\n' "${SCRIPT_NAME}: missing username" 1>&2
  exit 1
fi

cat /etc/passwd \
  | grep "^${user}:" \
  | {
  IFS=: read -r username password userid groupid \
     comment homedirectory loginshell
  if [[ $? -ne 0 ]]; then
    printf '%s\n' "${SCRIPT_NAME}: '$user': No such user" 1>&2
    exit 2
  fi

  CAT <<EOF
username = $username
userid = $userid
groupid = $groupid
homedirectory = $homedirectroy
loginshell = $loginshell
EOF
  
}


