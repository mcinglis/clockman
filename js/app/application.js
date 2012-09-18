// Generated by CoffeeScript 1.3.3
(function() {
  var Code, HomeView, Router, Time, TransmissionView, inlineTemplate, zeroPad,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  inlineTemplate = function(selector) {
    return _.template($(selector).html());
  };

  zeroPad = function(x, length) {
    return (new Array(length + 1 - x.toString().length)).join('0') + x;
  };

  Code = (function() {

    function Code(code, radix) {
      this.code = parseInt(code, radix).toString(2);
    }

    return Code;

  })();

  Time = (function() {

    function Time(text) {
      var _ref, _ref1;
      this.valid = this.parse(text);
      this._hours = (_ref = this.valid) != null ? _ref.hours : void 0;
      this._minutes = (_ref1 = this.valid) != null ? _ref1.minutes : void 0;
    }

    Time.prototype.code = function(command) {
      var code;
      code = command << 11;
      code += this._hours << 6;
      code += this._minutes;
      return code;
    };

    Time.prototype.parse = function(text) {
      var parser, pattern, re, split, _ref;
      _ref = this.patterns;
      for (pattern in _ref) {
        parser = _ref[pattern];
        split = pattern.split('/');
        re = new RegExp(split[1], split[2]);
        if (re.test(text)) {
          return parser(re.exec(text));
        }
      }
      return null;
    };

    Time.prototype.patterns = {
      "/^(0?[1-9]|1[0-2]):([0-5][0-9])\\s*(am|pm)$/i": function(exec) {
        var hours, minutes;
        hours = parseInt(exec[1], 10);
        if (exec[3].toLowerCase() === 'pm' && hours !== 12) {
          hours += 12;
        }
        minutes = parseInt(exec[2], 10);
        return {
          hours: hours,
          minutes: minutes
        };
      },
      "/^([0-1]\\d|2[0-3]):?([0-5]\\d)$/i": function(exec) {
        return {
          hours: parseInt(exec[1], 10),
          minutes: parseInt(exec[2], 10)
        };
      }
    };

    return Time;

  })();

  Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'home',
      'transmit/:code': 'transmit'
    };

    Router.prototype.home = function() {
      return (new HomeView()).render();
    };

    Router.prototype.transmit = function(code) {
      return (new TransmissionView(code)).render();
    };

    return Router;

  })(Backbone.Router);

  HomeView = (function(_super) {

    __extends(HomeView, _super);

    function HomeView() {
      return HomeView.__super__.constructor.apply(this, arguments);
    }

    HomeView.prototype.el = '#container';

    HomeView.prototype.template = inlineTemplate('#home-template');

    HomeView.prototype.events = {
      'change #time': 'validateTimeInput',
      'click #set-time': 'setTime',
      'click #set-alarm': 'setAlarm'
    };

    HomeView.prototype.render = function() {
      this.$el.html(this.template);
      return this;
    };

    HomeView.prototype.validateTimeInput = function(e) {
      var value;
      value = this.$('#time').val();
      this.time = new Time(value);
      return this.setInputClass(this.time.valid != null);
    };

    HomeView.prototype.setInputClass = function(valid) {
      if (valid) {
        return this.$('#time').parent().removeClass('error').addClass('success');
      } else {
        return this.$('#time').parent().removeClass('success').addClass('error');
      }
    };

    HomeView.prototype.startTransmission = function(command) {
      var code, _ref;
      if (((_ref = this.time) != null ? _ref.valid : void 0) != null) {
        code = this.time.code(command).toString(16);
        return Backbone.history.navigate("transmit/" + code, {
          trigger: true
        });
      }
    };

    HomeView.prototype.setTime = function(e) {
      e.preventDefault();
      return this.startTransmission(0);
    };

    HomeView.prototype.setAlarm = function(e) {
      e.preventDefault();
      return this.startTransmission(1);
    };

    return HomeView;

  })(Backbone.View);

  TransmissionView = (function(_super) {

    __extends(TransmissionView, _super);

    TransmissionView.prototype.el = '#container';

    TransmissionView.prototype.template = inlineTemplate('#transmission-template');

    TransmissionView.prototype.waitTime = 1000;

    TransmissionView.prototype.flashFrequency = 200;

    TransmissionView.prototype.initCode = '100100';

    function TransmissionView(code) {
      this.flash = __bind(this.flash, this);
      this.code = parseInt(code, 16).toString(2);
      TransmissionView.__super__.constructor.call(this);
    }

    TransmissionView.prototype.render = function() {
      var time1, time2;
      this.$el.html(this.template({
        waitTime: this.waitTime
      }));
      setTimeout(this.flash, this.waitTime, this.initCode);
      time1 = this.waitTime + this.timeNeeded(this.initCode);
      time2 = time1 + this.timeNeeded(this.code);
      setTimeout(this.flash, time1, this.code);
      setTimeout((function() {
        return Backbone.history.navigate('', {
          trigger: true
        });
      }), time2);
      return this;
    };

    TransmissionView.prototype.clear = function() {
      this.$el.empty();
      return $('body').css({
        background: '#fff'
      });
    };

    TransmissionView.prototype.timeNeeded = function(code) {
      return code.length * this.flashFrequency;
    };

    TransmissionView.prototype.flash = function(code) {
      var f,
        _this = this;
      this.clear();
      f = function() {
        if (code[0] === '1') {
          console.log('black');
          $('body').css({
            background: '#000'
          });
        } else {
          console.log('white');
          $('body').css({
            background: '#FFF'
          });
        }
        code = code.slice(1);
        if (code === '') {
          return _this.clear();
        } else {
          return setTimeout(f, _this.flashFrequency);
        }
      };
      return f();
    };

    return TransmissionView;

  })(Backbone.View);

  $(function() {
    new Router();
    return Backbone.history.start();
  });

}).call(this);
