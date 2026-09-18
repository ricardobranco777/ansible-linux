#!/usr/bin/env bash

readarray -t dirs < <(findmnt --real -lno target)
getcap -r "${dirs[@]}"
