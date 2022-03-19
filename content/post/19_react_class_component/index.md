---
title: 關於React Class Component｜bacnotes備份筆記
description: function Component 寫起來精簡又彈性，為什麼會需要了解 Class Component，因為可能還是會在專案當中碰到。了解如何處理Class Component，跟他們適合使用的時機，讓你在寫程式時可以更無往不利，以及在JavaScript如何使用錯誤邊界處理可能造成App Crash的狀況。
date: 2022-02-06T00:00:00+08:00
slug: react-class-component
image: pexels-max-fischer-5212336.jpg
tags:
  - React
---

## Class Component 是什麼

- 16.8 版本以前處理 State 跟 Side Effect 會需要使用 Class Component，後來有 Hook 就可以只寫 Function Component（寫起來相對單純)
- 使用 JavaScript 的 Class，定義要 render 的 JSX，React 會在適當時機點渲染
- 可以跟 Function Component 一起使用
- render 方法不會讀取 props，而是透過引入 react 的 Component 拿到 Props

```jsx
// class component
import { Component } from "react";
// 繼承Component的方法，拿到本身元件props屬性的資料
class User extends Component {
  // 使用this.props拿到所有props的資料
  render() {
    return <li className={classes.user}>{this.props.name}</li>;
  }
}

// function component
// props做為參數傳入
const User = (props) => {
  return <li className={classes.user}>{props.name}</li>;
};
```

## 使用 class Component 管理狀態

- 一樣需要定義狀態跟初始化 state
- 使用 constructor 定義 this.state，= 後面要是一個物件
- functional component 的 state 定義則是任意資料，useState(null)
- 一樣不能用 this.state.變數 = 值直接修改資料，必須用 setState(物件)
- 改寫一段 Function Component Code

```jsx
import { Component } from "react";

import User from "./User";

const DUMMY_USERS = [
  { id: "u1", name: "Max" },
  { id: "u2", name: "Manuel" },
  { id: "u3", name: "Julie" },
];

class Users extends Component {
  // super 是父層的建構函式，用來調用父層
  // 必須出現在this 關鍵字之前使用
  constructor() {
    super();
    this.state = {
      showUsers: true,
      more: "Test",
    };
  }
  // 使用this.setState更新狀態，沒有寫到state其他的屬性沒關係，同樣狀況在useState就會有問題
  toggleUsersHandler() {
    // this.state.showUsers = false;
    this.setState((curState) => {
      // class Component只會更新下方提到的的屬性，useState則會全部屬性都覆寫
      return { showUsers: !curState.showUsers };
    });
  }

  render() {
    const usersList = (
      <ul>
        {DUMMY_USERS.map((user) => (
          <User key={user.id} name={user.name} />
        ))}
      </ul>
    );

    return (
      <div className={classes.users}>
        <button onClick={this.toggleUsersHandler}>
          {this.state.showUsers ? "Hide" : "Show"} Users
        </button>
        {this.state.showUsers && usersList}
      </div>
    );
  }
}
// Function Component Code
// const Users = () => {
//   const [showUsers, setShowUsers] = useState(true);

//   const toggleUsersHandler = () => {
//     setShowUsers((curState) => !curState);
//   };

//   const usersList = (
//     <ul>
//       {DUMMY_USERS.map((user) => (
//         <User key={user.id} name={user.name} />
//       ))}
//     </ul>
//   );

//   return (
//     <div className={classes.users}>
//       <button onClick={toggleUsersHandler}>
//         {showUsers ? 'Hide' : 'Show'} Users
//       </button>
//       {showUsers && usersList}
//     </div>
//   );
// };

export default Users;
```

## 使用 class Component 處理 side Effect

### 先了解 React 重要的生命週期

componentDidMount()

- 在 evaluate 且渲染完後，只會在 mount 元件時呼叫一次，更新資料 re-render 不會，類似 useEffect(()=>{},[])

componentDidUpdate()

- 當元件更新狀態或 Props 會呼叫，類似 useEffect(()=>{},[參數])

componentWillUnmount()

- 當元件被銷毀，從真實 DOM 拿掉，類似 cleanup useEffect(()=>{},[])

### 以一個搜尋元件來當範例，會依照不同字詞出現不同使用者清單

- 一樣需要 import Component，初始化 state
- 有兩個狀態需要管理，搜尋字詞跟使用者清單

