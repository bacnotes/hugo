---
title: React 必須了解的3大Hooks：useEffect、useReducer、useContext｜React - The Complete Guide｜bacnotes備份筆記
description:
date: 2022-02-03T00:00:00+08:00
slug: react-effect-reducer-context
image: pexels-rodolpho-zanardo-1309095.jpg
tags:
  - React
---

## 什麼是 Hook?

- Hook 是函式，react 提供的內建 Hook 為 use 開頭的函式(e.g. useEffect、useReducer、useContext)
- 只能用在 Function Component 元件跟 custom Hook，Class Component 無法
- 使用時需要寫在元件內第一層，不能巢狀到

## 什麼是 Effect(Side Effect)?

React 主要工作是

1. 評估是否渲染元件在畫面上
2. 管理狀態跟 props
3. 表單與事件處理(使用者互動)
4. 根據狀態和 props 的更新評估是否重新渲染部分畫面

Side Effect: 非 React 的工作，跟渲染畫面無直接相關，包含儲存資料發送 http 請求跟設定 timer，驗證邏輯，手動操作 DOM 都是 Side Effect

Side Effect 可能造成的結果

1. 非同步操作可能會阻塞渲染工作
2. 跟伺服器請求資料可能會造成無限循環：發送請求->請求結果返回->set 新狀態->狀態改變->重新渲染元件->觸發發送請求...

## 使用 useEffect 來管理 Effect(Side Effect)

- useEffect(()=> {...}, [dependencies])
- 使用時機：re-render 元件時希望會再次觸發的函式
- useEffect 發生時間點為畫面渲染完
- 若沒有相依某個參數，每次渲染完都會執行，寫跟沒寫一樣
- 若有相依某個參數，re-render 時參數有改變的話可以重新觸發 useEffect 裡面的函式
- []相依空陣列，第一次渲染完會觸發，因空陣列資料不變，所以後續都不會觸發
- [state]相依狀態，第一次渲染完會觸發，且每次狀態改變都會跑一次
- [props]相依 props，第一次渲染完會觸發，props 更新都會跑一次
- 控制好觸發時機點，避免不必要的觸發

- 相依空陣列範例

```jsx
// 渲染登入頁面時，確認localStorage登入驗證資訊，只執行一次
function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  // 第一次渲染完會觸發，後續狀態/props更新不會run
  useEffect(() => {
    const storedUserLoggedInInformation = localStorage.getItem("isLoggedIn");

    if (storedUserLoggedInInformation === "1") {
      setIsLoggedIn(true);
    }
  }, []);

  const loginHandler = (email, password) => {
    // We should of course check email and password
    // But it's just a dummy/ demo anyways
    localStorage.setItem("isLoggedIn", "1");
    setIsLoggedIn(true);
  };

  const logoutHandler = () => {
    // 登出時移除登入驗證
    localStorage.removeItem("isLoggedIn");
    setIsLoggedIn(false);
  };
  // 若有登入驗證資訊 渲染Home頁面 沒有則渲染Login頁面
  return (
    <React.Fragment>
      <MainHeader isAuthenticated={isLoggedIn} onLogout={logoutHandler} />
      <main>
        {!isLoggedIn && <Login onLogin={loginHandler} />}

        {isLoggedIn && <Home onLogout={logoutHandler} />}
      </main>
    </React.Fragment>
  );
}
```

- 相依 enteredEmail、enteredPassword 表單狀態

```jsx
const Login = (props) => {
  const [enteredEmail, setEnteredEmail] = useState('');
  const [emailIsValid, setEmailIsValid] = useState();
  const [enteredPassword, setEnteredPassword] = useState('');
  const [passwordIsValid, setPasswordIsValid] = useState();
  const [formIsValid, setFormIsValid] = useState(false);
  // 第一次會執行，後續表單狀態更新也會執行（驗證程式碼）
  useEffect(() => {
    setFormIsValid(
      enteredEmail.includes('@') && enteredPassword.trim().length > 6
    );
  }, [enteredEmail, enteredPassword]);
...
}
```

