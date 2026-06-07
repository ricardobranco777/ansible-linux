#!/usr/bin/env bash

readarray dirs < <(findmnt --real -lno target)
getcap -r "${dirs[@]}"
