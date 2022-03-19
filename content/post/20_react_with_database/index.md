---
title: React 如何與遠端資料庫互動｜bacnotes備份筆記
description: React存取資料庫有什麼需要特別注意的地方嗎？其實跟一般fetch沒有太大的不同，但需要注意每次呼叫函式如何不因重新渲染元件，導致函式記憶體地址改變而開始無限迴圈，使用useCallback跟useEffect搭配fetch更安全，如果不熟悉這個操作的話可以看看這篇介紹唷。
date: 2022-02-07T00:00:00+08:00
slug: react-with-database
image: pexels-panumas-nikhomkhai-1148820.jpg
tags:
  - React
---

## React 如何與資料庫互動

- React 會透過 Backend APP 來存取資料庫
- 由於前端的程式碼透過 devtool 很容易被看光光，直接由前端 APP 存取資料庫等於曝光了資料庫的讀寫入口
- 因此前後端分離，前端透過 API 串接後端資料，除了考量到程式之間的關注點分離外，安全性也比較高

## 使用 fetch API 接收資料

- fetch API 是瀏覽器內建的 API，可以發送 Http 請求或接收 Http 回應
- 搭配 Response.json()方法

```js
response.json().then((data) => {
  // do something with your data
});
```

### 使用 Promise, then 接收 Data

```jsx
function App() {
  const [movies, setMovies] = useState([]);

  function fetchMoviesHandler() {
    // fetch預設為get所以不用寫method
    fetch("https://swapi.dev/api/films/")
      .then((response) => {
        // 使用Response.json()把response body 轉成JavaScript物件並返回一個Promise
        return response.json();
      })
      // Promise需要用then接住 並使用data來抓取裡面的資料
      .then((data) => {
        // 這邊把[{}, {}, {}]物件資料用map迭代取出，map返回一個新陣列
        const transformedMovies = data.results.map((movieData) => {
          // 物件key設定成component裡面的名字（因資料庫欄位名不一定對應）
          return {
            id: movieData.episode_id,
            title: movieData.title,
            openingText: movieData.opening_crawl,
            releaseDate: movieData.release_date,
          };
        });
        setMovies(transformedMovies);
      });
  }

  return (
    <React.Fragment>
      <section>
        <button onClick={fetchMoviesHandler}>Fetch Movies</button>
      </section>
      <section>
        <MoviesList movies={movies} />
      </section>
    </React.Fragment>
  );
}
export default App;
```

### 改寫為 async await 加上錯誤處理

- 搭配 try catch 加上 Loading
- Fetch API doesn't 不會把錯誤狀態代碼 404 視為錯誤，只要有成功回傳就會 200
- 所以我們可以自己加一段判斷在 try 裡面
- 當 Response 有問題拋出錯誤 if (!response.ok && response.status !== 200)
- error 記得也要用 useState 控制

```jsx
function App() {
  const [movies, setMovies] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  async function fetchMoviesHandler() {
    setIsLoading(true);
    try {
      // fetch預設為get所以不用寫method
      const response = await fetch("https://swapi.dev/api/films/");
      // The method returns a promise, so you have to wait for the JSON
      if (!response.ok && response.status !== 200) {
        throw new Error("Something went wrong");
      }
      const data = await response.json();

      const transformedMovies = data.results.map((movieData) => {
        return {
          id: movieData.episode_id,
          title: movieData.title,
          openingText: movieData.opening_crawl,
          releaseDate: movieData.release_date,
        };
      });

      setMovies(transformedMovies);
    } catch (error) {
      setIsLoading(false);
      setError(error.message);
    }
    setIsLoading(false);
  }
  return (
    <React.Fragment>
      <section>
        <button onClick={fetchMoviesHandler}>Fetch Movies</button>
      </section>
      <section>
        // 沒在Loading且有資料顯示MovieList
        {!isLoading && movies.length > 0 && <MoviesList movies={movies} />}
        // 沒在Loading且無資料顯示沒找到電影
        {!isLoading && movies.length === 0 && !error && <p>Found no movies.</p>}
        {!isLoading && error && <p>{error}</p>}
        {isLoading && <p>Loading...</p>}
      </section>
    </React.Fragment>
  );
}
```

- 重構一下程式碼，把 render 的 JSX 變單純一點

```jsx
function App() {
  const [movies, setMovies] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchMoviesHandler = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const response = await fetch("https://swapi.dev/api/films/");
      if (!response.ok) {
        throw new Error("Something went wrong!");
      }

      const data = await response.json();

      const transformedMovies = data.results.map((movieData) => {
        return {
          id: movieData.episode_id,
          title: movieData.title,
          openingText: movieData.opening_crawl,
          releaseDate: movieData.release_date,
        };
      });
      setMovies(transformedMovies);
    } catch (error) {
      setError(error.message);
    }
    setIsLoading(false);
  }, []);

  let content = <p>Found no movies.</p>;

  if (movies.length > 0) {
    content = <MoviesList movies={movies} />;
  }

  if (error) {
    content = <p>{error}</p>;
  }

  if (isLoading) {
    content = <p>Loading...</p>;
  }
  return (
    <React.Fragment>
      <section>
        <button onClick={fetchMoviesHandler}>Fetch Movies</button>
      </section>
      <section>{content}</section>
    </React.Fragment>
  );
}
```

### 使用 useEffect 管理 fetch 方法

