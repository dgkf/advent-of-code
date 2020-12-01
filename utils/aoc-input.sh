#! /bin/bash

# example: sh aoc-input.sh 2019 2

day=$(echo $2 | sed -e 's:^0*::')
cachefile="$(dirname "$0")/cache/$1/$day/input.txt"
mkdir -p $(dirname $cachefile)

if ! test -f "$cachefile"; then
    cookiefile="$(dirname "$0")/cookies.secret"
    curl "https://adventofcode.com/$1/day/$day/input" \
        --cookie "$(cat $cookiefile)" \
        --output "$cachefile" \
        --silent
fi

cat "$cachefile"
