#!/bin/bash
set -eo pipefail

# used for updater when WDQS_BACKEND_UPDATER_INIT is set to true
export WDQS_BACKEND_UPDATER_START_TIME="$(date --date="${WDQS_BACKEND_WIKIBASE_MAX_DAYS_BACK:-90} days ago" +%FT%TZ)"
