---
title: JavaScript基礎知識複習(3)｜The Complete JavaScript Course｜bacnotes備份筆記
description: 這篇會介紹邏輯運算子+指派運算子，for迴圈語法糖(for of、for in)、Enhanced Object Literals、Optional Chaining、Sets、Maps等知識，若對於這些方法還不是很熟悉，可以用這篇筆記幫助自己複習一下。
date: 2022-01-10T00:00:00+08:00
slug: javascript-fundamentals-part3
image: javascript.png
tags:
  - JavaScript
---

## 邏輯運算子 + 指派運算子 `&&=` `||=` `??=`

還記得 `&&` `||` `??` 這三個邏輯運算子嗎？其實他們可以跟指派運算子一起使用  
如果沒有接觸過的可以先看看第一篇[JavaScript 基礎知識複習(1)](https://bacnotes.github.io/p/javascript-fundamentals-part1/ 'JavaScript基礎知識複習(1)｜The Complete JavaScript Course')的介紹再來往下看唷  

- 下方是兩個餐廳資料物件，彼此的屬性略有不同

```js
const restaurant1 = {
  name: 'Carpi',
  numGuests: 20,
};

const restaurant2 = {
  name: 'La Piazza',
  owner: 'Giovanni Rossi',
};
```

- 當我們想增加物件內的屬性，可以用邏輯運算子的方式添加

```js
restaurant1.numGuests = restaurant1.numGuests || 10; // 屬性存在不會有變動
restaurant2.numGuests = restaurant2.numGuests || 10; // 沒有這個屬性，新增一個numGuests: 10
console.log(restaurant1); // { name: 'Carpi', numGuests: 20 }
console.log(restaurant2); // { name: 'La Piazza', owner: 'Giovanni Rossi', numGuests: 10 }
```

- 但還可以寫得更精簡，使用邏輯運算子 + 指派運算子，跟上方的結果是一樣的

```js
restaurant1.numGuests ||= 10; // 屬性存在不會有變動
restaurant2.numGuests ||= 10; // 沒有這個屬性，新增一個numGuests: 10
console.log(restaurant1); // { name: 'Carpi', numGuests: 20 }
console.log(restaurant2); // { name: 'La Piazza', owner: 'Giovanni Rossi', numGuests: 10 }
```

- 遇到 numGuests 數量為`0`，會因 falsy 更新成後面的值，這個邏輯不是我們期待的結果可以使用`??=` 的方式避免這個問題
- 當屬性 null 不存在或 undefined，使用後方的值增加這個屬性

```js
restaurant1.numGuests ??= 10;
restaurant2.numGuests ??= 10;
console.log(restaurant1); // { name: 'Carpi', numGuests: 20 }
console.log(restaurant2); // { name: 'La Piazza', owner: 'Giovanni Rossi', numGuests: 10 }
```

- 當我們想更新屬性值的時候則可以使用`&&=`，如果這個屬性不存在會回傳 undefined

```js
// 更新第一家餐廳的客戶數量
restaurant1.numGuests &&= 300;
console.log(restaurant1); // {name: 'Carpi', numGuests: 300}

// 更新第二家餐廳的owner
restaurant2.owner &&= 'Mars';
console.log(restaurant2); // {name: 'La Piazza', owner: 'Mars', numGuests: 10}
```

## for 迴圈語法糖：for of 迭代元素、for in 迭代屬性

- 每次寫 for 迴圈都覺得寫計數器跟迭代條件很麻煩嗎？其實還有更簡單的寫法
- 一樣可以搭配使用 continue 跟 break 語法

### for of 迴圈迭代陣列裡的元素

- for (const 陣列元素 of 陣列)
- 迭代元素

```js
const menu = ['Focaccia', 'Bruschetta', 'Garlic Bread'];

for (const item of menu) {
  console.log(item);
}
// Focaccia
// Bruschetta
// Garlic Bread
```

### for in 迴圈迭代物件屬性跟對應值

- for in 迭代出屬性(key)

```js
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18,
  },
};
for (const day in openingHours) {
  console.log(day);
}
// mon
// tue
```

## 使用 Object.keys()、Object.values() 迭代物件屬性跟值

### Object.keys 迭代物件屬性成一個陣列

```js
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18,
  },
};
console.log(Object.keys(openingHours));
//  ['mon', 'tue']
```

```js
- Object.keys()可搭配 for of 迭代出陣列元素(值)
for (const day of Object.keys(openingHours)){
  console.log(day)
}
// mon
// tue
```

### Object.values(openingHours)迭代物件 value

```js
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18,
  },
};
console.log(Object.values(openingHours));
// [{open: 10, close: 16}, {open: 12, close: 18}]
```

## 同時迭代陣列或物件的 key & value：.entries()

### 陣列 array.prototype.entries()

```js
const menu = ['Focaccia', 'Bruschetta', 'Garlic Bread'];
for (const item of menu.entries()) {
  console.log(item);
}
// [ 0, 'Focaccia' ]
// [ 1, 'Bruschetta' ]
// [ 2, 'Garlic Bread' ]

// ...展開陣列
for (const item of menu.entries()) {
  console.log(...item);
}
// 0 Focaccia
// 1 Bruschetta
// 2 Garlic Bread

// 使用解構賦值，並從1開始呈現
for (const [index, item] of menu.entries()) {
  console.log(`${index + 1}: ${item}`);
}

// 1: Focaccia
// 2: Bruschetta
// 3: Garlic Bread
```

### 物件 Object.entries()

- Object.entries(obj) 跟 for in 迴圈類似但 for in 還會列舉出 prototype 的屬性

```js
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18,
  },
};
// key value
for (const [key, { open, close }] of Object.entries(openingHours)) {
  console.log(`On ${key}, we open at${open} and close at ${close}`);
}
// On mon, we open at10 and close at 16
// On tue, we open at12 and close at 18
```

## Enhanced Object Literals

### 當變數跟屬性名稱相同可省略

```js
// 變數name 跟 openingHours
const name = 'Great Restaurant',
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18
  }
}
// 以往物件賦值，需要屬性跟值都寫上去
const restaurant = {
  name: name,
  openingHours:openingHours,
  location: 'France'
}

// 現在只要屬性跟變數名一樣，單寫屬性就好，程式碼會幫你把值對起來
const restaurant = {
  name,
  openingHours,
  location: 'France'
}
```

### 物件方法可省略冒號跟 function

```js
// 過去會寫成
order: function (a,b){
  return a + b
}

// 可以簡寫成 長得就跟宣告函式一樣
order(a, b) {
  return a + b
}

```

### 表達式作為物件的屬性名

```js
const weekdays = ['mon', 'tue', 'wed', 'thu', 'fri'];
const openingHours = {
  [weekdays[2]]: {
    open: 12,
    close: 18,
  },
  [`day-${2 + 4}`]: {
    open: 13,
    close: 19,
  },
};

console.log(openingHours);
// day-6: {open: 13, close: 19}
// wed: {open: 12, close: 18}
```

## Optional Chaining(ES2020) ?.

- 當資料本身很多屬性且每筆資料不一定存在這個屬性，讀取到不存在的屬性會跳出 Uncaught TypeError
- 使用?.讀取屬性，若不存在 null 或 undefined，會立即回傳 undefined，可以避免上方的 Uncaught TypeError
- 若為 0 ''會回傳相對應的值，只有 null undefined 會回傳 undefined
- 常搭配??一起使用

### 屬性加上 Optional Chaining

```JS
const openingHours = {
  mon: {
    open: 10,
    close: 16,
  },
  tue: {
    open: 12,
    close: 18
  },
  wed: {
    open: 12,
    close: 18
  }
}
const restaurant = {
  name: 'Great restaurant',
  openingHours
}

// 使用邏輯運算子的寫法 當屬性存在才執行（但資料一多會吐血）
if(restaurant.openingHours && restaurant.openingHours.mon)
console.log(restaurant.openingHours.mon.open)

// 使用Optional Chaining的寫法 簡短
console.log(restaurant.openingHours?.mon?.open)

// 加上迭代for of 想知道平日幾點開門
const weekdays = ['mon', 'tue', 'wed', 'thu', 'fri']
for (const weekday of weekdays){
  // 避免undefined出現 使用??設定預設值 not open
  const open = restaurant.openingHours[weekday]?.open ??'not open'
  console.log(`On ${weekday}, ${open}`)
}

// On mon, 10
// On tue, 12
// On wed, 12
// On thu, not open
// On fri, not open
```

### 物件方法加上 Optional Chaining

- 確認方法是否存在

```js
const restaurant = {
  order(starterIndex, mainIndex) {
    return 'Order!';
  },
  orderDelivery({ starterIndex = 1, mainIndex }) {
    return 'OrderDelivery!';
  },
};
console.log(restaurant.order?.(0, 1) ?? 'Method not existed'); // Order!
console.log(restaurant.orderRisotto?.(0, 1) ?? 'Method not exist'); // 'Method not exist'
```

### 陣列加上 Optional Chaining

- 檢查陣列是否有資料

```JS
const users = [{ name: 'Jonas', email: 'hello@jonas.com'}]

// 過去可能要寫
if(users.length > 0) console.log(users[0].name)
else console.log('User array empty')

// 使用Optional Chaining 寫起來更精簡
console.log(users[0]?.name ?? 'User array empty')
```

## Set

- 是元素的集合，元素可以是任何資料格式
- Set 中所有的元素都是唯一的 (unique values)，不會有重複的值，當你存入重複的元素(值)會被忽略
- Set 內部會用 === 來判斷是否有重複值，唯一的例外是 NaN 會被判斷作是重複的值(雖然 NaN !== NaN)
- 元素數量計算使用.size

```js
const someSet = newSet([a, b, c]);
console.log(someSet.size); // 3
```

- .has('元素')檢查是否有包含元素

```js
const someSet = newSet([a, b, c]);
console.log(someSet.has('a')); // true
```

- 增加與刪除元素 .add() .delete() .clear()

```js
someSet.add('d');
console.log(someSet); // [a, b, c, d]
someSet.delete('a');
console.log(someSet); // [b, c, d]
someSet.clear();
console.log(someSet); // []
```

- 無法用 index 從 Set 中把值取出，會回傳 undefined
- 可以迭代

```js
const someSet = newSet([a, b, c]);
for (const item of someSet) console.log(item); // a b c
```

- 查詢資料中不重複元素的數量

```js
const classmate = ['a', 'c', 'd', 'c', 'b'];
const classmateSet = new Set(classmate);
console.log(classmateSet.size);
```

- 把 Set 變不重複元素的陣列

```js
const classmate = ['a', 'c', 'd', 'c', 'b'];
const classmateSet = [...new Set(classmate)];
console.log(classmateSet); // [ 'a', 'c', 'd', 'b' ]
```

## Map

- key value pair 的組合，可以記住 key 的原始加入 Map 的順序
- 可以迭代，迭代順序為加入 Map 的順序
- 在 Map 判斷 NaN 跟 NaN 相等（雖然 NaN !== NaN），剩下的值使用=== 判斷是否相等

### 新建構一個 Map

```js
let restaurant = new Map(); //裡面是空的 跟物件有prototype不同
```

- 新增 kddey 使用.set(key, value)
- key 值的不限於字串，可以是任何資料型態（number、array、object、function、symbol)