### 不需加入相依的參數

- 更新狀態的函式 setXXX
- 元件外的變數或函式

### 應該加入的相依參數

- "things" could change because your component (or some parent component) re-rendered

### 用 setTimeout 優化觸發時間點，搭配 cleanup 清除功能

- 若不要每個 key 下去的動作都觸發驗證功能，可以用 setTimeout 一段時間再觸發 effect(非最佳解，後面還有其他做法)
- useEffect 裡面的 return 函式，只會在 unmount，元件要被從 DOM 卸載時觸發

```jsx
const Login = (props) => {
  const [enteredEmail, setEnteredEmail] = useState('');
  const [emailIsValid, setEmailIsValid] = useState();
  const [enteredPassword, setEnteredPassword] = useState('');
  const [passwordIsValid, setPasswordIsValid] = useState();
  const [formIsValid, setFormIsValid] = useState(false);

  useEffect(() => {
    const identifier = setTimeout(() => {
      // 第一次觸發，後續per 0.5秒觸發
      console.log('Checking form validity!');
      setFormIsValid(
        enteredEmail.includes('@') && enteredPassword.trim().length > 6
      );
    }, 500);

    // return內容需要是一個function
    // 下方程式碼不會在第一次渲染觸發，元件更新才會觸發(when unmounts from the DOM, the component is reused)
    return () => {
      console.log('CLEANUP');
      //在新的Timer設置前先把舊的Timer刪除
      clearTimeout(identifier);
    };
  }, [enteredEmail, enteredPassword]);

  const emailChangeHandler = (event) => {
    setEnteredEmail(event.target.value);
  };
  ...
}
```

### 官方說明不需要搭配 cleanup 的 Effect

- fetch data、手動操作 DOM、輸出 log 紀錄（不用追蹤後續）
- get 方法讓個別頁面獲取不同資料(把 dummyData 換成實際 server 資料)

### 需搭配 cleanup 的 Effect

- 訂閱監聽事件，監聽事件
- 避免 memory leak

```jsx
import React, { useState, useEffect } from "react";

function FriendStatus(props) {
  const [isOnline, setIsOnline] = useState(null);

  useEffect(() => {
    function handleStatusChange(status) {
      setIsOnline(status.isOnline);
    }
    ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
    // Specify how to clean up after this effect:
    return function cleanup() {
      ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
    };
  });

  if (isOnline === null) {
    return "Loading...";
  }
  return isOnline ? "Online" : "Offline";
}
```

## useReducer 管理複雜狀態邏輯

- 當寫 useState 開始覺得不好管理狀態，或需要處理複雜邏輯的時候可以考慮使用 useReducer
- const [state, dispatchFn] = useReducer(reducerFn, initState, initFn)
- dispatchFn 觸發 action，action 觸發 reducerFn
- reducer 會收到上一個狀態跟 action 參數，並且回傳新的 state
- reducerFn (prevState, action) => newState
- initFn 可以用來設定 initState，如果比較複雜的話，需要外部資料等等

- 使用 useReducer 管理 email 跟 password input 狀態(effect相依參數改成驗證狀態，減少不必要觸發)

