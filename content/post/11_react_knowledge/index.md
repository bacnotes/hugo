---
title: 自學React的你需要知道的一些知識｜bacnotes備份筆記
description: 這是一篇自學React的分享，React算是三大框架中工作數量最高的，為什麼大家都愛用React開發？JSX跟狀態(State)是什麼？為什麼我重新賦值畫面沒有更新？看完這篇筆記後幫助你更了解如何用React開發。
date: 2022-01-06T00:00:00+08:00
slug: react-knowledge-101
image: photo-1633356122544-f134324a6cee.jpeg
tags:
  - React
---

本文是基於下方這堂 Udemy 課程的筆記，對 React 有興趣的話可以購買看看唷  
[React - The Complete Guide (incl Hooks, React Router, Redux)](https://www.udemy.com/course/react-the-complete-guide-incl-redux/ 'React - The Complete Guide (incl Hooks, React Router, Redux')

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
  描述目標而非流程，比起過往 DOM 操作要一個個選元素，一個口令一個動作的指令式程式設計 imperative programming，可以讓撰寫的程式碼精簡不少
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

- 設定檔寫入

```js
{
  "emmet.includeLanguages": {
    "javascript": "javascriptreact"
  },
}
```

- 使用 rcc 或 rfc（趨勢) 來幫助你加速開發吧

```jsx
// rcc class component
import React, { Component } from 'react';

class 元件名 extends Component {
  render() {
    return (
      <div>

      </div>
    );
  }
}

export default 元件名;

// rfc function component
import React from 'react';

const 元件名 = () => {
  return (
    <div>

    </div>
  );
}

export default 元件名;
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

- 在 2020 React17 更新後不用在每個客製化元件最上方 `import React from 'react'`，Babel 遇到 JSX 就會幫我們處理，且跟過往的 JSX 程式碼相容

- 但記得 index.js entry point 這邊的 `import React from 'react'`不能拿掉

- 對於 JSX 轉換細節有興趣的人可以參考這篇文章[Introducing the New JSX Transform](https://zh-hant.reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html 'Introducing the New JSX Transform')

```jsx
// Inserted by a compiler (don't import it yourself!)
import { jsx as _jsx } from 'react/jsx-runtime';

function App() {
  return _jsx('h1', { children: 'Hello world' });
}
```

- SPA 是針對 server 回傳的單頁 HTML 做變動，也就是`<body>` 中 id='root'區塊

- 而 `<App />`是一個 JavaScript function 回傳 JSX code，我們不會在瀏覽器 element 區塊看到`<App />`裡面的 JSX 內容(因瀏覽器不懂 JSX 的內容) 而是會 render 出 Babel 轉譯`<App />`後的內容

```jsx
import React from 'react';
import ReactDOM from 'react-dom';
ReactDom.render(<App />, document.getElementById('root'));
```

## 8. 元件添加 CSS 樣式使用 className 而非 class
- 因為class是JavaScript的保留字，而JSX是JavaScript的延伸語法，所以不使用class
```jsx
function APP() {
  return (
    <div>
      <h1 className='container'>Hello</h1>
    </div>
  );
}
export default App;
```

## 9. 使用元件增加複用性

- 下方是一個元件範例，一般會放在 src/components 下，檔案命名建議大寫開頭
- 元件保持精簡，一個元件專心做一件事，降低耦合

```jsx
// 客製化元件大寫命名，跟內建HTML元素做區隔
function Todo() {
  return (
    <div className='container'>
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
      <h1 className='container'>Hello</h1>
      <Todo />
      <Todo />
    </div>
  );
}
export default App;
```

## 10. 父層透過 props 傳資料到子層元件

- `{}`放入表達式 ，用同樣邏輯渲染出不同的資料

```jsx
// App.js
// 資料傳入子層
import Todo from './components/Todo'
function APP () {
  return (
    <div>
       <h1 className='container'>Hello</h1>
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
  <div className='container'>
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

## 11. 設置與監聽事件

- 需理解 React 裡面的 JSX 不等於 HTML，所以不能用 HTML inline JavaScript
- 事件的值應該是一個表達式所以用 `onClick={}`
- 可以寫成匿名函式 `onClick={function(){}}`或箭頭函式 `onClick={()⇒{}}`
- 但建議指向另一個 function，保持 HTML 精簡(寫在 return 前的區塊)

```jsx
// 元件 Todo.js 下方是一個 delete 事件
function Todo(props) {
  // 命名通常是xxxHandler
  function openModalHandler() {
    console.log('click', props.text);
  }
  return (
    <div className='container'>
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

## 12. 引入多個元件

- 以提示窗為例，需要一個 `backdrop` 覆蓋 modal 後面的背景，跟一個 `modal`

```jsx
function Backdrop(props) {
  return <div className='backdrop' />;
}

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
      <h1 className='container'>Hello</h1>
      <Todo text='Learn React' />
      <Todo text='Master React' />
      <Modal />
      <Backdrop />
    </div>
  );
}

