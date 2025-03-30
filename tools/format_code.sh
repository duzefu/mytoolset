#!/bin/sh

check_code_style()
{
        local DIR="$1"
        files="$(find ${DIR} -name "*.c" -o -name "*.h")"
        for file in ${files};do
                astyle --style=kr -s4  --indent-switches \
                --attach-closing-while \
                --indent-col1-comments \
                --align-pointer=name \
                --attach-return-type \
                --attach-return-type-decl \
                --unpad-paren \
                --pad-oper \
                --pad-header -n ${file}
        done
}

check_code_style $@
