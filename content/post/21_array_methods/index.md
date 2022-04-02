---
title: 陣列的處理方法｜bacnotes備份筆記
description: 陣列是許多fetch資料後需要處理的資料型態，這份陣列方法懶人包整理了slice()、concat()、join()、flat()、flatMap()、map()、filter()、reduce()、find()、findIndex()、at()、some()、every()、splice()、reverse()、sort()、forEach()、Array.from()、fill()等用法。
date: 2022-02-11T00:00:00+08:00
slug: array-methods
image: pexels-photo-7988086.jpeg
tags:
  - JavaScript
---

## 不會改變原始資料

<-- 參數為值 -->

### slice()

- array.slice([start[, end]])
- 跟展開運算子 [...array]一樣常被用作淺拷貝
- 回傳一個新陣列物件，為原陣列選擇之 start 至 end（end index 元素不包含在回傳結果）的淺拷貝
- 可以不傳參數(start 預設 0，end 預設 array.length)
- 可單傳 start 參數或 start end 都傳
- 接受負數，slice(2, -1) 代表拷貝陣列中第三個元素至倒數第二個元素

```js
const animals = ["ant", "bison", "camel", "duck", "elephant"];

animals.slice();
// ['ant', 'bison', 'camel', 'duck', 'elephant']

animals.slice(2);
// ["camel", "duck", "elephant"]

animals.slice(2, 4);
// ["camel", "duck"]

animals.slice(-2);
// ["duck", "elephant"]
```

### concat()

- var newArray = oldArray.concat(value1[, value2[, ...[, valueN]]])
- 合併兩個或多個陣列。回傳一個包含呼叫者陣列本身的值，作為代替的是回傳一個新陣列
- 跟展開運算子[...arr, ...arr2] 一樣

```js
const array1 = ["a", "b", "c"];
const array2 = ["d", "e", "f"];
array1.concat(array2);

// ["a", "b", "c", "d", "e", "f"]
```

### join()

- array.join([separator])
- 回傳合併所有陣列元素的字串
- separator 為用來隔開陣列中每個元素的字串。如果必要的話，separator 會自動被轉成字串型態。如果未傳入此參數，陣列中的元素將預設用英文逗號（「, 」）隔開。如果 separator 是空字串，合併後，元素間不會有任何字元。
- 任何 undefined 或 null 的元素都會被視為空字串處理。
- 假如 arr.length 為 0，將回傳空字串。

```js
var a = ["Wind", "Rain", "Fire"];
a.join(); // 'Wind,Rain,Fire'
a.join(""); // 'WindRainFire'
a.join(", "); // 'Wind, Rain, Fire'
a.join(" + "); // 'Wind + Rain + Fire'
```

### flat() (IE 沒有支援)

- var newArray = arr.flat([depth]);
- 函數以遞迴方式將特定深度的子陣列重新串接成為一新的陣列
- 第一個參數為指定巢狀陣列展開的深度，預設為 1
- 當遭遇空元素時，flat()函數會自動清除陣列中空的元素

```js
var arr1 = [1, 2, [3, 4]];
// 巢狀1層
arr1.flat();
// [1, 2, 3, 4]

var arr2 = [1, 2, [3, 4, [5, 6]]];
// 巢狀1層
arr2.flat();
// [1, 2, 3, 4, [5, 6]]

var arr3 = [1, 2, [3, 4, [5, 6]]];
// 巢狀2層
arr3.flat(2);
// [1, 2, 3, 4, 5, 6]

// 相加帳戶中所有金額
const accounts = [
  {
    owner: "Jonas Schmedtmann",
    movements: [200, 450, -400, 3000, -650, -130, 70, 1300],
    interestRate: 1.2, // %
    pin: 1111,
  },
  {
    owner: "Jessica Davis",
    movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
    interestRate: 1.5,
    pin: 2222,
  },
  {
    owner: "Steven Thomas Williams",
    movements: [200, -200, 340, -300, -20, 50, 400, -460],
    interestRate: 0.7,
    pin: 3333,
  },
  {
    owner: "Sarah Smith",
    movements: [430, 1000, 700, 50, 90],
    interestRate: 1,
    pin: 4444,
  },
];

// 不同物件中的某個屬性為陣列，將陣列值丟到一個新陣列
// 攤平陣列中巢狀結構（單層)
// 加總
const overallBalance = accounts
  .map((el) => el.movements)
  .flat()
  .reduce((el, mov) => el + mov, 0);
```

