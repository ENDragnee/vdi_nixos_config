#!/usr/bin/env bash
echo "os_type value=\"$(nixos-version | cut -d' ' -f1)\""
