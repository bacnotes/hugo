---
title: React的CSS樣式管理方法｜bacnotes備份筆記
description: 提到React的樣式，就不得不提到當今趨勢的Styled Component跟CSS modules。這篇會分析四種撰寫樣式方法的優缺點，包含inline style、CSS、Styled Component、CSS modules。
date: 2022-02-02T00:00:00+08:00
slug: react-styling
image: pexels-vlada-karpovich-7025515.jpg
tags:
  - React
---

## 元件該怎麼添加 CSS 樣式?

主要方法有四種：

- Inline style 直接給他寫上去(最難維護)
- CSS(全域套用容易撞名)
- Styled Component(CSS in JS)
- CSS modules(CSS JS 分離)

## inline style 撰寫動態樣式

- useState 來更新有效無效狀態
- 沒效套用紅色，有效套用黑色

```jsx
const Input = props => {
  const [ enteredValue, setEnteredValue ] = useState('')
  const [ isValid, setIsValid ] = useState(true)
  const goalInputChangeHandler = event => {
    setEnteredValue(event.target.value);
  };
  if(enteredValue.trim().length === 0){
    setIsValid(false)
    return
  }
  return(
  <input style ={{ borderColor: !isValid ? 'red' : 'Black', background: !isValid ? 'red' : 'Black'}} onChange={goalInputChangeHandler}>
  )
}
```

### 為什麼不用 inline style 撰寫動態樣式?

- 分散在 html 程式的樣式不好管理
- inline style 會覆蓋掉其他 CSS 樣式(權重僅次!important)，找改動點更費時

## CSS 撰寫動態樣式

- 把剛剛的樣式貼到 CSS file

```CSS
.form-control {
  outline: none;
  background: pink;
  border-corlor: red;
  ...等等其他固定的樣式;
}
.invalid {
  border-color: red;
  background: red;
}
```

- 拿掉 inline style ，動態添加 className
- [上一篇"](https://bacnotes.github.io/p/react-knowledge-101/ "上一篇")有提到 class 是 JavaScript 的保留字，所以不使用 class

```jsx
 // 固定樣式form-control搭配動態樣式isValid
 <input className={`form-control ${!isValid ? 'invalid' : '' }`} onChange={goalInputChangeHandler}>
```

### 為什麼不用 CSS 撰寫動態樣式

- 因為樣式會套用在全域環境，即生效在所有元件上，而大型專案上在 className 命名的時候很難避免撞名，樣式容易發生衝突
- 使用 Styled Component 套件來創造 scoped CSS

## Styled Component 撰寫動態樣式

### 安裝套件跟撰寫方式

- cd 到專案資料夾` npm install --save styled-components`
- const Input = styled.html 元素`CSS樣式` (attacked template literal)
- styled package 有所有 html 元素的方法，透過``可以撰寫多行 CSS 樣式，指定到對應 html 元素當中
- 動態產生獨特 hash

```jsx
import styled from "styled-components";

const Input = styled.input`
  font: inherit;
  padding: 0.5rem 1.5rem;
  // 偽元素選擇器
  &:focus {
    outline: none;
  }
  &:hover,
  &:active {
    background: #ac2342;
  }
`;
```

### 使用 props 動態管理樣式

- 可以拿掉一些不必要的 CSS 樣式(form-control.invalid input 這種聯集的選擇器)

```jsx
import styled from 'styled-components';
const FormControl = styled.div`
  margin: 0.5rem 0;
  &:label {
    font-weight: bold;
    display: block;
    margin-bottom: 0.5rem;
    color: ${props => (props.invalid ? 'red' : 'black')};
  }
  &:input {
    display: block;
    width: 100%;
    border: 1px solid ${props => (props.invalid ? 'red' : '#ccc')};
    background: ${props => (props.invalid ? '#ffd7d7' : 'transparent')};
    font: inherit;
    line-height: 1.5rem;
    padding: 0 0.25rem;
  }
  &:input:focus {
    outline: none;
    background: #fad0ec;
    border-color: #8b005d;
  }
`;

...

return (
    <form onSubmit={formSubmitHandler}>
    // 原本CSS<div className={`form-control ${!isValid ? 'invalid':''}`}>
    // 改成FormControl是一個帶有樣式的 div
    // 動態className改成invalid或valid透過props 布林值決定
      <FormControl invalid={!isValid}>
        <label>Course Goal</label>
        <input type="text" onChange={goalInputChangeHandler} />
      </FormControl>

      <Button type="submit">Add Goal</Button>
    </form>
  );

```

### style component 使用 media queries

```jsx
const Button = styled.button`
  // 手機版展開
  width: 100%;
  font: inherit;
  padding: 0.5rem 1.5rem;
  border: 1px solid #8b005d;
  color: white;
  background: #8b005d;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.26);
  cursor: pointer;

  // 平板變小
  @media (min-width: 768px) {
    width: auto;
  }

  &:focus {
    outline: none;
  }
  &:hover,
  &:active {
    background: #ac0e77;
    border-color: #ac0e77;
    box-shadow: 0 0 8px rgba(0, 0, 0, 0.26);
  }
`;
```

### style component 的優缺點

- 優點：不用想 className 名字了
- 缺點：隨機的 hash 不容易 debug，但透過安裝 babel-plugin-styled-components 可以在瀏覽器看到元件名稱
- 適合喜歡 CSS 跟 JS 邏輯寫在一起的人

## CSS modules

- 不用安裝套件，CRA 本身支援 CSS modules
- 把副檔名.css 檔案改成.module.css，引用路徑也要改
- className = {styles.樣式選擇器名}
- 瀏覽器看到 class 名為：元件名\_class 名\_\_hash，因此不會撞名
- class 名若有橫線`-`連接，寫法需要改成`${style['form-control']}`

```jsx
// import後面的變數名自由命名，會當作物件(整包樣式屬性)傳入，這邊以styles為範例
import styles from "./Button.module.css";

const Button = (props) => {
  return (
    // 這邊
    <button type={props.type} className={styles.button} onClick={props.onClick}>
      {props.children}
    </button>
  );
};
export default Button;
```

### CSS modules 使用 media queries

- 一樣寫在 CSS 檔案就好

```CSS
.button {
  width: 100%;
  font: inherit;
  padding: 0.5rem 1.5rem;
  border: 1px solid #8b005d;
  color: white;
  background: #8b005d;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.26);
  cursor: pointer;
}

.button:focus {
  outline: none;
}

.button:hover,
.button:active {
  background: #ac0e77;
  border-color: #ac0e77;
  box-shadow: 0 0 8px rgba(0, 0, 0, 0.26);
}

@media (min-width: 768px) {
  .button {
    width: auto;
  }
}
```

### CSS modules 的優缺點

- 優點：命名時不用擔心撞名，hash 維持獨特性
- 缺點：需要改副檔名，一開始沒導入後面手動要改比較累一點
- 適合喜歡 CSS 跟 JS 分離的人
