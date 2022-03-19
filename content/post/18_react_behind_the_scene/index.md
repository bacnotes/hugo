---
title: React 背後運作原理｜bacnotes備份筆記
description: 除了講解關於React背後運作機制，也會分享如何在這些機制下使用React.memo、useCallback、useMemo優化效能。
date: 2022-02-04T00:00:00+08:00
slug: react-behind-the-scene
image: pexels-eren-li-7188802.jpg
tags:
  - React
---

## React 是怎麼運作的

- React 是一個打造使用者介面的 JavaScript 函式庫
- React 負責管理元件資料狀態(props, state, context)透過 Virtual DOM 評估哪些元件需要被更新
- React Dom 是操作 Web 的介面，跟瀏覽器的 真實 DOM 互動
- React Dom 收到 React 的更新資訊(比較差異)，操作瀏覽器 DOM 來改變畫面
- 比起直接操作真實 DOM，先從 Virtual DOM 評估差異再操作真實 DOM 裡必要修改的部分，較不耗資源

## 當 props, context, state 更新時會發生什麼事

- props, context 更新其實背後都是代表 state 更新，而 props 跟 context 只是傳輸資料管道不同
- React 會重新評估(re-evaluate)，即執行元件裡的函式（包含子層元件)，並更新資訊給 React DOM
- 下方範例，每次 props 變化（true false)，父子元件都會重新 re-evaluate，true 時渲染 This is new，false 則沒有內容

```jsx
// 父層元件
import React, { useState } from 'react';

import Button from './components/UI/Button/Button';
import DemoOutput from './components/Demo/DemoOutput';

function App() {
  const [showParagraph, setShowParagraph] = useState(false);

  console.log('APP RUNNING');

  const toggleParagraphHandler = () => {
    setShowParagraph((prevShowParagraph) => !prevShowParagraph);
  };

  return (
    <div className="app">
      <h1>Hi there!</h1>
      // props傳入showParagraph的狀態
      <DemoOutput show={showParagraph} />
      <Button onClick={toggleParagraphHandler}>Toggle Paragraph!</Button>
    </div>
  );
}

export default App;


// 子層元件
const DemoOutput = (props) => {
  console.log('DemoOutput RUNNING');
  return <p>{props.show ? 'This is new!' : ''}</p>;
};

export default DemoOutput;
```

## 父層重新渲染時，子層也會重新評估是否渲染

- 父層狀態有變但沒有傳入子層，父層渲染時子層也會重新評估，因為子層元件也是父層的程式碼一部分，但受影響的子層不一定會重新渲染
- 下方範例在真實 DOM 沒有變化（也沒有任何 flash)，表示沒有重新渲染，但會看到 console.log 有跳出，表示有重新評估

```jsx
// 父層元件
import React, { useState } from 'react';

import Button from './components/UI/Button/Button';
import DemoOutput from './components/Demo/DemoOutput';

function App() {
  const [showParagraph, setShowParagraph] = useState(false);

  console.log('APP RUNNING');

  const toggleParagraphHandler = () => {
    setShowParagraph((prevShowParagraph) => !prevShowParagraph);
  };

  return (
    <div className="app">
      <h1>Hi there!</h1>
      // 固定寫false，沒有傳入任何更新
      <DemoOutput show={false}} />
      <Button onClick={toggleParagraphHandler}>Toggle Paragraph!</Button>
    </div>
  )
}

export default App;


// 子層元件
const DemoOutput = (props) => {
  console.log('DemoOutput RUNNING');
  return <p>{props.show ? 'This is new!' : ''}</p>;
};

export default DemoOutput;
```

## React.memo 優化 Functional Component 效能

- 只有父層傳下來的 props 值有改變，才會重新渲染子層跟子層下的元件
- 下方範例若 props 沒改變，不會重新渲染 DemoOutput 跟 MyParagraph
- 使用 React.memo 也會耗費效能，適合不常更新的較高層級父層元件使用

```jsx
import React from "react";

import MyParagraph from "./MyParagraph";

const DemoOutput = (props) => {
  console.log("DemoOutput RUNNING");
  return <MyParagraph>{props.show ? "This is new!" : ""}</MyParagraph>;
};

export default React.memo(DemoOutput);
```

- Button 不適合使用 React.memo，除了是比較低階元件之外
- onClick 指向同一個 function，雖然內容沒有變更，但函式是物件，所以每次 render 都會是新的地址，每次都會當作 props 有更新值
- 可以用 useCallback 來解決這個問題

