---
title: 字串的處理方法｜bacnotes備份筆記
description: 在JavaScript會用到許多處理字串的方法，這份字串方法懶人包整理了indexOf()、lastIndexOf()、slice()、toUpperCase()、toLowerCase()、trim()、trimStart()、trimEnd()、replace()、replaceAll()、includes()、split()、join()、padStart()、padEnd()、repeat()、search()、match()等用法。
date: 2022-01-30T00:00:00+08:00
slug: string-methods
image: pexels-pixabay-278887.jpg
tags:
  - JavaScript
---

這是一個懶人包整理～！祝大家新年快樂！

## 字串可以使用部分陣列的方法

### 根據索引取值

```js
const airline = "TAP Air Portugal";
const plane = "A320";
console.log(plane[0]); // A
console.log("B35"[0]); // B
console.log(plane.length); // 4
```

### indexOf()、lastIndexOf() 找索引位置

- indexOf(searchElement, fromIndex) 由前往後找值的索引，第 2 個參數是 option
- lastIndexOf(searchElement, fromIndex) 由後往前找值的索引，第 2 個參數是 option
- 若不存在則回傳 -1

```js
const airline = "TAP Air Portugal";
const plane = "A320";
console.log(airline.indexOf("r")); // 6
console.log(airline.lastIndexOf("r")); // 10  後往前找
```

- 會判別字母大小寫(case-sensitive)

```js
console.log(airline.indexOf("portugal")); // -1
console.log(airline.indexOf("Portugal")); // 8
```

- 淺拷貝 slice(start, end)，預設 slice(0, arr.length)，回傳選取範圍之陣列
- 若有指定 end，所在的元素不會被納入
- 無法使用 splice 因為字串是 immutable

```js
console.log(airline.slice(4)); // Air Portugal
```

- 切出第一個字(不包含空白)

```js
console.log(airline.slice(0, airline.indexOf(" "))); // TAP
```

- 寫一個判斷字串尾端有無 B 或 E 的 function，來判段機位位置 e.g. 11B 23C

```js
const checkMiddleSeat = function (seat) {
  const position = seat.slice(-1);
  if (position === "B" || position === "E") console.log("middle seat");
  else console.log("not middle seat");
};
checkMiddleSeat("11B"); // middle seat
checkMiddleSeat("11C"); // not middle seat
```

### toUpperCase()、toLowerCase()轉大小寫

```js
const airline = "TAP Air Portugal";

console.log(airline.toLowerCase()); // tap air portugal
console.log(airline.toUpperCase()); // TAP AIR PORTUGAL

// 把大小寫混亂的字轉開頭大寫，後面小寫
const name = "jOnAs";
const nameLower = name.toLowerCase();
const nameCorrect = nameLower[0].toUpperCase() + nameLower.slice(1);
console.log(nameCorrect); // Jonas
```

### trim()、trimStart()、trimEnd() 移除泛空白字元(後兩個 IE 沒有支援)

- trim() 刪除兩端所有空白
- trimStart() 將刪除字串開頭的所有空白
- trimEnd() 將刪除字串末尾的所有空白

```js
// email輸入剪掉空白跟轉換成小寫
const email = "hello@jonas.io"; // 正確email資料
const loginEmail = "  Hello@jonas.Io\n"; // 輸入時大小寫混用+空白+enter

const normalizedEmail = loginEmail.toLowerCase().trim();
console.log(normalizedEmail); // hello@jonas.io
```

### replace()、replaceAll() 字串取代，會回傳一個新字串(後者 IE 沒有支援)

- replace(regexp|substr, newSubstr|function)第二個參數會取代第一個參數

```js
const priceGB = "288,97£";
const priceUS = priceGB.replace("£", "$").replace(",", ".");
console.log(priceUS); // 288.97$
```

- 當輸入對象是字串，replace 只會取代第一個匹配的，replaceAll 會取代所有匹配的

```js
const p = "abab";
console.log(p.replace("a", "A")); // "Abab"
console.log(p.replaceAll("a", "A")); // "AbAb"
```