```jsx
// reducerFn寫在元件外面，相關參數會透過dispatch傳入
const emailReducer = (state, action) => {
  // 收到dispatch事件同時更新input值跟isValid狀態
  if (action.type === 'USER_INPUT') {
    return { value: action.value, isValid: action.value.includes('@') };
  }
  // 點其他Input會Blur
  if (action.type === 'INPUT_BLUR') {
    // 這邊Blur事件不會傳遞值，但需要有一個值維持狀態
    // state.value可以拿到最新的state
    return { value: state.value, isValid: state.value.includes('@') };
        // includes驗證會回傳true false
  }
  return { value: '', isValid: false };
};

const passwordReducer = (state, action) => {
   if (action.type === 'USER_INPUT') {
    return { value: action.value, isValid: action.value.trim().length > 6 };
  }
  // 點其他Input會Blur
  if (action.type === 'INPUT_BLUR') {
    // 這邊Blur事件不會傳遞值，但需要有一個值維持狀態
    // state.value可以拿到最新的state
    return { value: state.value, isValid: state.value.trim().length > 6 };
        // includes驗證會回傳true false
  }
  return {value:'', isValid: false}
}

const Login = (props) => {
  // const [enteredEmail, setEnteredEmail] = useState('');
  // const [emailIsValid, setEmailIsValid] = useState();
  // const [enteredPassword, setEnteredPassword] = useState('');
  // const [passwordIsValid, setPasswordIsValid] = useState();
  const [formIsValid, setFormIsValid] = useState(false);

  const [emailState, dispatchEmail] = useReducer(emailReducer, {
    value: '',
    isValid: null,
  });
  // 上面是initState

  const [passwordState, dispatchPassword] = useReducer(passwordReducer, {
    value:'', isValid: null
  })

  useEffect(() => {
    console.log('EFFECT RUNNING');

    return () => {
      console.log('EFFECT CLEANUP');
    };
  }, []);

  // 解構賦值，改換另一個變數名
  const { isValid: emailIsValid } = emailState;
  const { isValid: passwordIsValid } = passwordState;

  useEffect(() => {
    const identifier = setTimeout(() => {
      console.log('Checking form validity!');
      setFormIsValid(emailIsValid && passwordIsValid);
    }, 500);

    return () => {
      console.log('CLEANUP');
      clearTimeout(identifier);
    };
    // 改由驗證有更新再re-run effect來優化效能
  }, [emailIsValid, passwordIsValid]);

  const emailChangeHandler = (event) => {
    // 通常是一個物件 {type:'', 也可以寫payload要跟上面reducer action內key值一樣: 傳遞下去的值}
    dispatchEmail({type: 'USER_INPUT', value: event.target.value});

    setFormIsValid(
      event.target.value.includes('@') && enteredPassword.trim().length > 6
    );
  };

  const passwordChangeHandler = (event) => {
    dispatchPassWord({type:'USER_INPUT', value:event.target.value})

    setFormIsValid(
      emailState.isValid && event.target.value.trim().length > 6
    );
  };

  const validateEmailHandler = () => {
    dispatchEmail({type: 'INPUT_BLUR'});
  };

  const validatePasswordHandler = () => {
    dispatchPassword({type: 'INPUT_BLUR'});
  };

  const submitHandler = (event) => {
    event.preventDefault();
    // state取值用state.value
    props.onLogin(emailState.value, passwordState.value);
  };
```

- 上述的解構賦值很常用在取相依參數，也可以用取屬性的方式

```jsx
const { someProperty } = someObject;
useEffect(() => {
  // code that only uses someProperty ...
}, [someProperty]);

useEffect(() => {
  // code that only uses someProperty ...
}, [someObject.someProperty]);
```

- 記得避免直接寫整個物件，因為物件傳值，彼此就算長一樣地址也不會相同

## useContext 管理全域 State

- 好處：不用透過長長的 prop chain 直接傳遞資料
- 流程：先透過 React.createContext 創造一個變數，透過 AuthContext 輸出，其他元件用 useContext 引用相對應的 context 檔案獲取物件值

```jsx
// src/store
import { createContext } from "react";

// 建立一個context物件 裡面放初始值
const AuthContext = createContext({
  isLoggedIn: false,
});
export default AuthContext;
```

- `<AuthContext.Provider>...</AuthContext.Provider>`透過 Provider 屬性可以獲取 AuthContext
- 而包裹在`<AuthContext.Provider>`之間的元件都可以獲取這個 AuthContext

