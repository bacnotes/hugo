---
title: 介紹Vue3與Composition API｜bacnotes備份筆記
description: Vue3 Composition API解決了Vue2在同功能程式碼分散於不同option API的可讀性問題，且加入Composition function容易讓程式碼複用，精簡程式碼，雖然有點像React Hook，但用起來較不容易踩到無限迴圈的坑(有種防呆版Hook的感覺)。開始使用setup()開啟你另一段Vue開發人生吧！
date: 2022-02-23T00:00:00+08:00
slug: vue-composition-api
image: Dup9I4d.jpeg
tags:
   - Vue
---

以下內容主要參考自 [Vue JS 3 Tutorial for Beginners #10 - The Composition API](https://www.youtube.com/watch?v=V-kxBWcPJfo "Vue JS 3 Tutorial for Beginners #10 - The Composition API")

## 使用 Composition API 的好處

* Option API 撰寫的程式碼，資料四散在 data、methods、computed、props 等，Composition API 把變數、函式集中在 setup，方便複用邏輯，不需要為了套用到模板就要宣告在 data 或是 computed，直接丟 return 即可
* 提高可讀性，一個功能可能會寫在不同的 option API 區塊，閱讀上不方便，使用 Composition API 可以容易把同一個功能的程式碼整理在一起
* mixin 也可以做到邏輯複用這件事，但有兩個缺點，一是被引用的 mixin 的跟引用的元件之間有隱式依賴，兩者無上下關係，你要重構元件的時候，跟 mixin 有關的東西不好改，因為改了也會影響其他有引用他的元件。
* 第二是裡面的變數可能會撞名，同一個元件裡面有一樣的屬性名稱，元件的變數名稱權重比 mixin 的大，會覆蓋 mixin 的，容易會產生 bug，如果這個 mixin 又是第三方套件的話... 又會更難了，因為程式碼不是你寫的，你可能根本不會想到是這個問題。

## Vue3 的生命週期

Vue3 的生命週期(對應在 Vue2 的生命週期名稱)

* setup(beforeCreate)：初始化 Vue 實例/事件跟生命週期
  -- 尚無法讀取 data, computed, methods, watch/event callbacks
  -- 適合展示loading畫面，不適合fetch資料，還沒有data可以存
* setup(created)：創建完實例(虛擬DOM) 
  -- 設置 data, computed, methods, watch/event callbacks
  -- 尚無法讀取$el，適合 fetch 資料
* onBeforeMount(beforeMount)：尚未掛載模板
  -- 相關 render 函式首次被調用
* onMounted(mounted)：實例掛載模板(真實DOM)
  -- el 被新創建的 vm.$el 替換
* onBeforeUpdate(beforeUpdate)：data 更新但還沒重新渲染畫面
  -- 適合在此更新資料
* onUpdated(updated)：data 更新且渲染畫面完成
  -- 可以取得更新的DOM
* onBeforeUnmount(beforeDestroy)：實例被銷毀前
  -- 適合在此時卸載手動添加的監聽/訂閱
* onUnmounted(destroyed)：實例被銷毀

如果希望在渲染畫面完畢才操作某些函式，在生命週期中使用 vm.$nextTick

### vue3 跟 vue2 混用時，vue3 的生命週期會優先執行

* setup -> beforeCreate -> created -> onBeforeMount -> beforeMount -> onMounted -> mounted -> onBeforeUpdate -> beforeUpdate -> onUpdated -> updated -> onBeforeUnmount -> beforeDestroy -> onUnmounted -> destroyed

* 也可以透過 console.log()觀察順序

```js
< script >
    // @ is an alias to /src
    export default {
        name: "Home",
        components: {},
        // before mounted, before created
        setup() {
            console.log("setup");
        },
        created() {
            console.log("created");
        },
        mounted() {
            console.log("mounted");
        }
        ...
    }; <
/script>
```

## 在 setup()函式定義 data

* setup()可以傳入 props 與 context setup(props, context)，但 script 要記得引入
* props 如果需要解構，使用 toRefs

```js
import {
    toRefs
} from 'vue'
props: {
        title: String
    },
    setup(props) {
        const {
            title
        } = toRefs(props)
        console.log(title.value)
    }
```

* script 執行順序為 setup 函式內容，return 回傳模板所需變數跟方法(data, computed, methods, watch/event)，模板渲染內容
* 過往把要放在模板的變數定義在 data(){}，現在我們改在 setup()使用 ref 跟 reactive 定義資料來獲取響應式資料
* 使用 Option API 的時候常常需要寫 this 指向自己，compositionAPI 幾乎不需要管 this

### template refs

* ref : 可以使用任何型態的資料，在生命週期函式取資料時用變數.value(模板上則不需要.value)不會對 Object 或是 Array 內部的屬性做監聽，適合用於傳值的 primitives 也適合用於單層物件。
* 使用前需要先`import {ref} from vue`
* 雖然可以用於手動改變 DOM 內容，但實務上很少這樣綁定操作
* 下方為使用 primitives 的例子

```vue
<template>
  <div class="home">
    <h1>home</h1>
    <p>My name is {{ name }} and my age is {{ age }}</p>
    <button @click="handleClick">Click</button>
    // 點按鈕age++
    <button @click="age++">add age by 1</button>
    // input text值跟name變數雙向綁定
    <input v-model="name" type="text" />
  </div>
</template>

<script>
// 引用ref方法
import { ref } from "vue";
export default {
  name: "Home",
  components: {},
  setup() {
    let name = ref("mario");
    let age = ref(30);
    // 點按鈕改變值
    const handleClick = () => {
      name.value = "luigi";
      age.value = 35;
    };
    return { name, age, handleClick };
  },
};
</script>
```

* 下方為使用 Object 的例子
* 一樣 click 更新名稱跟年齡，點 add age by 1 年齡加 1，input text 值跟 name 變數雙向綁定

```vue
<template>
  <div class="home">
    <h1>home</h1>
    <p>My name is {{ ninjaOne.name }} and my age is {{ ninjaOne.age }}</p>
    <button @click="ninjaOne.age++">add age by 1</button>
    <button @click="updateClick">Click</button>
  </div>
</template>

<script>
// 引用ref方法
import { ref } from "vue";
export default {
  name: "Home",
  components: {},
  setup() {
    const ninjaOne = ref({ name: "mario", age: 30 });
    const updateClick = () => {
      ninjaOne.value.name = "luigi";
      ninjaOne.value.age = 35;
    };
    return { ninjaOne, updateClick };
  },
};
</script>
```

### template reactive

* reactive : 只接受 Object 或 Array ，可以做深層的監聽，取資料不用 .value，不建議用解構的方式取得內容，會失去 Vue 響應。
* 同上方 Object 例子的內容，一樣 click 更新名稱跟年齡，點 add age by 1 年齡加 1，input text 值跟 name 變數雙向綁定
* 差別在不需要套用 value

```vue
<template>
  <div class="home">
    <h1>home</h1>
    <p>My name is {{ ninjaOne.name }} and my age is {{ ninjaOne.age }}</p>
    <button @click="updateNinjaOne">Click</button>
    <p>My name is {{ ninjaTwo.name }} and my age is {{ ninjaTwo.age }}</p>
    <button @click="updateNinjaTwo">Click</button>
  </div>
</template>

<script>
// 引用ref方法
import { ref, reactive } from "vue";
export default {
  name: "Home",
  components: {},
  setup() {
    const ninjaOne = ref({ name: "mario", age: 30 });
    const ninjaTwo = reactive({ name: "luigi", age: 35 });
    const updateNinjaOne = () => {
      ninjaOne.value.name = "luigi";
      ninjaOne.value.age = 35;
    };
    const updateNinjaTwo = () => {
      ninjaTwo.age = 45;
    };
    return { ninjaOne, ninjaTwo, updateNinjaOne, updateNinjaTwo };
  },
};
</script>
```

## Computed values

* Composition API 一樣可以使用 Computed 來做運算
* 使用前需要`import { computed } from vue`
* 把運算邏輯包裹 Computed 函式，return 運算結果
* 下方範例為 Computed 包裹篩選陣列字詞運算

```vue
<template>
  <div class="home">
    <h1>home</h1>
    // 輸入搜尋字詞
    <input type="text" v-model="search" />
    // 同步顯示搜尋字詞為何
    <p>search term - {{ search }}</p>
    // 輸出符合搜尋字詞的陣列字串
    <div v-for="name in matchingNames" :key="name">{{ name }}</div>
  </div>
</template>

<script>
import { ref, computed } from "vue";
export default {
  name: "Home",
  components: {},
  setup() {
    const search = ref("");
    // 單層物件也可以使用ref觀察變化
    const names = ref([
      "mario",
      "yoshi",
      "luigi",
      "toad",
      "bowser",
      "koopa",
      "peach",
    ]);
    // 篩選相關的搜尋字詞
    const matchingNames = computed(() => {
      return names.value.filter((name) => name.includes(search.value));
    });
    return { names, search, matchingNames };
  },
};
</script>
```

## watch

* watch(監聽 dependency, ()=>{})，當 watch 的 dependency 有變化就執行後面的函式
* 後面執行函式自帶選擇性的使用的兩個參數分別為新值跟舊值
* 監聽深層物件加上第三個參數{deep: true}
* 希望載入就執行需要加上 immediate: true

```js
watch(
    search,
    (newValue, OldValue) => {
        console.log("newValue, OldValue");
        console.log("watch");
    }, {
        deep: true,
        immediate: true
    }
);
```

## watchEffect

* watchEffect(() => {}) 執行函式中的變數會自動添加成 dependency
* 元件初始化就會執行一次，後續 dependency 有變化也會執行

```js
watchEffect(() => {
    console.log("watch");
}, search.value);
```

## watch v.s. watchEffect

* watch 可以明確指定需要依賴的屬性，watchEffect 則是依賴 callback 中使用到的屬性
* watch 可以獲取新舊值，watchEffect 無法
* watch 不會立即執行(除非有寫 immediate: true)，watchEffect 在元件初始化時就會執行一次
* watchEffect 中 dependency 會被重複執行，動態新增加的 dependency 也會被收集

```js
const counter = ref(0);
const enabled = ref(false);
watchEffect(() => {
    if (enabled.value) console.log(counter.value);
    counter.value += 1;
}); //watchEffect 立即執行，enabled是 false 所以dependency只有enabled
counter.value += 1; // 無反應
enabled.value = true; // Effect 觸發，輸出1
counter.value += 1; //counter為dependency，輸出2
enabled.value = false; // 函式重新執行 無輸出
counter.value += 1; // 函式重新執行 無輸出 雖然counter是false 但還是dependency可能會觸發函式
```

### 什麼時候用watch或watchEffect？

[這篇](https://www.zhihu.com/question/462378193 "Vue3 中watch 與watchEffect 有什麼區別？")推薦在大部分時候用 watch 顯式的指定依賴以避免不必要的重複觸發，也避免在後續代碼修改或重構時不小心引入新的 dependency。
watchEffect 適用於一些邏輯相對簡單，dependency 和邏輯強相關的場景

## Vue Composition API 和 React 的 Hooks 的差異

* React Hooks 在每次元件渲染時都會呼叫，需要透過 useEffect 跟 useCallback 相依參數來控制
* Vue 的 setup() 每個元件例項只會在初始化時呼叫一次，狀態通過引用儲存在 setup() 的閉包內， Composition API 中不同的函式可作為迴圈或條件語句的一部分。而 Hook 不能在迴圈或條件語句下使用，因為每一個 Hook 的 next 是指向下一個 Hook，這些操作會改變順序，導致報錯。

```js
function App() {
    const [name, setName] = useState("demo");
    // error
    if (condition) {
        const [val, setVal] = useState("");
    }
}
```

* React Hooks 都在渲染閉包中執行，頻繁的渲染會產生許多閉包，給 GC 帶來不小壓力。Composition API 當值變化時，也不會重新觸發 setup 的執行，每次渲染不會反覆呼叫函式，減少 GC 壓力
* Hook 若沒有設置正確的 dependency，設置在閉包的值會不變，Vue 的自動依賴跟嚮應式設計可以正確追蹤資料
* 不需要總是使用 useCallback 來快取傳給子元件的 callback 以防止過度更新
