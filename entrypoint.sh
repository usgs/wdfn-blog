#!/bin/bash

set -eux -o pipefail

COMMAND=$1
ARGS=${@:2}

case ${COMMAND} in
    build)
        cd /src/themes/wdfn_theme
        npm install
        npm run build
        cd /src
        hugo ${ARGS}
        ;;
    server)
        cd /src/themes/wdfn_theme
        npm install
        npm run watch & cd /src && hugo server --bind=0.0.0.0 ${ARGS}
        ;;
    *)
        exec "$@"
        ;;
esac