export default App;
```

## 13. useState 紀錄網頁 State，跟使用者互動
- useState是React一個Hook，Hook是一個內建function，useState是用來操作狀態的hook
- 我們註冊不同的 State，React 會在 State 改變時 render 不同東西
- const [state, setState] = useState(initialState setState(newState);
```jsx
// useState 是一個 function，因為是第三方函式庫不用寫路徑
import { useState } from ‘react’
function SomeFunction(){

// useState 會回傳陣列，內有 2 個元素，可以定義初始值參數
// useState 要放在元件 function 內第一層，不能巢狀到
const [variable, setVariable] = useState(initialValue)

return (
    <div>
      ...
    </div>
  );
}
export default SomeFunction
```
### 為什麼我重新賦值的變數畫面沒有更新？
**無法透過重新賦值 變數 的值來更新畫面**

- 更改值會需要呼叫陣列的第二個參數(一個callback function)更新初始值(以下方範例來說是 setModalIsOpen)
- 呼叫useState的時候 React 才會重新執行 State 所屬的元件，並重新更新資料跟畫面
＊不這麼做的話畫面是不會重新渲染的（也就是跑一次下方的return的JSX)。
- 我們會用 setModalIsOpen 來更新值，用 modalIsOpen 判斷條件渲染 JSX 的程式碼

＊Hook有很多種，官方文件有列出所有的Hook在這裡[Hook API](https://zh-hant.reactjs.org/docs/hooks-reference.html "Hook API")
- useEffect可以fetch 資料、訂閱、或操作 DOM
- useRef可以抓取Dom元素，獲取表單的value(但更新 current 值不會重新渲染畫面)    
- useContext可以管理全域狀態等，下方會繼續介紹    
### 同層元件監聽與觸發事件：以開啟 modal 為例

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
      <h1 className='container'>Hello</h1>
      <Todo text='Learn React' />
      <Todo text='Master React' />
      {modalIsOpen && <Modal />}
      {modalIsOpen && <Backdrop />}
    </div>
  );
}
```

### 父層監聽子層觸發事件：以關閉 modal 為例

- 子元件觸發事件，方法寫在父層
- onClick 監聽是觸發同層 function，裡面包裹 props 傳下來的父層方法(Passing Function As Props)
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
    <div className='container'>
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

## 14. 加上路由

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

## 15. 用導覽列來練習 Link

- 導覽列一般會設置在 src 下方資料夾 layout，因為是整體佈局的元件
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

- 導覽列 引入 App.js

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

## 16. CSS modules 來為元件加上樣式

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

## 17. 使用 map 迴圈渲染資料

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

- 傳統演算法比對兩個節點差異，時間複雜度為 O 的 3 次方
- 為了渲染的效能，React 使用 heuristic 演算法比較內容變動的元素，但也可能因為沒有比對好(部分演算法假設跟現實不符)造成渲染出錯誤的元素
- 透過設置 key 告訴 React 你改動的元素，而非讓 React 自己比較元素內容差異
- 避免使用 index(元素完全位移), Math.random(key 值非固定)等方式來建立 key

