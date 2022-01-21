#!/bin/sh

uname=$(uname)

suffix=""
case $uname in
"Darwin")
suffix="-darwin"
;;
"Linux")
    arch=$(uname -m)
    echo $arch
    case $arch in
    "aarch64")
    suffix="-arm64"
    ;;
    esac
    case $arch in
    "armv6l" | "armv7l")
    suffix="-armhf"
    ;;
    esac
    case $arch in
    "s390x")
    suffix="-s390x"
    ;;
    esac
    case $arch in
    "ppc64le")
    suffix="-ppc64le"
    ;;
    esac
;;
esac

version=$(curl -sI https://github.com/openfaas/license-check/releases/latest | grep Location | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')

url="https://github.com/openfaas/license-check/releases/download/$version/license-check${suffix}"

echo "Downloading $url.."

curl -fsSL $url > license-check
chmod +x license-check