```jsx
// App.js
// import context變數
import AuthContext from './store/auth-context';

function App() {
 const [isLoggedIn, setIsLoggedIn] = useState(false);
...

return (
    // 如果有預設值基本上不需要寫value，但若有會變動的值，要透過value傳入更新狀態，只能透過Provider來做
    <AuthContext.Provider
      value={{
        isLoggedIn: isLoggedIn,
        // context物件裡面的value 也可以放函式
        onLoggedOut: () => {},
      }}
    >
      <MainHeader onLogout={logoutHandler} />
      <main>
        {!isLoggedIn && <Login onLogin={loginHandler} />}
        {isLoggedIn && <Home onLogout={logoutHandler} />}
      </main>
    </AuthContext.Provider>
  );
  export default App;
```

- 在 Navbar 來獲取變數

```jsx
import React, { useContext } from "react";

import AuthContext from "../../store/auth-context";

const Navigation = () => {
  // 使用useContext 指向特定context獲取value(物件)
  const ctx = useContext(AuthContext);

  return (
    <nav className={classes.nav}>
      <ul>
        {ctx.isLoggedIn && (
          <li>
            <a href='/'>Users</a>
          </li>
        )}
        {ctx.isLoggedIn && (
          <li>
            <a href='/'>Admin</a>
          </li>
        )}
        {ctx.isLoggedIn && (
          <li>
            <button onClick={ctx.onLogout}>Logout</button>
          </li>
        )}
      </ul>
    </nav>
  );
};

export default Navigation;
```

- 重構：把登入登出 Auth 相關的函式都放在 context 管理

```jsx
import React, { useState, useEffect } from "react";

const AuthContext = React.createContext({
  isLoggedIn: false,
  onLogout: () => {},
  onLogin: (email, password) => {},
});

// 新增
export const AuthContextProvider = (props) => {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  useEffect(() => {
    const storedUserLoggedInInformation = localStorage.getItem("isLoggedIn");

    if (storedUserLoggedInInformation === "1") {
      setIsLoggedIn(true);
    }
  }, []);

  const logoutHandler = () => {
    localStorage.removeItem("isLoggedIn");
    setIsLoggedIn(false);
  };

  const loginHandler = () => {
    localStorage.setItem("isLoggedIn", "1");
    setIsLoggedIn(true);
  };

  return (
    <AuthContext.Provider
      value={{
        isLoggedIn: isLoggedIn,
        onLogout: logoutHandler,
        onLogin: loginHandler,
      }}>
      {props.children}
    </AuthContext.Provider>
  );
};

export default AuthContext;
```

- 把`<AuthContextProvider>`包裹全域監聽放到 index.js

```jsx
import React from "react";
import ReactDOM from "react-dom";

import "./index.css";
import App from "./App";
import { AuthContextProvider } from "./store/auth-context";

ReactDOM.render(
  <AuthContextProvider>
    <App />
  </AuthContextProvider>,
  document.getElementById("root")
);
```

- App.js 跟 Navbar 只要引用 Context 的資料

```jsx
//App.js
import AuthContext from "./store/auth-context";

function App() {
  const ctx = useContext(AuthContext);

  return (
    <React.Fragment>
      <MainHeader />
      <main>
        {!ctx.isLoggedIn && <Login />}
        {ctx.isLoggedIn && <Home />}
      </main>
    </React.Fragment>
  );
}

export default App;
```

```jsx
// Navbar
import AuthContext from "../../store/auth-context";

const Navigation = () => {
  const ctx = useContext(AuthContext);

  return (
    <nav className={classes.nav}>
      <ul>
        {ctx.isLoggedIn && (
          <li>
            <a href='/'>Users</a>
          </li>
        )}
        {ctx.isLoggedIn && (
          <li>
            <a href='/'>Admin</a>
          </li>
        )}
        {ctx.isLoggedIn && (
          <li>
            <button onClick={ctx.onLogout}>Logout</button>
          </li>
        )}
      </ul>
    </nav>
  );
};

export default Navigation;
```

### useContext 的限制

- 不適合頻繁更動的資料（每秒好幾次)，使用 redux
- 鄰近父子元件還是建議透過 props 傳遞資料，而非用 useContext 取代
