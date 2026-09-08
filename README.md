# 电子名片 · 多卡发布仓库

GitHub Pages 托管的多张电子名片（单文件 H5 动态页面）。每张卡一个独立链接。

## 卡片索引

| 卡片 | 链接 | 备注 |
| --- | --- | --- |
| 区佐宁（联合知识产权） | https://suntongqiang.github.io/mingpian-ecard/ | 根链接，首张 |
| （更多…见下方目录） | https://suntongqiang.github.io/mingpian-ecard/<人名>/ | 新增卡按人名子目录 |

## 结构约定

- `index.html` —— **根卡片**（目前是区佐宁），访问 `/mingpian-ecard/`。
- `<人名拼音>/index.html` —— 每张**新增卡**一个独立子目录，访问 `/mingpian-ecard/<人名>/`，可独立分享、互不干扰。
- `publish-card.ps1` —— **发卡脚本**（见下）。

> 块级约定：`/` 固定留给首张卡，避免改链接。新增卡一律放在子目录。

## 如何发一张新卡（一次命令）

```powershell
powershell -ExecutionPolicy Bypass -File .\publish-card.ps1 -Name wangwu -SourceFile "C:\path\to\王五.html"
```

脚本自动：建 `<人名>/` 目录 → 复制 `index.html` → 校验 → git 提交 → 推送到 `main` → 打印新卡链接。

发卡后卡片链接固定为：
`https://suntongqiang.github.io/mingpian-ecard/<人名>/`

## 卡片要求
- 必须是**单文件** `.html`：内嵌全部图片（base64）、logo、二维码、拨号、动画。无外部 CDN 依赖（微信里才能直接打开）。
- 每个文件应自包含、可独立运行。

## 修改已有卡片
把新版文件覆盖对应 `index.html`，再 `git add -A && git commit && git push` 即可，链接不变，微信里刷新即更新。

## 托管说明
- 域名 `.github.io` 在国内部分网络可能较慢，微信内一般可打开。
- 若要更稳定/更快，可迁至腾讯云 COS / OSS 静态托管（仓库结构不变）。
