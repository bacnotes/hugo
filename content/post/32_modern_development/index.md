---
title: 現代JavaScript開發工具｜bacnotes備份筆記
description: 介紹npm modules跟ES6 模組
date: 2022-05-01T00:00:00+08:00
slug: modern-javascript-development
image: tools.jpg
tags:
  - JavaScript
---

現代開發常常會引用到第三方函式庫，像是 Node.js 社群上的 npm 公開套件(React/jQuery/Leaflat)，因此懂得透過 npm 管理專案內的模組/函式庫就變的很重要

## npm 套件管理

- npm -v 確認安裝版本，若沒有到 node 官網下載 LTS 版本
- 安裝 node 會一起安裝 npm，透過 npm init 在一個專案資料夾啟用套件管理，所有套件透過 npm 命令安裝
- npm 在 package.json 控管在 repo 裡面的模組，package.json 內容會是你專案引用的套件的設定，而實際上安裝了哪一個版本的套件則是於 package.lock.json 中紀錄
- npm install 時，npm 會依照 package.lock.json 內容整理 node_modules 的內容，透過這個機制確保每個開發者取得同一份原始碼時能將 node_modules 的內容調整為一致的狀態
- npm 裡面的模組/函式庫，使用 common JS 模組系統，所以不能直接 import 到 code 裡面，會需要用 module bundler

## 打包成 JavaScript bundles

- 模組會透過一個 build process 打包成 JavaScript bundles，只打包有被引用的模組，壓縮檔案大小
- 舊版瀏覽器不支援模組(模組裡面的程式碼不會執行)，透過打包讓瀏覽器可以直接使用必要的 JavaScript
- Babel 套件做 Transpiling/polyfilling 讓 ES6 語法可以變成舊版瀏覽器讀的懂的 ES5 語法，也就是我們丟到 prod 上面的最終檔案
- 目前 webpack 跟 parcel 都是不錯的解決方案，webpack 目前人氣最高但有許多需要手動設定的地方，parcel 是 0-configuration，很容易上手

## 模組

- 類似 class 概念，是一段可重複使用的封裝程式碼(裡面包著執行細節)
- 通常是一個獨立的檔案，可以輸入其他模組，被輸入的模組就是 dependency(沒有這段就無法執行)，可以輸出給其他程式使用，作為 public api
- 在做大型 application 的時候，作為積木可以快速搭建產品
- 抽象化的程式碼，可以不用知道內部細節，但可以快速使用別人做好的方法
- 更好整理更好讀

```js
import { rand } from './math.js'
const diceP1 = rand(1, 6, 2)
const diceP2 = rand(1, 6, 2)
const scores = { diceP1, diceP2 }
export { scores }
```

## ES6 模組

- ES6 以前沒有內建模組，後來有了模組，一個模組一個檔案
- 跟 script 差異
  | item | script | module |
  | ---- | ---- | ---- |
  | top-level var | global | private |
  | default mode | sloppy mode | strict mode |
  | top-level this | window | undefined |
  | imports and exports | no | ok |
  | HTML linking | `<script>` | `<script type="module">` |
  | file downloading | 同步 | 非同步 |
- all imports 是 hoisted，無論在程式碼裡面的先後順序，會把 import 放在檔案最上面

```js
import { rand } from '.math.js'
import { showDice } from '.dom.js'
const dice = rand(1, 6, 2)
showDice(dice)
```

- 會先解析 index.js(read)知道要引入哪些 js（import hoisted)
- 同步引入下載各個 js，也就是沒有引入完成就不會執行，讓打包 bundles 跟刪除沒被使用的 code 變得可能
- 非同步下載 js 檔案後，連結 js 輸出對應的 import 的檔案，做 pointer 指向（單純做 ref)，實現引用內容改變時，對應引入的檔案也會一起連動改變
- import 的內容不是 copy 資料，若對陣列或物件原始資料有不可逆修改(e.g. push 資料到空陣列)，也會修改到原本的資料，使用同一個記憶體
- JavaScript 模組系統的機制跟其他模組系統不一定相同

## import & export

- 如果是在 html 上面引用，script 外面寫上 type="module"
- export 需要寫在最外層(top level)才會有作用，不能嵌套在 if 等其他程式碼

### name export

```js
// exporting module
console.log('exporting module')

// all top var is private, unlike script
const shippingCost = 10
export const cart = []

// add export即可輸出
export const addToCart = function (product, quantity) {
  cart.push({ product, quantity })
  console.log(`${quantity} ${product} add to cart`)
}

// 類似輸出物件的概念
const totalPrice = 238
const totalCount = 34
export { totalPrice, totalCount as count }
```

- 引入到其他檔案，需要對應之前輸出的名字
- 可以透過 as 在 export 或是 import 修改名稱

```js
import { addToCart, totalPrice as price, count, cart } from './shoppingCart.js'

console.log('import module')

addToCart('bread', 5)
// 5 bread added to cart
console.log(price, count) // 238 34
console.log(cart) // [{...}]
```

