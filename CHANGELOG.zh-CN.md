# BDCC 游戏更新日志（中文翻译）

游戏官方更新日志 [`CHANGELOG.md`](https://github.com/Alexofp/BDCC/blob/main/CHANGELOG.md) 的中文翻译，仅供阅读。
条目按版本号从新到旧排列，每次同步上游后只补新增的版本小节，旧版本不重译。

发版时 `release` job 会自动取本文件**第一个** `## [版本]` 小节，附在汉化更新日志之后
（见 `.github/workflows/runner.yml` 的 `Create release.md` 步骤），所以：
文件头与分隔线之下必须紧跟最新版本小节，小节之间用 `## [x.y.z] - YYYY-MM-DD` 分隔。

翻译约定：

- 保持原文 `### Added / Changed / Fixed / Contributions` 四段结构与条目顺序；
- 术语沿用 Paratranz 项目 10958 的既定译法（`lust attack` → 欲望攻击、`bluespace` → 蓝域、
  `portal panties` → 传送门内裤、`strapon` → 假阳具、`chastity cage` → 贞操笼、`mod browser` → 模组浏览器、
  `dom route` → 支配路线、`main route` → 主线、`stocks` → 枷锁 / 颈手枷、`troubleshooting` → 故障排除）；
- 链接、`(by xxx)` 贡献者署名、代码标识符（如 `SexEngine.resetJustCame()`）原样保留。

---

## [0.4.1] - 2026-11-14

### 修复（Fixed）

- 修复了传送门贞操笼相关的崩溃。
- 修复了故障排除界面把调试信息导出到错误文件夹的问题。
- 有望修复了罕见的 rollbacker 线程崩溃。
- 修复了费里（Ferri）招募时的崩溃。
- 修复了 Jack 反馈的大量拼写错误。

## [0.4.0] - 2026-11-13

### 新增（Added）

- 支配主线新增任务。2 个新剧情任务、2 个支线任务、4 个福利向性爱场景、1 名新招募角色。每个任务都要写上好久，不过我觉得这次效果很不错 :3。张力十足、动作戏充足、色情内容管饱。
- [战斗动画全面翻新](https://github.com/user-attachments/assets/8da53902-f82f-4b36-9adf-457a78c1f529)！战斗场景更新了大量新动画和待机姿势。普通攻击、欲望攻击、束缚攻击——大多数攻击现在都有帅气的动画了。倒地状态现在也真的表现出来了！受击瞬间与挨打／格挡动画的衔接顺畅了不少。部分角色拥有独特的战斗待机姿态，你也可以选择自己的架势。
- [囚服和内裤现在有"敞开"状态](https://github.com/user-attachments/assets/a0eae35e-bd61-4e77-98d1-f7c3d9499d81)。会弄乱你衣着的欲望攻击现在会真的把衣服弄乱给人看！程序化性爱中你也可以"弄乱"衣服。也就是说，穿着衣服做爱是可行的，没错。
- 凯特（Kait）新增了一些怀孕相关的内容。
- 模组浏览器大幅改版。分类、依赖支持、自动删除旧版本、可见的预览图、AI 模组开关（AI 模组默认隐藏）、收藏、分页。下载模组从未如此方便。
- 新的性爱动画。2 个普通体位、1 个女上位、1 个扼颈性爱、1 个双插三人行。三人行在没有进行任何性爱行为时也会显示全部三名角色。69 式现在有快速版本。部分旧性爱动画也有所改进。
- 部分固定角色只要剧情推进得足够深入，现在允许你喂他们服用某些药物（发情／催乳等）。
- 囚服可以关掉上衣。拘束服可以关掉贞操带。
- [进阶假阳具](https://github.com/user-attachments/assets/a23924b9-377e-4a66-a069-9d9175581965)！这是实验室里可以解锁的新假阳具，能"投射"蓝域中任何可用的阴茎。只要给某人穿上传送门内裤，你基本上就能用这支假阳具使用对方的阴茎。毛病不少。它平时还是普通假阳具的用法，但射精时用的是对方的精液。我还加了[传送门贞操笼](https://github.com/user-attachments/assets/4609df75-30da-49be-97be-46444a3e5ba2)。功能和传送门内裤类似，但只覆盖阴茎。想用别人自己的老二操对方的时候，简直完美 x3
- 被按在墙上搜身现在有专属动画，你的角色每次被搜身都会用到。新的剧情场景也有新的性爱动画。

### 变更（Changed）

- 现在可以在程序化性爱的任意时刻让假阳具"射精"。
- （玩家）进行抵抗现在会提升角色的抵抗值。
- 伊丽莎任务的最终阶段现在会更好地说明你需要做什么。

### 修复（Fixed）

- 自动翻译的按钮现在点"显示原文"会恢复成原文，而不再只恢复场景文本。
- 影响胸部大小的 TF 药丸现在判定是否该生效时，依据的是"基础"胸部尺寸而非"最终"尺寸。
- 修复了一些崩溃和拼写错误。

### 贡献（Contributions）

- [新增查看某位作者全部模组的功能](https://github.com/Alexofp/BDCC/pull/354)（by keerifox）
- [拒绝帮忙从枷锁／荡妇墙上被放下来时可以提出用身体交换，并避免反复遇到同一批救人或性工作客户](https://github.com/Alexofp/BDCC/pull/356)（by keerifox）
- [改动 2 行，使 part3D 能引用其玩偶所属的角色](https://github.com/Alexofp/BDCC/pull/359)（by Selinoccino）
- [可模组化的代码块](https://github.com/Alexofp/BDCC/pull/360)（by Selinoccino）
- [性工作客户明确要求时，允许玩家不计声望地服务主子](https://github.com/Alexofp/BDCC/pull/362)（by keerifox）
- [小修小补](https://github.com/Alexofp/BDCC/pull/365)（by keerifox）
- [载入／新游戏时重建游戏扩展器](https://github.com/Alexofp/BDCC/pull/364)（by Selinoccino）
- [让 2 个通用 NPC 遵循性别显示选项](https://github.com/Alexofp/BDCC/pull/368)（by Selinoccino）
- [修复模组菜单按钮的快捷键](https://github.com/Alexofp/BDCC/pull/370)（by Selinoccino）
- [调整 `SexEngine.resetJustCame()` 的调用位置，避免它在 SexActivities 访问之前就被重置](https://github.com/Alexofp/BDCC/pull/366)（by Mindstormsman）