- 當第一個參數為是正則表達式，兩者都會取代所有匹配的

```js
const p = "abab";
console.log(p.replace(/a/g, "A")); // "AbAb"
console.log(p.replaceAll(/a/g, "A")); // "AbAb"
```

### includes() 檢查是否包含特定字串，回傳 true false

- arr.includes(valueToFind, fromIndex)，第 2 個參數 option
- 區分大小寫，使用零值相等確認元素是否一樣
- 若 fromIndex 大於陣列長度，直接回傳 false
- 若 fromIndex 小於 0，會搜尋整個陣列

```js
const plane = "Airbus A320neo";
console.log(plane.includes("A320")); // true
console.log(plane.includes("Boeing")); //false
console.log(plane.startsWith("Airb")); // true
```

- 寫一個檢查字串是否有刀槍字串的 function

```js
const checkBaggage = function (items) {
  const baggage = items.toLowerCase(); // 輸入統一轉小寫，比較好處理檢查

  if (baggage.includes("knife") || baggage.includes("gun")) {
    console.log("You are NOT allowed on board");
  } else {
    console.log("Welcome aboard!");
  }
};

checkBaggage("I have a laptop, some Food and a pocket Knife"); // You are NOT allowed on board
checkBaggage("Socks and camera"); // Welcome aboard!
```

### split() 使用指定字串切割字串，切割的結果回傳成一個陣列

- split(separator, limit)，第 2 個參數是 option

```js
console.log("string".split(""));
// [ 's', 't', 'r', 'i', 'n', 'g' ] 沒有寫條件，會以字元為單位切
console.log("a+very+nice+string".split("+")); //  以+切割
// [ 'a', 'very', 'nice', 'string' ]
console.log("Jonas Schmedtmann".split(" ")); // 以空白切割
// [ 'Jonas', 'Schmedtmann' ]
const [firstName, lastName] = "Jonas Schmedtmann".split(" ");
// 切割後解構賦值
```

### join() 使用指定字串將陣列元素合併為一個字串

- join([separator])
- join() // a, b, c
- join('') // abc
- join('-') // a-b-c
- 若陣列只有一個就不使用 join 中的字串
- 在陣列長度為零、元素為 undefined 或 null 狀況下，回傳空字串

```js
const newName = ["Mr.", firstName, lastName.toUpperCase()].join(" ");
console.log(newName);
```

- 使用 split()跟 join()把名字整理成只有第一個大寫開頭

```js
// 方法一
const capitalizeName = function (name) {
  const names = name.split(" ");
  const nameUpper = [];
  for (const char of names) {
    nameUpper.push(char[0].toUpperCase() + char.slice(1));
  }
  console.log(nameUpper.join(" "));
};
capitalizeName("jessica ann smith davis"); // Jessica Ann Smith Davis

// 方法二 改用replace
const capitalizeName = function (name) {
  const names = name.split(" ");
  const nameUpper = [];
  for (const char of names) {
    nameUpper.push(char.replace(char[0], char[0].toUpperCase()));
  }
  console.log(nameUpper.join(" ")); // Jessica Ann Smith Davis
};
```