- 如果 fetch 方法只需要在渲染元件時執行一次，放在 useEffect 中不讓 re-render 重跑 fetch 即可
- 但若 fetch 方法會跟其他元件一起使用(e.g.點按鈕也會重拉資料），則需放到 useEffect 外，用 useCallback 包裹存成變數(記住記憶體位置)，把再變數放到 useEffect 的 dependencies 中
- 不然點下去按鈕，重新渲染 APP 元件時，函式記憶體位置也會改變，等於 useEffect 的相依參數有更新[fetchMoviesHandler]，再次執行 useEffect，陷入無限無圈

```jsx
function App() {
  const [movies, setMovies] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  // 使用useCallback 記住物件記憶體位置
  const fetchMoviesHandler = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const response = await fetch("https://swapi.dev/api/films/");
      // 也可以只寫一個，但這樣寫比較安全
      if (!response.ok && response.status !== 200) {
        throw new Error("Something went wrong!");
      }

      const data = await response.json();

      const transformedMovies = data.results.map((movieData) => {
        return {
          id: movieData.episode_id,
          title: movieData.title,
          openingText: movieData.opening_crawl,
          releaseDate: movieData.release_date,
        };
      });
      setMovies(transformedMovies);
    } catch (error) {
      setError(error.message);
    }
    setIsLoading(false);
  }, []);

  // 只希望在一開始執行一次，後續fetchMoviesHandler被呼叫會再執行，若fetchMoviesHandler有變(點按鈕)才會執行
  useEffect(() => {
    fetchMoviesHandler();
  }, [fetchMoviesHandler]);

  let content = <p>Found no movies.</p>;

  if (movies.length > 0) {
    content = <MoviesList movies={movies} />;
  }

  if (error) {
    content = <p>{error}</p>;
  }

  if (isLoading) {
    content = <p>Loading...</p>;
  }

  return (
    <React.Fragment>
      <section>
        <button onClick={fetchMoviesHandler}>Fetch Movies</button>
      </section>
      <section>{content}</section>
    </React.Fragment>
  );
}

export default App;
```

## 使用 firebase 作為 backend APP

- 才能夠看到實際來回傳遞資料互動
- 發送請求使用 addMovieHandler(movie)
- 接收請求使用 fetchMoviesHandler

```jsx
function App() {
  const [movies, setMovies] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchMoviesHandler = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      // fetch接收資料的網址也改為firebase，但收到的資料結構會有變
      const response = await fetch(
        "https://react-http-6b4a6.firebaseio.com/movies.json"
      );
      if (!response.ok) {
        throw new Error("Something went wrong!");
      }

      const data = await response.json();
      // 新的資料結構uid{屬性1:值, 屬性2:值...}
      console.log(data);
      const loadedMovies = [];

      // loop所有uid(key)
      for (const key in data) {
        loadedMovies.push({
          id: key,
          title: data[key].title,
          openingText: data[key].openingText,
          releaseDate: data[key].releaseDate,
        });
      }

      setMovies(loadedMovies);
    } catch (error) {
      setError(error.message);
    }
    setIsLoading(false);
  }, []);

  useEffect(() => {
    fetchMoviesHandler();
  }, [fetchMoviesHandler]);

  async function addMovieHandler(movie) {
    // firebase 發送請求網址最後需要加上.json 不然會失敗
    // movies為儲存的資料表
    const response = await fetch(
      "https://react-http-6b4a6.firebaseio.com/movies.json",
      {
        method: "POST",
        // 表單物件轉JSON資料格式
        body: JSON.stringify(movie),
        // 非必要，但對某些restAPI可能需要這個欄位
        headers: {
          "Content-Type": "application/json",
        },
      }
    );
    const data = await response.json();
    console.log(data);
    // 這邊先不處理錯誤 專注於post程式碼
  }

  let content = <p>Found no movies.</p>;

  if (movies.length > 0) {
    content = <MoviesList movies={movies} />;
  }

  if (error) {
    content = <p>{error}</p>;
  }

  if (isLoading) {
    content = <p>Loading...</p>;
  }

  return (
    <React.Fragment>
      <section>
        <AddMovie onAddMovie={addMovieHandler} />
      </section>
      <section>
        <button onClick={fetchMoviesHandler}>Fetch Movies</button>
      </section>
      <section>{content}</section>
    </React.Fragment>
  );
}

export default App;
```

### 伺服器回傳狀態代碼

​​- 瀏覽器會根據 HTTP Status code 判斷目前跟伺服器溝通狀態為何

- 2xx 成功
- 3xx 重新導向
- 4xx 客戶端錯誤
- 5xx 伺服器錯誤
  詳細可以看 POY 大整理的[HTTP 狀態碼一覽表](https://blog.poychang.net/http-status-code/ "HTTP 狀態碼一覽表")

## 補充：REST APIs vs GraphQL APIs

### 相同處

- 傳輸 json 格式資料或其他格式資料
- 沒有限制前後端的語言或框架
- 都是無狀態

### 差異

- 多個 Endpoint v.s. 單個 Endpoint
- 多個方法 Get/Post/Patch/Put/Delete v.s. 單個方法 Post
- Post/user{name: 'Max'} v.s. Post/graphql{query: 'query'}
  (Http Verb/Path{Body}) (Http Verb/Path{Body})
- 資料範圍限制較少 v.s. 容易限制資料範圍
