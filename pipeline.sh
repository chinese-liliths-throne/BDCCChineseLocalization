#!/bin/bash
set -euo pipefail

# Paratranz API Token 必须由环境变量提供，不要写死在脚本里
: "${PARATRANZ_TOKEN:?请先 export PARATRANZ_TOKEN=<Paratranz API Token>}"
PARATRANZ_PROJECT="${PARATRANZ_PROJECT:-10958}"
TRANSLATION_VERSION="${TRANSLATION_VERSION:-1.0.0}"
SUBMODULE_BRANCH="${SUBMODULE_BRANCH:-chinese}"

# 1) 子模块拉到远端最新
git submodule update --init --recursive --remote

# 2) BDCC 工作树必须先回到与远端一致
#    Godot（.NET）打开项目会自动改 .import / .tres / project.godot，这些脏改动会被
#    当成源码提取出来（实测会多出「原文是中文」的词条）。汉化侧需要的代码补丁必须
#    提交在 chinese 分支上，不能只留在工作树里。
git -C BDCC fetch --quiet origin
git -C BDCC reset --hard "origin/${SUBMODULE_BRANCH}"
if [ -n "$(git -C BDCC status --porcelain)" ]; then
  echo "错误: BDCC 工作树仍有改动，先处理再继续：" >&2
  git -C BDCC status --porcelain >&2
  exit 1
fi

# 3) 提取 → 合并 → 替换 → 校验 → 打包
dotnet run --project BDCCChineseLocalization -- Translate \
  "$PARATRANZ_TOKEN" "$PARATRANZ_PROJECT" -v "$TRANSLATION_VERSION"
