---
title: 關於SSH key與多組GitHub帳號切換｜bacnotes備份筆記
description: 一台電腦怎麼管理多組GitHub帳號？生成rsa卻一直覆蓋原本的檔案，難道一台電腦只能登一個GitHub帳戶嗎？來試試看管理多組帳戶的config吧
date: 2021-12-25
slug: github-ssh-key
image: maria-ziegler-jJnZg7vBfMs-unsplash.jpg
tags:
    - SSH key
    - GitHub
---

疑？不是說下一篇要介紹GitHub部署嗎？怎麼變成SSH key管理

Um...在部署前卡到了Github多組帳號權限的問題  
如果你的電腦只有使用1組GitHub帳號，可以點下方連結直接到下一篇  
只要3秒鐘，使用GitHub一鍵部署你的Hugo部落格

## WHY 要用一台電腦使用多組GitHub帳號
在**後疫情時代**，遠距工作變成時代趨勢  
工作時勢必會有1組公司用的GitHub帳號(或GitLab或...其他的雲端協作平台)   
但自己在寫side project也會用到1組GitHub帳號   
先演練一下1台電腦可以使用2組GitHub帳號的情境  
聽起來好像很簡單，辦第2組GitHub帳號就好了吧（就跟google帳號一樣（？  
但你用GitHub的新帳號，在你的terminal照著下方指令做到最後一步
```
git init
git add .
git commit -m 'some msg'
git branch -M main
git remote add origin 'your repo'
git push -u origin main
```
就會發現跳出這個訊息
>ERROR: Permission to aaa/aaa.git denied to bbb
fatal: 無法讀取遠端版本庫。

要commit的時候，被最初註冊的bbb帳號deny

Um...啊！  
<img src="./cat.jpg" alt="drawing" width="400"/>  
之前的帳號有設定一組對應的SSH key讓GitHub驗證身份  
應該是SSH key的問題吧？  
有2組帳號，生2組key應該就沒問題了吧！  
欸不對，我的terminal在push的時候，怎麼知道哪組帳號對應哪個SSH key  
上網查了一下相關文章，發現可以寫一個config來對應各自的key  

## 管理多組SSH key流程如下
aaa為範例，可自由代入你的帳號
1. 產生SSH key `ssh-keygen -t rsa -C "aaa@example.com"`
2. 決定要儲存的檔名(路徑) 
在Enter file in which to save the key (/Users/XXX/.ssh/id_rsa):  
後方填入 `/Users/aaa/.ssh/id_rsa_aaa`  
3. Enter passphrase(如果不想加密，可以直接enter不設定密碼)    
4. Enter same passphrase again(同上判斷)  
5. 把對應的公鑰(id_rsa_aaa.pub裡面的文字)新增到GitHub的SSH key，[官方圖文教學](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)  
6. 在.ssh目錄下，touch一個config(不用副檔名)

```
Host gh.aaa
HostName github.com
User aaa
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_aaa
```

7. 把key加入管理 `ssh-add ~/.ssh/id_rsa_aaa`
8. 嘗試連線看看對應host是否有生效`ssh -T git@gh.aaa`
>Hi aaa! You've successfully authenticated, but GitHub does not provide shell access.

看到上方訊息表示有成功連線囉！  
第2個帳號照著上方步驟寫在同個config檔案即可  
  
```
Host gh.aaa
HostName github.com
User aaa
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_aaa

Host gh.bbb
HostName github.com
User bbb
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_bbb
```

注意：經過上面的設定檔後，repo的位置會從預定的
git@github.com:ooo/ooo.git變成git@gh.aaa:ooo/ooo.git  
後續在新增repo連結時需注意，不然可能吃不到config設定檔唷  

參考文章:  
[[Git] 多個SSH Key與帳號的設定(Mac)](https://dotblogs.com.tw/as15774/2018/04/30/174737 "[[Git] 多個SSH Key與帳號的設定(Mac)")


