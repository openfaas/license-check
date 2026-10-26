#!/bin/sh

uname=$(uname)

suffix=""
case $uname in
"Linux")
    arch=$(uname -m)
    echo $arch
    case $arch in
    "aarch64")
    suffix="-arm64"
    ;;
    esac
;;
esac

version=$(curl -sI https://github.com/openfaas/license-check/releases/latest | grep Location | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')

url="https://github.com/openfaas/license-check/releases/download/$version/license-check${suffix}"

echo "Downloading $url.."

curl -fsSL $url > license-check
chmod +x license-check
