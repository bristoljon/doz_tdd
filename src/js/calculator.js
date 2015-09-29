var Calculator, calc;

Calculator = (function() {
  function Calculator() {}

  Calculator.prototype.init = function() {
    var j, key, keys, len;
    keys = document.getElementsByClassName('key');
    for (j = 0, len = keys.length; j < len; j++) {
      key = keys[j];
      key.addEventListener('click', this.clickHandler);
    }
    return true;
  };

  Calculator.prototype.clickHandler = function() {
    return console.log('clicked');
  };

  Calculator.prototype.dozToDec = function(dozInt) {
    var d, i, j, len, n, neg, ref, res;
    neg = false;
    if (dozInt.charAt(0) === '-') {
      dozInt = dozInt.substring(1);
      neg = true;
    }
    res = 0;
    n = 0;
    ref = dozInt.length;
    for (j = 0, len = ref.length; j < len; j++) {
      i = ref[j];
      d = dozInt.charAt(i);
      if (d === 'b') {
        n = 11;
      } else if (d === 'a') {
        n = 10;
      } else {
        n = parseInt(d);
      }
      res += n * Math.pow(12, dozInt.length - i - 1);
    }
    if (neg) {
      res = '-' + res;
    }
    return res;
  };

  return Calculator;

})();

calc = new Calculator;

calc.init();
