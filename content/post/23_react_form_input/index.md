---
title: React 如何處理表單元素｜bacnotes備份筆記
description: 控制表單輸入有什麼困難的？除了使用者輸入時，減少畫面不必要的渲染，何時觸發驗證，讓錯誤訊息出現的時機剛剛好。使用Custom Hook複用邏輯在多個表單input，也會讓你的程式碼更好讀。
date: 2022-02-18T00:00:00+08:00
slug: react_input_form
image: pexels-pixabay-261621.jpg
tags:
   - React
---

## 前端驗證時機有三種

### 當使用者點 submit

* 等使用者輸入完所有內容再跳出錯誤訊息
* 沒辦法在輸入完成就告訴使用者有無錯誤，要等到最後，回饋不及時

### 當 input lose focus

* 跳到下一個input時再跳出錯誤訊息
* 回饋即時，但input需紀錄未被點擊過狀態

## 獲取當前表單輸入值

### useState

* 使用 useState 定義初始值跟 set 新值的函式名稱
* 觸發事件，使用 event.target.value 捕捉 input 值
* 適合需要立即驗證、即時捕捉每個 keystroke 的 input

### useRef

* 使用 useRef 綁定指定 DOM input 元素，存在一個變數(通常會命名 xxxRef)
* 觸發事件，透過綁定的變數.current.value 獲取值
* input 初始值可以透過綁定的變數名.current 獲得
* 適合不用獲取每個 keystroke 輸入的 input

```jsx
import { useRef, useState } from "react";

const SimpleInput = (props) => {
  const nameInputRef = useRef();
  const [enteredName, setEnteredName] = useState("");

  const nameInputChangeHandler = (event) => {
    setEnteredName(event.target.value);
  };

  const formSubmissionHandler = (event) => {
    event.preventDefault();
    console.log(enteredName);

    const enteredValue = nameInputRef.current.value;
    console.log(enteredValue);

    // nameInputRef.current.value = ''; => NOT IDEAL, DON'T MANIPULATE THE DOM
    setEnteredName("");
  };

  return (
    <form onSubmit={formSubmissionHandler}>
      <div className='form-control'>
        <label htmlFor='name'>Your Name</label>
        <input
          ref={nameInputRef}
          type='text'
          id='name'
          onChange={nameInputChangeHandler}
          value={enteredName}
        />
      </div>
      <div className='form-actions'>
        <button>Submit</button>
      </div>
    </form>
  );
};

export default SimpleInput;
```

### submit 搭配 keystroke事件 更新表單值驗證

* 驗證內容為確認表單內容不為空白：trim()完後的結果不為空字串，或 if(! 變數.trim())
* 回饋使用者驗證結果：在 input 欄位下方加上 p 的欄位
* 條件渲染顯示 e.g. 使用 nameInputIsInvalid && <p>some err msg</p>，加上 invalid 樣式
* 為了不要太早就呈現出 err msg，多加上一個狀態有無 touched 做判斷
* 新增變數作為錯誤訊息渲染判斷(nameInputIsInvalid)，當不符合驗證且有 touched 過才會顯示，!enteredNameIsValid && enteredNameTouched; 
* 下方範例為 useState 獲取表單值

```jsx
import { useState } from "react";

const SimpleInput = (props) => {
  // 有新的enteredName就會驗證一次是否空白，re-evaluate(重跑下方函式)
  const [enteredName, setEnteredName] = useState("");
  const [enteredNameTouched, setEnteredNameTouched] = useState(false);
  // 驗證是否為空白
  const enteredNameIsValid = enteredName.trim() !== "";
  const nameInputIsInvalid = !enteredNameIsValid && enteredNameTouched;

  const nameInputChangeHandler = (event) => {
    setEnteredName(event.target.value);
  };

  const formSubmissionHandler = (event) => {
    event.preventDefault();
    // 提交後touched狀態改true
    setEnteredNameTouched(true);

    // 沒過驗證
    if (!enteredNameIsValid) {
      return;
    }

    // 過了驗證，還原表格
    setEnteredName("");
    setEnteredNameTouched(false);
  };

  const nameInputClasses = nameInputIsInvalid
    ? "form-control invalid"
    : "form-control";

  return (
    <form onSubmit={formSubmissionHandler}>
      <div className={nameInputClasses}>
        <label htmlFor='name'>Your Name</label>
        <input
          type='text'
          id='name'
          onChange={nameInputChangeHandler}
          value={enteredName}
        />
        {nameInputIsInvalid && (
          <p className='error-text'>Name must not be empty.</p>
        )}
      </div>
      <div className='form-actions'>
        <button>Submit</button>
      </div>
    </form>
  );
};

export default SimpleInput;
```

### 提早在 input lose focus(blur) 時觸發 touched

* 條件渲染錯誤訊息的兩個條件：驗證沒過且 touched 為真
* 除了 submit 有一個 touched 更新為 true，新增一個 blur 監聽更新 touched 狀態
* 當 input blur 事件觸發，更新 touched 狀態為 true

