---
title: JavaScript基礎知識(2)｜The Complete JavaScript Course｜bacnotes備份筆記
description: function函式, object物件, array陣列, loop迴圈 對於這些抽象的概念不理解嗎？透過The Complete JavaScript Course 這堂課，讓我對於JavaScript有了更深的認識，這篇會介紹關於JavaScript的基礎知識（後半篇）。
date: 2021-12-31T00:00:00+08:00
slug: javascript-fundamentals-part2
image: javascript.jpeg
tags:
  - JavaScript
---

如果還沒看過
[JavaScript 基礎知識(1)｜ The Complete JavaScript Course](https://bacnotes.github.io/p/javascript-fundamentals-part1/ 'JavaScript基礎知識(1)｜The Complete JavaScript Course')  
可以看完上一篇，再回來繼續閱讀

## 使用嚴格模式提高程式碼品質

在檔案最上方加 `'use strict mode'` ，會幫你檢查哪些不適當的撰寫程式方式，下方狀況會拋出錯誤

- 未宣告的全域變數
- 對於無法寫入的變數(e.g. NaN, undefined)或不存在的物件屬性賦值
- 刪除不能刪除的屬性(e.g. delete Object.prototype)
- 物件屬性不是唯一值 unique
- Function 名稱有重複
- deleting plain names

```javascript
var x;
delete x; // !!! syntax error
```

- 使用到 reserved keywords

## function

- 實踐 dry code，重複使用一樣的邏輯，傳不同的參數
- parameter 是 function 的右邊的參數
- argument 是用在實際呼叫的值
- call = invoke = execute = run 都是執行(函式)的動詞

```javascript
function fruitProcessor(applesCount, orangesCount) {
  const juice = `juice with ${applesCount} apples & ${orangesCount} oranges`;
  return juice;
}
fruitProcessor(2, 5); // 'juice with 2 apples & 5 oranges'
fruitProcessor(3, 4); // 'juice with 3 apples & 4 oranges'
```

### 函式宣告 function declaration

- 呼叫後存到變數

```javascript
function calcAge(birthYear) {
  return 2037 - birthYear;
}
const age = calcAge(2036); // 放在function前後都可以 因為hoisting
console.log(age); // 1
```

### 函式表達式 function expression

- 匿名函式是 expression 會產生 value，存到左邊變數

```javascript
const calcAge = function (birthYear) {
  return 2037 - birthYear;
};
console.log(calcAge(2036)); // 1
```

### 箭頭函式 arrow function

- ES6 語法，沒有自己的 this

```javascript
// 單行 不需要{}跟return
const calcAge = (birthYear) => 2037 - birthYear;
console.log(calcAge(2036)); // 1

// 多行 需要{}跟return 程式會結束在return這行
const retireAge = (yourName, birthYear) => {
  const age = 2037 - birthYear;
  const retirement = 65 - age;
  return `${yourName} retires in ${retirement} years`;
};
console.log(retireAge('bacnotes', 2036)); // bacnotes retires in 64 years
```

## array 陣列

### 宣告陣列

```javascript
const arrayA = [1, 2, 3];
const arrayB = new Array(123, 123, 123);
```

### 陣列取值，序號從 0 開始

```javascript
array[0] // 第1個元素值
array[n] // 第n+1個元素值
array[arr.length - 1]  陣列尾巴元素值
```

### 修改陣列元素值

```javascript
arrayA[2] = 234;
```

- const 不是不能修改值嗎？ 單獨修改元素值是可以的
- 如果是 arrayA = ['a', 'b', 'c'] 就不行，因為就表示重新賦值整個陣列
- 補充 immutable（不可變更）跟 mutable（可變更）：只有賦值時是傳值的 primitives 是 immutable，而賦值時是傳址的陣列、物件內部值是 mutable

### array 方法

- array.push() 新增元素到陣列最後面，回傳陣列新的長度

```javascript
const friends = ['a', 'b', 'c', 'd'];
const newFriend = friends.push('e');
console.log(friends); // [ 'a', 'b', 'c', 'd', 'e' ]
console.log(newFriend); // 5
```

- array.pop() 刪除陣列最後一個元素 並回傳 刪除的元素值

```javascript
const friends = ['a', 'b', 'c', 'd', 'e'];
const popFriend = friends.pop();
console.log(friends)[('a', 'b', 'c', 'd')];
console.log(popFriend); // e
```

- array.unshift() 新增元素到陣列最前面，回傳陣列新的長度

```javascript
const friends = ['a', 'b', 'c', 'd'];
const unshiftFriend = friends.unshift('z');
console.log(friends); // [ 'z', 'a', 'b', 'c', 'd' ]
console.log(unshiftFriend); // 5
```

- array.shift() 刪除陣列第一個元素，回傳刪除的元素值

```javascript
const friends = ['z', 'a', 'b', 'c', 'd'];
const shiftFriend = friends.shift();
console.log(friends); // [ 'a', 'b', 'c', 'd' ]
console.log(shiftFriend); // z
```

- array.indexOf(element, fromIndex) 搜尋元素索引位置

```javascript
const friends = ['a', 'b', 'c', 'd'];
const positionD = friends.indexOf('d');
console.log(positionD); // 3
const positionL = friends.indexOf('l');
console.log(positionL); // if not existed return -1
```

- array.includes(element, fromIndex) 回傳陣列中是否有這個元素

```javascript
const hasLowerCaseA = friends.includes('a');
const hasUpperCaseA = friends.includes('A');
console.log(hasLowerCaseA, hasUpperCaseA); // true, false
```

還有很多其他的 array 方法，課程先介紹基本的  
推薦這篇大大寫的[JavaScript Array 陣列操作方法大全 ( 含 ES6 )](https://www.oxxostudio.tw/articles/201908/js-array.html 'JavaScript Array 陣列操作方法大全 ( 含 ES6 )')

## object 物件

### 宣告物件

```javascript
const jonas = {
  firstName: 'Jonas',
  lastName: 'Schmedtmann',
  age: 28,
  job: 'teacher',
  friends: ['a', 'b', 'c'],
};
```

### dot notation 取值

直觀簡潔，無法在[]裡面修改資料

```javascript
console.log(jonas.lastName); // 'Schmedtmann'
```

### brackets notation 取值

可以在[]裡面修改資料  
[]裡面是一個 expression，key 記得加上單引號

```javascript
console.log(jonas['lastName']); // 'Schmedtmann'

const nameKey = 'Name';
console.log(jonas['last' + nameKey]); // 'Schmedtmann'
```

### brackets notation 可以使用 expression，dot notation 無法

```javascript
const interestedIn = prompt(
  'what do you want ot know about Jonas? Choose between firstName, lastName,age or job'
);

// dot notation 無法用expression取得屬性(物件沒有interestedIn的屬性)
console.log(jonas.interestedIn); // undefined

// bracket 可使用expression取得屬性
console.log(jonas[interestedIn]); // teacher

// 當屬性存在列印出屬性值，屬性不存在時列印出'data not existed'
jonas[interestedIn]
  ? console.log(jonas[interestedIn])
  : console.log('data not existed');
```

### 新增/修改元素值

```javascript
jonas.location = 'Portugal'
jonas['twitter'] = '@jonas'
jonas.age = 82
console.log(jonas)
//
{
  firstName: 'Jonas',
  lastName: 'Schmedtmann',
  age: 82,
  job: 'teacher',
  friends: [ 'a', 'b', 'c' ],
  location: 'Portugal',
  twitter: '@jonas'
}

// 使用模板字串
console.log(`${jonas.firstName} has ${jonas.friends.length} friends, and his best friends is called ${jonas.friends[0]}`)
// Jonas has 3 friends, and his best friends is called a

```

### object 方法

- 物件的 function，習慣叫 method

```javascript
const jonas = {
  firstName: 'Jonas',
  lastName: 'Schmedtmann',
  birthYear: 2000,
  age: 28,
  job: 'teacher',
  friends: ['a', 'b', 'c'],
  // 方法
  calcAge: function (birthYear) {
    return 2027 - birthYear;
  },
};
console.log(jonas.calcAge(2000)); // 27
console.log(jonas['calcAge'](2000)); // 27
```

- 關於 this 的使用，有助於精簡程式碼
- 如果需要用一樣的物件，寫 this 就不需要修改寫死的變數

```javascript
const jonas = {
  firstName: 'Jona',
  lastName: 'Schmedtmann',
  birthYear: 2000,
  age: 28,
  job: 'teacher',
  friends: ['a', 'b', 'c'],
  hasDriverLicense: true,

  calcAge: function () {
    // return 2027 - jonas.birthYear 寫字的名字會不好維護
    this.age = 2027 - this.birthYear;
    return this.age; // 更新值就不用每次調用都重複計算，減少浪費效能
  },
};
```

## for 迴圈

- `for ([初始表達式]; [條件為真時會執行{}內容]; [更新表達式])`
- 適合確定迴圈次數時使用(e.g. by array 的元素長度或一個數字)
- 可用來精簡重複執行重複的程式碼

```javascript
// 假設要執行10次，從0開始到9結束
// 從 i = 0 開始，當(i < 9)條件為true會執行{}內的內容，完成後i++
for (let i = 0; i < 9; i++) {
  console.log(`lifting weights repetition ${i} 🏋️‍♀️ `)
}

//
lifting weights repetition 0 🏋️‍♀️
lifting weights repetition 1 🏋️‍♀️
lifting weights repetition 2 🏋️‍♀️
lifting weights repetition 3 🏋️‍♀️
lifting weights repetition 4 🏋️‍♀️
lifting weights repetition 5 🏋️‍♀️
lifting weights repetition 6 🏋️‍♀️
lifting weights repetition 7 🏋️‍♀️
lifting weights repetition 8 🏋️‍♀️
lifting weights repetition 9 🏋️‍♀️
```

- 反向迴圈 Backwards loop

```javascript
// 假設要執行10次，從9開始到0結束
// 從 i = 9 開始，當(i > 0)條件為true會執行{}內的內容，完成後i--
for (let i = 9; i >= 0; i--) {
  console.log(`lifting weights repetition ${i} 🏋️‍♀️ `)
}

//
lifting weights repetition 9 🏋️‍♀️
lifting weights repetition 8 🏋️‍♀️
lifting weights repetition 7 🏋️‍♀️
lifting weights repetition 6 🏋️‍♀️
lifting weights repetition 5 🏋️‍♀️
lifting weights repetition 4 🏋️‍♀️
lifting weights repetition 3 🏋️‍♀️
lifting weights repetition 2 🏋️‍♀️
lifting weights repetition 1 🏋️‍♀️
lifting weights repetition 0 🏋️‍♀️

```

- 陣列使用迴圈迭代元素
```javascript
// 範例1 迭代元素資料類型並放到另一陣列type
const arr = [1, 2, 3];
const type = [];

for (let i = 0; i < arr.length; i++) {
  console.log(arr[i]);
  // filling types array
  type[i] = typeof arr[i];
}
console.log(type); // [ 'number', 'number', 'number' ]

// 範例2 迭代元素元素值並放到另一陣列ages
const years = [1991, 2003, 2022, 1972];
const ages = [];

for (let i = 0; i < years.length; i++) {
  ages.push(2038 - years[i]);
}

//[ 47, 35, 16, 66 ]

// 範例3 使用比較簡潔的forEach語法 列印出元素
const arr = [1, 2, 3];
arr.forEach(function(element){
  console.log(element)
})
```

- continue: 跳出本次迴圈，執行下個迴圈(e.g. i = 2 → i = 3)

```javascript
const arrayB = ['stringA', 'stringB', 1, 2022 - 11, true];

for (let i = 0; i < arrayB.length; i++) {
  if (typeof arrayB[i] !== 'string') continue;
  console.log(arrayB[i], typeof arrayB[i]);
}
// stringA string
// stringB string
```

- break: 終止整個迴圈

```javascript
for (let i = 0; i < arrayB.length; i++) {
  if (typeof arrayB[i] === 'number') break;
  console.log(arrayB[i], typeof arrayB[i]);
}
// stringA string
// stringB string
```

- 巢狀迴圈

```javascript
for (let i = 0; i < 4; i++) {
  console.log(`-----starting excercise ${i}`);
  for (let j = 1; j < 3; j++) {
    console.log(`-----lifting ${j} time🏋️‍♀️`);
  }
}
```

## while Loop

- `while (condition) 當條件為真，則會一直執行{}`
- 適合不確定迴圈次數時使用(e.g. Math.random 的亂數)

```javascript
while (i < 10) {
  text += 'The number is ' + i;
  i++;
}
```

- 隨機 1-6 的骰子，骰到 6 才會停止

```javascript
let dice = Math.floor(Math.random() * 6 + 1); // 隨機產生1~6的數字

while (dice !== 6) {
  console.log(`Your rolled a ${dice}`);
  dice = Math.floor(Math.random() * 6) + 1;
  if (dice === 6) console.log(`Loop is about to end...`);
}

// Math.floor() 回傳小於等於所給數字的最大整數。(正數時等於無條件捨去，負數時等於無條件進位)
// Math.random() 回傳一個偽隨機小數(pseudo-random) 介於0到1之間(包含0，不包含1)
```

＊文章內容有錯誤的地方，都歡迎討論與指正
