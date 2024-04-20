set -e
[ -n "$1" ] && docker="$1" || docker=$(podman --help >/dev/null 2>&1 && echo podman || echo docker)
echo -e "$docker" >podman_or_docker.tmp

[ -d .venv ] || python3 -m venv .venv || python3 -m vitualenv .venv
[ -f .venv/bin/activate ] || (echo ERROR: The virtual environment was not created! ; exit 1)
source .venv/bin/activate
[ -f requirements.txt -a ! -f pip_freeze.log ] && pip install -r requirements.txt && pip freeze >pip_freeze.log

[ -d ./ch_data ] || ( mkdir ./ch_data && chmod a+rwx ./ch_data )
[ -d ./ch_logs ] || ( mkdir ./ch_logs && chmod a+rwx ./ch_logs )

$docker ps -q -a -f "name=some-clickhouse-server" | xargs -r $docker rm -f
$docker run -d --name some-clickhouse-server \
    --ulimit nofile=262144:262144 \
    -v $(realpath ./ch_data):/var/lib/clickhouse/ \
    -v $(realpath ./ch_logs):/var/log/clickhouse-server/ \
    -p 8123:8123/tcp \
    -p 9000:9000/tcp \
    -e CLICKHOUSE_DB=ch_database \
    -e CLICKHOUSE_USER=ch_username \
    -e CLICKHOUSE_PASSWORD=ch_password \
    -e CLICKHOUSE_DEFAULT_ACCESS_MANAGEMENT=1 \
    docker.io/clickhouse/clickhouse-server

$docker ps -q -f "name=some-clickhouse-server" | xargs $docker inspect -f '{{range $k,$v:=.NetworkSettings.Ports}}{{if eq $k "8123/tcp"}}{{range $v}}{{print .HostPort}}{{end}}{{end}}{{end}}' >ch_port.tmp
