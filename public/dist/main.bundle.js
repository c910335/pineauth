/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "/dist";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _amber = __webpack_require__(1);

var _amber2 = _interopRequireDefault(_amber);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

/***/ }),
/* 1 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var EVENTS = {
  join: 'join',
  leave: 'leave',
  message: 'message'
};
var STALE_CONNECTION_THRESHOLD_SECONDS = 100;
var SOCKET_POLLING_RATE = 10000;

/**
 * Returns a numeric value for the current time
 */
var now = function now() {
  return new Date().getTime();
};

/**
 * Returns the difference between the current time and passed `time` in seconds
 * @param {Number|Date} time - A numeric time or date object
 */
var secondsSince = function secondsSince(time) {
  return (now() - time) / 1000;
};

/**
 * Class for channel related functions (joining, leaving, subscribing and sending messages)
 */

var Channel = exports.Channel = function () {
  /**
   * @param {String} topic - topic to subscribe to
   * @param {Socket} socket - A Socket instance
   */
  function Channel(topic, socket) {
    _classCallCheck(this, Channel);

    this.topic = topic;
    this.socket = socket;
    this.onMessageHandlers = [];
  }

  /**
   * Join a channel, subscribe to all channels messages
   */


  _createClass(Channel, [{
    key: 'join',
    value: function join() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.join, topic: this.topic }));
    }

    /**
     * Leave a channel, stop subscribing to channel messages
     */

  }, {
    key: 'leave',
    value: function leave() {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.leave, topic: this.topic }));
    }

    /**
     * Calls all message handlers with a matching subject
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      this.onMessageHandlers.forEach(function (handler) {
        if (handler.subject === msg.subject) handler.callback(msg.payload);
      });
    }

    /**
     * Subscribe to a channel subject
     * @param {String} subject - subject to listen for: `msg:new`
     * @param {function} callback - callback function when a new message arrives
     */

  }, {
    key: 'on',
    value: function on(subject, callback) {
      this.onMessageHandlers.push({ subject: subject, callback: callback });
    }

    /**
     * Send a new message to the channel
     * @param {String} subject - subject to send message to: `msg:new`
     * @param {Object} payload - payload object: `{message: 'hello'}`
     */

  }, {
    key: 'push',
    value: function push(subject, payload) {
      this.socket.ws.send(JSON.stringify({ event: EVENTS.message, topic: this.topic, subject: subject, payload: payload }));
    }
  }]);

  return Channel;
}();

/**
 * Class for maintaining connection with server and maintaining channels list
 */