```jsx
import { Fragment, useState, useEffect, Component } from "react";

import Users from "./Users";

const DUMMY_USERS = [
  { id: "u1", name: "Max" },
  { id: "u2", name: "Manuel" },
  { id: "u3", name: "Julie" },
];

class UserFinder extends Component {
  constructor() {
    super();
    this.state = {
      filteredUsers: [],
      searchTerm: "",
    };
  }
  // 只會執行一次
  componentDidMount() {
    // Send http request...假想是從資料庫獲取DUMMY_USERS
    this.setState({ filteredUsers: DUMMY_USERS });
  }
  // 更新狀態
  componentDidUpdate(prevProps, prevState) {
    // 需要加上判斷是否有變類似之前的callback
    // 不然一樣因為資料更新，重新渲染，再次觸發資料更新會重複循環
    if (prevState.searchTerm !== this.state.searchTerm) {
      this.setState({
        filteredUsers: DUMMY_USERS.filter((user) =>
          user.name.includes(this.state.searchTerm)
        ),
      });
    }
  }
  // 搜尋字詞
  searchChangeHandler(event) {
    this.setState({ searchTerm: event.target.value });
  }

  render() {
    return (
      <Fragment>
        <div className={classes.finder}>
          // 元件綁定上面方法
          <input type='search' onChange={this.searchChangeHandler.bind(this)} />
        </div>
        <Users users={this.state.filteredUsers} />
      </Fragment>
    );
  }
}

// const UserFinder = () => {
//   const [filteredUsers, setFilteredUsers] = useState(DUMMY_USERS);
//   const [searchTerm, setSearchTerm] = useState('');

//   useEffect(() => {
//     setFilteredUsers(
//       DUMMY_USERS.filter((user) => user.name.includes(searchTerm))
//     );
//   }, [searchTerm]);

//   const searchChangeHandler = (event) => {
//     setSearchTerm(event.target.value);
//   };

//   return (
//     <Fragment>
//       <div className={classes.finder}>
//         <input type='search' onChange={searchChangeHandler} />
//       </div>
//       <Users users={filteredUsers} />
//     </Fragment>
//   );
// };

export default UserFinder;
```

- 點按鈕隱藏 User，呈現銷毀元件的生命週期 console.log

```jsx
import { Component } from "react";

class User extends Component {
  componentWillUnmount() {
    console.log("User will unmount!");
  }

  render() {
    return <li className={classes.user}>{this.props.name}</li>;
  }
}

// const User = (props) => {
//   return <li className={classes.user}>{props.name}</li>;
// };

export default User;
```

## 使用 class Component 處理 context

- 一樣在 store 先建立初始值，用 Provider 包起來監聽

```jsx
// src/store
import React from "react";

const UsersContext = React.createContext({
  users: [],
});

export default UsersContext;
```

```jsx
// App.js
import UserFinder from "./components/UserFinder";
import UsersContext from "./store/users-context";

const DUMMY_USERS = [
  { id: "u1", name: "Max" },
  { id: "u2", name: "Manuel" },
  { id: "u3", name: "Julie" },
];

function App() {
  const usersContext = {
    users: DUMMY_USERS,
  };

  return (
    <UsersContext.Provider value={usersContext}>
      <UserFinder />
    </UsersContext.Provider>
  );
}

export default App;
```

- DUMMY_USER 改從 store 取得

### useContext 改成使用 context consumer

- 這個方法在 Class Component 跟 Function Component 都可以使用

```jsx
import { Fragment, useState, useEffect, Component } from 'react';

import Users from './Users';
import classes from './UserFinder.module.css';
import UsersContext from '../store/users-context';

class UserFinder extends Component {
  static contextType = UsersContext;

  ...
  render() {
    return (
      <Fragment>
        <UsersContext.Consuer>
        <div className={classes.finder}>
          <input type='search' onChange={this.searchChangeHandler.bind(this)} />
        </div>
        <Users users={this.context.filteredUsers} />
        </UsersContext.Consuer>
      </Fragment>
    );
  }
}

export default UserFinder;
```

- 在 class Component 一個元件只能對應一個 context，不同於 useContext 可以一個元件對應多個不同 context
- 使用 static 定義一個靜態的方法
- 原本 this.state 的資料改成 this.context

