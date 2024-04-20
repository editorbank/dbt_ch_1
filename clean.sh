set -ex
[ -f "podman_or_docker.tmp" ] && docker="$(cat podman_or_docker.tmp)" || docker=$(podman --help >/dev/null 2>&1 && echo podman || echo docker)

# Удаление контейнеров и образов сделанных проектом
$docker ps -q -f "name=some-clickhouse-server" | xargs -r $docker rm -f || true
$docker images -q clickhouse/clickhouse-server | xargs -r $docker rmi -f || true

# Удаление игнорируемых Git-ом файлов кроме *.bak (как файлов так и директорий) И Удаление только пустых директорий
git ls-files --others --ignored --exclude-standard 2>/dev/null | grep -v .bak | grep -v ch_data/ | grep -v ch_logs/ | xargs -r -i{} rm "{}" || true
find . -not -path './ch_data/*' -empty -type d -delete 2>/dev/null || true
sudo ./clean_ch_data.sh
