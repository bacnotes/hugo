---
title: 數字檢查及轉換還有時間處理的那些小事｜bacnotes備份筆記
description: 介紹在JavaScript該如何處理數字跟時間的資料，有時候會有意想不到的小坑，比起遇到才知道，可以考慮先讀讀這ㄘ篇筆記避免踩雷。
date: 2022-03-14T00:00:00+08:00
slug: math-number-date
image: pexels-photo-168784.jpeg
tags:
   - math
   - number
   - date
---

## 數字檢查跟數字轉換

### JavaScript 數字都是浮點數

```js
console.log(23 === 23.0); // true
```

## 數字是 Base64 的 2 進位編碼

```js
console.log(0.1 + 0.2); // 0.30000000000000004
console.log(0.1 + 0.2 === 0.3); // false
```

## 字串轉數字

### Number

```js
console.log(Number("23")); // 23
```

### `+` 運算子

* - 是 Number() 的簡寫

```js
console.log(+"23"); // 23
```

## 解析數字

### Number.parseInt(string[, radix])

* 此方法跟全局 parseInt()一樣
* 第一個參數為待轉成數字的字串。若 string 參數類型不是字串的話，會先將其轉成字串（相當於先執行 ToString 再執行 parseInt）空白值會被忽略，如果遇到不能轉為數字的字符，就不再進行下去，回傳已經轉好的部分，若無法轉為數自回傳 NaN
* 第二個參數為進位數，從 2 到 36，能代表該進位系統的數字。如果沒有指定 radix 的話，給出的結果會按照實做不同而異，通常預設值不是 10 進位，強烈建議填寫好進位參數避免非預期 bug

```js
// parsing
Number.parseInt === parseInt; // true

console.log(Number.parseInt("30px", 10)); // 30

// 開頭不能為字母
console.log(Number.parseInt("e23", 10)); // NaN
// 整數
console.log(Number.parseInt("2.5rem")); // 2
// 浮點數
console.log(Number.parseFloat("2.5rem")); // 2.5
```

## NaN 系列

### 何時出現 NaN (Not a Number)

* NaN 是一個 Number 型態但強制轉成數字後無法用任何數字表現的結果
* NaN !== NaN // true
* 回傳未定義 not defined
* 超出範圍
* 運算式有一個參數是 NaN

### isNaN(value)

* 過往判斷 NaN 習慣用 isNaN(因為 NaN !== NaN)，但有些缺點，遇到非數字會強制轉型，容易出現非預期的狀況

```js
// 正常使用狀況下
isNaN(NaN); // true 是NaN 回傳true
isNaN(undefined); // true 是NaN 回傳true
isNaN({}); // true 不是數字 回傳true
isNaN("37,5"); // true 不是數字 回傳true
isNaN(37); // false 是數字 回傳false

// 布林值強制轉型
isNaN(true); // false 不是數字 強制轉1 變成數字
isNaN(null); // false 不是數字 強制轉0 變成數字

// 字串強制轉型
isNaN("37"); // false  不是數字 強制轉37 為數字
isNaN("37.37"); // false  不是數字 強制轉37.37 為數字
isNaN(""); // false: 轉0

// 數字混合字串
isNaN("123ABC"); // true:  Number("123ABC")無法轉成功，為 NaN; 若parseInt("123ABC")會轉 123,
```

### Number.isNaN(value)

* 檢查是否為 NaN，回傳布林值 **注意不是非數字回傳 true，而是 NaN 回傳 true**
* 使用 Number.isNaN 回傳結果則單純續多

```js
console.log(Number.isNaN(20)); // false 不是NaN
console.log(Number.isNaN("20")); // false 不是NaN
console.log(Number.isNaN(+"20x")); // true  表達式+'20x'為NaN
console.log(Number.isNaN(23 / 0)); // false Infinity不是NaN
```

### Number.isFinite(value)

* 適合確認是否為數字

```js
console.log(Number.isFinite(20)); // true
console.log(Number.isFinite("20")); // false
console.log(Number.isFinite(+"20x")); // false
console.log(Number.isFinite(23 / 0)); // false
```

### Number.isInteger(value)

* 適合確認是否為整數

```js
console.log(Number.isInteger(20)); // true
console.log(Number.isInteger(20.0)); // true
console.log(Number.isInteger(20.5)); // false
console.log(Number.isInteger(23 / 0)); // false
```

