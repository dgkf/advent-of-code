# example: sh aoc-input.sh 2019 2

cachefile="$(dirname "$0")/cache/$1-$2.txt"

if ! test -f "$cachefile"; then
    cookiefile="$(dirname "$0")/cookies.secret"
    curl "https://adventofcode.com/$1/day/$2/input" \
        --cookie "$(cat $cookiefile)" \
        --output "$cachefile" \
        --silent
fi

cat "$cachefile"