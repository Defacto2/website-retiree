#!/usr/bin/env bash

function ping {
    local url=localhost:8888/status.cfm

    local response=$(curl -m 5 -so /dev/null -w '%{response_code}' $url)

    case "$response" in
        200 | 302 | 304) exit 0 ;;
        *)
            printf "Received: HTTP $response ==> $url\n"
            /usr/bin/docker container restart d2020-webapp
            exit 0
        ;;
    esac
}

ping
