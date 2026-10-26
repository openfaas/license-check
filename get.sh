#!/bin/sh

uname_s=$(uname -s)
uname_m=$(uname -m)

suffix=""
case "$uname_s/$uname_m" in
"Linux/x86_64")
    suffix=""
    ;;
"Linux/aarch64")
    suffix="-arm64"
    ;;
*)
    echo "Unsupported platform: $uname_s/$uname_m" >&2
    echo "license-check is published for Linux amd64 and arm64 only" >&2
    exit 1
    ;;
esac

version=$(curl -sI https://github.com/openfaas/license-check/releases/latest | grep Location | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')

url="https://github.com/openfaas/license-check/releases/download/$version/license-check${suffix}"

echo "Downloading $url.."

curl -fsSL $url > license-check
chmod +x license-check