- 一次引入所有變數，變成一個物件，使用時像調用一個 api

```js
import * as ShoppingCart from './shoppingCart'

shoppingCart.addToCart('bread', 5)
```

### default export

- 只希望模組輸出一個值可以用 export default，不用命名直接輸出值
- 且可以用任意的名字輸出（import 的變數名任意)

```js
export default function (product, quantity) {
  cart.push({ product, quantity })
  console.log(`${quantity} ${product} add to cart`)
}
```

```js
import add from './shoppingCart.js'
add('pizza', 2)
```

## top-level await(ES2022)

- 在程式碼最外層使用 await，可以等待執行完畢再往下
- 模組可使用，script 無法

```html
<!-- html -->
<script type="module" defer src="script.js"></script>
```

```js
// script.js
console.log('start')
const res = await fetch('https://jsonplaceholder.typicode.com/posts')
const data = await res.json()
console.log(data)
console.log('something')

// start
// [{...}, {...} ]
// something
```

- 更真實一點的 fetch 例

```js
// script.js
const getLastData = async function () {
  const res = await fetch('https://jsonplaceholder.typicode.com/posts')
  const data = await res.json()
  console.log(data)

  return {
    title: data.at(-1).title,
    text: data.at(-1).body,
  }
}

const lastPost = getLastData()
// 不會是我們要的資料，因為還在處理中，會得到一個Promise
console.log(lastPost)

const lastPost2 = await getLastData()
// 會得到期望的資料
console.log(lastPost2)
```

- 如果一個模組引入另一個帶有 top-level await 的模組，會等待被引入模組的 top-level await

```js
// shoppingCart.js(被script.js引入)

console.log('start fetching')
await fetch('https://jsonplaceholder.typicode.com/posts')
console.log('finish fetching')

// script.js

console.log('import module')

// start fetching
// finish fetching
// import module
```

## module pattern

- module 目的是把功能封裝成 private data 跟 expose a public api，
- 在 ES6 出現前，會利用 IIFE 只會執行一次且 scope 獨立的特性來做到類似的效果
- 但如果要一個檔案一個 module，就必須要寫很多 script 引入到 HTML 上面，且需要注意引入順序，跟全域變數污染問題

```js
const ShoppingCart2 = (function(){
  const cart = []
	const shippingCost = 10
	const totalPrice = 238
	const totalCount = 23
	const addToCart = function(product, quantity) {
		cart.push({product, quantity})
		console.log(`${quantity} ${product} added to cart`)
	}

	const orderStock = function (product, quality) {
		console.log(`${quantity} ${product} ordered from supplier`)
	}
	return {
		addToCart,
		cart,
		totalPrice
		totalCount
	}
})()

ShoppingCart2.addToCart('apple', 4)
console.log(ShoppingCart2)
// 可以看到資料跟方法

console.log(ShoppingCart.shippingCost)
// undefined 無法獲取內部資料
```

## 其他的模組系統：AMD modules / Common JS modules

- 不是 native javascript
- 在 ES6 模組出現前，npm 上的模組是用 common js，目前也都還是很常用
- export.方法在 node 可以使用，瀏覽器不行

```js
// export
export.addTocart = function (product, quantity) {
  cart.push({ product, quantity })
  console.log(`${quantity} ${product} add to cart`)
}

// import
const { addToCart } = require('./shoppingCart.js')
```

### lodash

- lodash 有許多 array/objects/function/dates 的 JavaScript 方法
- npm i lodash(是 common JS 不能用 import export)
- npm i lodash-es(下載 ES6 版本)

```js
// add "type": "module" in your "package.json" file if error
// 這只是一個展示deep clone 的 sample 平常不會這樣做
import cloneDeep from './node_modules/lodash-es/cloneDeep.js'

const state = {
  cart: [
    {
      product: 'bread',
      quantity: 5,
    },
    {
      product: 'pizza',
      quantity: 3,
    },
  ],
  user: {
    loggedIn: true,
  },
}

// methods1: 用Object.assign淺拷貝
const stateClone = Object.assign({}, state)
console.log(stateClone)

stateClone.user.loggedIn = false // 淺拷貝會修改到非第一層的原始資料
console.log(state.user.loggedIn) // false

stateClone.newProperty = 1 // 第一層新增屬性，舊資料不會被修改到

console.log(stateClone)
// {
//     "cart": [
//         {
//             "product": "bread",
//             "quantity": 5
//         },
//         {
//             "product": "pizza",
//             "quantity": 3
//         }
//     ],
//     "user": {
//         "loggedIn": false
//     },
//     "newProperty": 1
// }

console.log(state)

// {
//     "cart": [
//         {
//             "product": "bread",
//             "quantity": 5
//         },
//         {
//             "product": "pizza",
//             "quantity": 3
//         }
//     ],
//     "user": {
//         "loggedIn": false
//     }
// }

// methods2: 用lodash的cloneDeep方法
const stateDeepClone = cloneDeep(state)
stateDeepClone.user.loggedIn = false
console.log(stateDeepClone.user.loggedIn) // false
console.log(stateDeepClone.user.loggedIn) // true 沒有動到原始資料
```

