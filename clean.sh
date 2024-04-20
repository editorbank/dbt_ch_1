set -e
docker ps -q -f "name=some-clickhouse-server" | xargs -r docker rm -f
docker images -q clickhouse/clickhouse-server | xargs -r docker rmi -f