### flatMap() (IE 沒有支援)

- var new_array = arr.flatMap(function callback(currentValue[, index[, array]]) {
  // return element for new_array
  }[, thisArg])
- 幾乎等同 map().flat()，但比分別調用這兩個方法效能更好

```js
// 不同物件中的某個屬性為陣列，將陣列值丟到一個新陣列
// 攤平陣列中巢狀結構（單層)
// 加總
const overallBalance = accounts
  .flatMap((el) => el.movements)
  .reduce((el, mov) => el + mov, 0);
```

<-- 參數為 callback -->

### map()

- var new_array = arr.map(function callback(currentValue[, index[, array]]) {
  // Return element for new_array
  }[, thisArg])
- 把元素丟到函式裡執行，並回傳一個新陣列
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）
- 可以用作淺拷貝

```js
const array = [1, 4, 9, 16];

// pass a function to map
const map = array.map((x) => x * 2);

console.log(map);
// [2, 8, 18, 32]
```

### filter()

- var newArray = array.filter(callback(element[, index[, array]])[, thisArg])
- 回傳通過該函式檢驗之元素所構成的新陣列
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）

```js
const words = [
  "spray",
  "limit",
  "elite",
  "exuberant",
  "destruction",
  "present",
];

const result = words.filter((word) => word.length > 6);

console.log(result);
// ["exuberant", "destruction", "present"]
```

### reduce()

- array.reduce(callback[accumulator, currentValue, currentIndex, array], initialValue)
- 迭代到的陣列元素，回傳 accumulator，accumulator 是累加處理結果（累加是邏輯的累加不一定是數值累加）
- callback 可以收四個參數（accumulator 累加器處理結果、當前處理元素、當前處理元素 index、正在操作的陣列）
- 若有傳入 initialValue，則由索引 0 之元素開始，若無則自索引 1 之元素開始
- 空陣列呼叫 reduce() 方法且沒有提供累加器初始值，將會發生錯誤
- 可以把陣列變成一個計算結果，結果可以是數字/物件各種形式

```js
// a is accumulator, b is currentValue

// 累加
const array = [1, 2, 3, 4];
const reducer = (a, b) => a + b;
const added = array.reduce(reducer));
console.log(added)
// 6

// 找max最大值
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300]
const reducer = (a, b) => {
  if (a > b) return a
  else return b
}
const maxValue = movements.reduce(reducer)
console.log(maxVlue)
// 3000

// 攤平巢狀陣列
const array = [
  [0, 1],
  [2, 3],
  [4, 5]
]
const reducer = (a, b) => a.concat(b)
const flattened = array.reduce((reducer), []);
console.log(flattened)
// [0, 1, 2, 3, 4, 5]

// 計數器
const names = ['Alice', 'Bob', 'Tiff', 'Bruce', 'Alice']
const reducer = (allNames, name) => {
  if (name in allNames) {
    allNames[name]++;
  } else {
    allNames[name] = 1;
  }
  return allNames;
}
const countedNames = names.reduce(reducer, {});
console.log(countedNames)
// { 'Alice': 2, 'Bob': 1, 'Tiff': 1, 'Bruce': 1 }
```

### find()

- array.find(callback[, thisArg])
- 回傳第一個滿足所提供之測試函式的元素值
- 查找不到會回傳 undefined
- callback 可以收三個參數（當前處理函數、當前處理函數 index、正在操作的陣列）

