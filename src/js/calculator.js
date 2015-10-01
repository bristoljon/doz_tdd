var Calculator, calc;

calc = '';

Calculator = (function() {
  function Calculator() {}

  Calculator.prototype.mode = 'DOZ';

  Calculator.prototype.modeDiv = document.getElementById('mode');

  Calculator.prototype.init = function() {
    var j, key, keys, len;
    keys = document.getElementsByClassName('key');
    for (j = 0, len = keys.length; j < len; j++) {
      key = keys[j];
      key.addEventListener('click', (function(_this) {
        return function(event) {
          return _this.clickHandler(event);
        };
      })(this));
    }
    document.getElementById('mode').addEventListener('click', this.modeToggle);
    document.getElementById('equals').addEventListener('click', this.equals);
    document.getElementById('clear').addEventListener('click', this.reset);
    this.outputDiv = document.getElementById('output');
    this.mode = 'DOZ';
    this.equation = '';
    return true;
  };

  Calculator.prototype.clickHandler = function(event) {
    var current;
    current = event.target.innerHTML;
    console.log(current);
    this.equation += current;
    return this.display(this.equation);
  };

  Calculator.prototype.modeToggle = function() {
    if (this.mode = 'DOZ') {
      this.mode = 'DEC';
      return this.modeDiv.innerHTML = 'DEC';
    } else {
      this.mode = 'DOZ';
      return this.modeDiv.innerHTML = 'DOZ';
    }
  };

  Calculator.prototype.reset = function() {
    this.equation = '';
    return this.outputDiv.innerHTML = '';
  };

  Calculator.prototype.display = function(output) {
    return this.outputDiv.innerHTML = output;
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

window.onload = function() {
  console.log('loaded');
  calc = new Calculator;
  return calc.init();
};