## 18. 客製化元件的其他使用方式，目的在於讓元件專注在一件事

### 元件作為容器 Wrapper/Container 使用
- 設定Container包裹children內容
```jsx
import classes from './Container.module.css';
// 引入props.children children是每個元件都可以獲取的預設屬性，值是tag包覆的內容
function Container(props) {
  return <div className={classes.container}>{props.children}</div>;
}

export default Container;
```
- div外用Container包裹

```jsx
import Container from '../ui/Container';
function MeetUpItem(props) {
  return (
    <Container>
      <div>some content</div>
    </Container>
  );
}
```

### 元件作為 Layout 使用(排版 body 內容)

- Layout 放導覽列跟語意化標籤 main 包裹其他內容
- 在 components/layout 資料夾製作一個 Layout.js

```jsx
import MainNavigation from './MainNavigation';
import classes from './Layout.module.css';

function Layout(props) {
  return (
    <div>
      <MainNavigation />
      <main className={classes.main}>{props.children}</main>
    </div>
  );
}
export default Layout;
```

- Layout 包裹路由內容

```jsx
// App.js
import { Route } from 'react-router-dom';
import AllMeetupsPage from './pages/AllMeetups';
import NewMeetupsPage from './pages/NewMeetups';
import FavoritesPage from './pages/Favorites';
// 拿掉之前的MainNavigation 換成Layout
import Layout from './components/layout/Layout';

function App() {
  return (
    <div>
      <Layout>
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
      </Layout>
    </div>
  );
}
export default App;
```

## 19. 加上表單

- Page 新增一頁 裡面放表單元件

```jsx
function NewMeetupPage() {
  return (
    <section>
      <h1>Add New Meetup</h1>
      <NewMeetupFrom>
    </section>
  );
}
export default NewMeetupPage;
```

- 新增表單元件
- for 屬性在React要寫成 htmlFor

```jsx
// NewMeetupForm.js
import Container from '../ui/Container';
import classes from './NewMeetupForm.module.css';
function NewMeetupForm() {
  return (
    <Container>
      <form className={classes.form}>
        <div className={classes.control}>
          <label htmlFor='title'>Title</label>
          <input type='text' id='title' required />
        </div>
        <div className={classes.control}>
          <label htmlFor='image'>Image</label>
          <input type='url' id='image' required />
        </div>
        <div className={classes.control}>
          <label htmlFor='address'>Address</label>
          <input type='text' id='address' required />
        </div>
        <div className={classes.control}>
          <label htmlFor='description'>Address</label>
          <input type='textarea' rows='5' id='description' required />
        </div>
        <div className={classes.control}>
          <label htmlFor='description'>Address</label>
          <input type='textarea' rows='5' id='description' required />
        </div>
        <div className={classes.action}>
          <button>Add</button>
        </div>
      </form>
    </Container>
  );
}
export default NewMeetupFrom;
```

## 20. 使用 useRef 獲取表單元素值

- 偵測表單內容有兩種做法  
1. 使用 useState 監聽每個 input onChange 事件，更新資料  
2. 使用 useRef 直接操作 DOM 元素  
- ref 還適合用在管理 focus、文字選擇、播放影音、整合第三方 DOM 函式庫、觸發動畫
- 非必要時不濫用 ref 操作 DOM 元素，多數元素保持用 State 管理
- ref 建議以 callback 方式使用

```jsx
// 元素綁定this.content，使用this.xxx呼叫相關屬性
<input type='text' ref={(el) => (this.content = el)} />;
this.content.focus();
```

- 引入 ref object，使用 current 屬性獲取 value