```js
// 查找含有特定屬性的物件
const accounts = [
  {
    owner: "Jonas Schmedtmann",
    movements: [200, 450, -400, 3000, -650, -130, 70, 1300],
    interestRate: 1.2, // %
    pin: 1111,
  },
  {
    owner: "Jessica Davis",
    movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
    interestRate: 1.5,
    pin: 2222,
  },
  {
    owner: "Steven Thomas Williams",
    movements: [200, -200, 340, -300, -20, 50, 400, -460],
    interestRate: 0.7,
    pin: 3333,
  },
  {
    owner: "Sarah Smith",
    movements: [430, 1000, 700, 50, 90],
    interestRate: 1,
    pin: 4444,
  },
];

const account = accounts.find((account) => account.owner === "Jessica Davis");
console.log(account);

// 查找數值大於10
const array = [5, 12, 8, 130, 44];

const found = array.find((element) => element > 10);

console.log(found);
// 12
```

### findIndex() v.s. indexOf()

- array.findIndex(callback[, thisArg])
- 回傳第一個滿足所提供之測試函式的元素索引，若找不到會回傳-1
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）
- indexOf(element, fromIndex) 也可以搜尋元素索引位置，但參數通常是給一個 primitives 值
- findIndex()期望參數為一個 callback，可以處理複雜邏輯

```js
// 刪除特定筆資料
btnCloseAccount.addEventListener("click", (e) => {
  e.preventDefault();
  const index = accounts.findIndex(
    (account) => account.username === currentAccount.username
  );
  accounts.splice(index, 1);
});

const array = [5, 12, 8, 130, 44];

const isLargeNumber = (element) => element > 13;

console.log(array.findIndex(isLargeNumber));
// 3
```

### at()

- 功能類似 find()，array.at(index)等於 array[index]
- 回傳索引的元素，通常用來取最尾端的元素
- 允許正整數和負整數。負整數從數組中的最後一項開始倒數
- 找不到元素回傳 undefined

```js
const array = [5, 12, 8, 130, 44];

let index = 2;

console.log(`index ${index + 1} is ${array.at(index)}`);
// "index 2 is 8"

index = -2;

console.log(`index ${index + 1} is ${array.at(index)}`);
// "index -2 is 130"
```

### some()

- arr.some(callback[, thisArg])
- some() 測試陣列中是否至少有一個元素，符合該函式條件，回傳結果為 true false
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）

```js
const array = [1, 2, 3, 4, 5];

// checks whether an element is even
const even = (element) => element % 2 === 0;

console.log(array.some(even));
// true

// 檢查是否有任一存款紀錄
const movements = [200, 450, -400, 3000, -650, -130, 70, 1300];
const anyDeposit = movements.some((mov) => mov > 0);
console.log(anyDeposit); // true

// 借貸條件為，曾存款過且需有一筆存款金額大於等於借貸金額10% 假設借貸30000 需要有一筆大於3000的存款
btnLoan.addEventListener("click", function (e) {
  e.preventDefault();

  const amount = Number(inputLoanAmount.value);
  const condition = (mov) => mov >= amount * 0.1;
  if (amount > 0 && currentAccount.movements.some(condition)) {
    currentAccount.movements.push(amount);

    updateUI(currentAccount);
  }
});
```

### every()

- arr.every(callback[, thisArg])
- every() 方法會測試陣列中的所有元素是否都通過函式條件，回傳結果為 true false
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）

```js
const isBelowThreshold = (currentValue) => currentValue < 40;

const array1 = [1, 30, 39, 29, 10, 13];

console.log(array1.every(isBelowThreshold));
// true
```

## 會改變原始資料

