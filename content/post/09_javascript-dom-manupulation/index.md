---
title: DOM操作基礎知識複習｜bacnotes備份筆記
description: DOM跟HTML不一樣嗎？其實HTML比較像是網頁的設計稿，而DOM是由W3C制定的文件物件模型，我們可以透過DOM提供的一些方法跟屬性操作網頁，像是選取與修改元素值或是監聽事件。這篇會介紹關於JavaScript DOM操作的基礎知識。
date: 2022-01-02T00:00:00+08:00
slug: javascript-dom-manipulation
image: jade-seok-WOv2t_N6iwQ-unsplash.jpg
tags:
  - JavaScript
---

完全沒接觸過 JavaScript 的朋友可以先補足下方知識點再繼續閱讀唷

- [JavaScript 基礎知識複習(1)](https://bacnotes.github.io/p/javascript-fundamentals-part1/ "JavaScript基礎知識複習(1)｜The Complete JavaScript Course")
- [JavaScript 基礎知識複習(2)](https://bacnotes.github.io/p/javascript-fundamentals-part2/ "JavaScript基礎知識複習(2)｜The Complete JavaScript Course")

## Document Object Model(DOM) 是什麼

- 將 HTML 元素變成文件物件模型，由節點 Node 組成的樹狀結構
- 讓 JavaScript 可以修改 HTML 內容跟改變 CSS 樣式(HTML 的 style 屬性)
- DOM 最上方結構是 document 物件，是我們對 DOM 的 entry point
- 節點之間有縱向的父子關係(parent/child)或橫向的兄弟關係(sibling)
- 第一個子元素通常是 HTML(也被稱作根元素)，下方通常有兩個子元素 head 跟 body，互為 sibling
- DOM 方法(e.g. querySelector)跟屬性(e.g. innerHTML)不屬於 JavaScript 這個語言，而是 WebAPIs(瀏覽器上使用 JavaScript 撰寫的 library)的一部分
- 我們可以用 JavaScript 去跟 WebAPIs 互動，像是 timer、fetch API

![dom-tree](1200px-DOM-model.svg.png)

## 選取元素

### 選取單個元素 document.querySelector()

- 回傳相符的第一個元素

```JavaScript
document.querySelector('#id') //id selector
document.querySelector('.classname') //class selector
```

### 選取多個元素 document.querySelectorAll()

- 回傳所有相符的元素於一個 nodeList 類陣列
- 比單個元素多 index 與 length 屬性
- 只能使用部分陣列方法(e.g. forEach, index, length)

```JavaScript
document.querySelectorAll('.classname') // class selector
document.querySelectorAll('li') // type selector
```

### 選取多個元素中特定條件

```JavaScript
// 選取tbody第一行內容
document.querySelectorAll('.className tbody tr')[0]
```

### 選取文字內容 innerHTML v.s. innerText v.s. textContent

下方是一段 HTML

```HTML
<section class="left">
  <input type="number" class="guess" />
  <button class="btn check">Check!</button>
</section>
```

- innerHTML 選取元素下的整個 HTML 結構

```js
console.log(document.querySelector('.left').innerHTML)

<input type="number" class="guess" />
<button class="btn check">Check!</button>
```

- innerText 選取整個 HTML 下可見(非 display:none)的文字
- 會讀取 CSS，效能較差

```JavaScript
console.log(document.querySelector('.left').innerText)
//
           Check!

```

- textContent 選取整個 HTML 下的所有文字(包含空白)
- 不會讀取 CSS，效能較好

```JavaScript
console.log(document.querySelector('.left').textContent)
// Check!
```

### document.querySelector().value 選取表單元素值

```JavaScript
document.querySelector('.className').value;
```

## 修改元素內容

在選取元素後加上 = 即可

```JavaScript
document.querySelector('.className').value = 1
```

## 修改 CSS 樣式

### 修改特定屬性

```JavaScript
// 修改顏色
document.querySelector('body').style.background = '#ffffff'
// 修改寬度
document.querySelector('.number').style.width = '10rem'
```

### 新增/切換/刪除/確認 class

```JavaScript
document.classList.add('hidden');
document.classList.toggle('hidden');
document.classList.remove('hidden');
document.classList.contains('hidden');
```

### 新增/切換/刪除/確認 屬性/回傳屬性值

```JavaScript
document.setAttribute('disable');
document.toggleAttribute('disable');
document.removeAttribute('disable');
document.hasAttribute('disable'); // 是否包含指定屬性 return boolean
document.getAttribute('width'); // 回傳指定屬性值 e.g. 18rem 不存在會回傳null
```

## 設置監聽事件

- 第一個參數為事件，第二個為執行{}內容，第三個是否捕捉冒泡事件
- 第三個參數沒有設定時預設為 false 監聽冒泡事件，設定為 true 監聽捕捉事件

```JavaScript
element.addEventListener(event, function, useCapture)
```

### 滑鼠點擊事件 click

```JavaScript
// 選取按鈕跟呈現訊息元素
const guessButton = document.querySelector('.check')
const message = document.querySelector('.message')
// 用addEventListener監聽guessButton元素上的click事件
guessButton.addEventListener('click', function() {
  console.log('click')
})
```

### 按鍵事件 keydown v.s. keyup v.s. keypress

- keydown 按下去時觸發(不放開會連續觸發)
- keyup 抬起來時觸發
- keypress 按著時觸發(不放開會連續觸發)

```JavaScript
// 任何鍵盤皆可觸發keypress事件
document.addEventListener('keypress', function() {
  console.log('key pressed')
})

// 任何鍵盤皆可觸發keydown事件
document.addEventListener('keydown', function(e) {
  //只在esc按鍵下觸發
  if (e.key === 'Escape') {
    // 在modal"沒有"hidden class下，也就是顯示modal時觸發
    if (!modal.classList.contains('hidden')) {
      console.log('close modal')
    }
  }
})
```

- keycode: 每一個鍵盤都有一個對應的數字，可以到這裡查詢[keycodeInfo](https://keycode.info/ "keycode.info")

### 捕捉特定條件事件

- 監聽觸發事件元素

```JavaScript
if (event.target) {
  console.log('event')
}
```

- 監聽設置在父元素，下面可能有多個子元素，設置 data-\* attribute，符合條件的才觸發

```JavaScript
if (event.target.dataset.id === 變數) {
  console.log('event')
}
```

- 設置 class，偵測有無特定 class 時觸發

```JavaScript
if (!modal.classList.contains('hidden')) {
  console.log('event')
}
```

### 其他常用事件

- dblclick(雙擊滑鼠)
- resize(變更視窗大小)
- select(選取)
- focus(當元素處於 focus 聚焦狀態，e.g. 聚焦在表單某一行 input)
- blur(當元素失去焦點狀態，e.g. 點聚焦元素旁邊內容)
- DOMContentLoaded(HTML 檔案解析完成，樣式表跟外部資源還在下載時)
- scroll(捲軸滾動)
- submit(提交表單)
- mouseover(滑鼠移到目標)
- mouseenter(滑鼠移到目標，不會連續觸發)
- mousemove(滑鼠移動)
- mouseout(滑鼠離開目標)
- mouseleave(滑鼠離開目標，不會冒泡)
- mousedown(按下滑鼠)
- mouseup(滑鼠放開)
- contextmenu(按下滑鼠右鍵)

## 補充

### 早期選取元素的方法

```JavaScript
// 選取ID
document.getElementById('idName')
同 document.querySelector('#idName')

// 選取class name
document.getElementsByClassName('className')
同 document.querySelectorAll('.className')

// 選取HTMLCollection
document.getElementsByTagName('li')
同 document.querySelector('li')

// 選取name 属性的值 在不同瀏覽器的邏輯不同，避免使用
document.getElementsByName()
```

### NodeList v.s. HTMLCollection

- NodeList 為節點的集合，包含 HTML 元素節點和其他節點(e.g. 屬性節點、文字節點等)
- HTMLCollection 為 HTML 元素集合，只有元素節點，不包含其他節點
- HTMLCollection 多一個 nameItem()方法，可以回傳集合中 name 屬性和 id 屬性值的元素
