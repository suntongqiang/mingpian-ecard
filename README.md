# 电子名片 · 广州舒克机电（潘海波）

这是一个静态电子名片页面，用 GitHub Pages 托管即可获得可分享的链接。

## 文件
- index.html —— 名片页面（单文件，已内嵌 logo 和微信二维码，直接可部署）

## 如何上线（GitHub Pages）
1. 在 GitHub 上新建一个仓库（公开），如 usiness-card。
2. 把本目录内容推上去：
   - 本机已 git init，只需设置你的身份并推送：
     git config --global user.name "你的GitHub用户名"
     git config --global user.email "你的邮箱"
     git remote add origin https://github.com/你的用户名/business-card.git
     git add -A
     git commit -m "电子名片"
     git branch -M main
     git push -u origin main
   - 或直接用 GitHub 网页上传这 2 个文件。
3. 仓库 Settings → Pages → Source 选 "main" 分支 /（root）→ Save。
4. 等 1-2 分钟，访问：
   https://你的用户名.github.io/business-card/

## 说明
- 该域名 .github.io 在国内部分网络可能较慢，微信内一般能打开。
- 若想要更快、微信内更稳定，可改用腾讯云 COS / OSS 静态托管。