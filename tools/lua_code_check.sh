#!/bin/sh

check_code_style_lua() {
         files="$(find ${1} -name *.lua)"
         if [ -n "$files" ];
         then
                 luacheck $files --globals ngx --globals eco --no-max-line-length --codes --ignore 421 --ignore 212 --ignore 411 --ignore 431 --ignore 111 || {
                         exit 1
                 }
         fi
}
check_code_style_lua $@
