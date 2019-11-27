license-check
==================

[![Build Status](https://travis-ci.com/teamserverless/license-check.svg?branch=master)](https://travis-ci.com/teamserverless/license-check)

This tool scans all files within a given path for copyright authors. It flags up any files which have authors not specified in a list of given strings. 

The tool is currently in use across the [OpenFaaS organisation](https://github.com/openfaas/) on GitHub.

## Usage

```
Usage:
  license-check -root $HOME/go/src/github.com/openfaas -verbose=false "Alex Ellis" "OpenFaaS Author(s)"
```

Just pass your license strings as arguments when running the tool.

### Downloading

The following can be added to a Dockerfile to download the license-check binary:

```Dockerfile
RUN curl -sSfL https://github.com/teamserverless/license-check/releases/download/0.2.3/license-check \
      > /usr/bin/license-check \
      && chmod +x /usr/bin/license-check
```

If you want to automatically download the correct binary for Linux/Darwin or armhf (Raspberry Pi) then use the `get.sh` script with the following:

```Dockerfile
RUN curl -sLSf https://raw.githubusercontent.com/teamserverless/license-check/master/get.sh | sh
```

### Example usage

```sh
license-check -path ./ --verbose=false "Alex Ellis" "OpenFaaS Project" "OpenFaaS Authors" "OpenFaaS Author(s)"
```

The following checks for the above valid strings in the current working path.

Examples of usage in OpenFaaS:

* https://github.com/openfaas/faas-cli/blob/master/Dockerfile
* https://github.com/openfaas/faas/blob/master/gateway/Dockerfile

## Contributing

If you'd like to submit a PR or request a feature, please raise an issue first.

Then once the issue is cleared for working on, go ahead and raise a PR making sure to read the [CONTRIBUTING](./CONTRIBUTING.md) guide.

### Development / hacking

Go 1.8 or newer is required

