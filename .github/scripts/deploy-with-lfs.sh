#!/bin/bash

set -e

# 配置变量
BUILD_DIR="${1:-build/web}"
GITHUB_TOKEN="${2:-$GITHUB_TOKEN}"
REPO="${3:-$GITHUB_REPOSITORY}"
BRANCH="${4:-gh-pages}"

# 获取当前工作目录（从 workflow 调用时就是项目根目录）
WORKSPACE_DIR="$(pwd)"
BUILD_ABS_PATH="$WORKSPACE_DIR/$BUILD_DIR"

echo "🚀 开始使用 Git LFS 部署到 GitHub Pages"
echo "📁 工作目录: $WORKSPACE_DIR"
echo "📁 构建目录: $BUILD_ABS_PATH"
echo "🌐 仓库: $REPO"
echo "🌿 分支: $BRANCH"

# 检查必要的工具
command -v git >/dev/null 2>&1 || { echo "❌ git 未安装"; exit 1; }
command -v git-lfs >/dev/null 2>&1 || { echo "❌ git-lfs 未安装"; exit 1; }

# 检查构建目录是否存在
if [ ! -d "$BUILD_ABS_PATH" ]; then
    echo "❌ 构建目录不存在: $BUILD_ABS_PATH"
    exit 1
fi

# 查找大文件（大于 50MB 的文件）
echo "🔍 检查大文件..."
LARGE_FILES=$(find "$BUILD_ABS_PATH" -type f -size +50M -not -path '*/.git/*' | head -20)

if [ -n "$LARGE_FILES" ]; then
    echo "📦 发现以下大文件，将使用 Git LFS 管理："
    echo "$LARGE_FILES" | while read -r file; do
        size=$(stat -c%s "$file")
        echo "  - $file ($(echo "scale=2; $size/1000000" | bc)MB)"
    done
else
    echo "ℹ️ 没有发现大文件"
fi

# 设置 Git 配置
git config --global user.name "GitHub Actions"
git config --global user.email "actions@github.com"

# 克隆 gh-pages 分支
echo "📥 克隆 gh-pages 分支..."
git clone --single-branch --branch "$BRANCH" "https://x-access-token:$GITHUB_TOKEN@github.com/$REPO.git" gh-pages-temp

cd gh-pages-temp

# 初始化 Git LFS（如果还没有初始化）
if [ ! -f ".gitattributes" ]; then
    echo "🔧 初始化 Git LFS..."
    git lfs install
fi

# 为大文件设置 Git LFS 跟踪
if [ -n "$LARGE_FILES" ]; then
    echo "📋 设置 Git LFS 跟踪规则..."
    
    # 为常见的大文件类型设置 LFS 跟踪
    echo "*.pck filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.pkz filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.zip filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.exe filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.dll filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.so filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    echo "*.dylib filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
    
    # 为特定的大文件设置跟踪
    echo "$LARGE_FILES" | while read -r file; do
        if [ -f "$file" ]; then
            # 获取相对于构建目录的路径
            rel_path=$(realpath --relative-to="$BUILD_ABS_PATH" "$file")
            echo "$rel_path filter=lfs diff=lfs merge=lfs -text" >> .gitattributes
            echo "  ✓ 设置 $rel_path 使用 Git LFS"
        fi
    done
fi

# 清理旧文件（保留 .git 和 .gitattributes）
echo "🧹 清理旧文件..."
find . -maxdepth 1 ! -name '.git' ! -name '.gitattributes' ! -name '.' -exec rm -rf {} + 2>/dev/null || true

# 复制新文件
echo "📋 复制新文件..."
cp -r "$BUILD_ABS_PATH"/* .

# 如果有 .gitattributes 文件在构建目录中，保留我们的设置
if [ -f "$BUILD_ABS_PATH/.gitattributes" ]; then
    echo "📋 合并 .gitattributes 设置..."
    cat "$BUILD_ABS_PATH/.gitattributes" >> .gitattributes
    # 去重
    sort -u .gitattributes > .gitattributes.tmp && mv .gitattributes.tmp .gitattributes
fi

# 添加所有文件到 Git
echo "➕ 添加文件到 Git..."
git add .

# 检查是否有更改
if git diff --staged --quiet; then
    echo "ℹ️ 没有更改需要部署"
    cd ..
    rm -rf gh-pages-temp
    exit 0
fi

# 提交更改
echo "💾 提交更改..."
commit_message="Deploy to GitHub Pages with Git LFS - $(date '+%Y-%m-%d %H:%M:%S')

Files managed with Git LFS:
$(echo "$LARGE_FILES" | sed 's/^/  - /' || echo "  None")
"

git commit -m "$commit_message"

# 推送更改（包括 LFS 对象）
echo "📤 推送更改（包括 Git LFS 对象）..."
git push origin "$BRANCH"

# 清理
cd ..
rm -rf gh-pages-temp

echo "🎉 部署完成！"
if [ -n "$LARGE_FILES" ]; then
    echo "✅ 大文件已通过 Git LFS 成功部署"
    echo "💡 Git LFS 会自动处理文件的下载和缓存"
else
    echo "✅ 所有文件已成功部署"
fi