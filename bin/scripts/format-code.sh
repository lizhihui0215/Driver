#!/bin/sh

if [ "$1" == "" ]; then
  echo "missing directory"
  exit 1
fi

if which swiftformat >/dev/null; then
  swiftformat $1 --stripunusedargs closure-only --patternlet inline --exclude $1/Resources/
else
  echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
fi

if which swiftlint >/dev/null; then
  swiftlint lint --path $1 --config ./.swiftlint.yml
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
