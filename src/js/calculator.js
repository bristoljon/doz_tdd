var Calculator, calc,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

calc = '';

Calculator = (function() {
  function Calculator() {
    this.transform = bind(this.transform, this);
    this.reset = bind(this.reset, this);
    this.modeToggle = bind(this.modeToggle, this);
    this.clickHandler = bind(this.clickHandler, this);
  }

  Calculator.prototype.init = function() {
    var digits, j, k, key, len, len1, ops, ref, thing;
    digits = document.getElementsByClassName('digit');
    ops = document.getElementsByClassName('operator');
    ref = [digits, ops];
    for (j = 0, len = ref.length; j < len; j++) {
      thing = ref[j];
      for (k = 0, len1 = thing.length; k < len1; k++) {
        key = thing[k];
        key.addEventListener('click', (function(_this) {
          return function(event) {
            return _this.clickHandler(event);
          };
        })(this));
      }
    }
    document.getElementById('mode').addEventListener('click', this.modeToggle);
    document.getElementById('equals').addEventListener('click', this.equals);
    document.getElementById('clear').addEventListener('click', this.reset);
    this.outputDiv = document.getElementById('output');
    this.modeDiv = document.getElementById('mode');
    this.mode = 'DOZ';
    this.equation = '';
    return true;
  };

  Calculator.prototype.clickHandler = function(event) {
    var currentChar, digit, lastChar;
    currentChar = event.target.innerHTML;
    digit = event.target.className.match(/\bdigit\b/);
    if (this.equation.length !== 0) {
      lastChar = this.equation.charAt(this.equation.length - 1);
      if (!digit) {
        if (lastChar.match(/[^0-9XL]/)) {
          this.equation = this.equation.substr(0, this.equation.length - 1);
        }
      }
    }
    this.equation += currentChar;
    return this.outputDiv.innerHTML = this.equation;
  };

  Calculator.prototype.modeToggle = function() {
    if (this.mode === 'DOZ') {
      this.mode = 'DEC';
      this.equation = this.dozToDec(this.equation);
      this.outputDiv.innerHTML = this.equation;
      return this.modeDiv.innerHTML = 'DEC';
    } else {
      this.mode = 'DOZ';
      this.equation = this.decToDoz(this.equation);
      this.outputDiv.innerHTML = this.equation;
      return this.modeDiv.innerHTML = 'DOZ';
    }
  };

  Calculator.prototype.equals = function() {
    return console.log('equals pressed');
  };

  Calculator.prototype.reset = function() {
    this.equation = '';
    return this.outputDiv.innerHTML = '';
  };

  Calculator.prototype.dozToDec = function(dozInt) {
    var d, i, j, n, neg, ref, res;
    console.log('dozToDec ran with: ' + dozInt);
    dozInt = this.transform(dozInt);
    if (dozInt !== '') {
      neg = false;
      if (dozInt.charAt(0) === '-') {
        dozInt = dozInt.substring(1);
        neg = true;
      }
      res = 0;
      n = 0;
      for (i = j = 0, ref = dozInt.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
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
      console.log('dozToDec end with: ' + res);
      return this.transform(res);
    } else {
      return '';
    }
  };

  Calculator.prototype.decToDoz = function(dec) {
    console.log('decToDoz ran with: ' + dec);
    dec = this.transform(dec);
    if (dec !== '') {
      console.log('decToDoz ends with: ' + parseInt(dec).toString(12));
      return this.transform(parseInt(dec).toString(12));
    } else {
      return '';
    }
  };

  Calculator.prototype.transform = function(input) {
    var equation, i, j, output, ref;
    console.log('Transform ran with: ' + input);
    input = input.toString();
    if (input.match(/[^0-9XLab]/g)) {
      console.log('is an equation');
      output = [];
      console.log("Input is an equation");
      equation = input.replace(/\*/g, "#*#");
      equation = equation.replace(/\//g, "#/#");
      equation = equation.replace(/\-/g, "#-#");
      equation = equation.replace(/\+/g, "#+#");
      equation = equation.split(/\#/g);
      for (i = j = 0, ref = equation.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        if (equation[i].match(/[0-9XLab]/)) {
          output[i] = this.transform(equation[i]);
        } else {
          output[i] = equation[i];
        }
      }
      return output.join('');
    } else {
      console.log('isnt an equation');
      if (input.match(/[XL]/g)) {
        input = input.replace(/X/g, 'a');
        input = input.replace(/L/g, 'b');
      } else {
        input = input.replace(/a/g, 'X');
        input = input.replace(/b/g, 'L');
      }
      console.log('returned: ' + input);
      return input;
    }
  };

  return Calculator;

})();

window.onload = function() {
  console.log('loaded');
  calc = new Calculator;
  return calc.init();
};
