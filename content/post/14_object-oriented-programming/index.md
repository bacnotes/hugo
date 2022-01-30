---
title: 今晚，我們來聊點物件導向程式設計(Object-Oriented Programming) ｜The Complete JavaScript Course｜bacnotes備份筆記
description: 程式語言通常分成兩種設計方式，一種是物件導向程式設計OOP，把物件的屬性跟方法「封裝」在物件中管理，使程式碼更容易理解。一種是函式程式設計FP(Functional Programming)，把每個函式做的事情「最小化」，一次只做一件事。兩者的存在都是為了讓程式更易讀更好用。而這篇會講解的是物件導向程式設計。
date: 2022-01-14T00:00:00+08:00
slug: object-oriented-programming
image: pexels-jéshoots-271458.jpg
tags:
  - JavaScript
---

產出好維護好管理的程式碼是重要的，想像今天你的任務是要從這個房間裡找出某一本書，你覺得你需要多少時間？

<img src="./15772480102360.jpeg" width="500" alt="room">

如果專案程式碼長這樣的話，還沒開始 debug 腦袋就已經先當機了...

物件導向程式設計就是為了解決這個問題而誕生的一種方便管理程式碼的方式

## 什麼是物件導向程式設計(Object-Oriented Programming)

- 基於物件概念的程式設計方法
- 使用物件形容(model)具體或抽象的feature(e.g. user, todo-item, 元件或資料結構)
- 我們把相關屬性跟方法都包在一個物件，可以很方便取得內部資料
- 物件是獨立的(self-contained)的程式碼片段，透過彼此互動構築成一個應用程式
- 公開的 API 即是透過物件內方法跟應用程式互動

## Class 跟 Instance 實例是什麼？

- Class 是一個藍圖(非物件)，透過 Class 建構出來的東西是 instance 實例(即物件)
- 但 JavaScript 其實沒有真正的 Class 這個類別實例(Java，C++有)
- JavaScript 的 Class 比較像是語法糖，透過建構函式來模擬物件類別，可以調用原型(prototype-based)方法

## Prototype 原型是什麼？

- 在 JavaScript 物件都會連結到原型(Prototype)，原型繼承(Prototypal inheritance)表示所有被連結到的物件都可以使用原型的方法
- 舉例來說，我們在使用陣列的 map 方法，也是從陣列的 prototype 取用這個方法，而不是 num 本身有的方法()

```js
const num = [1, 2, 3];
console.log(num.map((el) => el + 2)); //[ 3, 4, 5 ]
```

## 原型 v.s. 建構函式 v.s. 實例

- 原型.constructor === 建構函式
- 建構函式.prototype === 原型
- 實例.**proto** === 原型

## 物件導向程式語言四大原則

### 抽象化

- 實作細節隱藏起來的機制

### 封裝

- 把屬性跟方法封裝在 class 不讓外部讀取修改，但 class 內部可以讀取
- 封裝好(讓屬性跟方法保持 private)可避免產生非預期 bug
- 當外在程式碼能夠更動到 class 內部資料，會連動影響到調用這個 class 的相關程式碼
- 需要公開存取 API 可設計成開放存取

### 繼承

- 當有兩個相似的 class，我們可以使用繼承特性避免撰寫重複程式碼(parent class → child class)

### 多型

- child class 可以覆寫 parent class 的方法

## 如何建立原型 prototypes

- 使用建構函式(Constructor functions)跟 new 運算子產生新的物件實例，JavaScript 的內建物件：陣列、Map、Set 就是使用建構函式
- ES6 的 class 方法語法糖
- Object.create（最簡單創造出一個物件連結 prototype 的方法)

### 使用建構函式跟 new 運算子

- 寫一個建構函式(上面前面提到的藍圖)，使用 new 運算子產生新的物件實例
- 物件實例的 this 指向這個實例本身{} (因為使用 new 運算子才有這個特性，跟一般函式不同)
- 實例會連結到建構函式，讓實例可以使用建構函式的方法(產生**proto**)
- 因此每個物件下會有.**proto**屬性
- 建構函式本身自帶 return

```js
console.log(jonas.__proto__); // jonas的原型{calcAge:f constructor:f}
console.log(jonas.__proto__ === Person.prototype); // 原型連結的物件 true
console.log(Person.prototype.isPrototypeOf(jonas)); // 原型連結的物件 true
```

```js
const Person = function (firstName, birthYear) {
  console.log(this); // Person {}
  // 設定物件屬性為外部傳進來的參數
  this.firstName = firstName;
  this.birthYear = birthYear;
};

// 創造一個firstName為Jonas birthYear為1991的Person物件
const jonas = new Person('Jonas', 1991);

console.log(jonas);
// Person { firstName: 'Jonas', birthYear: 1991 }

// 創造一個firstName為mirenda birthYear為2003的Person物件
const mirenda = new Person('mirenda', 2003);
console.log(mirenda);
// Person { firstName: 'mirenda', birthYear: 2003 }
```

- 檢查物件所屬實例方法 instanceof

```js
console.log(jonas instanceof Person);
// true
```

- 使用.prototype 新增原型共用方法

```js
const Person = function (firstName, birthYear) {
  console.log(this); // Person {}
  // 設定物件屬性為外部傳進來的參數
  this.firstName = firstName;
  this.birthYear = birthYear;
  // ＊never do this 直接把方法寫在物件中
  // this.calcAge = function () {
  //   console.log(2037 - birthYear);
  // };
};

Person.prototype.calcAge = function () {
  console.log(2037 - this.birthYear);
};

// 可以共用原型方法
jonas.calcAge(); // 46
mirenda.calcAge(); // 34

Person.prototype.species = 'Homo Sapiens';
console.log(jonas.species); // 可以取得共用屬性 Homo Sapiens
console.log(jonas); // Person { firstName: 'Jonas', birthYear: 1991 } 但不會出現在物件裡面，除非有寫入
```

- 檢查是否有屬性 hasOwnProperty

```js
console.log(jonas.hasOwnProperty('firstName')); // true
console.log(jonas.hasOwnProperty('species')); // false
```

### ES6 的 class 方法

### Object.create()

（最近忙著寫線上測試題會盡快回來更新Q Q）
