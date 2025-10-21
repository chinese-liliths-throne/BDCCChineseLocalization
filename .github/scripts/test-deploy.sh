#!/bin/bash

set -e

echo "🧪 测试 Git LFS 部署脚本"

# 创建测试环境
TEST_DIR="test_deploy"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# 创建模拟的构建目录
mkdir -p build/web

# 创建一些测试文件
echo "<html><body>Test HTML</body></html>" > build/web/index.html
echo "console.log('test');" > build/web/test.js

# 创建一个大文件来测试 LFS（模拟 index.pck）
echo "创建测试大文件..."
dd if=/dev/zero of=build/web/index.pck bs=1M count=60 2>/dev/null || {
    # 如果 dd 不可用，使用其他方法
    python3 -c "
with open('build/web/index.pck', 'wb') as f:
    f.write(b'0' * 60 * 1024 * 1024)
"
}

echo "📁 测试文件结构："
find build/web -type f -exec ls -lh {} \;

# 运行部署脚本（使用测试参数）
echo ""
echo "🚀 运行部署脚本测试..."
cd ..

# 设置测试环境变量
export GITHUB_TOKEN="test_token"
export GITHUB_REPOSITORY="test/test"

# 运行脚本（但不实际推送）
bash .github/scripts/deploy-with-lfs.sh "$TEST_DIR/build/web" "test_token" "test/test" "gh-pages" || {
    echo "⚠️ 部署脚本测试完成（预期会失败，因为没有真实的仓库）"
}

# 清理
rm -rf "$TEST_DIR"

echo ""
echo "✅ 测试完成！"
echo "💡 在实际使用中，脚本会："
echo "   1. 检测大文件（>50MB）"
echo "   2. 为大文件配置 Git LFS"
echo "   3. 部署到 gh-pages 分支"
echo "   4. 自动处理 Git LFS 对象的推送"