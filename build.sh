#!/bin/sh
set -eu
cd "$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
case "$(uname -s)" in
  Linux) widgetset=${1:-gtk2}; project=demo/SunGridDemo.lpi ;;
  Darwin) widgetset=${1:-cocoa}; project=demo/SunGridDemoMac.lpi ;;
  *) echo "Run this script on Linux or macOS." >&2; exit 2 ;;
esac
case "$widgetset" in
  gtk2|qt5|qt6|cocoa) ;;
  *) echo "Usage: sh build.sh [gtk2|qt5|qt6|cocoa]" >&2; exit 2 ;;
esac
lazbuild --build-all --widgetset="$widgetset" sungridlcl.lpk
lazbuild --build-all --widgetset="$widgetset" "$project"

lazbuild --build-all --widgetset="$widgetset" tests/SunGridSmoke.lpi