```jsx
import React, { useState } from "react";

import Button from "./components/UI/Button/Button";
import DemoOutput from "./components/Demo/DemoOutput";

function App() {
  const [showParagraph, setShowParagraph] = useState(false);

  console.log("APP RUNNING");

  const toggleParagraphHandler = () => {
    setShowParagraph((prevShowParagraph) => !prevShowParagraph);
  };

  return (
    <div className='app'>
      <h1>Hi there!</h1>
      <DemoOutput show={false} />
      <Button onClick={toggleParagraphHandler}>Toggle Paragraph!</Button>
    </div>
  );
}

export default App;
```

## useCallback 優化 Functional Component 效能

- 用 useCallback 包裹函式，第二個參數也是一個陣列
- 相依[]空陣列表示永遠不會改變，只會跑一次，若裡面有變數做條件判斷觸發，會因為 closure，變數不會更新

```jsx
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

- 回到剛剛 button 的範例，記住按鈕裡面的onClick參數避免因為函式地址改變重新渲染按鈕

```jsx
import React, { useState, useCallback } from "react";

import Button from "./components/UI/Button/Button";
import DemoOutput from "./components/Demo/DemoOutput";

function App() {
  const [showParagraph, setShowParagraph] = useState(false);

  console.log("APP RUNNING");
  const toggleParagraphHandler = useCallback(() => {
    setShowParagraph((prevShowParagraph) => !prevShowParagraph);
  }, []);

  return (
    <div className='app'>
      <h1>Hi there!</h1>
      <DemoOutput show={false} />
      <Button onClick={toggleParagraphHandler}>Toggle Paragraph!</Button>
    </div>
  );
}

export default App;
```

- 若 toggle 外面有一層判斷，相依參數需要加上 allowToggle
- 若為空陣列則函式本身永遠不會改變而無法觸發

```jsx

import React, { useState, useCallback } from 'react';

import Button from './components/UI/Button/Button';
import DemoOutput from './components/Demo/DemoOutput';

function App() {
  const [showParagraph, setShowParagraph] = useState(false);

  console.log('APP RUNNING');
  const toggleParagraphHandler = useCallback(() => {
    if(allowToggle){
    setShowParagraph((prevShowParagraph) => !prevShowParagraph);
    }
  }, [allowToggle]);

  const allowToggleHandler = () = {
    setAllowToggle(true)
  }

  return (
    <div className="app">
      <h1>Hi there!</h1>
      <DemoOutput show={false} />
       <Button onClick={allowToggleHandler}>Allow Toggle</Button>
      <Button onClick={toggleParagraphHandler}>Toggle Paragraph!</Button>
    </div>
  );
}

export default App;
```

## 每次的 state update 其實是非同步的排程

- 保證順序但不保證立即執行
- 會有 state batching 來優化渲染流程，同一個函式內程式執行完後再統一更新 state ，並判斷哪些元件需要重新渲染

```jsx
const someComponent = () => {
  ...
  const navHandler = (navPath) => {
    // 會把同一個函式的統合一起更新，one schedule
    setCurrentPath(navPath)
    setDrawerIsOpen(false)
  }
}
```

```jsx
const someComponent = () => {
  const [value, setValue] = useState(0);
  // 統一更新，因為batching所以更新後會是1
  const eventHandler = () => {
    setValue(value + 1);
    setValue(value + 1);
    setValue(value + 1);
  };
};
```

## useMemo 優化 Functional Component 效能

- 使用時機：遇到吃效能的運算例如 sort，會希望避免不必要的重新運算
- useMemo 包裹耗能的運算函式，把運算結果放在return後
- 相依參數放陣列裡面，可以用解構賦值把要相依的結果放入[]
```jsx
import React, { useMemo } from 'react';

const DemoList = (props) => {
  // 只取出props裡面的items，但因為傳入是物件所以地址會變
  const { items } = props;

  const sortedList = useMemo(() => {
    console.log('Items sorted');
    return items.sort((a, b) => a - b);
  }, [items]); 
  console.log('DemoList RUNNING');

  return (
    <div className={classes.list}>
      <h2>{props.title}</h2>
      <ul>
        {sortedList.map((item) => (
          <li key={item}>{item}</li>
        ))}
      </ul>
    </div>
  );
};

export default React.memo(DemoList);
```
- 需要在App.js傳入時就做useMemo固定住記憶體地址才有意義
```jsx

function App() {
  const [listTitle, setListTitle] = useState('My List');

  const changeTitleHandler = useCallback(() => {
    setListTitle('New Title');
  }, []);
  // useMemo記住地址，傳下去的listItems才會是同一個物件
  const listItems = useMemo(() => [5, 3, 1, 10, 9], []);

  return (
    <div className="app">
      <DemoList title={listTitle} items={listItems} />
      <Button onClick={changeTitleHandler}>Change List Title</Button>
    </div>
  );
}

export default App;
```
- 不是每個都需要做useMemo，因為也會佔據記憶體，根據經驗跟狀況判斷是否需要使用