```js
console.log(restaurant.set(1, 'Firenze, Italy'));
// Map(1) { 1 => 'Firenze, Italy' }

console.log(restaurant.set(2, 'Tokyo, Japan'));
// Map(2) { 1 => 'Firenze, Italy', 2 => 'Tokyo, Japan' }
```

### 使用 get 獲取 key 的對應值

```js
restaurant.set(1, 'Test');
console.log(restaurant.get(1));
// 'Test'
```

### 讀取 key 值加上邏輯判斷做條件渲染

```js
// 新增以下key
restaurant.set('open', 11);
restaurant.set('close', 21);
restaurant.set(true, 'we are open');
restaurant.set(false, 'we are closed');
// 判斷營業時間
const time = 21;
console.log(
  restaurant.get(
    time > restaurant.get('open') && time < restaurant.get('close')
  )
);
// we are closed
```

### 使用.size 查詢資料長度

```js
console.log(restaurant.size); //6
```

### 使用 has 確認是否包含某個 key，回傳 true false

```js
console.log(restaurant.has(true)); //true
console.log(restaurant.has(false)); //true
```

### 使用 delete 刪除元素 clear 清空元素

```js
restaurant.delete(1);
console.log(restaurant);
//  Map(5) {
//  2 => 'Tokyo, Japan',
//  'open' => 11,
//  'close' => 21,
//  true => 'we are open',
//  false => 'we are closed'
//  }
restaurant.clear();
// Map(0) {}
```