## Math 運算系列跟取整數

### 開根號、平方

```js
console.log(Math.sqrt(25)); // 5
console.log(5 ** 2); // 25
console.log(25 ** (1 / 2)); // 5   1 / 2需要括號 不然會算成12.5
console.log(8 ** (1 / 3));
```

### 找最大值、最小值

```js
console.log(Math.max(5, 18, 23, 11, 2)); // 23
console.log(Math.max(5, 18, "23", 11, 2)); // '23'也會強制轉型 23
console.log(Math.max(5, 18, "23px", 11, 2)); // 轉失敗 NaN
```

### 圓周率

```js
// Math.PI 為3.14159...
console.log(Math.PI * Number.parseFloat("10px") ** 2); //314.159...
```

### Math.random() 隨機產生 0~1 的小數，不包含 1

```js
console.log(Math.random());

// 隨機產生 0... - 5...的小數
console.log(Math.random() * 6);

// 隨機產生 1 - 6 的整數
console.log(Math.floor(Math.random() * 6 + 1));
```

### Math.trunc() 去掉小數

```js
// 隨機產生1~6的整數 骰子
console.log(Math.trunc(Math.random() * 6) + 1);

// 產生一個介於min與max的隨機數(包含min max)
function getRandomIntInclusive(min, max) {
    return Math.trunc(Math.random() * (max - min + 1)) + min;
}
```

### Math.round() 四捨五入

```js
console.log(Math.round(23.3)); // 23
console.log(Math.round(23.9)); // 24
```

### Math.ceil() 無條件往更大的值取整數

```js
console.log(Math.ceil(23.3)); // 24
console.log(Math.ceil(23.9)); // 24
console.log(Math.ceil(-23.3)); // -23
console.log(Math.ceil(-23.9)); // -23
```

### Math.floor() 無條件往更小的值取整數

* 正數時跟 Math.trunc() 結果一樣，負數則不同

```js
console.log(Math.floor(23.3)); // 23
console.log(Math.floor("23.9")); // 23
console.log(Math.floor(-23.3)); // -24

// 正數跟Math.trunc() 相同
console.log(Math.trunc(23.3)); // 23
// 負數跟Math.trunc() 不同
console.log(Math.trunc(-23.3)); // -23
```

### Number.prototype.toFixed()

* 使用定點小數表示法（fixed-point notation）來格式化數字。

```js
// Rounding decimals
console.log((2.7).toFixed(0));
console.log((2.7).toFixed(3));
console.log((2.345).toFixed(2));
console.log(+(2.345).toFixed(2));
```

## 餘數運算子 `%`

### 表格變色

```js
const isEven = n => n % 2 === 0

isEven(2) // true
isEven(3) // false

// even cols change to blue background
labelBalance.addEventListener('click', function() {
            [...document.querySelectorAll('.movements__row')].forEach(function, (row, i) {
                    if (isEven(i) row.style.backgroundColor = 'marined'
                    })
            })
```

## Numeric Separators 數字分隔符

* 一樣的值，透過底線分割提高可讀性
* Number()無法解析含有數字分隔的的數字，這個只適合用於手動建立的參數，而非 API 回傳字串類型的數字

```js
const diameter1 = 2082432342;
const diameter2 = 2_082_432_342;
console.log(diameter1); // 2082432342
console.log(diameter2); // 2082432342
```

* 小數點

```js
const fee = 15.000_3;
console.log(fee); // 15.0003
```

## BigInt

* 用來儲存更大的數字，因為一個數字能使用的記憶體有限
* JavaScript 可以呈現的最大值是 9007199254740991，即(2 \*\* 53 - 1)，超過這個數字無法往上加
* 數字後面寫 n，或用 BigInt 包裹後會變成 BigInt

```js
console.log(Number.MAX_SAFE_INTEGER); // 9007199254740991
console.log(2 ** 53 - 1); // 9007199254740991
console.log(23423412312311n); // 23423412312311n
console.log(BigInt(23423412312311)); // 23423412312311n
```

## BigInt 運算

* 用 n 的形式無法跟其他數字相加，BigInt 只能跟 BigInt 運算
* 若 BitInt+d 字串，BitInt 一樣會轉成字串

```js
const num = 23;
const huge = 2342341231242352n;

console.log(num + huge); // 數字跟BigInt相加會 error 因為不同類型
console.log(BigInt(num) + huge); // 2342341231242375n

console.log(12n / 3n); // 4n
```