var Socket = exports.Socket = function () {
  /**
   * @param {String} endpoint - Websocket endpont used in routes.cr file
   */
  function Socket(endpoint) {
    _classCallCheck(this, Socket);

    this.endpoint = endpoint;
    this.ws = null;
    this.channels = [];
    this.lastPing = now();
    this.reconnectTries = 0;
    this.attemptReconnect = true;
  }

  /**
   * Returns whether or not the last received ping has been past the threshold
   */


  _createClass(Socket, [{
    key: '_connectionIsStale',
    value: function _connectionIsStale() {
      return secondsSince(this.lastPing) > STALE_CONNECTION_THRESHOLD_SECONDS;
    }

    /**
     * Tries to reconnect to the websocket server using a recursive timeout
     */

  }, {
    key: '_reconnect',
    value: function _reconnect() {
      var _this = this;

      clearTimeout(this.reconnectTimeout);
      this.reconnectTimeout = setTimeout(function () {
        _this.reconnectTries++;
        _this.connect(_this.params);
        _this._reconnect();
      }, this._reconnectInterval());
    }

    /**
     * Returns an incrementing timeout interval based around the number of reconnection retries
     */

  }, {
    key: '_reconnectInterval',
    value: function _reconnectInterval() {
      return [1000, 2000, 5000, 10000][this.reconnectTries] || 10000;
    }

    /**
     * Sets a recursive timeout to check if the connection is stale
     */

  }, {
    key: '_poll',
    value: function _poll() {
      var _this2 = this;

      this.pollingTimeout = setTimeout(function () {
        if (_this2._connectionIsStale()) {
          _this2._reconnect();
        } else {
          _this2._poll();
        }
      }, SOCKET_POLLING_RATE);
    }

    /**
     * Clear polling timeout and start polling
     */

  }, {
    key: '_startPolling',
    value: function _startPolling() {
      clearTimeout(this.pollingTimeout);
      this._poll();
    }

    /**
     * Sets `lastPing` to the curent time
     */

  }, {
    key: '_handlePing',
    value: function _handlePing() {
      this.lastPing = now();
    }

    /**
     * Clears reconnect timeout, resets variables an starts polling
     */

  }, {
    key: '_reset',
    value: function _reset() {
      clearTimeout(this.reconnectTimeout);
      this.reconnectTries = 0;
      this.attemptReconnect = true;
      this._startPolling();
    }

    /**
     * Connect the socket to the server, and binds to native ws functions
     * @param {Object} params - Optional parameters
     * @param {String} params.location - Hostname to connect to, defaults to `window.location.hostname`
     * @param {String} parmas.port - Port to connect to, defaults to `window.location.port`
     * @param {String} params.protocol - Protocol to use, either 'wss' or 'ws'
     */

  }, {
    key: 'connect',
    value: function connect(params) {
      var _this3 = this;

      this.params = params;

      var opts = {
        location: window.location.hostname,
        port: window.location.port,
        protocol: window.location.protocol === 'https:' ? 'wss:' : 'ws:'
      };

      if (params) Object.assign(opts, params);
      if (opts.port) opts.location += ':' + opts.port;

      return new Promise(function (resolve, reject) {
        _this3.ws = new WebSocket(opts.protocol + '//' + opts.location + _this3.endpoint);
        _this3.ws.onmessage = function (msg) {
          _this3.handleMessage(msg);
        };
        _this3.ws.onclose = function () {
          if (_this3.attemptReconnect) _this3._reconnect();
        };
        _this3.ws.onopen = function () {
          _this3._reset();
          resolve();
        };
      });
    }

    /**
     * Closes the socket connection permanently
     */

  }, {
    key: 'disconnect',
    value: function disconnect() {
      this.attemptReconnect = false;
      clearTimeout(this.pollingTimeout);
      clearTimeout(this.reconnectTimeout);
      this.ws.close();
    }

    /**
     * Adds a new channel to the socket channels list
     * @param {String} topic - Topic for the channel: `chat_room:123`
     */

  }, {
    key: 'channel',
    value: function channel(topic) {
      var channel = new Channel(topic, this);
      this.channels.push(channel);
      return channel;
    }

    /**
     * Message handler for messages received
     * @param {MessageEvent} msg - Message received from ws
     */

  }, {
    key: 'handleMessage',
    value: function handleMessage(msg) {
      if (msg.data === "ping") return this._handlePing();

      var parsed_msg = JSON.parse(msg.data);
      this.channels.forEach(function (channel) {
        if (channel.topic === parsed_msg.topic) channel.handleMessage(parsed_msg);
      });
    }
  }]);

  return Socket;
}();

module.exports = {
  Socket: Socket
};

