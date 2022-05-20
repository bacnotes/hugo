---
title: 尚硅谷Vue全家桶筆記 105-｜bacnotes備份筆記
description: 課程包含vue基礎、vue-cli、vue-router、vuex、element-ui、vue3
date: 2022-05-30T00:00:00+08:00
draft: true
slug: vue2-note-3
image: pexels-pixabay-60616.jpg
tags:
  - Vue
---

## Vuex

- 初始化資料 state，配置 actions、mutations，操作文件 store.js
- 元件讀取 vuex state 資料(類似 data)：$store.state.變數
- 元件讀取 vuex getters 加工資料(類似 computed)：$store.getters.變數
- 元件修改 vuex 資料：$store.dispatch('action 中的方法名',資料) 或 $store.commit('mutations 中的方法名',資料)
- 若沒有非同步或其他判斷需求，可以跳過 actions 不 dispatch 直接 commit
- state、actions、mutations 資料跟邏輯都需要註冊在$store，不然沒有意義
- 若在 actions 直接對 state 做操作，開發者工具不會抓到資料，更複雜的透過 API 判斷數據邏輯無法處理

```js
state 管理狀態
  | dispatch 觸發action裡的事件
action 不同事件/方法 (可以處理非同步 e.g. ajax處理)
  | commit 觸發mutation裡面的方法
mutation 改變數據 -- devtools
  |
state 改變
```

### 安裝跟使用 Vuex

- vue2 搭配 vuex3，vue3 搭配 vuex4
- npm i vuex
- 需要引入跟 use vm/vc 才會有$store
- import 位置不影響執行順序，都會先執行 import
- state 保存數據
- action 響應動作，加上一些判斷或是非同步時用
- mutation 修改數據，若沒有需要判斷或計時器也可以直接commit修改
- getters 方便元件取出數據
```js
import Vuex from 'vuex'
Vue.use(Vuex)

const vm = new Vue{{
	el: '#app',
	render: h => h(App),
	store: ''
}}
```

```js
// store/index.js
import Vue from 'vue'
import Vuex from 'vuex'
Vue.use(Vuex)

const actions = {}
const mutations = {}
const states = {}
const getters = {}

// 創建並暴露Store
// 需要先Vue.use(Vuex) 才能new Vuex 不然會報錯
export default new Vuex.Store({
  actions,
  mutations,
  state,
	getters
})
```

```js
//引入Vue核心庫
import Vue from 'vue'
//引入Vuex
import Vuex from 'vuex'
//引用Vuex
Vue.use(Vuex)

const actions = {
    // 響應元件中add的動作 context裡面有commit dispatch state getters
	add(context,value){
		// console.log('actions中的add被調用了',miniStore,value)
		context.commit('ADD',value)
	},
}

const mutations = {
    // 修改state數據
	ADD(state,value){
		// console.log('mutations中的ADD被調用了',state,value)
		state.sum += value
	}
}
 // 對於state數據進行加工 寫成一個函式回傳值
const getters = {
	bigSum(){
		return state.sum * 10
	}
}

// 初始化數據 保存數據
const state = {
   sum: 0
	 school: 'schoolName'
}

// 創建並暴露store
export default new Vuex.Store({
	actions,
	mutations,
	state,
})
```

### mapState mapGetters

- mapState 方法：映射 state 中的數據
- mapGetters 方法：映射 getters 中的数据

```html
<template>
	<div>
		<h1>當前和 {{ sum }}</h1>
		<h3>10倍和 {{ bigSum }}</h3>
		<select> v-model.number="n"
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
		</select>
		<button @click="increment">+</button>
		<button @click="decrement">-</button>
		<button @click="incrementOdd">奇數和+</button>
		<button @click="incrementWait">延後+</button>
	</div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
export default {
	data () {
		return {
			n: 1
		}
	},
	methods: {
		increment () {
			this.$store.commit('ADD', this.n)
		},
		decrement () {
			this.$store.commit('SUBSTRACT', this.n)
		},
		incrementOdd () {
			this.$store.commit('addOdd', this.n)
		},
		incrementWait () {
			this.$store.commit('addWait', this.n)
		}
	},
	computed: {
		sum () {
			return this.$store.state.sum
		},
		school () {
			return this.$store.state.school
		},
		total () {
			return this.$store.state.sum
		},

		// 借助mapState 生成計算屬性 從state讀取數據 obj寫法 若state跟元件變數不同可用這個
		...mapState({total: 'sum'}),

		// 借助mapState 生成計算屬性 從state讀取數據 arr寫法 推薦用這個 變數相同也比較好讀
		...mapState(['sum', 'school']),

		...mapGetters(['bigSum'])
	}
}
</script>
```

### mapAction mapMutation

- mapActions方法：生成和actions對話的方法，即包含$store.dispatch(xxx)的函式
- mapMutations方法：生成与mutations對話的方法，即：包含$store.commit(xxx)的函式
- 傳遞參數需要在模板裡綁定事件時傳，否則參數是預設event

```html
<template>
	<div>
		<h1>當前和 {{ sum }}</h1>
		<h3>10倍和 {{ bigSum }}</h3>
		<select> v-model.number="n"
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
		</select>
		<button @click="increment(n)">+</button>
		<button @click="decrement(n)">-</button>
		<button @click="incrementOdd(n)">奇數和+</button>
		<button @click="incrementWait(n)">延後+</button>
	</div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
export default {
	data () {
		return {
			n: 1
		}
	},
	methods:{
	// mapAction 生成：increment、decrement
	...mapAction({
		increment:'ADD',
		decrement:'SUBSTRACT'
	}),

	// mapActions生成：incrementOdd、incrementWait
	...mapActions([
		incrementOdd: 'addOdd',
		incrementWait: 'addWait'
	]),

  // mapMutation 生成：increment、decrement
  ...mapMutations({
		increment:'ADD',
		decrement:'SUBSTRACT'
	}),

  // mapMutation 生成：ADD、SUBSTRACT
    ...mapMutations([
			'ADD',
			'SUBSTRACT'
		]),
  }
	
	computed: {
		...mapState(['sum', 'school']),

		...mapGetters(['bigSum'])
	}
}
</script>
```