＊字串拼接還有一種 concat 方法，但 MDN 強烈建議直接使用運算子 assignment operators (en-US) 來達成， 像是 + 及 +=
若想了解 concat 方法，可以參考[陣列的處理方法](https://bacnotes.github.io/p/array-methods/ "介紹陣列方法")

### padStart()、padEnd()填充字串 (IE 沒有支援)

- padStart(targetLength, padString)，從開頭填充字串到指定長度
- padEnd(targetLength, padString)，從結尾填充字串到指定長度
- 第 2 個參數沒寫會填充空白

```js
const message = "Go to gate 23!";
console.log(message.padStart(20, "+").padEnd(26, "+"));
//++++++Go to gate 23!++++++
```

- 信用卡加密

```js
const maskCreditCard = function (number) {
  const str = number + "";
  const last = str.slice(-4);
  return last.padStart(str.length, "*");
};
console.log(maskCreditCard("334859493847755774747"));
// *****************4747
```

### repeat() 回傳指定數量 copy 字串

- repeat(count)

```js
const planesInLine = function (num) {
  console.log(`There are ${num} planes in line ${"🛩".repeat(num)}`);
};
planesInLine(5);
// There are 5 planes in line 🛩🛩🛩🛩🛩
```

### search()

- 回傳正規表達式的第一個匹配的 index，若找不到，回傳 -1。

```js
const paragraph =
  "The quick brown fox jumps over the lazy dog. If the dog barked, was it really lazy?";

// any character that is not a word character or whitespace
const regex = /[^\w\s]/g;

console.log(paragraph.search(regex));
// expected output: 43

console.log(paragraph[paragraph.search(regex)]);
// expected output: "."
```

### match()

- 回傳一個字串匹配正規表達式的结果
- 使用 g 全局比對，回傳所有結果在一個陣列
- 沒有使用 g，回傳第一個匹配的結果，匹配的起始點，輸入字串本身，捕獲陣列或 undefined

```js
const paragraph = "The quick brown fox jumps over the lazy dog. It barked.";
const regex = /[A-Z]/g;
const regexNotGlobal = /[A-Z]/;
const found = paragraph.match(regex);
const foundNotGlobal = paragraph.match(regexNotGlobal);

console.log(found);
// expected output: Array ["T", "I"]

console.log(foundNotGlobal);

// [
//  'T',
//  index: 0,
//  input: 'The quick brown fox jumps over the lazy dog. It barked.',
//  groups: undefined
// ]
```

### 綜合練習

```js
// Q1
//TEST DATA (pasted to textarea)
//underscore_case
// first_name
//Some_Variable
//  calculate_AGE
//delayed_departure

//SHOULD PRODUCE THIS OUTPUT (5 separate console.log outputs)
//underscoreCase      ✅
//firstName           ✅✅
//someVariable        ✅✅✅
//calculateAge        ✅✅✅✅
//delayedDeparture    ✅✅✅✅✅

document.body.append(document.createElement("textarea"));
document.body.append(document.createElement("button"));
const text = document.querySelector("textarea").value;
document.querySelector("button").addEventListener("click", function () {
  const text = document.querySelector("textarea").value;
  const rows = text.split("\n");
  for (const [i, row] of rows.entries()) {
    const [first, second] = row.toLowerCase().trim().split("_");
    const output = `${first}${second.replace(
      second[0],
      second[0].toUpperCase()
    )}`.padEnd(20);
    const check = "✅".repeat(i + 1);
    console.log(output + check);
  }
});

// Q2
// const flights = '_Delayed_Departure;fao93766109;txl2133758440;11:25+_Arrival;bru0943384722;fao93766109;11:45+_Delayed_Arrival;hel7439299980;fao93766109;12:05+_Departure;fao93766109;lis2323639855;12:30';

// 🔴 Delayed Departure from FAO to TXL (11h25)
//              Arrival from BRU to FAO (11h45)
//   🔴 Delayed Arrival from HEL to FAO (12h05)
//            Departure from FAO to LIS (12h30)

// 抽出共用方法：切出前三個字轉大寫
const getCode = (str) => str.slice(0, 3).toUpperCase();

for (const item of flights.split("+")) {
  const [status, from, to, time] = item.split(";");
  const signal = status.slice(1).includes("_") ? "🔴" : "";
  console.log(
    `${signal}${status.replaceAll("_", " ")} ${getCode(from)} ${getCode(
      to
    )} ${time.replace(":", "h")}`.padStart(35)
  );
}
```

## 補充：為什麼字串是 Primitives (不是物件)，卻可以呼叫方法

- JavaScript 在字串呼叫方法時會把字串轉成物件，這個過程叫 boxing

```js
console.log(new String("jonas")); // String{'jonas'}
console.log(typeof new String("jonas")); //object
```

- 當轉換結束後會再把物件轉回字串

```js
console.log(typeof new String("jonas").slice(1)); // string
```
