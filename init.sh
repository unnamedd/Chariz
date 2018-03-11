#!/bin/bash
set -e

find . -name Cartfile -execdir carthage bootstrap --verbose --platform macos --no-use-binaries --cache-builds \;