/***/ })
/******/ ]);
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgNmZlZTg1ZGM2MjRlMDM0ZjhjOWYiLCJ3ZWJwYWNrOi8vLy4vc3JjL2Fzc2V0cy9qYXZhc2NyaXB0cy9tYWluLmpzIiwid2VicGFjazovLy8uL2xpYi9hbWJlci9hc3NldHMvanMvYW1iZXIuanMiXSwibmFtZXMiOlsiRVZFTlRTIiwiam9pbiIsImxlYXZlIiwibWVzc2FnZSIsIlNUQUxFX0NPTk5FQ1RJT05fVEhSRVNIT0xEX1NFQ09ORFMiLCJTT0NLRVRfUE9MTElOR19SQVRFIiwibm93IiwiRGF0ZSIsImdldFRpbWUiLCJzZWNvbmRzU2luY2UiLCJ0aW1lIiwiQ2hhbm5lbCIsInRvcGljIiwic29ja2V0Iiwib25NZXNzYWdlSGFuZGxlcnMiLCJ3cyIsInNlbmQiLCJKU09OIiwic3RyaW5naWZ5IiwiZXZlbnQiLCJtc2ciLCJmb3JFYWNoIiwiaGFuZGxlciIsInN1YmplY3QiLCJjYWxsYmFjayIsInBheWxvYWQiLCJwdXNoIiwiU29ja2V0IiwiZW5kcG9pbnQiLCJjaGFubmVscyIsImxhc3RQaW5nIiwicmVjb25uZWN0VHJpZXMiLCJhdHRlbXB0UmVjb25uZWN0IiwiY2xlYXJUaW1lb3V0IiwicmVjb25uZWN0VGltZW91dCIsInNldFRpbWVvdXQiLCJjb25uZWN0IiwicGFyYW1zIiwiX3JlY29ubmVjdCIsIl9yZWNvbm5lY3RJbnRlcnZhbCIsInBvbGxpbmdUaW1lb3V0IiwiX2Nvbm5lY3Rpb25Jc1N0YWxlIiwiX3BvbGwiLCJfc3RhcnRQb2xsaW5nIiwib3B0cyIsImxvY2F0aW9uIiwid2luZG93IiwiaG9zdG5hbWUiLCJwb3J0IiwicHJvdG9jb2wiLCJPYmplY3QiLCJhc3NpZ24iLCJQcm9taXNlIiwicmVzb2x2ZSIsInJlamVjdCIsIldlYlNvY2tldCIsIm9ubWVzc2FnZSIsImhhbmRsZU1lc3NhZ2UiLCJvbmNsb3NlIiwib25vcGVuIiwiX3Jlc2V0IiwiY2xvc2UiLCJjaGFubmVsIiwiZGF0YSIs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Q0Q7O0FBRUQ7Ozs7Ozs7NEJBSVFqRCxLLEVBQU87QUFDYixVQUFJa0QsVUFBVSxJQUFJbkQsT0FBSixDQUFZQyxLQUFaLEVBQW1CLElBQW5CLENBQWQ7QUFDQSxXQUFLaUIsUUFBTCxDQUFjSCxJQUFkLENBQW1Cb0MsT0FBbkI7QUFDQSxhQUFPQSxPQUFQO0FBQ0Q7O0FBRUQ7Ozs7Ozs7a0NBSWMxQyxHLEVBQUs7QUFDakIsVUFBSUEsSUFBSTJDLElBQUosS0FBYSxNQUFqQixFQUF5QixPQUFPLEtBQUtDLFdBQUwsRUFBUDs7QUFFekIsVUFBSUMsYUFBYWhELEtBQUtpRCxLQUFMLENBQVc5QyxJQUFJMkMsSUFBZixDQUFqQjtBQUNBLFdBQUtsQyxRQUFMLENBQWNSLE9BQWQsQ0FBc0IsVUFBQ3lDLE9BQUQsRUFBYTtBQUNqQyxZQUFJQSxRQUFRbEQsS0FBUixLQUFrQnFELFdBQVdyRCxLQUFqQyxFQUF3Q2tELFFBQVFMLGFBQVIsQ0FBc0JRLFVBQXRCO0FBQ3pDLE9BRkQ7QUFHRDs7Ozs7O0FBR0hFLE9BQU9DLE9BQVAsR0FBaUI7QUFDZnpDLFVBQVFBO0FBRE8sQ0FBakIsQyIsImZpbGUiOiJtYWluLmJ1bmRsZS5qcyIsInNvdXJjZXNDb250ZW50IjpbIiBcdC8vIFRoZSBtb2R1bGUgY2FjaGVcbiBcdHZhciBpbnN0YWxsZWRNb2R1bGVzID0ge307XG5cbiBcdC8vIFRoZSByZXF1aXJlIGZ1bmN0aW9uXG4gXHRmdW5jdGlvbiBfX3dlYnBhY2tfcmVxdWlyZV9fKG1vZHVsZUlkKSB7XG5cbiBcdFx0Ly8gQ2hlY2sgaWYgbW9kdWxlIGlzIGluIGNhY2hlXG4gXHRcdGlmKGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdKSB7XG4gXHRcdFx0cmV0dXJuIGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdLmV4cG9ydHM7XG4gXHRcdH1cbiBcdFx0Ly8gQ3JlYXRlIGEgbmV3IG1vZHVsZSAoYW5kIHB1dCBpdCBpbnRvIHRoZSBjYWNoZSlcbiBcdFx0dmFyIG1vZHVsZSA9IGluc3RhbGxlZE1vZHVsZXNbbW9kdWxlSWRdID0ge1xuIFx0XHRcdGk6IG1vZHVsZUlkLFxuIFx0XHRcdGw6IGZhbHNlLFxuIFx0XHRcdGV4cG9ydHM6IHt9XG4gXHRcdH07XG5cbiBcdFx0Ly8gRXhlY3V0ZSB0aGUgbW9kdWxlIGZ1bmN0aW9uXG4gXHRcdG1vZHVsZXNbbW9kdWxlSWRdLmNhbGwobW9kdWxlLmV4cG9ydHMsIG1vZHVsZSwgbW9kdWxlLmV4cG9ydHMsIF9fd2VicGFja19yZXF1aXJlX18pO1xuXG4gXHRcdC8vIEZsYWcgdGhlIG1vZHVsZSBhcyBsb2FkZWRcbiBcdFx0bW9kdWxlLmwgPSB0cnVlO1xuXG4gXHRcdC8vIFJldHVybiB0aGUgZXhwb3J0cyBvZiB0aGUgbW9kdWxlXG4gXHRcdHJldHVybiBtb2R1bGUuZXhwb3J0cztcbiBcdH1cblxuXG4gXHQvLyBleHBvc2UgdGhlIG1vZHVsZXMgb2JqZWN0IChfX3dlYnBhY2tfbW9kdWxlc19fKVxuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5tID0gbW9kdWxlcztcblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGUgY2FjaGVcbiBcdF9fd2VicGFja19yZXF1aXJlX18uYyA9IGluc3RhbGxlZE1vZHVsZXM7XG5cbiBcdC8vIGRlZmluZSBnZXR0ZXIgZnVuY3Rpb24gZm9yIGhhcm1vbnkgZXhwb3J0c1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5kID0gZnVuY3Rpb24oZXhwb3J0cywgbmFtZSwgZ2V0dGVyKSB7XG4gXHRcdGlmKCFfX3dlYnBhY2tfcmVxdWlyZV9fLm8oZXhwb3J0cywgbmFtZSkpIHtcbiBcdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkoZXhwb3J0cywgbmFtZSwge1xuIFx0XHRcdFx0Y29uZmlndXJhYmxlOiBmYWxzZSxcbiBcdFx0XHRcdGVudW1lcmFibGU6IHRydWUsXG4gXHRcdFx0XHRnZXQ6IGdldHRlclxuIFx0XHRcdH0pO1xuIFx0XHR9XG4gXHR9O1xuXG4gXHQvLyBnZXREZWZhdWx0RXhwb3J0IGZ1bmN0aW9uIGZvciBjb21wYXRpYmlsaXR5IHdpdGggbm9uLWhhcm1vbnkgbW9kdWxlc1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5uID0gZnVuY3Rpb24obW9kdWxlKSB7XG4gXHRcdHZhciBnZXR0ZXIgPSBtb2R1bGUgJiYgbW9kdWxlLl9fZXNNb2R1bGUgP1xuIFx0XHRcdGZ1bmN0aW9uIGdldERlZmF1bHQoKSB7IHJldHVybiBtb2R1bGVbJ2RlZmF1bHQnXTsgfSA6XG4gXHRcdFx0ZnVuY3Rpb24gZ2V0TW9kdWxlRXhwb3J0cygpIHsgcmV0dXJuIG1vZHVsZTsgfTtcbiBcdFx0X193ZWJwYWNrX3JlcXVpcmVfXy5kKGdldHRlciwgJ2EnLCBnZXR0ZXIpO1xuIFx0XHRyZXR1cm4gZ2V0dGVyO1xuIFx0fTtcblxuIFx0Ly8gT2JqZWN0LnByb3RvdHlwZS5oYXNPd25Qcm9wZXJ0eS5jYWxsXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLm8gPSBmdW5jdGlvbihvYmplY3QsIHByb3BlcnR5KSB7IHJldHVybiBPYmplY3QucHJvdG90eXBlLmhhc093blByb3BlcnR5LmNhbGwob2JqZWN0LCBwcm9wZXJ0eSk7IH07XG5cbiBcdC8vIF9fd2VicGFja19wdWJsaWNfcGF0aF9fXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLnAgPSBcIi9kaXN0XCI7XG5cbiBcdC8vIExvYWQgZW50cnkgbW9kdWxlIGFuZCByZXR1cm4gZXhwb3J0c1xuIFx0cmV0dXJuIF9fd2VicGFja19yZXF1aXJlX18oX193ZWJwYWNrX3JlcXVpcmVfXy5zID0gMCk7XG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gd2VicGFjay9ib290c3RyYXAgNmZlZTg1ZGM2MjRlMDM0ZjhjOWYiLCJpbXBvcnQgQW1iZXIgZnJvbSAnYW1iZXInXG5cblxuXG5cbi8vIFdFQlBBQ0sgRk9PVEVSIC8vXG4vLyAuL3NyYy9hc3NldHMvamF2YXNjcmlwdHMvbWFpbi5qcyIsImNvbnN0IEVWRU5UUyA9IHtcbiAgam9pbjogJ2pvaW4nLFxuICBsZWF2ZTogJ2xlYXZlJyxcbiAgbWVzc2FnZTogJ21lc3NhZ2UnXG59XG5jb25zdCBTVEFMRV9DT05ORUNUSU9OX1RIUkVTSE9MRF9TRUNPTkRTID0gMTAwXG5jb25zdCBTT0NLRVRfUE9MTElOR19SQVRFID0gMTAwMDBcblxuLyoqXG4gKiBSZXR1cm5zIGEgbnVtZXJpYyB2YWx1ZSBmb3IgdGhlIGN1cnJlbnQgdGltZVxuICovXG5sZXQgbm93ID0gKCkgPT4ge1xuICByZXR1cm4gbmV3IERhdGUoKS5nZXRUaW1lKClcbn1cblxuLyoqXG4gKiBSZXR1cm5zIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gdGhlIGN1cnJlbnQgdGltZSBhbmQgcGFzc2VkIGB0aW1lYCBpbiBzZWNvbmRzXG4gKiBAcGFyYW0ge051bWJlcnxEYXRlfSB0aW1lIC0gQSBudW1lcmljIHRpbWUgb3IgZGF0ZSBvYmplY3RcbiAqL1xubGV0IHNlY29uZHNTaW5jZSA9ICh0aW1lKSA9PiB7XG4gIHJldHVybiAobm93KCkgLSB0aW1lKSAvIDEwMDBcbn1cblxuLyoqXG4gKiBDbGFzcyBmb3IgY2hhbm5lbCByZWxhdGVkIGZ1bmN0aW9ucyAoam9pbmluZywgbGVhdmluZywgc3Vic2NyaWJpbmcgYW5kIHNlbmRpbmcgbWVzc2FnZXMpXG4gKi9cbmV4cG9ydCBjbGFzcyBDaGFubmVsIHtcbiAgLyoqXG4gICAqIEBwYXJhbSB7U3RyaW5nfSB0b3BpYyAtIHRvcGljIHRvIHN1YnNjcmliZSB0b1xuICAgKiBAcGFyYW0ge1NvY2tldH0gc29ja2V0IC0gQSBTb2NrZXQgaW5zdGFuY2VcbiAgICovXG4gIGNvbnN0cnVjdG9yKHRvcGljLCBzb2NrZXQpIHtcbiAgICB0aGlzLnRvcGljID0gdG9waWNcbiAgICB0aGlzLnNvY2tldCA9IHNvY2tldFxuICAgIHRoaXMub25NZXNzYWdlSGFuZGxlcnMgPSBbXVxuICB9XG5cbiAgLyoqXG4gICAqIEpvaW4gYSBjaGFubmVsLCBzdWJzY3JpYmUgdG8gYWxsIGNoYW5uZWxzIG1lc3NhZ2VzXG4gICAqL1xuICBqb2luKCkge1xuICAgIHRoaXMuc29ja2V0LndzLnNlbmQoSlNPTi5zdHJpbmdpZnkoeyBldmVudDogRVZFTlRTLmpvaW4sIHRvcGljOiB0aGlzLnRvcGljIH0pKVxuICB9XG5cbiAgLyoqXG4gICAqIExlYXZlIGEgY2hhbm5lbCwgc3RvcCBzdWJzY3JpYmluZyB0byBjaGFubmVsIG1lc3NhZ2VzXG4gICAqL1xuICBsZWF2ZSgpIHtcbiAgICB0aGlzLnNvY2tldC53cy5zZW5kKEpTT04uc3RyaW5naWZ5KHsgZXZlbnQ6IEVWRU5UUy5sZWF2ZSwgdG9waWM6IHRoaXMudG9waWMgfSkpXG4gIH1cblxuICAvKipcbiAgICogQ2FsbHMgYWxsIG1lc3NhZ2UgaGFuZGxlcnMgd2l0aCBhIG1hdGNoaW5nIHN1YmplY3RcbiAgICovXG4gIGhhbmRsZU1lc3NhZ2UobXNnKSB7XG4gICAgdGhpcy5vbk1lc3NhZ2VIYW5kbGVycy5mb3JFYWNoKChoYW5kbGVyKSA9PiB7XG4gICAgICBpZiAoaGFuZGxlci5zdWJqZWN0ID09PSBtc2cuc3ViamVjdCkgaGFuZGxlci5jYWxsYmFjayhtc2cucGF5bG9hZClcbiAgICB9KVxuICB9XG5cbiAgLyoqXG4gICAqIFN1YnNjcmliZSB0byBhIGNoYW5uZWwgc3ViamVjdFxuICAgKiBAcGFyYW0ge1N0cmluZ30gc3ViamVjdCAtIHN1YmplY3QgdG8gbGlzdGVuIGZvcjogYG1zZzpuZXdgXG4gICAqIEBwYXJhbSB7ZnVuY3Rpb259IGNhbGxiYWNrIC0gY2FsbGJhY2sgZnVuY3Rpb24gd2hlbiBhIG5ldyBtZXNzYWdlIGFycml2ZXNcbiAgICovXG4gIG9uKHN1YmplY3QsIGNhbGxiYWNrKSB7XG4gICAgdGhpcy5vbk1lc3NhZ2VIYW5kbGVycy5wdXNoKHsgc3ViamVjdDogc3ViamVjdCwgY2FsbGJhY2s6IGNhbGxiYWNrIH0pXG4gIH1cblxuICAvKipcbiAgICogU2VuZCBhIG5ldyBtZXNzYWdlIHRvIHRoZSBjaGFubmVsXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBzdWJqZWN0IC0gc3ViamVjdCB0byBzZW5kIG1lc3NhZ2UgdG86IGBtc2c6bmV3YFxuICAgKiBAcGFyYW0ge09iamVjdH0gcGF5bG9hZCAtIHBheWxvYWQgb2JqZWN0OiBge21lc3NhZ2U6ICdoZWxsbyd9YFxuICAgKi9cbiAgcHVzaChzdWJqZWN0LCBwYXlsb2FkKSB7XG4gICAgdGhpcy5zb2NrZXQud3Muc2VuZChKU09OLnN0cmluZ2lmeSh7IGV2ZW50OiBFVkVOVFMubWVzc2FnZSwgdG9waWM6IHRoaXMudG9waWMsIHN1YmplY3Q6IHN1YmplY3QsIHBheWxvYWQ6IHBheWxvYWQgfSkpXG4gIH1cbn1cblxuLyoqXG4gKiBDbGFzcyBmb3IgbWFpbnRhaW5pbmcgY29ubmVjdGlvbiB3aXRoIHNlcnZlciBhbmQgbWFpbnRhaW5pbmcgY2hhbm5lbHMgbGlzdFxuICovXG5leHBvcnQgY2xhc3MgU29ja2V0IHtcbiAgLyoqXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBlbmRwb2ludCAtIFdlYnNvY2tldCBlbmRwb250IHVzZWQgaW4gcm91dGVzLmNyIGZpbGVcbiAgICovXG4gIGNvbnN0cnVjdG9yKGVuZHBvaW50KSB7XG4gICAgdGhpcy5lbmRwb2ludCA9IGVuZHBvaW50XG4gICAgdGhpcy53cyA9IG51bGxcbiAgICB0aGlzLmNoYW5uZWxzID0gW11cbiAgICB0aGlzLmxhc3RQaW5nID0gbm93KClcbiAgICB0aGlzLnJlY29ubmVjdFRyaWVzID0gMFxuICAgIHRoaXMuYXR0ZW1wdFJlY29ubmVjdCA9IHRydWVcbiAgfVxuXG4gIC8qKlxuICAgKiBSZXR1cm5zIHdoZXRoZXIgb3Igbm90IHRoZSBsYXN0IHJlY2VpdmVkIHBpbmcgaGFzIGJlZW4gcGFzdCB0aGUgdGhyZXNob2xkXG4gICAqL1xuICBfY29ubmVjdGlvbklzU3RhbGUoKSB7XG4gICAgcmV0dXJuIHNlY29uZHNTaW5jZSh0aGlzLmxhc3RQaW5nKSA+IFNUQUxFX0NPTk5FQ1RJT05fVEhSRVNIT0xEX1NFQ09ORFNcbiAgfVxuXG4gIC8qKlxuICAgKiBUcmllcyB0byByZWNvbm5lY3QgdG8gdGhlIHdlYnNvY2tldCBzZXJ2ZXIgdXNpbmcgYSByZWN1cnNpdmUgdGltZW91dFxuICAgKi9cbiAgX3JlY29ubmVjdCgpIHtcbiAgICBjbGVhclRpbWVvdXQodGhpcy5yZWNvbm5lY3RUaW1lb3V0KVxuICAgIHRoaXMucmVjb25uZWN0VGltZW91dCA9IHNldFRpbWVvdXQoKCkgPT4ge1xuICAgICAgdGhpcy5yZWNvbm5lY3RUcmllcysrXG4gICAgICB0aGlzLmNvbm5lY3QodGhpcy5wYXJhbXMpXG4gICAgICB0aGlzLl9yZWNvbm5lY3QoKVxuICAgIH0sIHRoaXMuX3JlY29ubmVjdEludGVydmFsKCkpXG4gIH1cblxuICAvKipcbiAgICogUmV0dXJucyBhbiBpbmNyZW1lbnRpbmcgdGltZW91dCBpbnRlcnZhbCBiYXNlZCBhcm91bmQgdGhlIG51bWJlciBvZiByZWNvbm5lY3Rpb24gcmV0cmllc1xuICAgKi9cbiAgX3JlY29ubmVjdEludGVydmFsKCkge1xuICAgIHJldHVybiBbMTAwMCwgMjAwMCwgNTAwMCwgMTAwMDBdW3RoaXMucmVjb25uZWN0VHJpZXNdIHx8IDEwMDAwXG4gIH1cblxuICAvKipcbiAgICogU2V0cyBhIHJlY3Vyc2l2ZSB0aW1lb3V0IHRvIGNoZWNrIGlmIHRoZSBjb25uZWN0aW9uIGlzIHN0YWxlXG4gICAqL1xuICBfcG9sbCgpIHtcbiAgICB0aGlzLnBvbGxpbmdUaW1lb3V0ID0gc2V0VGltZW91dCgoKSA9PiB7XG4gICAgICBpZiAodGhpcy5fY29ubmVjdGlvbklzU3RhbGUoKSkge1xuICAgICAgICB0aGlzLl9yZWNvbm5lY3QoKVxuICAgICAgfSBlbHNlIHtcbiAgICAgICAgdGhpcy5fcG9sbCgpXG4gICAgICB9XG4gICAgfSwgU09DS0VUX1BPTExJTkdfUkFURSlcbiAgfVxuXG4gIC8qKlxuICAgKiBDbGVhciBwb2xsaW5nIHRpbWVvdXQgYW5kIHN0YXJ0IHBvbGxpbmdcbiAgICovXG4gIF9zdGFydFBvbGxpbmcoKSB7XG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucG9sbGluZ1RpbWVvdXQpXG4gICAgdGhpcy5fcG9sbCgpXG4gIH1cblxuICAvKipcbiAgICogU2V0cyBgbGFzdFBpbmdgIHRvIHRoZSBjdXJlbnQgdGltZVxuICAgKi9cbiAgX2hhbmRsZVBpbmcoKSB7XG4gICAgdGhpcy5sYXN0UGluZyA9IG5vdygpXG4gIH1cblxuICAvKipcbiAgICogQ2xlYXJzIHJlY29ubmVjdCB0aW1lb3V0LCByZXNldHMgdmFyaWFibGVzIGFuIHN0YXJ0cyBwb2xsaW5nXG4gICAqL1xuICBfcmVzZXQoKSB7XG4gICAgY2xlYXJUaW1lb3V0KHRoaXMucmVjb25uZWN0VGltZW91dClcbiAgICB0aGlzLnJlY29ubmVjdFRyaWVzID0gMFxuICAgIHRoaXMuYXR0ZW1wdFJlY29ubmVjdCA9IHRydWVcbiAgICB0aGlzLl9zdGFydFBvbGxpbmcoKVxuICB9XG5cbiAgLyoqXG4gICAqIENvbm5lY3QgdGhlIHNvY2tldCB0byB0aGUgc2VydmVyLCBhbmQgYmluZHMgdG8gbmF0aXZlIHdzIGZ1bmN0aW9uc1xuICAgKiBAcGFyYW0ge09iamVjdH0gcGFyYW1zIC0gT3B0aW9uYWwgcGFyYW1ldGVyc1xuICAgKiBAcGFyYW0ge1N0cmluZ30gcGFyYW1zLmxvY2F0aW9uIC0gSG9zdG5hbWUgdG8gY29ubmVjdCB0bywgZGVmYXVsdHMgdG8gYHdpbmRvdy5sb2NhdGlvbi5ob3N0bmFtZWBcbiAgICogQHBhcmFtIHtTdHJpbmd9IHBhcm1hcy5wb3J0IC0gUG9ydCB0byBjb25uZWN0IHRvLCBkZWZhdWx0cyB0byBgd2luZG93LmxvY2F0aW9uLnBvcnRgXG4gICAqIEBwYXJhbSB7U3RyaW5nfSBwYXJhbXMucHJvdG9jb2wgLSBQcm90b2NvbCB0byB1c2UsIGVpdGhlciAnd3NzJyBvciAnd3MnXG4gICAqL1xuICBjb25uZWN0KHBhcmFtcykge1xuICAgIHRoaXMucGFyYW1zID0gcGFyYW1zXG5cbiAgICBsZXQgb3B0cyA9IHtcbiAgICAgIGxvY2F0aW9uOiB3aW5kb3cubG9jYXRpb24uaG9zdG5hbWUsXG4gICAgICBwb3J0OiB3aW5kb3cubG9jYXRpb24ucG9ydCxcbiAgICAgIHByb3RvY29sOiB3aW5kb3cubG9jYXRpb24ucHJvdG9jb2wgPT09ICdodHRwczonID8gJ3dzczonIDogJ3dzOicsXG4gICAgfVxuXG4gICAgaWYgKHBhcmFtcykgT2JqZWN0LmFzc2lnbihvcHRzLCBwYXJhbXMpXG4gICAgaWYgKG9wdHMucG9ydCkgb3B0cy5sb2NhdGlvbiArPSBgOiR7b3B0cy5wb3J0fWBcblxuICAgIHJldHVybiBuZXcgUHJvbWlzZSgocmVzb2x2ZSwgcmVqZWN0KSA9PiB7XG4gICAgICB0aGlzLndzID0gbmV3IFdlYlNvY2tldChgJHtvcHRzLnByb3RvY29sfS8vJHtvcHRzLmxvY2F0aW9ufSR7dGhpcy5lbmRwb2ludH1gKVxuICAgICAgdGhpcy53cy5vbm1lc3NhZ2UgPSAobXNnKSA9PiB7IHRoaXMuaGFuZGxlTWVzc2FnZShtc2cpIH1cbiAgICAgIHRoaXMud3Mub25jbG9zZSA9ICgpID0+IHtcbiAgICAgICAgaWYgKHRoaXMuYXR0ZW1wdFJlY29ubmVjdCkgdGhpcy5fcmVjb25uZWN0KClcbiAgICAgIH1cbiAgICAgIHRoaXMud3Mub25vcGVuID0gKCkgPT4ge1xuICAgICAgICB0aGlzLl9yZXNldCgpXG4gICAgICAgIHJlc29sdmUoKVxuICAgICAgfVxuICAgIH0pXG4gIH1cblxuICAvKipcbiAgICogQ2xvc2VzIHRoZSBzb2NrZXQgY29ubmVjdGlvbiBwZXJtYW5lbnRseVxuICAgKi9cbiAgZGlzY29ubmVjdCgpIHtcbiAgICB0aGlzLmF0dGVtcHRSZWNvbm5lY3QgPSBmYWxzZVxuICAgIGNsZWFyVGltZW91dCh0aGlzLnBvbGxpbmdUaW1lb3V0KVxuICAgIGNsZWFyVGltZW91dCh0aGlzLnJlY29ubmVjdFRpbWVvdXQpXG4gICAgdGhpcy53cy5jbG9zZSgpXG4gIH1cblxuICAvKipcbiAgICogQWRkcyBhIG5ldyBjaGFubmVsIHRvIHRoZSBzb2NrZXQgY2hhbm5lbHMgbGlzdFxuICAgKiBAcGFyYW0ge1N0cmluZ30gdG9waWMgLSBUb3BpYyBmb3IgdGhlIGNoYW5uZWw6IGBjaGF0X3Jvb206MTIzYFxuICAgKi9cbiAgY2hhbm5lbCh0b3BpYykge1xuICAgIGxldCBjaGFubmVsID0gbmV3IENoYW5uZWwodG9waWMsIHRoaXMpXG4gICAgdGhpcy5jaGFubmVscy5wdXNoKGNoYW5uZWwpXG4gICAgcmV0dXJuIGNoYW5uZWxcbiAgfVxuXG4gIC8qKlxuICAgKiBNZXNzYWdlIGhhbmRsZXIgZm9yIG1lc3NhZ2VzIHJlY2VpdmVkXG4gICAqIEBwYXJhbSB7TWVzc2FnZUV2ZW50fSBtc2cgLSBNZXNzYWdlIHJlY2VpdmVkIGZyb20gd3NcbiAgICovXG4gIGhhbmRsZU1lc3NhZ2UobXNnKSB7XG4gICAgaWYgKG1zZy5kYXRhID09PSBcInBpbmdcIikgcmV0dXJuIHRoaXMuX2hhbmRsZVBpbmcoKVxuXG4gICAgbGV0IHBhcnNlZF9tc2cgPSBKU09OLnBhcnNlKG1zZy5kYXRhKVxuICAgIHRoaXMuY2hhbm5lbHMuZm9yRWFjaCgoY2hhbm5lbCkgPT4ge1xuICAgICAgaWYgKGNoYW5uZWwudG9waWMgPT09IHBhcnNlZF9tc2cudG9waWMpIGNoYW5uZWwuaGFuZGxlTWVzc2FnZShwYXJzZWRfbXNnKVxuICAgIH0pXG4gIH1cbn1cblxubW9kdWxlLmV4cG9ydHMgPSB7XG4gIFNvY2tldDogU29ja2V0XG59XG5cblxuXG4vLyBXRUJQQUNLIEZPT1RFUiAvL1xuLy8gLi9saWIvYW1iZXIvYXNzZXRzL2pzL2FtYmVyLmpzIl0sInNvdXJjZVJvb3QiOiIifQ==