---
title: 初學React的你需要知道的一些知識｜bacnotes備份筆記
description: 這是一篇自學React的分享，React算是三大框架中工作數量最高的，為什麼大家都愛用React開發？身為前端工程師的你就算不會寫React，看完這篇後也可以裝逼跟大大們聊上幾句。
date: 2022-01-06T00:00:00+08:00
slug: react-knowledge-101
image: photo-1633356122544-f134324a6cee.jpeg
tags:
  - react
---

本文是基於下方這堂 Udemy 課程的整理，歡迎大家去親自體驗看看。
[React - The Complete Guide (incl Hooks, React Router, Redux)](https://www.udemy.com/course/react-the-complete-guide-incl-redux/"React - The Complete Guide (incl Hooks, React Router, Redux")

讓我們娓娓道來 React 的各種知識吧！

## 1. 什麼是 React？

```jsx
A JavaScript library for building user interfaces.
一套用來打造使用者介面的JavaScript函式庫
```

- React 是客戶端 based(非伺服器端運作)，在瀏覽器操作 DOM 讓互動性變高
- 使用 SPA 減少跟伺服器的溝通，使用上就跟手機的原生 APP 一樣順暢，所以名字才叫 React
- 技術上來說(e.g.跟 Augular 相比)React 不算是一個完整的框架

＊什麼是 SPA（Single-page application）

- 單頁應用，伺服器傳送一次 HTML，就接管整個頁面的生命週期
- 可以透過 API(e.g. XMLHttpRequest 或 Fetch)更新部分畫面(元件)或整個頁面
- Angular、React、Vue 都是熱門的 SPA

## 2. 為什麼用 React

### 對開發者好處

- 使用 Declarative programming 宣告式程式設計  
  描述目標而非流程，比起過往 DOM 操作要一個個選元素，一個口令一個動作的命令式程式設計 imperative programming，可以讓撰寫的程式碼精簡不少
- 以元件為中心  
  把視覺呈現、資料等元素放在單一檔案中，複用性高，可以減少重複代碼
- JSX 語法  
  JSX 幫助我們同時寫 HTML 跟 JS 邏輯，資料跟事件的綁定可以直接寫在 HTML 上，很方便，像是在 HTML 上實作 JS 邏輯，且容易閱讀
- 關注點分離  
  每一模組各自有獨立關注焦點，有助於後續協作跟維護
- 資料驅動畫面  
  用 useState+雙向綁定 HTML 元素，資料有變動畫面就會變動
  不用再寫一個渲染指令請程式更新畫面

### 對使用者好處

- 不需要在換頁時跟伺服器要資料(減少等待重新渲染的時間)，使用者體驗佳

## 3. React.js v.s. Angular v.s. Vue

- 都是以元件為中心，資料驅動畫面
- React：內建 framework 較少，建議使用 JSX 語法但也可以用 JavaScript 撰寫，不想跟用 Vue 一樣記太多額外的語法，適合直接來 React
- Angular：用 TypeScript 撰寫，有很多內建的 framework，不太需要社群資源，比較複雜
- Vue：內建 framework 比 React 多，比 Angular 少，有很多語法糖，適合初學者建立框架與生命週期觀念

## 4. React 建立專案 CRA(create-creact-app)

- 相對傳統撰寫網頁的方式，只要建立 HTML、CSS、JavaScript 三個檔案
- React 專案建立相較複雜一點，使用 CRA 指令前要先安裝 node.js(JavaScript 執行環境)才能使用 npm/npx 等指令下載相關模組(記得下載時網路要順暢)

```jsx
// cd到專案資料夾 專案名以new-app為範例
npx create-creact-app new-app
cd new-app
npm start
// 可以在localhost 3000看到
```

- CRA 內建 Babel 和 Webpack 幫你把 JSX 轉成瀏覽器可以解析的 HTML、CSS、JavaScript

## 5. VSCode 安裝 Prettier

### format document 選擇 prettier

- 若同時會使用 Vue 或 Javascript 開發不同專案，建議 VSCode 設定檔 by 框架/語言設定格式化的預設套件及 formatOnSave 選項

```js
{
  // JavaScript
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  // vue
  "[vue]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  // react JSX
  "[javascriptreact]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
}
```

參考文章：[VSCode does not format JSX Correctly](https://pretagteam.com/question/vscode-does-not-format-jsx-correctly 'VSCode does not format JSX Correctly')

### 啟用 emmet snippet 縮寫

- 開始使用 rcc 或 rfc 來幫助你加速開發吧

```js
{
  "emmet.includeLanguages": {
    "javascript": "javascriptreact"
  },
}
```

參考文章：[Enable Emmet support for JSX in Visual Studio Code | React](https://eshwaren.medium.com/enable-emmet-support-for-jsx-in-visual-studio-code-react-f1f5dfe8809c 'Enable Emmet support for JSX in Visual Studio Code | React')

## 6. 開發專案前環境整理

- 如果只是要簡單開發一個 React 程式，必要的檔案有 App.js、index.css、index.js
- 移除不需要的 import

```jsx
// App.js
function App() {
  return <div>Hello</div>;
}
export default App;
```

- npm run start 觀看即時 Hot Reload 畫面

## 7. 了解 React 運作方式跟元件

- 在 2020 React17 更新後不用在每個客製化元件最上方 import react

```jsx
import React from 'react';
```

- 因為 Babel 遇到 JSX 就會幫我們處理

```jsx
// Inserted by a compiler (don't import it yourself!)
import { jsx as _jsx } from 'react/jsx-runtime';

function App() {
  return _jsx('h1', { children: 'Hello world' });
}
```

參考文章：[Introducing the New JSX Transform](https://zh-hant.reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html 'Introducing the New JSX Transform')

- 只有 index.js 這邊的 import 不能拿掉，compile 會失敗

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
```

- SPA 是針對 server 回傳的單頁 HTML 做變動，也就是`<body>` 中 id='root'區塊

- `<App />`是一個 JavaScript function 回傳 JSX code，我們不會在瀏覽器 element 區塊看到`<App />`裡面的 JSX 內容(因瀏覽器不懂 JSX 的內容) 而是會 render 出 Babel 轉譯`<App />`後的內容

```jsx
ReactDom.render(<App />, document.getElementById('root'));
```

## 8. 元件添加 CSS 樣式使用 className 而非 class

```jsx
function APP() {
  return (
    <div>
      <h1 className='card'>Hello</h1>
    </div>
  );
}
export default App;
```

## 9. 引用元件方法(增加複用性)

- 下方是一個元件範例，一般會放在 src/components 下，檔案命名建議大寫開頭

```jsx
// 客製化元件大寫命名，跟內建HTML元素做區隔
function Todo() {
  return (
    <div className='card'>
      <h2>Title</h2>
      <div className='actions'>
        <span>A span</span>
        <button className='btn'>Delete</button>
      </div>
    </div>
  );
}
export default Todo;
```

- 引用元件到 App.js 要先 import

```jsx
// App.js
import Todo from './components/Todo';
function APP() {
  return (
    <div>
      <h1 className='card'>Hello</h1>
      <Todo />
      <Todo />
    </div>
  );
}
export default App;
```

## 9. 父層透過 props 傳資料到子層元件

- {}放入表達式 ，用同樣邏輯渲染出動態資料

```jsx
// App.js
// 資料傳入子層
import Todo from './components/Todo'
function APP () {
  return (
    <div>
       <h1 className='card'>Hello</h1>
       <Todo text='Learn React'/>
       <Todo text='Master React'/>
    </div>
  )
}

export default App

// 元件 Todo.js
// 利用props收到的動態資料，渲染出2項Todo
function Todo(props) {
  return (
  <div className='card'>
    <h2>{props.text}</h2>
    <div className='actions'>
      <span>A span</span>
      <button className='btn'>Delete</button>
    </div>
  </div>
  )
}
export default Todo;
```

## 10. 設置與監聽事件

- 需理解 React 裡面的 JSX 不等於 HTML，所以不能用 HTML inline JavaScript
- 事件的值應該是一個表達式所以用 `onClick={}`
- 可以寫成匿名函式 `onClick={function(){}}`或箭頭函式 `onClick={()⇒{}}`
- 但建議指向另一個 function，寫在上方 return 外層，保持 HTML 精簡
- 且可用同樣邏輯觸發，但有不同輸出

```jsx
// 元件 Todo.js 下方是一個 delete 事件
function Todo(props) {
  // 命名通常是xxxHandler
  function openModalHandler() {
    console.log('click', props.text);
  }
  return (
    <div className='card'>
      <h2>{props.text}</h2>
      <div className='actions'>
        <span>A span</span> // openModalHandler這邊不會加上執行() 等觸發才執行
        <button onClick={openModalHandler} className='btn'>
          Delete
        </button>
      </div>
    </div>
  );
}
export default Todo;
```

## 11. 引入多個元件

- 以提示窗為例，需要一個 backdrop 覆蓋 modal 後面的背景

```jsx
function Backdrop(props) {
  return <div className='backdrop' />;
}
```

- 跟一個 modal

```jsx
function Modal(props) {
  return (
    <div>
      <p>Are you sure?</p>
      <button className='btn btn--alt'>Cancel</button>
      <button className='btn'>Delete</button>
    </div>
  );
}

export default Modal;
```

- 兩個都引入到 App

```jsx
// App.js
import Todo from './components/Todo';
import Modal from './components/Modal';
import Backdrop from './components/Backdrop';
function APP() {
  return (
    <div>
      <h1 className='card'>Hello</h1>
      <Todo text='Learn React' />
      <Todo text='Master React' />
      <Modal />
      <Backdrop />
    </div>
  );
}

export default App;
```

- 元件要好維護，元件本身的程式碼就不能太多

## 12. useState(hook)讓網頁紀錄狀態，跟使用者互動

### 同層元件監聽與觸發事件：開啟 modal

- `import { useState } from ‘react’`
- useState 是一個 function，因為是第三方函式庫不用路徑
- 我們註冊不同的 state，React 會改變狀態，render 不同東西
- useState 要在元件 function 第一層，不能巢狀到
- useState 會回傳陣列，內有 2 個元素，可以定義初始值參數
- 更改值會需要呼叫第二個參數更新初始值(以下方範例來說是 setModalIsOpen)

**我們不會直接 re-assign 一個 modalIsOpen 的值**

- 呼叫的時候 React 會重新執行 state 所屬的元件，並重新更新資料跟畫面
- 我們會用 setModalIsOpen 來更新值，modalIsOpen 條件渲染 JSX 的程式碼

```jsx
// Todo.js 元件
import Modal from './components/Modal';
import Backdrop from './components/Backdrop';

function Todo(props) {
  const [modalIsOpen, setModalIsOpen] = userState(false);
  function deleteHandler() {
    setModalIsOpen(true);
  }

  return (
    <div>
      <h1 className='card'>Hello</h1>
      <Todo text='Learn React' />
      <Todo text='Master React' />
      {modalIsOpen && <Modal />}
      {modalIsOpen && <Backdrop />}
    </div>
  );
}
```

### 父層監聽子層觸發事件：關閉 modal

- 子元件觸發事件，方法寫在父層
- onClick 監聽是觸發同層 function，裡面包裹 props 傳下來的父層方法 expression value(Passing Function As Props)
- 範例為點 Cancel 跟 Delete 按鈕會關閉 modal

```jsx
// Todo.js 元件
import Modal from './components/Modal';
import Backdrop from './components/Backdrop';

function Todo(props) {
  const [modalIsOpen, setModalIsOpen] = userState(false);
  function openModalHandler() {
    setModalIsOpen(true);
  }
  function closeModalHandler() {
    setModalIsOpen(false);
  }

  return (
    <div className='card'>
      <h2>{props.text}</h2>
      <div className='actions'>
        <button onClick={openModalHandler} className='btn'>
          Delete
        </button>
        {modalIsOpen && (
          <Modal onCancel={closeModalHandler} onConfirm={openModalHandler} />
        )}
        // 透過props傳下去key value 讓子層觸發執行
        {modalIsOpen && <Backdrop onCancel={closeModalHandler} />}
      </div>
    </div>
  );
}

// Modal.js
function Modal(props) {
  function cancelHandler() {
    // 執行onCancel 父層方法
    props.onCancel();
  }
  function confirmHandler() {
    props.onConfirm();
  }
  return (
    <div>
      <p>Are you sure?</p>
      <button onClick={cancelHandler} className='btn btn--alt'>
        Cancel
      </button>
      <button onClick={confirmHandler} className='btn'>
        Delete
      </button>
    </div>
  );
}

export default Modal;
```

＊onCancel 是離開一個 dialog 元素會觸發的事件(e.g. 點遮罩或右上角 x，或取消按鈕)  
＊onConfirm 是點確認

## 13. 加上路由

- 需要安裝套件（不包含在 CRA)

```jsx
npm install --save react-router-dom@5
```

- 建議加上 src/pages 資料夾，比較好找到對應元件

```jsx
// 建立這三個檔案在pages裡面
AllMeetups.js
命名Page幫助我們知道這個元件是一個頁面
function AllMetupsPage(){
  return (
    <div>AllMetupsPage</div>
  )
}
export default AllMeetupsPage

Favorites.js NewMeetup.js 同上邏輯 改div內容跟function名字跟export名即可
```

- 我們使用 BrowserRouter 套件去定義哪些頁面何時要 load

```jsx
// index.js
import { BrowserRouter } from 'react-router-dom';
// 初始化套件 確保他有在觀察url
RouterDOM.render(
  <BrowserRouter>
    <APP />
  </BrowserRouter>
);
```

- 搭配使用 Switch 渲染第一個符合路徑的元件

```jsx
// App.js
import { Route } from 'react-router-dom';
import AllMeetupsPage from './pages/AllMeetups';
import NewMeetupsPage from './pages/NewMeetups';
import FavoritesPage from './pages/Favorites';

function App() {
  return (
    <div>
      <Switch>
        // 避免/巢狀重複出現多個頁面內容 也可以直接exact
        <Route path='/' exact={true}>
          <AllMeetupsPage />
        </Route>
        <Route path='/newmeetup'>
          <NewMeetupsPage />
        </Route>
        <Route path='/favorites'>
          <FavoritesPage />
        </Route>
      </Switch>
    </div>
  );
}
export default App;
```

## 14. 設置 Navbar 來練習 Link

- Navbar 一般會設置在 src 下方資料夾 layout，因為 nav 是整體佈局的元件
- `a href`屬性可以用，但我們不想用伺服器傳 HTML，失去 SPA 優勢
- import link 元件，會搭配`to`屬性加入路徑使用
- `<Link>`tag 自動在 DOM 加入監聽，阻擋瀏覽器預設行為送出請求
- 且只會解析 url，修改網址列跟 load 相對應的元件(React/JavaScript)

```jsx
// MainNavigation.js

import { Link } from 'react-router-dom'
function MainNavigation() {
  return (
  <header>
    <div> React Meetups</div>
    <nav>
      <ul>
         <li>
           <Link to='/'>All Meetups</Link>
         </li>
         <li>
           <Link to='/newMeetup'>Add New Meetups</Link>
         </li>
         <li>
           <Link to='/favorites'>My favorites</Link>
         </li>
      <ul>
    </nav>
  </header>
  )
}
export default MainNavigation
```

- Navbar 引入 App.js

```jsx
// App.js
import { Route } from 'react-router-dom';
import AllMeetupsPage from './pages/AllMeetups';
import NewMeetupsPage from './pages/NewMeetups';
import FavoritesPage from './pages/Favorites';
import MainNavigation from './components/layout/MainNavigation';

function App() {
  return (
    <div>
      <MainNavigation />
      <Switch>
        <Route path='/' exact={true}>
          <AllMeetupsPage />
        </Route>
        <Route path='/newmeetup'>
          <NewMeetupsPage />
        </Route>
        <Route path='/favorites'>
          <FavoritesPage />
        </Route>
      </Switch>
    </div>
  );
}
export default App;
```

## 15. CSS modules 來為元件加上樣式

- CRA 本身有內建 CSS modules
- 需要在檔名使用 module.css
- 引入名稱自訂(e.g. classes)

```jsx
// MainNavigation.js
// classes會變成一個物件
import classes from './MainNavigation.module.css'

import { Link } from 'react-router-dom'
function MainNavigation() {
  return (
   //module.css裡面的css樣式會變成key value pair
  <header className={classes.header}>
    <div className={classes.logo}> React Meetups</div>
    <nav>
      <ul>
         <li>
           <Link to='/'>All Meetups</Link>
         </li>
         <li>
           <Link to='/newMeetup'>Add New Meetups</Link>
         </li>
         <li>
           <Link to='/favorites'>My favorites</Link>
         </li>
      <ul>
    </nav>
  </header>
  )
}
export default App

```

## 16. 使用 dummyData map 迴圈渲染資料

### React 能渲染出 JSX 元素裡的陣列

- JSX expression`{[<li>item1</li>, <li>item2</li>]}`
- 或用 map 方法把元素 return 出來

```jsx
// pages/AllMeetup.js
const DUMMY_DATA = [
  {
    id: 'm1',
    title: 'This is a first meetup',
    image:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Stadtbild_M%C3%BCnchen.jpg/2560px-Stadtbild_M%C3%BCnchen.jpg',
    address: 'Meetupstreet 5, 12345 Meetup City',
    description:
      'This is a first, amazing meetup which you definitely should not miss. It will be a lot of fun!',
  },
  {
    id: 'm2',
    title: 'This is a second meetup',
    image:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Stadtbild_M%C3%BCnchen.jpg/2560px-Stadtbild_M%C3%BCnchen.jpg',
    address: 'Meetupstreet 5, 12345 Meetup City',
    description:
      'This is a first, amazing meetup which you definitely should not miss. It will be a lot of fun!',
  },
];

function AllMeetupsPage() {
  return (
    <section>
      <h1>AllMeetupsPage</h1>

      {DUMMY_DATA.map((el) => {
        return <li key={el.id}>{el.title}</li>;
      })}
    </section>
  );
}
export default AllMeetupsPage;
```

### 迴圈的元素設置 唯一值的 key

- 傳統演算法比對兩個節點差異時間複雜度 O 的 3 次方
- 為了渲染的效能，React 使用 heuristic 演算法比較內容變動的元素，但也可能因為沒有比對好(部分演算法假設跟現實不符)造成渲染出錯誤的元素
- 透過設置 key 告訴 React 你改動的元素，而非讓 React 自己比較元素內容差異
- 避免使用 index(元素完全位移), Math.random(key 值非固定)等方式來建立 key

（持續更新中）

＊這篇是大方向的介紹，後續還會寫其他 React 學習的筆記

最後想補充一下...  
其實我覺得 Vue 也不錯啊（x)

有好吃的語法糖：用@監聽事件，：動態 class，watch 深層監聽物件屬性，computed 動態更新，v-model 雙向綁定表單...各種好吃的糖)

<img src="./smile.jpeg" alt="smile-meme" width="350px">

原來暗藏一篇 Vue 推銷文，真是太邪惡了
