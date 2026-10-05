#!/bin/bash
set -e

FLUTTER_VERSION="3.44.0"
FLUTTER_DIR="$HOME/flutter"

if ! command -v flutter &>/dev/null; then
  git clone https://github.com/flutter/flutter.git \
    -b "$FLUTTER_VERSION" --depth 1 "$FLUTTER_DIR"
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

flutter config --enable-web
flutter pub get
flutter build web --release
