# DSH 手机端（Web 客户端）

手机浏览器远程控制跑在电脑上的 **DeepSeek Harness**。通过 `@linxin666/dsh-remote-bridge` 的 **protocol v1**（`/ios/v1` WebSocket）直连，不需要安装 App。

## 在线地址

**https://lty05042.github.io/dsh-mobile-web/**

> 手机浏览器打开即可；iOS 建议「分享 → 添加到主屏幕」，Android Chrome 建议「菜单 → 添加到主屏幕」。
> 页面是单文件、零外部依赖，所有界面数据都在本地渲染。

## 电脑端配对工具

配对码只能在**运行 DSH 的电脑**上生成（一次性、30 秒有效）：

| 方式 | 说明 |
|---|---|
| 双击 `pair.cmd` | 直接打印配对链接 + 一键深链，并复制到剪贴板（深链已内置本站地址） |
| `powershell -ExecutionPolicy Bypass -File tools\pair.ps1 -Client https://lty05042.github.io/dsh-mobile-web/` | 命令行方式，同上 |
| DSH 侧栏二维码 | 电脑上点侧栏底部二维码图标 → 手机扫码复制链接文本 |

## 手机端使用

1. 手机打开 **https://lty05042.github.io/dsh-mobile-web/**
2. 把电脑给的**一键深链**发到手机点开（自动配对），或把 `wss://...?token=...` 粘贴到页面输入框后点「连接」
3. 配对一次后设备令牌保存在手机浏览器里，以后打开页面自动登录

配对码 30 秒一次性；过期回电脑重新生成。

## 功能

- 会话列表（**按工作区分组**、可折叠且记忆折叠状态 / 搜索 / 刷新 / 运行中与空白标记）
- 新建会话（工作区 + 预设 + 标题）、重命名、归档、置顶、分叉
- 聊天：历史渲染（消息 / 思考过程 / 工具调用 / 工具结果 / 代码块）+ 实时流式回复
- 发送消息、停止回合、权限审批卡片
- 斜杠指令与技能面板
- 模型切换 + **reasoning effort（推理强度）选择**
- 权限模式切换
- 公网连接（桥的中继 wss / TLS）、自动重连、已配对设备自动登录
- 手机竖屏适配（触控目标、软键盘避让、窄屏排版）

## 安全说明

- 传输强制 TLS：公网地址只接受 `wss://`（`ws://` 仅允许本机/局域网调试）
- 页面内置 CSP、`Referrer-Policy: no-referrer`，配对链接读入后立即从地址栏抹除
- 设备令牌等价于该 DSH 实例的控制凭据，只在自己的设备上配对
- 撤销设备：退出 DSH → 删除 `%USERPROFILE%\.dsh\remote-bridge\devices.json` → 重启 DSH
- 本仓库不含任何密钥；本地测试用的设备令牌文件从未被提交

## 仓库文件

```
index.html          # 客户端本体（单文件：HTML + CSS + JS，无构建、无依赖）
pair.cmd            # 电脑端：双击生成配对码（ASCII 脚本，避免 cmd 编码问题）
tools/pair.ps1      # 电脑端：配对码生成器（自动发现 DSH 端口、写剪贴板）
README.md           # 本文件
```

## 更新方式（维护者）

```powershell
# 在本地工程目录
powershell -ExecutionPolicy Bypass -File tools\publish.ps1 -Message "更新说明"
```

脚本会把 `index.html`、`pair.cmd`、`tools/pair.ps1`、公开版 README 同步到发布仓库并推送，GitHub Pages 约 30–60 秒自动重建。

## 已知限制

- 不支持取消归档（桥不传输已归档会话）、附件上传、子代理详情、问题（question）交互
- Markdown 为简化渲染（粗体、行内代码、代码块、换行）
- 配对需要电脑侧生成一次性码
- 需要 DSH ≥ 0.2.2-rc.1 且已启用 `dsh-remote-bridge`

---

本项目为个人自用工具；协议定义与名称权利归 `@linxin666/dsh-remote-bridge` 作者。