```jsx
// NewMeetupForm.js
import Container from '../ui/Container';
import classes from './NewMeetupForm.module.css';
import { useRef } from 'react';
function NewMeetupForm() {
  // 創造一個ref物件，帶有ref屬性，裡面有current屬性
  const titleInputRef = useRef();
  const imageInputRef = useRef();
  const addressInputRef = useRef();
  const descriptionInputRef = useRef();

  function submitHandler(event) {
    // 阻擋瀏覽器預設事件，避免點下表單就會對伺服器發出請求
    event.preventDefault();

    // 獲得title目前input值
    const enteredTitle = titleInputRef.current.value;
    const enteredImage = imageInputRef.current.value;
    const enteredAddress = addressInputRef.current.value;
    const enteredDescription = descriptionInputRef.current.value;
    // 創造一個物件管理
    const meetupData = {
      title: enteredTitle,
      image: enteredImage,
      address: enteredAddress,
      description: enteredDescription,
    };
    // send to server console.log(meetupData)
    props.onAddMeetupData(meetupData);
  }
  return (
    <Container>
      // 新增 submit 監聽
      <form className={classes.form} onSubmit={submitHandler}>
        <div className={classes.control}>
          <label htmlFor='title'>Title</label>
          <input type='text' id='title' ref={titleInputRef} required />
        </div>
        <div className={classes.control}>
          <label htmlFor='image'>Image</label>
          <input type='url' id='image' ref={imageInputRef} required />
        </div>
        <div className={classes.control}>
          <label htmlFor='address'>Address</label>
          <input type='text' id='address' ref={addressInputRef} required />
        </div>
        <div className={classes.control}>
          <label htmlFor='description'>Description</label>
          <input
            type='textarea'
            rows='5'
            id='description'
            ref={descriptionInputRef}
            required
          />
        </div>
        <div className={classes.action}>
          <button>Add</button>
        </div>
      </form>
    </Container>
  );
}
export default NewMeetupFrom;
```
- 表單資料丟到父層
```jsx
// pages/NewMeetup.js
function NewMeetupPage() {
                     // 表單資料meetupData
  function addMeetupHandler(meetupData) {
    // send http req
  }
  return (
    <section>
      <h1>Add New Meetup</h1>
      <NewMeetupForm onAddMeetupData={addMeetupHandler}>
    </section>
  );
}
export default NewMeetupPage;
```

## 21. API 串接

### 為什麼需要 API

- 前端的程式碼在 devtool 可以看到，透過 API 資料跟 server 要資料以確保安全
- 不然懂一點程式的人透過前端程式碼呼叫 server，可以盜取使用者個資，也可以把你 server 清空
- 可以用 Firebase Realtime Database 測試前端丟出去的 JSON 資料

```jsx
function NewMeetupPage() {
  function addMeetupHandler(meetupData) {
    // Firebase realtime 資料庫的API後方加上/xxx.json等於一個大表
    fetch('firebaseAPI網址/xxx.json',
    {

      method: 'POST',
      // body是JSON格式
      body:JSON.stringify(meetupData),
      // 部分API會要求提供'Content-Type'
      headers: {
        'Content-Type':'application/json'
      }
    })
  }
  return (
    <section>
      <h1>Add New Meetup</h1>
      <NewMeetupForm onAddMeetupData={addMeetupHandler}>
    </section>
  );
}
export default NewMeetupPage;
```

## 22. 使用 useHistory 跳轉頁面

- history.goBack() 回上一頁
- history.push('/') 到首頁，新增一個網址資料到陣列尾端
- history.replace('/') 回首頁，直接取代 current entry 資料，不新增資料，當不希望使用者回上一頁可使用

```jsx
import { useHistory } from 'react-router-dom';

function NewMeetupPage() {
  function addMeetupHandler(meetupData) {
    // Firebase realtime 資料庫的API後方加上/xxx.json等於一個大表
    fetch('firebaseAPI網址/xxx.json', {
      method: 'POST',
      // body是JSON格式
      body: JSON.stringify(meetupData),
      // 部分API會要求提供'Content-Type'
      headers: {
        'Content-Type': 'application/json',
      },
    }).then(() => {
      history.replace('/');
    });
  }
}
```

