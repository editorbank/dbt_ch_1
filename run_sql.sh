set -e
[ -z "$1" ] && ( 2>&1 echo "Use: $0 <filename.sql> | \"sql command\"" ; exit 1 )
( [ -f "$1" ] && cat "$1" || echo "$*" ) | curl --fail-with-body "http://localhost:$(cat chport.bak)/?database=ch_database&user=ch_username&password=ch_password&query=" -s --data-binary @-