## parcel

### 安裝

- 使用前記得把 `<script>` 後面的 `type="module"` 拿掉
- npm i parcel --save-dev（local 安裝)，開發用的工具，放 dev-dependency
- 不是會放在專案本身裡面的 code，在開發或測試的時候需要的套件
- npm i parcel -g (為了每次都能抓取最新版本，不需要全域安裝)
- npm i parcel@指定版本
- sudo npm i parcel@指定版本 權限問題

### 使用方式

- npx parcel index.html (entry point: script.js 的入口)
- 或是在 package.json 裡面的 scripts 寫`"start": "parcel index.html"` 之後用`npm start`
- 部署版本：scripts 寫`build": "parcel build index.html"` 之後用`npm build` 產出壓縮版本的打包檔
- parcel 會把相關的檔案打包在 dist 裡面，可以透過 live server 觀看編譯後的結果
- 用 parcel 打包可以不用寫檔案路徑，直接引用模組名稱
- parcel 兼容 common js 模組，寫`import cloneDeep from 'lodash'`也可以

```js
// 直接引用名稱
import cloneDeep from 'lodash-es'

// 可以maintain state
if (module.hot) {
  module.hot.accept()
}
```

## Babel

- 舊版瀏覽器使用 ES5 語法，parcel 預設使用 Babel 編譯
- Babel 使用 plugin 去 transpile 特定 JavaScript feature(e.g. 箭頭函式)

### preset

- preset 是一包 plugin(preset-env, preset-flow, preset-react, preset-typescript)，依照瀏覽器支援的狀況提供不同的包，不用一個個 plugin 安裝(箭頭函式安裝一個，var const let 安裝一個)

### transpile

- 單純語法糖(let、const、箭頭函式等)
- Transpilation is at compile time, while pollyfill is at runtime, and this is what differentiates one from the other

### polyfill

- 透過 native browser APIs or other environment APIs 模仿實作不支援的方法(Promise、Array.find)
- 需要從 polyfill 函式庫引用對應的模組進來，用 `--save `安裝，只有打包前時編譯會需要，並透過`import 'core-js/stable'`引入
- Parcel 會自動安裝 npm i core-js，若沒有可以手動

### polyfill async function

- `npm i regenerator-runtime`
- `import 'regenerator-runtime/runtime'`

## modern and clean code

### readable

- others can understand it
- you can understand it in 1 year
- avoid too clever and overcomplicated solutions
- use descriptive variable names: what they contain
- use descriptive function names: what they do

### general

- use Dry principle (refactor your code)
- don't pollute global namespace, encapsulate instead
- don't use var
- use === !==

### functions

- 1 function do 1 thing
- don't use more than 3 function parameters
- use default parameters whenever possible
- return same data type as received

### OOP

- use ES6 classes
- encapsulate data and don't mutate it from outside the class
- implement method chaining
- do not use arrow functions as methods in regular objects

### avoid nested code

- use early return(guard clauses)
- use ternary or logical operators instead of if
- use multiple if instead of if / else-if
- avoid for loops, use array methods instead
- avoid callback-based async APIs

### async code

- use async / await for best readability
- whenever possible, run promises in parallel(Promise.all)
- handle errors and promise rejections

以上為[The Complete JavaScript Course - From Zero to Expert](https://www.udemy.com/course/the-complete-javascript-course/ 'The Complete JavaScript Course - From Zero to Expert')的小筆記，附上連結推推這堂課

## 補充: 使用 nvm 管控 Node.js 版本

- 當專案需要使用到不同版本的 Node.js，透過 nvm 安裝 Node.js，可以很方便切換使用

### 安裝 nvm

- 選項 A : brew install nvm
- 選項 B : 使用 curl 下載
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

- 透過確認版本號看安裝是否完成

```js
nvm --version
```

- 配置環境變量

```js
export NVM_DIR="$HOME/.nvm"

#This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

#This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
```

### 安裝 Node.js

Mac M1 為 ARM64 架構，Node.js v16 以上才支援 ARM64 ，因此建議安裝 v16

```js
nvm install v16
nvm use v16
```

### 常用指令

- 安裝: nvm install [version]
- 移除: nvm uninstall [version]
- 列出本地 Node.js 版本: nvm ls
- 列出遠端所有版本: nvm ls-remote
- 設定預設啟用的 Node.js 版本: nvm alias default [version]
- 使用的 Node.js 版本: nvm use [version]

### 查詢第三方函式庫是否支援 Mac M1 晶片

- [Does It ARM?](https://doesitarm.com/app/nodejs/)
- 查詢 Node.js ✅ Yes, Full Native Apple Silicon Support as of v16

參考資料：
https://blog.logrocket.com/how-to-set-up-m1-macbook-web-development/
