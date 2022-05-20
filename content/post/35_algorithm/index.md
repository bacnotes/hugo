---
title: 演算法｜bacnotes備份筆記
description: 了解如何寫出時間跟空間複雜度低的程式
date: 2022-05-15T00:00:00+08:00
slug: algorithm-note
image: pexels-cottonbro-4778676.jpg
tags:
  - Readings
---

## 如何計算哪一種程式的效能比較好

```js
function addUpTo(n) {
  let total = 0
  for (let i = 1; i <= n; i++) {
    total += i
  }
  return total
}

function addUpTo(n) {
  return (n * (n + 1)) / 2
}
```

### performance.now()

- 列印出執行時間差

```js
function addUpTo(n) {
  return (n * (n + 1)) / 2
}

var time1 = performance.now()
addUpTo(1000000000)
var time2 = performance.now()
console.log(`Time Elapsed: ${(time2 - time1) / 1000} seconds.`)

function addUpTo(n) {
  let total = 0
  for (let i = 1; i <= n; i++) {
    total += i
  }
  return total
}

var t1 = performance.now()
addUpTo(1000000000)
var t2 = performance.now()
console.log(`Time Elapsed: ${(t2 - t1) / 1000} seconds.`)
```

- 不同機器跑出來的時間不同誤差
- 同樣的機器跑同樣的程式也會有誤差
- 計算時間的測量本身也會有誤差

### Big O 比時間更好衡量效能的指標

- is a way to formalize fuzzy counting
- how the runtime of an algorithm grows as the inputs grow
- algorithm is o(f(n)) if the number of simple operations the computer has to do
- algorithm is eventually less than a constant times f(n) as n increases

### 時間複雜度

- constant/linear/quadratic

```js
// O(n2)

function printAllPairs(n){
  for(var i=0;i<n;i++){
    for(var j=0; j<n; j++){
        console.log(i,j)
    }

}


// O(n)
function addUpTo(n) {
  let total = 0;
  for (let i = 1; i <= n; i++) {
    total += i;
  }
  return total;
}


// O(1)
function addUpTo(n) {
  return n * (n + 1) / 2;
}

```

- arithmetic operations are constant
- variable assignment is constant
- accessing elements in an array(by index) or object(by key) is constant
- in a loop, the complexity is the length of the loop times the complexity of whatever happens inside of the loop
- 趨近無限大，常數可忽略，只看次方最大的
- 巢狀迴圈看要跑的次數，若為常數時間複雜度不會增加

### 空間複雜度: 使用記憶體的量

- 基礎型別空間複雜度是 O(1)
- n 長度的字串空間複雜度是 O(n)
- n 個元素陣列跟 n 個 keys 的物件等 ref types 通常是 O(n)

```js
// O(1)
function sum(arr) {
  let total = 0
  for (let i = 0; i < arr.length; i++) {
    total += arr[i]
    return total
  }
}

// O(n)
function double(arr) {
  let newArr = []
  for (let i = 0; i < arr.length; i++) {
    newArr.push(2 * arr[i])
  }
}
```

[performance 模擬教材](https://rithmschool.github.io/function-timer-demo/)

### Big O of objects

- Fast, but no order
- Most constant

```js
insertion O(1)
removal O(1)
searching O(N)
  Object.keys(arr)
  Object.values(arr)
  Object.entries(arr)
access O(1)
  Object.hasOwnProperty(arr)
```

### Big O of arrays

- When you need order and fast access

```js
searching O(N)
access O(1)
insertion and removal
 - pop push O(1)
 - unshift unshift O(n)

concat O(n)
slice O(n)
splice O(n)
sort O(N*logN)
forEach/map/filter/reduce/etc O(n)
```

## what an algorithm is: 
- A PROCESS OR SET OF STEPS TO ACCOMPLISH A CERTAIN TASK
- devise a plan to solve algorithms
- compare and contrast a problem solving patterns including frequency counters, 2 pointer problem and divide and conquer

## problem solving

### understand the problem

- can i restate the problem in my own words?
  a add b
- what are the inputs that go into the problem
  ints? floats? what about string of large numbers

- what are the outputs that should come from the solution to the problem
  int? float? string?
- can the outputs be determined by the inputs?( do i have enough info to solve the problem)

- how should i label the important pieces of data that are a part of the problem

### explore concrete examples

- user stories
- start with simple examples -> complex
- empty inputs/ invalid inputs

```js
// a function takes in a string and returns counts of each char in the string

charCount(“aaaa”) // {a: 4}
charCount(“hello”) // {h: 1, e: 1. l:2, o:1}
```

- 可以問：需要回傳不在單字內的字母數量嗎
- “my phone number is 191231” // 需要數空白嗎 大小寫敏感嗎 數字忽略嗎
- () “” 回傳 null undefined?

### break down problem

- 寫下步驟，幫助了解整體規劃

```js
function charCount(str) {
  // make obj to return at end
  // loop over string, for each char
  // if the char is a number/letter AND is a key in obj add 1 to count
  // if the char is a number/letter AND not in obj, add it to obj, and set value to 1
  // if char is something else(space, period, etc), do nothing
  // return obj
}
```

### solve or simplify

- 先做出核心邏輯，找出 pattern 再處理複雜的

```js
function charCount(str) {
  // make obj to return at end
  var result = {}
  // loop over string, for each char
  for (var i = 0; i < str.length; i++) {
    var char = str[i].toLowerCase()
    if (result[char] > 0) {
      // if the char is a number/letter AND is a key in obj add 1 to count
      results[char]++
    } else {
      // if the char is a number/letter AND not in obj, add it to obj and set value to 1
      result[char] = 1
    }
    // return obj
    return results
  }
}
```

### loop back and refactor

- 結果正確嗎
- 有其他種寫法嗎
- 可以一看就懂嗎
- 可以複用在其他情境嗎
- 可以優化效能嗎
- 有其他重構或優化的方法嗎
- 其他人怎麼解的

```js
function charCount(str) {
  var obj = {}
  for (const char of str) {
    char = char.toLowerCase()
    if (/a-z0-9/.test(char)) {
      obj[char] = ++obj[char] || 1
    }
    return obj
  }
}
```
- 優化版
```js
function charCount(str) {
  var obj = {}
  for (const char of str) {
    char = char.toLowerCase()
    if (isAlphaNumeric(char)) {
      char = char.toLowerCase()
      obj[char] = ++obj[char] || 1
    }
    return obj
  }
}

function isAlphaNumeric(char) {
  var code = char.charCodeAt(0)
  if (
    !(code > 47 && code < 58) && // 0-9
    !(code > 64 && code < 91) && // A-Z
    !(code > 96 && code < 123) // a-z
  ) {
    return false
  }
  return true
}
charCodeAt(0)
```
