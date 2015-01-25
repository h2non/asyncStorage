# asyncStore

A fully asynchronous `localStorage` implementation using Web Workers

**Note**: beta implementation. Do not use in production projects

## Installation

Install via npm
```
component install h2non/asyncStore
```

Install via Bower
```
bower install asyncStore
```

Install via Component
```
component install h2non/asyncStore
```

Or loading the script remotely
```html
<script src="//cdn.rawgit.com/h2non/asyncStore/0.1.0/asyncStore"></script>
```

## Browser Support

![Chrome](https://raw.github.com/alrra/browser-logos/master/chrome/chrome_48x48.png) | ![Firefox](https://raw.github.com/alrra/browser-logos/master/firefox/firefox_48x48.png) | ![IE](https://raw.github.com/alrra/browser-logos/master/internet-explorer/internet-explorer_48x48.png) | ![Opera](https://raw.github.com/alrra/browser-logos/master/opera/opera_48x48.png) | ![Safari](https://raw.github.com/alrra/browser-logos/master/safari/safari_48x48.png)
--- | --- | --- | --- | --- |
+23 | +10 | +10 | +15 | +7 |

## Usage

The API is a mirror of [localStorage](http://www.w3.org/TR/webstorage/#storage) with fully asynchronous based on `callbacks`

#### Read

```js
asyncStore.getItem(key, callback)
```

#### Write

```js
asyncStore.setItem(key, value, callback)
```

#### Remove

```js
asyncStore.removeItem(key, callback)
```

#### Clear

```js
asyncStore.clear(callback)
```

#### Length
```js
asyncStore.length // -> 1
```

## License

MIT - Tomas Aparicio