- 注意：物件如果不是 ref 的方式給值，無法讀取到對應 value

```js
restaurant.set([1, 2], 'Test');
console.log(restaurant.get([1, 2]));
// undefined

const arr = [1, 2];
restaurant.set(arr, 'Test');
console.log(restaurant.get(arr));
// 'Test'
```

### 可以綁定 DOM 元素

```js
restaurant.set(document.querySelector('h1'), 'Heading');
console.log(restaurant.get('h1'));
//Map(1) {h1.bold-title.is-1 => 'Heading'}
```

### 物件轉 Map

```js
console.log(Object.entries(openingHours));
const hoursMap = new Map(Object.entries(openingHours));
console.log(hoursMap);
```

### Map 轉 array

```js
console.log([...question]);
// [Array(2), Array(2), Array(2), Array(2), Array(2), Array(2), Array(2)]

// 迭代key
console.log([...question.keys()]);
// ['question', 1, 2, 3, 'correct', true, false]

// 迭代value
console.log([...question.values()]);
//  ['What is the best programming language in the world?', 'C', 'Java', 'JavaScript', 3, 'Correct 🎉', 'Try again!']
```

### 迭代 Map key value

- 在巢狀陣列的資料格式下迭代（跟 Object.entries(物件)的結構一樣）
  // [['屬性', {value}], ['屬性', {value}], ['屬性', {value}]]

