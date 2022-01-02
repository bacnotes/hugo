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

1. 一台筆電(o)
2. 持續學習(o)
3. 跟容量大的腦袋來備份知識(x

Um...工程師的世界永遠有追不完的技術，  
自知腦容量沒有這麼大，記錄成部落格文字來比較可靠，而且

> 寫成部落格也有機會跟別人交流，也許還會有高手可以切磋(!

好像好處多多呢！  
然後也開始思考，過去半年來用 MAC 開發，但未來也許工作不一定分到 MAC 電腦  
要不要把之前沒在用的 windows 的電腦拿來寫 code，演練一下上工後拿到的是 Windows(希望不是ＱＱ)

## Windows 寫程式需要的基本工具

身為 JavaScript 開發者，電腦空空的我可能會需要

1. 安裝 Git Bash(可使用 Linux 指令操作 Window 的檔案系統)
2. 設定 git config --global user.name & user.email
3. 安裝 VS Code 跟套件 extensions  
   Bracket Pair Colorizer 已經內建好了不用另外下載，但要記得在 setting 啟用  
   可以參考這個影片[VS Code tips — Built-in bracket pair colorization](https://www.youtube.com/watch?v=tw7LJZfhowU 'VS Code tips — Built-in bracket pair colorization')  
   a. 安裝 Emmet (自動跳出提示跟各種好用的縮寫)  
   b. 安裝 Live Server (可以直接用本地端瀏覽器看到結果) +DevTools 方便 debug  
   c. 安裝 ESLint (檢查語法錯誤/統一 coding style/提高程式碼品質)  
   d. 安裝 vscode-icons (有賞心悅目的 icon)
   e. 安裝 Prettier (自動排版)
4. 安裝 Node.js (未來開發時需要有個執行環境在本地跑)

ok! 來開始架站吧！

## 部落格架站選擇很多元 - Jekyll, Hexo, Hugo, Gatsby(不是那個抓頭髮的)

除了 hugo 外，其實還有很多人氣的靜態網站生成器 [Jekyll (Ruby)](https://jekyllrb.com/ 'Jekyll (Ruby)') / [Hexo (JavaScript)](https://hexo.io/zh-tw/ 'Hexo (JavaScript)') / [Gatsby (React)](https://www.gatsbyjs.com/ 'Gatsby (React)')等  
關於比較文也有很多

1. [[Day06] Jekyll vs Hexo vs Hugo](https://ithelp.ithome.com.tw/m/articles/10269253 '[Day06] Jekyll vs Hexo vs Hugo')
2. [Hexo Hugo Vuepress Gatsby 静态网站生成器的选择](https://www.tangruiping.com/post/hexo-hugo-vuepress-gatsby.html 'Hexo Hugo Vuepress Gatsby静态网站生成器的选择')

[Hugo](https://gohugo.io/getting-started/installing/ 'Hugo')用 Go 寫，號稱部屬最快的框架，也許未來有時間會想學學看這個 google 工程師團隊開發的語言  
而且時間就是金錢！就先選用這個！

### 安裝 Hugo

在 Hugo install 發現 windows 有個 Chocolatey 可以管理套件  
下載 Chocolatey 用 `choco install hugo-extended -confirm` 就裝起來了

依照官方說明建立這兩個資料夾  
You will use`C:\Hugo\Sites` as the starting point for your new project.  
You will use`C:\Hugo\bin` to store executable files.

到 Hugo Releases 找到符合電腦環境的安裝檔，解壓縮於 bin 資料夾
新增 window PATH 環境變數，新增`C:\Hugo\bin`，讓全域都可以執行 hugo 命令
可以到其他資料夾用 hugo version or hugo help 來檢查是否有新增成功

官方 windows 環境架設流程

<iframe width="640" height="360" src="https://www.youtube.com/embed/" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

### 新增專案資料夾

以 example.com 為範例，這邊根據自己的網站名稱做修改  
cd 到`C:\Hugo\Sites>`  
執行`hugo new site example.com`

到[Hugo Themes](https://themes.gohugo.io/)找喜歡的主題  
目前選用 Jimmy 大撰寫的樣式 hugo-theme-stack  
也有詳細的[文件說明](https://docs.stack.jimmycai.com/getting-started.html#installation)如何安裝
簡單來說就是

1. git clone 主題檔案到 theme 資料夾
2. 因為一開始 blog 裡面沒有內容，把範例的 exampleSite 資料夾覆蓋專案資料夾，就有 demo 可以看
3. 到 網站資料夾 執行 `hugo server`
4. 查看 http://localhost:1313

哇真的出現了  
<img src="./screenshot.png" alt="drawing" width="600"/>

出現的瞬間真的好感人啊！等等...現在只有自己可以看到  
下一篇會來介紹如何使用 GitHub 來部署我們的部落格  
[只要 3 秒，使用 GitHub 一鍵部署你的 Hugo 部落格](https://bacnotes.github.io/p/github-deploy-hugo/ '只要3秒，使用GitHub一鍵部署你的Hugo部落格')  
但記得部署前記得先來客製一下部落格標題跟說明文字唷  
你說不太確定該怎麼設定嗎？那來看看這篇 [如何設定 Hugo config 跟 Disqus 討論區](https://bacnotes.github.io/p/hugo-config-and-disqus/ '如何設定Hugo config跟Disqus討論區')

參考文章:  
[用指令安裝程式--Chocolatey](https://ithelp.ithome.com.tw/articles/10242201 '用指令安裝程式--Chocolatey')  
[[Day07] Let's Hugo!](https://ithelp.ithome.com.tw/m/articles/10269925 "[Day07] Let's Hugo!")
