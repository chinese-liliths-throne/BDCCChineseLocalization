#!/bin/bash
set -euo pipefail

# Paratranz API Token 必须由环境变量提供，不要写死在脚本里
: "${PARATRANZ_TOKEN:?请先 export PARATRANZ_TOKEN=<Paratranz API Token>}"
PARATRANZ_PROJECT="${PARATRANZ_PROJECT:-10958}"
TRANSLATION_VERSION="${TRANSLATION_VERSION:-1.0.0}"

git submodule update --remote

dotnet run --project BDCCChineseLocalization -- Translate \
  "$PARATRANZ_TOKEN" "$PARATRANZ_PROJECT" -v "$TRANSLATION_VERSION"