push()、pop()、shift()、unshift()可以參考[JavaScript 基礎知識複習(2)](https://bacnotes.github.io/p/javascript-fundamentals-part2/)

<– 參數為值 –>

### splice()

- array.splice(start[, deleteCount[, item1[, item2[, ...]]]])
- 回傳一個包含被刪除的元素陣列
- 如果只有一個元素被刪除，依舊是回傳包含一個元素的陣列。若沒有元素被刪除，則會回傳空陣列。
- 多數時候不在意回傳值而是修改後的陣列資料，可以用來取代陣列某個索引的元素，可以新增元素也可以刪除元素
- start 是改動點，若大於陣列長度，起始點為陣列長度。若為負，起始點為-1。複數絕對值大於陣列長度，則起始點為 0
- deleteCount 為刪除元素數量
- array.splice(-1) 等於 array.pop()

```js
const months = ["Jan", "March", "April", "June"];
months.splice(1, 0, "Feb");
// 起始點1，刪除0個元素，並插入元素'Feb'
// []

console.log(months);
// ["Jan", "Feb", "March", "April", "June"]

months.splice(4, 1, "May");
// 作為取代方法，起始點4 刪除1元素 並插入元素'May'
// [ 'June' ]

console.log(months);
// ["Jan", "Feb", "March", "April", "May"]
```

### reverse()

- array.reverse()
- 回傳反轉後的陣列

```js
const array = ["one", "two", "three"];

array.reverse();
// ["three", "two", "one"]
```

<-- 參數為 callback -->

### sort()

- arr.sort([compareFunction])
- 對一個陣列的所有元素進行排序，並回傳此陣列。排序不一定是穩定的（stable）
- 由於依賴執行環境的實作，所以並不能保證排序的時間及空間複雜度
- 預設的排序順序是根據字串的 Unicode 編碼位置（code points）而定，可以用第一個參數 compareFunction(a, b)自定義比較邏輯

```js
function compare(a, b) {
  if (在某排序標準下 a 小於 b) {
    return -1;
  }
  if (在某排序標準下 a 大於 b) {
    return 1;
  }
 // a 必須等於 b
  return 0;
}
```

- 若 compareFunction(a, b) 的回傳值小於 0，則會把 a 排在小於 b 之索引的位置，即 a 排在 b 前面。

```js
// 若 a 小於 b ，a - b < 0 a會被丟到前面，由小排到大
movements.sort((a, b) => a - b);
```

- 若 compareFunction(a, b) 的回傳值大於 0，則會把 b 排在小於 a 之索引的位置，即 b 排在 a 前面。

```js
// 若 a 大於 b ，b - a < 0，a會被丟到後面，由大排到小
movements.sort((a, b) => b - a);
```

- 若 compareFunction(a, b) 回傳 0，則 a 與 b 皆不會改變彼此的順序，但會與其他全部的元素比較來排序。備註：ECMAscript 標準並不保證這個行為，因此不是所有瀏覽器（如 Mozilla 版本在 2003 以前）都遵守此行為。
- compareFunction(a, b) 在給予一組特定元素 a 及 b 為此函數之兩引數時必須總是回傳相同的值。若回傳值不一致，排序順序則為 undefined。

```js
// 展示的function
const displayMovements = function (movements, sort = false) {
  // 有要sort才會使用排序後資料(copy資料)
  const movs = sort ? movements.slice().sort((a, b) => a - b) : movements;
  // some render logic
};

let sorted = false;
btnSort.addEventListener("click", function (e) {
  e.preventDefault();
  // 改變畫面
  displayMovements(currentAccount.movements, !sorted);
  // 更新狀態
  sorted = !sorted;
});
```

## 針對每個元素處理

- 原始資料可改可不改，看函式邏輯
- 可以只迭代 render 在畫面上，也可修改資料 e.g. 新增物件屬性等

### forEach()

- array.forEach(callback(currentValue [, index [, array]])[, thisArg])
- 對每個陣列內的元素執行一次函式的內容，不會回傳執行結果，但可以修改原來的陣列
- callback 可以收三個參數（當前處理元素、當前處理元素 index、正在操作的陣列）
- forEach 無法從迴圈跳出，會執行完畢

```js
// 交易紀錄
const array = [100, 300, -250, 200, 300, -20, 50, -100];

array.forEach((el, index, array) => {
  if (el > 0) {
    console.log(`${index + 1}: you deposited ${el} dollars`);
  } else {
    console.log(`${index + 1}: you withdrew ${Math.abs(el)} dollars`);
  }
});

// 等於之前的for of 搭配array.entries()同時取出index(key) value
for (const [index, el] of array.entries()) {
  if (el > 0) {
    console.log(`${index + 1}: you deposited ${el} dollars`);
  } else {
    console.log(`${index + 1}: you withdrew ${Math.abs(el)} dollars`);
  }
}

// 0: you deposited 100 dollars
// 1: you deposited 300 dollars
// 2: you withdrew 250 dollars
// 3: you deposited 200 dollars
// 4: you deposited 300 dollars
// 5: you withdrew 20 dollars
// 6: you deposited 50 dollars
// 7: you withdrew 100 dollars
```

- forEach 用在 set 跟 map

```js
// set
const currenciesUnique = new Set(["USD", "EUR", "GBP"]);
currenciesUnique.forEach((el, _, map) => {
  console.log(`${el}: ${el}`);
});

// USD: USD
// EUR: EUR
// GBP: GBP

// map
const currencies = new Map([
  ["USD", "United States dollar"],
  ["EUR", "Euro"],
  ["GBP", "Pound sterling"],
]);

currencies.forEach((el, index, map) => {
  console.log(`${index + 1}: ${el}`);
});
// USD: United States dollar
// EUR: Euro
// GBP: Pound sterling
```

- 增加物件屬性

```js
const accounts = [
  {
    owner: "Jonas Schmedtmann",
    movements: [200, 450, -400, 3000, -650, -130, 70, 1300],
    interestRate: 1.2, // %
    pin: 1111,
  },
  {
    owner: "Jessica Davis",
    movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
    interestRate: 1.5,
    pin: 2222,
  },
  {
    owner: "Steven Thomas Williams",
    movements: [200, -200, 340, -300, -20, 50, 400, -460],
    interestRate: 0.7,
    pin: 3333,
  },
  {
    owner: "Sarah Smith",
    movements: [430, 1000, 700, 50, 90],
    interestRate: 1,
    pin: 4444,
  },
];

const createUsernames = (array) => {
  array.forEach((account) => {
    accounts.username = acc.owner
      .toLowerCase()
      .split(" ")
      .map((name) => name[0])
      .join("");
  });
};
```

## 產生 Array 跟注入元素方法

### new Array()

- 陽春版手動放陣列元素

```js
const arr = new Array(1, 2, 3);
```

### new Array，搭配 fill() 注入元素

- fill() 方法會將陣列中索引的第一個到最後一個的每個位置全部填入一個靜態的值
- arr.fill(value[, start[, end]])，start 預設 0，end 預設陣列長
- 元素區間為 [start, end)，意即包含 start 但不包含 end

```js
const arr = new Array(7);
// [ <7 empty items> ]
arr.fill(1);
// [1, 1, 1, 1, 1, 1, 1]

const arr2 = new Array(7);
arr2.fill(1, 3, 5);
// index 3開始到 index 4 注入元素1
//[ <3 empty items>, 1, 1, <2 empty items> ]
```

### Array.from()

- Array.from() 方法會從類陣列（array-like）或是可迭代（iterable）物件建立一個新的 Array 實體
- 第一個參數是 arrayLike 將類陣列或可迭代物件轉換成陣列
- 第二個參數是 Map 函式迭代陣列中的每一個元素
- 第三個參數是函式執行時的 this 對象

```js
const y = Array.from(
  {
    length: 7,
  },
  () => 1
);
console.log(y);
// [1,1,1,1,1,1,1]

const z = Array.from(
  {
    length: 7,
  },
  (_, i) => i + 1
);
// [1,2,3,4,5,6,7]

console.log(Array.from("foo"));
// Array ["f", "o", "o"]
```

- querySelectorAll 選到的 nodeList 可以先用 Array.from 方法轉陣列

```js
// 選取需要的div元素，取出textContent
labelBalance.addEventListener('click', function() => {
  const movementsUI = Array.from(
    document.querySelectorAll('.movements__value'), el => Number(el.textContent.replace('€', '')) console.log(movementsUI)

    const movementsUI2 = [...document.querySelectorAll('.movements__value')]
    )
})
```

## 小練習

- slice concat forEach

```js
// 寫一個'checkDogs' 功能 收兩個陣列參數，依序列印第幾隻狗夠是成年或幼年/幾歲
//TEST DATA 1: Julia's data [3, 5, 2, 12, 7], Kate's data [4, 1, 15, 8, 3]

//TEST DATA 2: Julia's data [9, 16, 6, 8, 3], Kate's data [10, 5, 6, 1, 4]
const checkDogs = function (arr1, arr2) {
  // [...arr1]
  // 排除第一個跟最後兩筆錯誤資料
  dogsJulia = arr1.slice(1, 4);
  dogsKate = arr2.slice();
  // 合併兩組陣列
  allDogs = dogsJulia.concat(dogsKate);
  // console文字 大於等於3算adult 小於算puppy
  allDogs.forEach((el, index) => {
    const dogType = el >= 3 ? "adult" : "puppy";
    console.log(`Dog ${index + 1} is an ${dogType} and is ${el} years old`);
  });
};
```

- map filter reduce

```js
// TEST DATA 1: [5, 2, 4, 1, 15, 8, 3]
// TEST DATA 2: [16, 6, 10, 5, 6, 1, 4]

// 寫一個calcAverageHumanAge 換算成平均人類年齡

const calcAverageHumanAge = function(ages) {
  // 狗狗年齡換算人類邏輯 若<=2 直接*2; 若>2 初始值16 + 年齡*4
  const humanAges = ages
  .map((age) => (age <= 2 ? age * 2 : 16 + age * 4))
  .filter((age) => age >= 18); // 排除換算年齡小於18的狗狗
  .reduce((sum, age, i, arr) => sum + age / arr.length, 0) // 狗狗換算平均年齡

  // 下方reduce若沒有設定初始值 結果會有錯
  // const avg = adults.reduce((sum, age, i, arr) => sum + age / arr.length, 0)
  // 2 3. (2+3)/2 = 2.5 === 2/2+3/2 = 2.5
  return avg;
};

calcAverageHumanAge([5, 2, 4, 1, 15, 8, 3]);
```

- 綜合練習
- 三元運算子算是兩行，不會隱含 return
- count++ 跟 ++count 差異

```js
// challenge #3
// data
const account1 = {
  owner: "Jonas Schmedtmann",
  movements: [200, 450, -400, 3000, -650, -130, 70, 1300],
  interestRate: 1.2, // %
  pin: 1111,
};

const account2 = {
  owner: "Jessica Davis",
  movements: [5000, 3400, -150, -790, -3210, -1000, 8500, -30],
  interestRate: 1.5,
  pin: 2222,
};

const account3 = {
  owner: "Steven Thomas Williams",
  movements: [200, -200, 340, -300, -20, 50, 400, -460],
  interestRate: 0.7,
  pin: 3333,
};

const account4 = {
  owner: "Sarah Smith",
  movements: [430, 1000, 700, 50, 90],
  interestRate: 1,
  pin: 4444,
};

const accounts = [account1, account2, account3, account4];

// 1-1 所有帳戶存款紀錄加總 map flat
const overAllBalance = accounts
  .map((el) => el.movements)
  .flat() // 變成一維陣列
  .filter((el) => el > 0)
  .reduce((sum, el) => sum + el);
console.log(overAllBalance);

// 1-2 所有帳戶存款紀錄加總 flatMap
const overAllBalance = accounts
  .flatMap((el) => el.movements) // 變成一維陣列
  .filter((el) => el > 0)
  .reduce((sum, el) => sum + el);
console.log(overAllBalance); // 25180

// 2 大於1000存款記錄有幾筆
// reduce 第二個參數為初始值 複習計數器用法
// sum++先return 再+ ; ++sum 先+再return
const numDeposit1000 = accounts
  .flatMap((el) => el.movements)
  // 如果寫sum++ 每次都先return 0 給accumulator 再+1 累加結果就永遠是0
  .reduce((count, el) => (el > 1000 ? ++count : count), 0);
console.log(numDeposit1000); // 5

// 3 reduce 回傳結果為{存款記錄筆數: 提款記錄筆數:}

const balanceCounter = accounts
  .flatMap((el) => el.movements)
  // 如果寫sum++ 每次都先return 0 給accumulator 再+1 累加結果就永遠是0
  .reduce(
    (sums, el) => {
      el > 0 ? (sums.deposits += el) : (sums.withdraws += el);
      // 這邊有+= 運算 非單行 記得加return
      return sums;
    },
    {
      deposits: 0,
      withdraws: 0,
    }
  );
console.log(balanceCounter);
// {deposits: 25180, withdraws: -7340}

// 更簡潔的寫法

const balanceCounter = accounts
  .flatMap((el) => el.movements)
  // 如果寫sum++ 每次都先return 0 給accumulator 再+1 累加結果就永遠是0
  .reduce(
    (sums, el) => {
      sums[el > 0 ? "deposits" : "withdraws"] += el;
      return sums;
    },
    {
      deposits: 0,
      withdraws: 0,
    }
  );
console.log(balanceCounter);

// 4. 格式轉換器 this is a nice title -> This Is a Nice Title
// array.includes(element)
const covertTitleCase = function (title) {
  const exceptions = ["a", "an", "and", "the", "but", "or", "on", "in", "with"];
  const titleCase = title
    .toLowerCase()
    .split(" ")
    .map((word) =>
      exceptions.includes(word) ? word : word[0].toUpperCase() + word.slice(1)
    )
    .join(" ");

  return titleCase;
};

//
```

- 綜合練習 2

```js
// challenge #4
// TEST DATA:
// const dogs = [
//  { weight: 22, curFood: 250, owners: ['Alice', 'Bob'] },
//  { weight: 8, curFood: 200, owners: ['Matilda'] },
//  { weight: 13, curFood: 275, owners: ['Sarah', 'John'] },
//  { weight: 32, curFood: 340, owners: ['Michael'] }
// ];

// 1. calculate the recommended food portion and add it to the object as a new property. Do NOT create a new array, simply loop over the array. Forumla: recommendedFood = weight ** 0.75 * 28. (The result is in grams of food, and the weight needs to be in kg)

// 2. Find Sarah's dog and log to the console whether it's eating too much or too little. HINT: Some dogs have multiple owners, so you first need to find Sarah in the owners array, and so this one is a bit tricky (on purpose)

// 3. Create an array containing all owners of dogs who eat too much ('ownersEatTooMuch') and an array with all owners of dogs who eat too little ('ownersEatTooLittle').

// 4. Log a string to the console for each array created in 3., like this: "Matilda and Alice and Bob's dogs eat too much!" and "Sarah and John and Michael's dogs eat too little!"

// 5. Log to the console whether there is any dog eating EXACTLY the amount of food that is recommended (just true or false)

// 6. Log to the console whether there is any dog eating an OKAY amount of food (just true or false)

// 7. Create an array containing the dogs that are eating an OKAY amount of food (try to reuse the condition used in 6.)

// 8. Create a shallow copy of the dogs array and sort it by recommended food portion in an ascending order (keep in mind that the portions are inside the array's objects)
```
