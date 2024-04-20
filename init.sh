set -e
[ -d .venv ] || python3 -m venv .venv || python3 -m vitualenv .venv
[ -f .venv/bin/activate ] || (echo ERROR: The virtual environment was not created! ; exit 1)
source .venv/bin/activate
[ -f requirements.txt ] && pip install -r requirements.txt

