set -e

#echo -ne 'GET /?database=ch_database&user=ch_username&password=ch_password&query=SELECT%201 HTTP/1.0\r\n\r\n' | nc localhost 8123

echo "SELECT version()" | curl --fail-with-body "http://localhost:$(cat ch_port.tmp)/?database=ch_database&user=ch_username&password=ch_password&query=" -s --data-binary @-

echo OK