```jsx
import { useState } from 'react';

const SimpleInput = (props) => {
  const [enteredName, setEnteredName] = useState("");
  const [enteredNameTouched, setEnteredNameTouched] = useState(false);

  const enteredNameIsValid = enteredName.trim() !== '';
  const nameInputIsInvalid = !enteredNameIsValid && enteredNameTouched;

  const nameInputChangeHandler = (event) => {
    setEnteredName(event.target.value);
  };

  // 新增這段 blur即touched過
  const nameInputBlurHandler = event => {
    setEnteredNameTouched(true);
  };

  ...

  return (
    <form onSubmit={formSubmissionHandler}>
      <div className={nameInputClasses}>
        <label htmlFor='name'>Your Name</label>
        <input
          type='text'
          id='name'
          onChange={nameInputChangeHandler}
          // blur監聽
          onBlur={nameInputBlurHandler}
          value={enteredName}
        />
        {nameInputIsInvalid && (
          <p className='error-text'>Name must not be empty.</p>
        )}
      </div>
      <div className='form-actions'>
        <button>Submit</button>
      </div>
    </form>
  );
};

export default SimpleInput;
```

### 使用 Custom Hook 管理多個元素驗證

* 一個 input 就寫了這麼多程式碼，那 10 個 input 就...
* 使用上篇文章提到的 Custom Hook，創造一個 input Hook 來處理共同邏輯
* 驗證的邏輯每個 input 可能條件不同，傳入 function 收 input 內容，讓條件彈性化

```jsx
import { useState } from "react";
// 傳入一個validateValue function驗證enteredValue
const useInput = (validateValue) => {
  const [enteredValue, setEnteredValue] = useState("");
  const [isTouched, setIsTouched] = useState(false);

  const valueIsValid = validateValue(enteredValue);
  const hasError = !valueIsValid && isTouched;

  const valueChangeHandler = (event) => {
    setEnteredValue(event.target.value);
  };

  const inputBlurHandler = (event) => {
    setIsTouched(true);
  };

  const reset = () => {
    setEnteredValue("");
    setIsTouched(false);
  };

  return {
    value: enteredValue,
    isValid: valueIsValid,
    hasError,
    valueChangeHandler,
    inputBlurHandler,
    reset,
  };
};

export default useInput;
```

* 引用到元件中

```jsx
import useInput from "../hooks/use-input";
// 驗證邏輯
const isNotEmpty = (value) => value.trim() !== "";
const isEmail = (value) => value.includes("@");

const BasicForm = (props) => {
  // 套用custom hook，取新變數名區隔狀態
  const {
    value: firstNameValue,
    isValid: firstNameIsValid,
    hasError: firstNameHasError,
    valueChangeHandler: firstNameChangeHandler,
    inputBlurHandler: firstNameBlurHandler,
    reset: resetFirstName,
    //驗證邏輯
  } = useInput(isNotEmpty);

  const {
    value: lastNameValue,
    isValid: lastNameIsValid,
    hasError: lastNameHasError,
    valueChangeHandler: lastNameChangeHandler,
    inputBlurHandler: lastNameBlurHandler,
    reset: resetLastName,
    //驗證邏輯
  } = useInput(isNotEmpty);

  const {
    value: emailValue,
    isValid: emailIsValid,
    hasError: emailHasError,
    valueChangeHandler: emailChangeHandler,
    inputBlurHandler: emailBlurHandler,
    reset: resetEmail,
    //驗證邏輯
  } = useInput(isEmail);

  let formIsValid = false;
  // 都過了才可以提交
  if (firstNameIsValid && lastNameIsValid && emailIsValid) {
    formIsValid = true;
  }

  const submitHandler = (event) => {
    event.preventDefault();

    if (!formIsValid) {
      return;
    }

    console.log("Submitted!");
    console.log(firstNameValue, lastNameValue, emailValue);
    //提交後還原狀態
    resetFirstName();
    resetLastName();
    resetEmail();
  };

  // 動態驗證error樣式
  const firstNameClasses = firstNameHasError
    ? "form-control invalid"
    : "form-control";

  const lastNameClasses = lastNameHasError
    ? "form-control invalid"
    : "form-control";

  const emailClasses = emailHasError ? "form-control invalid" : "form-control";

  return (
    <form onSubmit={submitHandler}>
      <div className='control-group'>
        <div className={firstNameClasses}>
          <label htmlFor='name'>First Name</label>
          // value綁定狀態 onChange變更值 onBlur觸發驗證
          <input
            type='text'
            id='name'
            value={firstNameValue}
            onChange={firstNameChangeHandler}
            onBlur={firstNameBlurHandler}
          />
          {firstNameHasError && (
            <p className='error-text'>Please enter a first name.</p>
          )}
        </div>
        <div className={lastNameClasses}>
          <label htmlFor='name'>Last Name</label>
          <input
            type='text'
            id='name'
            value={lastNameValue}
            onChange={lastNameChangeHandler}
            onBlur={lastNameBlurHandler}
          />
          {lastNameHasError && (
            <p className='error-text'>Please enter a last name.</p>
          )}
        </div>
      </div>
      <div className={emailClasses}>
        <label htmlFor='name'>E-Mail Address</label>
        <input
          type='text'
          id='name'
          value={emailValue}
          onChange={emailChangeHandler}
          onBlur={emailBlurHandler}
        />
        {emailHasError && (
          <p className='error-text'>Please enter a valid email address.</p>
        )}
      </div>
      <div className='form-actions'>
        <button disabled={!formIsValid}>Submit</button>
      </div>
    </form>
  );
};

export default SimpleInput;
```
