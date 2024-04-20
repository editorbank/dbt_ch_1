set -e

# Удаление томов Clickhouse
[ -d ./ch_data ] && rm -f -r ./ch_data
[ -d ./ch_logs ] && rm -f -r ./ch_logs

