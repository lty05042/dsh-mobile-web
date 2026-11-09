# DSH 手机端（Web 客户端）

手机浏览器远程控制跑在电脑上的 **DeepSeek Harness**。通过 `@linxin666/dsh-remote-bridge` 的 **protocol v1**（`/ios/v1` WebSocket）直连，不需要安装 App。

## 在线地址

**https://lty05042.github.io/dsh-mobile-web/**

> 用手机浏览器打开上面的地址；iOS 建议「分享 → 添加到主屏幕」，Android Chrome 建议「菜单 → 添加到主屏幕」。

## 功能

- 会话列表（标题 / 工作目录 / 运行中 / 空白标记 / 搜索 / 刷新）
- 新建会话（选工作区 + 预设 + 标题）、重命名、归档、置顶、分叉
- 聊天：历史渲染（消息 / 思考过程 / 工具调用 / 工具结果 / 代码块）+ 实时流式回复
- 发送消息、停止回合、权限审批卡片
- 斜杠指令与技能面板
- 模型切换 + **reasoning effort（推理强度）选择**
- 权限模式切换
- 公网连接（桥的中继 wss / TLS）、自动重连、已配对设备自动登录
- 手机竖屏适配（触控目标、软键盘避让、窄屏排版）
- 界面数据全部本地渲染（无外部 CDN、无第三方脚本）

## 快速使用

1. 在电脑上打开 DSH，展开侧栏，点底部的二维码图标（`配对 iPhone`）
2. 用手机相机扫码，复制二维码里的链接文本（形如 `wss://xxx.dsh-market.com/ios/v1?token=...`）
3. 在手机页面里粘贴到「配对链接」输入框，点「连接」
4. 配对一次后设备令牌保存在本机浏览器里，之后打开页面自动登录

配对码 30 秒有效且一次性；过期就在电脑面板点「重新取码」。

也支持深链：把 `wss://...?token=...` 做 URL 编码后拼成 `https://lty05042.github.io/dsh-mobile-web/?pair=<编码后的链接>`，手机点开即自动配对。

## 安全说明

- 传输强制 TLS：公网地址只接受 `wss://`（`ws://` 仅允许本机/局域网调试）
- 页面内置 CSP、`Referrer-Policy: no-referrer`，配对链接读入后立即从地址栏抹除
- 设备令牌等价于该 DSH 实例的控制凭据，只在自己的设备上配对
- 撤销设备：退出 DSH → 删除 `%USERPROFILE%\.dsh\remote-bridge\devices.json` → 重启 DSH
- 手机丢失时请立即按上一条撤销

## 技术说明

- 单文件实现：整个客户端就是 `index.html`（HTML + CSS + JS，无构建、无依赖）
- 协议：`@linxin666/dsh-remote-bridge` protocol v1；配对使用 P-256 ECDSA（对 nonce 的原始 64 字节签名）
- 需 DSH ≥ 0.2.2-rc.1 且已启用 `dsh-remote-bridge`

## 已知限制

- 不支持取消归档（桥不传输已归档会话）、附件上传、子代理详情、问题（question）交互
- Markdown 为简化渲染（粗体、行内代码、代码块、换行）
- 配对需要电脑侧取码，配对码 30 秒过期

---

本项目为个人自用工具；协议定义与名称权利归 `@linxin666/dsh-remote-bridge` 作者。