## 23. 使用 useEffect

- useEffect 可以用來限制元件不要每次渲染都執行所有的程式碼
- 第一個參數為函式，第二個是陣列，只有[]內容有變化才會執行
- 若沒加第二個參數等於每次都會執行，有用跟沒用一樣
- 若為空陣列，由於沒有相依任何變數，所以偵測不到變化，只會執行第一次
- 若裡面有變數，則變數有變化就會再執行一次
- 適合用在 fetch data、訂閱監聽事件、改變 DOM、輸出 log
- get 方法讓個別頁面獲取不同資料(把 dummyData 換成實際 server 資料)

```jsx
// pages/AllMeetup.js
import { useState, useEffect } from 'react';

function AllMeetupsPage() {
  const [isLoading, setIsLoading] = useState(true);
  const [meetups, setMeetups] = useState([]);
  useEffect(() => {
    // fetch回傳promise
    fetch('firebaseUrl/meetups.json')
      .then((response) => {
        // 獲取body 使用.json方法 把json檔案變成JS object
        // 因為.json return promise所以用then接 課程這邊專心在獲取資料 沒有寫到error處理
        return response.json();
      })
      .then((data) => {
        // 我們期望是陣列資料套入到模板，而firebase上的meetups資料是巢狀物件結構
        // 最外層是一個object，每筆資料是一個key value pair
        // meetups = {
        //  key1: {title:'', image:'', address:'', description:''},
        //  key2: {title:'', image:'', address:'', description:''}
        // }
        const meetups = [];
        for (const key in data) {
          // 解構出data
          const meetups = {
            id: key,
            ...data[key],
          };
          // 資料一筆筆推入陣列
          meetups.push(meetup);
        }
        setIsLoading(false);

        setMeetups(data);
      });
  }, []);

  if (isLoading) {
    return (
      <section>
        <p>Loading...</p>
      </section>
    );
  }
  // 這段不會等上面回傳資料，但不能用async function AllMeetupPage await fetch來處理
  // 元件函式應是同步函式，不應該return promise而是JSX
  // 可使用State條件渲染 loading
  return (
    <section>
      <h1>AllMeetupsPage</h1>
      {meetups.map((el) => {
        return <li key={el.id}>{el.title}</li>;
      })}
    </section>
  );
}
export default AllMeetupsPage;
```

- 若沒使用 useEffect，當 useState 更新狀態會再跑一次元件，再 fetch 一次就會無限迴圈

## 24-1 useContext 管理全域 State (這個應該是最複雜的)

- 上面介紹過 useState 在單個元件的更新資料方法
- 如果需要管理全域的 State，可以用 props 傳遞 State 更新其他元件資料，但大專案會不好維護跟管理
- 也可以使用 redux，但 React 函式庫本身就有內建 context 管理 State 的 function
- 管理 State 的 context 一般會建立在 src/store 下(e.g. favorites-context.js)

```jsx
import { createContext, useState } from 'react';

// 建立一個context物件 裡面放初始值
const FavoritesContext = createContext({
  favorites: [],
  totalFavorites: 0,
  addFavorite: (favoriteMeetup) => {},
  removeFavorite: (favoriteMeetup) => {},
  itemIsFavorite: (favoriteMeetup) => {},
});

// 更新我的最愛State的函式 用來管理這個函式裡的State 這邊加上export之後會從外部呼叫
export function FavoritesContextProvider(props) {
  const [userFavorites, setUserFavorites] = useState([]);

  // 建立三個處理我的最愛State的函式
  function addFavoriteHandler(favoriteMeetup) {
    setUserFavorites((prevUserFavorites) => {
      return prevUserFavorites.concat(favoriteMeetup);
    });
  }

  function removeFavoriteHandler(meetupId) {
    setUserFavorites((prevUserFavorites) => {
      return prevUserFavorites.filter((prev) => prev.id !== meetupId);
    });
  }

  function itemIsFavoriteHandler(meetupId) {
    return userFavorites.some((meetup) => meetup.id !== meetupId);
  }

  // 新增一個 context object 透過value把值傳過去
  const context = {
    // 把userFavorite的snapshot放在這裡，當State改變context物件也會改變
    // 也會透過value={context}傳新的值到相關元件
    favorites: userFavorites,
    totalFavorites: userFavorites.length,
    // 當其他元件要使用上方三個函式時，用pointer指向下面的key然後就會執行後面的函式，即上面的function
    addFavorite: addFavoriteHandler,
    removeFavorite: removeFavoriteHandler,
    itemIsFavorite: itemIsFavoriteHandler,
  };

  // Provider是內建的元件 必須包在所有會跟他互動的元件(e.g. App) value會傳值
  return (
    <FavoritesContext.Provider value={context}>
      {props.children}
    </FavoritesContext.Provider>
  );
}
// 輸出Favoritescontext
export default FavoritesContext;
```

