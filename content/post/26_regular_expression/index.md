---
title: 認識正規表達式RegExp (Regular Expression)｜bacnotes備份筆記
description: 正規表達式是一個物件，用來來匹配字串中字元進行字串操作，常用於字串判斷、資料搜尋、清除或取代目標字詞等，常常會在專案裡用到，但又有時候因為特殊符號不容易聯想他的意義，因此整理一篇筆記方便後續查看。
date: 2022-03-06T00:00:00+08:00
slug: regular-expression
image: pexels-photo-7794425.jpeg
tags:
   - RegExp
---


## 建立正規表達式物件

- 兩個斜線 / /
- new RegExp()
- 定值時，使用斜線的方法效能較佳
- 若內容會異動，匹配模式未知，用建構函式較佳

```js
// 匹配完全符合abc的字串
const regex = /abc/;
// 使用建構函式
const regex = new RegExp("abc");
```

### Flag: 寫在//後面

- i：不區分大小寫
- m：多行，讓^$比對每一行的開頭跟結尾
- g：全局(比對多個相符結果，而非只有一個，可以從尾巴找)
- 正規表示式有開啟 g flag，可以連續執行 exec() 逐一取得原始字串中所有的匹配字串
- 每次執行完 exec() 都會重設 lastIndex 為匹配字串後面接續的字元的索引位置。

```js
var regex = /ab*/g;
var str = "abbcdefabh";
var arr;

while ((arr = regex.exec(str)) !== null) {
  var msg = "Found " + arr[0] + ". ";
  msg += "Next match starts at " + regex.lastIndex;
  console.log(msg);
}

// Found abb. Next match starts at 3
// Found ab. Next match starts at 9
```

## 正規表達式物件自帶方法

- regex.test(測試內容) // 會回傳 true false 判斷是否匹配
- regex.exec(測試內容) // 回傳陣列 匹配的全部字串/個別匹配字串/開始符合的 index 起始點/原始輸入字串

```js
// Match "quick brown" followed by "jumps", ignoring characters in between
// Remember "brown" and "jumps"
// Ignore case
const inputValue = "The Quick Brown Fox Jumps Over The Lazy Dog";
const regex = /quick\s(brown).+?(jumps)/gi;
const result = regex.exec(inputValue);

console.log(result);

// [
//  'Quick Brown Fox Jumps',
//  'Brown',
//  'Jumps',
//  index: 4,
//  input: 'The Quick Brown Fox Jumps Over The Lazy Dog',
//  groups: undefined
// ]
```

- 這些字串方法也可以用正規表達式 search、match、replace、split
  可以參考這篇[字串的處理方法](https://bacnotes.github.io/string-methods/ "字串的處理方法")

## 特殊字元

- ^：字串開頭為 (/^A/ 會匹配「An E」中的 A 不會匹配「an A」的 A) 寫在集合[]表示非
- $：字串結尾為（/t$/ 會匹配「eat」中的 t 不會匹配「eater」中的 t）
- \：下一個字元開始視為一般值而非運算式
- \b：字串邊界不能有英數或底線
- \B：字串邊界要有英數或底線
- .：代替除了換行符號所有可能的字元（a.c 會匹配到 "aGc", "a c", "a_c"，但不能匹配 "a\nc"，.ool 會匹配到 cool fool）
- |：或，不能放在最後面

### 字元代號

- ()：匹配括弧中內相符字元順序（(sym)，結果可能有 sympathy、assym，sy(m|n) 會匹配 syn 或 sym）
- []：匹配括弧中的字元範圍，不分順序
- [^]：匹配非括弧中的字元
- [A-Z]：匹配大寫英文字母
- [a-z]：匹配小寫英文字母
- [0–9]：匹配數字 0–9，[^0-9] 匹配不含數字 0–9
- red[1-3]：red1 red2 red3 都會匹配到
- \d：匹配數字 (digital)
- \D：匹配非數字
- \w：匹配英數與底線，即 [A-Za-z0–9_]
- \W：匹配非英數與底線，即 [^a-za-z0–9_]
- \s：匹配泛空白字元，包含換行符號 tab space \r \n
- \S：匹配非泛空白字元

### 匹配次數

- {m}：匹配前面的運算式 m 次
- {n,}：匹配前面的運算式最少 n 次
- {m,n}：匹配前面的運算式 m 次到 n 次
- {m,n}?：匹配前面的運算式 m 次到 n 次之間最少次的
- `*`：至少 0 次，等於{0,}，有或無都可，匹配多次(bag0`1*`: bag0 bag01 bag011 )
- +：至少 1 次，等於 {1,}，至少要包含一個
- ?：0 次或 1 次，等於{0,}，有或無都可(ha`?t`: ha hat)

## 常見 case

信箱

```js
const regex = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
```

身分證

```js
const regex = /^[A-Z]{1}[1-2]{1}[0-9]{8}$/;
```

郵遞區號

```js
const regex = /^[1-9]\d{4}$/;
```

手機

```js
const regex = /^09\d{8}$/;
```

密碼要大小寫英文+數字+長度至少 8

```js
const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/;
```

日期

```js
// 日
const regex = /(([0-2][1-9])|10|20|30|31)/;
// 月
const regex = /((0[1-9])|(1[0-2]))/;
// 年
const regex = /(19|20)\d{2}/;
```

正規表達式測試工具 https://www.regextester.com/
