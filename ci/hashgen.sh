#!/bin/sh

for f in license-check*; do shasum -a 256 $f > $f.sha256; done