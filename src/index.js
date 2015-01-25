'use strict'

var thread = require('thread-js')

var asyncStore =
module.exports =
window.asyncStore =
window.asyncStorage = Object.create(AsyncStore.prototype)

AsyncStore.call(asyncStore)

function AsyncStore() {
  AsyncStore.run = runCommand(this)
}

AsyncStore.prototype.constructor = AsyncStore

AsyncStore.prototype.getItem = function (key, cb) {
  AsyncStore.run('get', key, null, cb)
}

AsyncStore.prototype.setItem = function (key, value, cb) {
  cb = commandHandler(incrementLength(this), cb)
  AsyncStore.run('add', key, value, cb)
}

AsyncStore.prototype.removeItem = function (key, cb) {
  cb = commandHandler(crecementLength(this), cb)
  AsyncStore.run('delete', key, null, cb)
}

AsyncStore.prototype.clear = function (cb) {
  AsyncStore.run('clear', null, null, cb)
}

AsyncStore.prototype.length = 0

function commandHandler(action, cb) {
  return function (err, value) {
    if (!err) action()
    cb(err, value)
  }
}

function incrementLength(store) {
  return function () { store.length += 1 }
}

function decrementLength(store) {
  return function () { store.length -= 1 }
}

function createWorker(store) {
  var worker = null
  return function getWorker() {
    if (worker === null) {
      worker = thread({
        evalPath: store.evalPath,
        require: 'https://cdn.rawgit.com/dfahlander/Dexie.js/master/dist/latest/Dexie.js'
      })
    }
    return worker
  }
}

function runCommand(store) {
  var getWorker = createWorker(store)

  return function () {
    var args = toArray(arguments)
    var cb = args.pop() || noop

    getWorker().run(function (operation, key, value, done) {
      var args = [].slice(arguments).slice(1)
      var db = self.db

      if (!db) {
        self.db = db = new Dexie('asyncStorage')
        db.version(1).stores({ pairs: '++id, key, value'})
      }

      db.open().then(function () {
        db.transaction('rw', db.pairs, performTransaction).catch(done)
      }).catch(done)

      function performTransaction() {
        switch (operation) {
          case 'get':
            db.pairs.where('key')
            .equals(key)
            .first()
            .then(function (pair) { done(null, pair.value) })
            .catch(done)
            break
          case 'add':
            db.pairs.add({ key: key, value: value })
            .then(function () { done() })
            .catch(done)
            break
          case 'delete':
            db.pairs.where('key')
            .equals(key)
            .delete()
            .then(function () { done() })
            .catch(done)
            break
          case 'clear':
            db.delete()
            .then(function () { done() })
            .catch(done)
            break
          throw new Error()
        }
      }
    }, args.slice(3)).then(cb).catch(cb)
  }
}

function toArray(args) {
  var arr = new Array(args.length)
  for (var i = 0, l = args.length; i < l; i += 1) {
    arr[i] = args[i]
  }
  return arr
}

function noop() {}
