(function($) {
  $.fn.sessionTimeout = function (options) {
    var opts = $.extend({}, $.fn.sessionTimeout.defaults, options);
    var inter = this.data('timer');
    if (inter) {
      clearInterval(inter);
    }

    var info = {
      warned: false,
      expired: false
    };
    processCookie(info, opts);

    this.data('timer', setInterval(cookieCheck, opts.interval, this, info, opts));
    cookieCheck(this, info, opts);
  };

  function processCookie(info, opts) {
    info.serverTime = Date.parse($.fn.sessionTimeout.readCookie(opts.timeCookie));
    info.sessionTime = Date.parse($.fn.sessionTimeout.readCookie(opts.sessCookie));
    info.offset = new Date().getTime() - info.serverTime;
    info.expires = info.sessionTime + info.offset;
    info.duration = Math.floor((info.sessionTime - info.serverTime) / 1000);
  };

  // private
  function cookieCheck(els, info, opts) {
    var sessionTime = Date.parse($.fn.sessionTimeout.readCookie(opts.sessCookie));
    if (sessionTime != info.sessionTime) {
      processCookie(info, opts);
    }
    info.timeLeft = {};
    var ms = info.expires - (new Date().getTime());
    info.timeLeft.minutes = Math.floor(ms / 60000);
    info.timeLeft.seconds = Math.floor(ms % 60000 / 1000);
    info.timeLeft.onlySeconds = info.timeLeft.minutes * 60 + info.timeLeft.seconds;
    info.timeLeft.minutes = info.timeLeft.minutes.toString().replace(/^([0-9])$/, '0$1');
    info.timeLeft.seconds = info.timeLeft.seconds.toString().replace(/^([0-9])$/, '0$1');
    if (!info.warned && info.timeLeft.onlySeconds <= opts.warningTime) {
      info.warned = true;
      opts.onWarning(els, info, opts);
    } else if (!info.expired && info.timeLeft.onlySeconds < 0) {
      info.expired = true;
      opts.onExpire(els, info, opts);
    }
    if (!info.expired) {
      opts.onTick(els, info, opts);
    }
  };

  function onTick(els, info, opts) {
    els.each(function() {
      opts.onTickEach(this, info, opts);
    });
  };

  function onTickEach(el, info, opts) {
    $(el).html(info.timeLeft.minutes + ':' + info.timeLeft.seconds);
  };

  function onWarning(el, info, opts) {
    //alert('Warning');
  };

  function onExpire(el, info, opts) {
    alert('Ihre Session ist leider abgelaufen');
	pathArray = window.location.pathname.split( '/' );
	location.href='/'+pathArray[1];
  };

  // public
  $.fn.sessionTimeout.readCookie = function(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i=0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1,c.length);
      if (c.indexOf(nameEQ) == 0)
        return unescape(c.substring(nameEQ.length,c.length));
    }
    return null;
  }

  $.fn.sessionTimeout.defaults = {
    timeCookie: 'SERVERTIME',
    sessCookie: 'SESSIONTIMEOUT',
    interval: 1000,
    onTick: onTick,
    onTickEach: onTickEach,
    warningTime: 3600, // seconds
    onWarning: onWarning,
    onExpire: onExpire
  };
})(jQuery);