- index.js 引用，讓全域都可以使用 context

```jsx
// index.js
import { BrowserRouter } from 'react-router-dom';
import { FavoriteContextProvider } from './store/favorite-context';

RouterDOM.render(
  <FavoriteContextProvider>
    <BrowserRouter>
      <APP />
    </BrowserRouter>
  </FavoriteContextProvider>
);
```

## 24-2 在元件引用 useContext

- 引用到MeetupItem.js

```jsx
// 點加入我的最愛就會把item加入陣列，更新按鈕文字
...
import FavoritesContext from './../../store/favorite-context'
function MeetUpItem(props) {
  function toggleFavoritesStatusHandler() {
    const favoritesCtx = useContext(FavoritesContext)
    const itemIsFavorite = favoriteCtx.itemIsFavorite(prop.id)

    function toggleFavoriteStatusHandler() {
      if(itemIsFavorite) {
        favoritesCtx.removeFavorite(prop.id)
      } else {
        // 更新陣列資料，就會透過favorite-context讓全域物件下相關資料都更新
        favoritesCtx.addFavorite({
          id: props.id,
          title: props.title,
          address: props.address,
          image: props.image,
          description: prop.description
        })
      }
    }
    return (
      <li className={classes.item}>
        <Container>
        ...
         <div>
           <button onClick={toggleFavoriteStatusHandler}>{itemIsFavorite ? 'Remove' : 'Add'}</button>
         </div>
        </Container>
      </li>
    );
  }
}
```

- 引用到FavoritesPage

```jsx
...
import { useContext } from 'react'
import FavoritesContext from './../store/favorite-context'

// 顯示我的最愛item
function FavoritesPage(){
  const favoritesCtx = useContext(FavoritesContext)

  let content
  if (favoritesCtx.totalFavorites.length === 0){
    content = <p>No Favorites yet</p>
  } else {
    content = <MeetupList meetups={favoritesCtx.favorites}>
  }
  return <section>
  <h1>My Favorites</h1>
  // array
  {content}
  </section>
}

export default FavoritesPage
```

- 引用到導覽列(放上我的最愛總數)

```jsx
// MainNavigation.js
...
import { useContext } from 'react'
import FavoritesContext from './../../store/favorite-context'

import { Link } from 'react-router-dom'
function MainNavigation() {
  const favoriteCtx = useContext(FavoritesContext)
  return (
  <header>
   ...
         <li>
           <Link to='/favorites'>My favorites
           <span>{favoriteCtx.totalFavorites.length}</span>
           </Link>
         </li>
    ...
  </header>
  )
}
export default MainNavigation

```

最後想補充一下...  
其實我覺得 Vue 也不錯啊（x)

有好吃的語法糖：用@監聽事件，@submit.prevent.stop 就可阻止瀏覽器提交表單跟冒泡：動態 class，watch 深層監聽物件屬性，computed 動態更新，v-model 雙向綁定表單...各種好吃的糖)

<img src="./smile.jpeg" alt="smile-meme" width="350px">

原來暗藏一篇 Vue 推銷文，真是太邪惡了
