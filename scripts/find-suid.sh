#!/usr/bin/env bash

readarray -t dirs < <(findmnt --real -lno target)
find "${dirs[@]}" -xdev -type f -perm /06000 -exec ls -lZ {} +