```js
const question = new Map([
  ['question', 'What is the best programming language in the world?'],
  [1, 'C'],
  [2, 'Java'],
  [3, 'JavaScript'],
  ['correct', 3],
  [true, 'Correct 🎉'],
  [false, 'Try again!'],
]);

// 用於問答
console.log(question.get('question'));
// What is the best programming language in the world?
for (const [key, value] of question) {
  if (typeof key === 'number') console.log(`Anwser ${key}: ${value}`);
}

// Anwser 1: C
// Anwser 2: Java
// Anwser 3: JavaScript

const answer = Number(prompt('Your Anwser'));
console.log(answer);
// 問答用布林判斷
question.get(question.get('correct') === answer);
```

## 如何決定資料結構

### 考量資料來源

1. 程式本身 2. UI 互動介面 3. API(JSON 格式{a, b:[{},{}...], c})

### 資料結構

1. list (可用陣列或 set)
2. key value pairs (可用 obj 或 map)
   也有 weekset 跟 weekmap

### 何時適合 Set 而不是陣列呢

- 需要 list 裡面都是唯一值(不能有重複值)
- 不需要索引取值
- 不需要對資料做操作
- 需要高效能查找

### 何時適合 Map 而不是物件呢

- 需要對資料頻繁操作，保持高效能
- 當資料插入順序是需要考慮的因素
- 需要使用不同資料型態的 key（不限於 string 和 symbol 作為 key)
- 方便迭代跟計算大小 size
- 比較少需要單獨對部分資料做操作(物件比較方便用.跟[]取值)