* 判斷運算子> < =，用 n 的形式沒問題

```js
console.log(20n > 15); //true
console.log(20n === 20); // false
console.log(20n == 20); // true
```

## 建立日期物件

### Date.now()

* 回傳自 1970 年 1 月 1 日 00:00:00 (UTC) 到當前時間的毫秒數
* Date.now() 的精度可能受到瀏覽器影響被取整數

```js
const start = Date.now();
console.log(start); // 1647780438069
```

### new Date()

* new Date(): 沒有傳入任務參數到建構子，會依系統設定建立出代表當下時間的 Date 物件

```js
console.log(new Date(2017, 0, 30));
// Mon Jan 30 2017 00:00:00 GMT+0800
```

* new Date(value): value 是自世界標準時間（UTC） 1970 年 1 月 1 日 00:00:00 開始的毫秒整數值（注意：Unix timestamp是以秒而非毫秒為單位）

```js
console.log(new Date(0));
// Thu Jan 01 1970 08:00:00 GMT+0800
```

* new Date(dateString): 表示時間日期的字串。這個字串應該要能被 Date.parse() (en-US) 方法解析
* new Date("yyyy-mm-dd hh:mm:ss") 符合所有瀏覽器格式

```js
console.log(new Date("2010/08/17 12:09:36"));
console.log(new Date("Jan 30 2017"));
// Mon Jan 30 2017 00:00:00 GMT+0800
```

* new Date(year, month[, day[, hour[, minutes[, seconds[, milliseconds]]]]]); 
* 傳入至少兩個參數，缺少日期的話會設為 1，其它參數則會被設定為 0。
* 備註：當傳入超過一個參數，且參數值超過它的合理範圍（例如：傳數值 13 到月份，或傳數值 70 給分鐘），相鄰的參數值將會被調整。例如： new Date(2013, 13, 1) 將等同於 new Date(2014, 1, 1) 都會建立代表 2014-02-01 的物件

```js
console.log(new Date(2017, 10, 19, 14, 23, 1));
// Sun Nov 19 2017 14:23:01 GMT+0800
console.log(new Date(2017, 10));
// Wed Nov 01 2017 00:00:00 GMT+0800
```

### 取得日期物件的值

* getFullYear(): 年
* getMonth(): 月
* getDate(): 日
* getHours(): 時
* getMinutes(): 分
* getSeconds(): 秒

```js
const future = new Date(2037, 10, 19, 14, 22);
// Thu Nov 19 2037 14:22:00 GMT+0800
console.log(future.getFullYear()); // 2037
console.log(future.getMonth()); // 10
console.log(future.getDate()); // 19
```

### 修改日期物件的值

* 如果設定的 value 超出了合理範圍，會相對應的往前或往後推算
* setFullYear(): 年
* setMonth(): 月
* setDate(): 日
* setHours(): 時
* setMinutes(): 分
* setSeconds(): 秒

```js
const future = new Date(2037, 10, 19, 14, 22);
// Thu Nov 19 2037 14:22:00 GMT+0800
future.setFullYear(2022)
future.setMonth(2));
future.setDate(3))
console.log(future)
// Thu Mar 03 2022 14:22:00 GMT+0800
```

### 時間物件轉字串 .toISOString())

* 時區為UTC

```js
const future = new Date(2037, 10, 19, 14, 22);
// Thu Nov 19 2037 14:22:00 GMT+0800
console.log(future.toISOString()); // 2037-11-19T06:22:00.000Z
```

### 時間物件轉毫秒

* 回傳距離 1970 年 1 月 1 日 0 時 0 分 0 秒（UTC 時間）多久的毫秒數

```js
const future = new Date(2037, 10, 19, 14, 22);
// Thu Nov 19 2037 14:22:00 GMT+0800
console.log(future.getTime()); // 2142224520000
```

### 時間的運算

* 會先轉換成Time Stamp毫秒為單位

```js
const future = Number(new Date(2037, 10, 19))
console.log(future) // 2142172800000

const calcDaysPassed = (date1, date2) => Math.abs(date2 - date1) / (1000 * 60 * 60 * 24)
const days = calcDaysPassed(new Date(2037, 10, 19), new Date(2037, 10, 24))
console.log(days) // 5
```

持續更新中...