#!/usr/bin/env bash

 find /tmp/* -type d -mtime +1 -exec rm --recursive --force --verbose {} +