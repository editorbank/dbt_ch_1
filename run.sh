set -e
source .venv/bin/activate
dbt run-operation stage_external_sources
dbt run
