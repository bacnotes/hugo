---
title: React的CSS樣式管理方法 ｜The Complete JavaScript Course｜bacnotes備份筆記
description: 說到React的樣式管理就不能不提到Styled Component跟CSS modules，使用Inline Style有什麼壞處呢？讓我們來講解關於React樣式管理的知識吧!
date: 2022-01-13T00:00:00+08:00
draft: true
slug: react-styling
image:
tags:
  - React
---

## 元件該怎麼添加 CSS 樣式?

方法很多種，以下列出來一一介紹

- inline style 直接給他寫上去(最不建議)
- CSS 
- Styled Component(CSS in JS)
- CSS modules（個人prefer)
## inline style 撰寫樣式

```jsx
const Input = props => {
  const [ enteredValue, setEnteredValue ] =useState('')
  const [ isValid, setIsValid ] = useState(true)
  const goalInputChangeHandler = event => {
    setEnteredValue(event.target.value);
  };
  if(enteredValue.trim().length === 0){
    setIsValid(false)
    return
  }
  return(
  <input style ={{ borderColor: isValid ? 'red' : 'Black', background: !isValid ?isValid ? 'red' : 'Black'}} onChange={goalInputChangeHandler}>
  )
}
```

### 為什麼不用 inline style?

看起來還可以動態搭配狀態改變樣式，不是很好嗎？原因有二

- 分散在 html 程式的樣式不好管理
- inline style 會覆蓋掉其他 css 樣式(權重僅次!important)，找改動點更費時

## CSS 撰寫樣式
- 新增css file
- 把剛剛的樣式貼到 CSS file

```css
.invalid {
  border-color: red;
  background: red;
}
```

- inline style 拿掉，使用 className 寫樣式

```js
 <input className={!isValid ? 'invalid' : '' } onChange={goalInputChangeHandler}>
```

### 為什麼不用 CSS 撰寫樣式
- 因為樣式會套用在全域環境，即生效在所有元件上，而大型專案上在className命名的時候很難避免撞名，樣式容易發生衝突
- 所以Styled Component套件誕生了

## Styled Component
- cd到專案資料夾` npm install --save styled-components`

### 
- const Input = styled.<元素名>`CSS樣式`
```jsx
import styled from 'styled-components'

const Input = styled.input`
  .invalid {
    border-color: red;
    background: red;
  }
`
```
### 單一個元件希望用