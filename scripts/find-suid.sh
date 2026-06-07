#!/usr/bin/env bash

readarray dirs < <(findmnt --real -lno target)
find "${dirs[@]}" -xdev -type f -perm /06000 -exec ls -lZ {} +
