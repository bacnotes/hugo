---
title: React 使用Custom Hook複用程式碼邏輯｜bacnotes備份筆記
description: 需要複用邏輯時，一般會把重複的程式碼放到一個js檔案 export輸出，在另一個地方透過import引用。Custom Hook也是一樣的道理，只是函式變數需要取名為use開頭，跟其他元件做區隔。Custom Hook可以跨元件共享程式碼邏輯，對於精簡程式碼很有幫助。
date: 2022-02-14T00:00:00+08:00
slug: react-custom-hook
image: pexels-photo-4792079.jpeg
tags:
    - React
---

## 什麼是 Custom Hook?

* Hook 是 React 內建的 JavaScript 函式，而 Custom Hook 就是我們自創的 JavaScript 函式，用來複用程式碼邏輯
* Custom Hook 邏輯共享，但元件獲取到的變數狀態彼此都是獨立的，不用擔心會互相影響

## 如何打造 Custom Hook?

* 在 src 下面創一個 hooks 資料夾，創一個 use 開頭的 js 檔案 e.g. use-counter.js（檔名不一定要 use 開頭，取名 use 開頭是為了方便辨識這是一個 Hook）
* hook 元件裡面的變數一定要 use 開頭

## Hook 使用範例

### 計數器範例

* 條件判斷執行邏輯，預設+1，如果參數為 false 則改為-1

```jsx
import { useState, useEffect } from "react";
// 設定 forwards參數，判斷計算邏輯，且相依下方的useEffect
const useCounter = (forwards = true) => {
  const [counter, setCounter] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      if (forwards) {
        setCounter((prevCounter) => prevCounter + 1);
      } else {
        setCounter((prevCounter) => prevCounter - 1);
      }
    }, 1000);

    return () => clearInterval(interval);
  }, [forwards]);

  return counter;
};

export default useCounter;
```

* 在不同元件裡面 counter 狀態不會互相影響，彼此獨立運作，const [counter, setCounter] = useState(0); 

* 計數器+元件引用計數器 Hook

```jsx
import Card from "./Card";
import useCounter from "../hooks/use-counter";

const ForwardCounter = () => {
  // return的counter狀態存到變數
  const counter = useCounter();
  return <Card>{counter}</Card>;
};

export default ForwardCounter;
```

* 計數器-元件引用計數器 Hook

```jsx
import { useState, useEffect } from "react";
import Card from "./Card";

const BackwardCounter = () => {
  // return的counter狀態存到變數
  const counter = useCounter(false);
  return <Card>{counter}</Card>;
};
```

### http Hook 範例

* http 發送請求時，可以使用 hook 針對不同 url 發送 get/post 等請求
* requestConfig 用物件包裹發送請求參數(url, method, headers, body 等屬性)，彈性設計參數，可用於各種請求
* useCallback 記住 async 記憶體位置，後續放在 dependency 才不會 loop

```jsx
// hook
import { useState, useCallback } from "react";

const useHttp = () => {
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  // 請求參數放於requestConfig物件，元件使用Hook時需要傳入
  // applyData參數傳入元件自己的方法，傳入伺服器回傳的data
  const sendRequest = useCallback(async (requestConfig, applyData) => {
    setIsLoading(true);
    setError(null);
    try {
      const response = await fetch(requestConfig.url, {
        // 有提供參數則套用參數，沒有提供參數則套用預設值
        method: requestConfig.method ? requestConfig.method : "GET",
        headers: requestConfig.headers ? requestConfig.headers : {},
        body: requestConfig.body ? JSON.stringify(requestConfig.body) : null,
      });

      if (!response.ok) {
        throw new Error("Request failed!");
      }

      const data = await response.json();
      applyData(data);
    } catch (err) {
      setError(err.message || "Something went wrong!");
    }
    setIsLoading(false);
  }, []);

  // return isLoading error 的狀態，sendRequest收到的結果
  return {
    isLoading,
    error,
    sendRequest,
  };
};

export default useHttp;
```

* App 元件引用 http Hook
* load 資料庫的 task 內容

```jsx
// app
import React, { useEffect, useState, useCallback } from "react";
import Tasks from "./components/Tasks/Tasks";
import NewTask from "./components/NewTask/NewTask";
import useHttp from "./hooks/use-http";

function App() {
  const [tasks, setTasks] = useState([]);
  // 存return的http狀態跟async function到變數
  // sendRequest取新函式名為fetchTasks，用來指向下方fetchTasks
  const { isLoading, error, sendRequest: fetchTasks } = useHttp();

  useEffect(() => {
    // 把task放到transformTasks管理
    const transformTasks = (tasksObj) => {
      const loadedTasks = [];
      for (const taskKey in tasksObj) {
        loadedTasks.push({ id: taskKey, text: tasksObj[taskKey].text });
      }
      // 陣列任務更新到狀態
      setTasks(loadedTasks);
    };
    // 參數對應的是async(requestConfig, applyData)
    fetchTasks(
      { url: "https://react-http-6b4a6.firebaseio.com/tasks.json" },
      transformTasks
    );
  }, [fetchTasks]);

  const taskAddHandler = (task) => {
    setTasks((prevTasks) => prevTasks.concat(task));
  };

  return (
    <React.Fragment>
      <NewTask onAddTask={taskAddHandler} />
      <Tasks
        items={tasks}
        loading={isLoading}
        error={error}
        onFetch={fetchTasks}
      />
    </React.Fragment>
  );
}

export default App;
```

* 新增 task 使用 http Hook

```jsx
import Section from "../UI/Section";
import TaskForm from "./TaskForm";
import useHttp from "../../hooks/use-http";

const NewTask = (props) => {
  const { isLoading, error, sendRequest: sendTaskRequest } = useHttp();

  const createTask = (taskText, taskData) => {
    const generatedId = taskData.name; // firebase-specific => "name" contains generated id
    const createdTask = { id: generatedId, text: taskText };

    props.onAddTask(createdTask);
  };

  const enterTaskHandler = async (taskText) => {
    // 參數對應的是async(requestConfig, applyData)
    sendTaskRequest(
      {
        url: "https://react-http-6b4a6.firebaseio.com/tasks.json",
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: { text: taskText },
      },
      // 透過bind綁定，第二個參數會變成呼叫這個函式的第一個參數
      // this在這裡不重要所以設定null
      // 上方taskData等其他的參數還是會傳入，這邊只是先預處理
      createTask.bind(null, taskText)
    );
  };

  return (
    <Section>
      <TaskForm onEnterTask={enterTaskHandler} loading={isLoading} />
      {error && <p>{error}</p>}
    </Section>
  );
};
```
對Custom Hook的應用有興趣的話，可以繼續看Custom Hook在表單上的應用
[React 如何處理表單元素](https://bacnotes.github.io/p/react_input_form/)
