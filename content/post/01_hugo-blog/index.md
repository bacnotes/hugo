---
title: 工程師的技術部落格要怎麼架？使用Hugo!｜bacnotes備份筆記
description: 為什麼工程師要寫部落格？很多新技術要學，腦袋卻又記不住的時候，技術部落格就是你的另一個大腦，而Hugo是你的好夥伴。
date: 2021-12-23
author: bacnotes
slug: hugo-blog
image: helena-hertz-wWZzXlDpMog-unsplash.jpg
tags:
  - Hugo
---

## 為什麼工程師要寫部落格

身為一個**專業的工程師**，你也許會需要

- 一台筆電(o)
- 持續學習(o)
- 跟容量大的腦袋來備份知識(x)

Um...工程師的世界永遠有追不完的技術，自知腦容量沒有這麼大，記錄成部落格文字來比較可靠，而且

> 寫成部落格也有機會跟別人交流，也許還會有高手可以切磋(!

## 部落格架站選擇 - Jekyll, Hexo, Hugo, Gatsby

除了 hugo 外還有很多人氣的靜態網站生成器 [Jekyll (Ruby)](https://jekyllrb.com/ 'Jekyll (Ruby)') / [Hexo (JavaScript)](https://hexo.io/zh-tw/ 'Hexo (JavaScript)') / [Gatsby (React)](https://www.gatsbyjs.com/ 'Gatsby (React)')等，也有很多比較文

- [[Day06] Jekyll vs Hexo vs Hugo](https://ithelp.ithome.com.tw/m/articles/10269253 '[Day06] Jekyll vs Hexo vs Hugo')
- [Hexo Hugo Vuepress Gatsby 静态网站生成器的选择](https://www.tangruiping.com/post/hexo-hugo-vuepress-gatsby.html 'Hexo Hugo Vuepress Gatsby静态网站生成器的选择')

[Hugo](https://gohugo.io/getting-started/installing/ 'Hugo')號稱部屬最快的框架，用 Go 語言寫的，也許未來有時間會想學學看這個 google 工程師團隊開發的語言，而且時間就是金錢啊！就先選用這個了！

## 安裝 Hugo

### 如果是用 Mac，直接 homebrew 下載

- 如果沒用過 homebrew 套件管理軟體可以先下載[homebrew](https://brew.sh/ 'homebrew')
- `brew install hugo`
- 用 `hugo version` or `hugo help` 來檢查是否有新增成功

### 如果是用 Windows，可以使用 Chocolatey 下載

- 沒用過 ChocoLatey 套件管理工具的話，可以先參考這篇安裝說明  
  [用指令安裝程式--Chocolatey](https://ithelp.ithome.com.tw/articles/10242201 '用指令安裝程式--Chocolatey')

- 下載完後來安裝 Hugo  
- 基礎版是`choco install hugo -confirm`  
- Sass/SCSS version 是 `choco install hugo-extended -confirm`  

看之後部落格選擇的主題，會使用到 Sass/SCSS 語法的就選後者

- 依照官方影片說明，在 C:\下方新增 Hugo 資料夾
<iframe width="640" height="360" src="https://www.youtube.com/embed/" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

- Hugo 資料夾下新增 Sites 跟 bin 資料夾(Sites 是專案資料夾，bin 是儲存執行檔案用)
- 到[Hugo Releases](https://github.com/gohugoio/hugo/releases 'Hugo Releases') 下載安裝檔，解壓縮完的檔案丟到 bin 資料夾
- 新增 window 開發環境變數，在變數 PATH 下新增一個值叫`C:\Hugo\bin`，讓全域都可以執行 hugo 命令
- 到其他資料夾用 `hugo version` or `hugo help` 來檢查是否有新增成功

### 新增網站的專案資料夾

＊以下用`example.com`為部落格網址作為範例，這邊根據自己的網站名做修改即可(mac 跟 windows 流程大同小異)

- window 的使用者 cd 到`C:\Hugo\Sites>`，mac 的使用者 cd 到你設定的專案資料夾
- 執行`hugo new site example.com`

### 選擇與安裝喜歡的主題

- 到[Hugo Themes](https://themes.gohugo.io/)找喜歡的主題
- 我選用的是 hugo-theme-stack
  -- `git clone`你喜歡的主題到`theme`資料夾  
  -- 一開始我們的部落格裡面沒有內容，hugo-theme-stack 有提供範例，`exampleSite`資料夾，我們用這個來覆蓋專案資料夾看看實際部落格效果
  -- 在 example.com 網站資料夾下執行 `hugo server`  
  -- 網址列查看`http://localhost:1313`

<img src="./screenshot.png" alt="drawing" width="600"/>

哇真的出現了!好感人啊！  現在只有自己可以看到，下一篇會介紹如何使用 GitHub 來部署我們的部落格  
[只要 3 秒，使用 GitHub 一鍵部署你的 Hugo 部落格](https://bacnotes.github.io/p/github-deploy-hugo/ '只要3秒，使用GitHub一鍵部署你的Hugo部落格')  

參考文章: [[Day07] Let's Hugo!](https://ithelp.ithome.com.tw/m/articles/10269925 "[Day07] Let's Hugo!")