```jsx
import { Fragment, useState, useEffect, Component } from "react";

import Users from "./Users";
import classes from "./UserFinder.module.css";
import UsersContext from "../store/users-context";

class UserFinder extends Component {
  // 定義這個元件可以獲取UsersContext
  static contextType = UsersContext;

  constructor() {
    super();
    this.state = {
      filteredUsers: [],
      searchTerm: "",
    };
  }

  componentDidMount() {
    // Send http request...
    this.setState({ filteredUsers: this.context.users });
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.searchTerm !== this.state.searchTerm) {
      this.setState({
        filteredUsers: this.context.users.filter((user) =>
          user.name.includes(this.state.searchTerm)
        ),
      });
    }
  }

  searchChangeHandler(event) {
    this.setState({ searchTerm: event.target.value });
  }

  render() {
    return (
      <Fragment>
        <div className={classes.finder}>
          <input type='search' onChange={this.searchChangeHandler.bind(this)} />
        </div>
        <Users users={this.state.filteredUsers} />
      </Fragment>
    );
  }
}

// const UserFinder = () => {
//   const [filteredUsers, setFilteredUsers] = useState(DUMMY_USERS);
//   const [searchTerm, setSearchTerm] = useState('');

//   useEffect(() => {
//     setFilteredUsers(
//       DUMMY_USERS.filter((user) => user.name.includes(searchTerm))
//     );
//   }, [searchTerm]);

//   const searchChangeHandler = (event) => {
//     setSearchTerm(event.target.value);
//   };

//   return (
//     <Fragment>
//       <div className={classes.finder}>
//         <input type='search' onChange={searchChangeHandler} />
//       </div>
//       <Users users={filteredUsers} />
//     </Fragment>
//   );
// };

export default UserFinder;
```

## 什麼是錯誤邊界 Error Boundaries

- 錯誤邊界是一個 React component，捕捉了任何在它的 child component tree 裡發生的 JavaScript 的錯誤，記錄那些錯誤，然後顯示在一個 fallback 的使用介面，而非讓整個 component tree 崩壞
- 錯誤邊界會在 render 的時候、在生命週期函式內、以及底下一整個 component tree 裡的 constructor 內捕捉錯誤
- 當子層 Component 出現錯誤，e.g. server 抓不到資料，無法跟 JavaScript 一樣直接 try catch 捕捉
- 這個元件無法被使用在 Function Component

### 建立一個 Error Boundary

- 放在 src/components 下
- 透過 componentDidCatch 方法，讓這個 Component 成為一個 Error Boundary
- 當子層 Component 出現錯誤就會觸發 componentDidCatch，避免整個 APP crash

```jsx
import { Component } from "react";

class ErrorBoundary extends Component {
  // 可以用state管理error (option)
  constructor() {
    super();
    this.state = { hasError: false };
  }
  // error
  componentDidCatch(error) {
    console.log(error);
    // 設定錯誤狀態
    this.setState({ hasError: true });
  }

  render() {
    // 當狀態出錯就回傳一段JSX，提示使用者
    if (this.state.hasError) {
      return <p>Something went wrong!</p>;
    }
    // render 被包裹的元件
    return this.props.children;
  }
}

export default ErrorBoundary;
```

### 把邊界建立在可能出錯的元件

```jsx
import { Fragment, useState, useEffect, Component } from 'react';

import Users from './Users';
import classes from './UserFinder.module.css';
import UsersContext from '../store/users-context';
import ErrorBoundary from './ErrorBoundary';

class UserFinder extends Component {
  static contextType = UsersContext;

  constructor() {
    super();
    this.state = {
      filteredUsers: [],
      searchTerm: '',
    };
  }

  componentDidMount() {
    // Send http request...
    this.setState({ filteredUsers: this.context.users });
  }

  componentDidUpdate(prevProps, prevState) {
    if (prevState.searchTerm !== this.state.searchTerm) {
      this.setState({
        filteredUsers: this.context.users.filter((user) =>
          user.name.includes(this.state.searchTerm)
        ),
      });
    }
  }

  searchChangeHandler(event) {
    this.setState({ searchTerm: event.target.value });
  }

  render() {
    return (
      <Fragment>
        <div className={classes.finder}>
          <input type='search' onChange={this.searchChangeHandler.bind(this)} />
        </div>
        <ErrorBoundary>
          <Users users={this.state.filteredUsers} />
        </ErrorBoundary>
      </Fragment>
    );
  }
```
