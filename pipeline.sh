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
# .mono/ .import/ .godot/ 是 Godot 生成的未跟踪目录，不算脏改动；其余一律拦下
dirty="$(git -C BDCC status --porcelain --untracked-files=normal \
  | grep -vE '^\?\? \.(mono|import|godot)/' || true)"
if [ -n "$dirty" ]; then
  echo "错误: BDCC 工作树仍有改动，先处理再继续：" >&2
  echo "$dirty" >&2
  exit 1
fi

# 3) Python 解释器：优先用工具子模块里的 .venv（CI 里 deps 装在系统 python 上）
if [ -z "${PYTHON:-}" ] && [ -x "BDCC-Localization-Replacer/.venv/Scripts/python.exe" ]; then
  PYTHON="$(pwd)/BDCC-Localization-Replacer/.venv/Scripts/python.exe"
  # git-bash/MSYS 下 $(pwd) 是 /e/... 形式，.NET 起进程需要 Windows 原生路径
  if command -v cygpath >/dev/null 2>&1; then
    PYTHON="$(cygpath -w "$PYTHON")"
  fi
fi
export PYTHON="${PYTHON:-}"
if [ -n "$PYTHON" ]; then echo "使用 Python: $PYTHON"; fi

# 4) 提取 → 合并 → 替换 → 校验 → 打包
dotnet run --project BDCCChineseLocalization -- Translate \
  "$PARATRANZ_TOKEN" "$PARATRANZ_PROJECT" -v "$TRANSLATION_VERSION"
