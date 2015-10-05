var Calculator, calc,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

calc = '';

Calculator = (function() {
  function Calculator() {
    this.convertEquation = bind(this.convertEquation, this);
    this.reset = bind(this.reset, this);
    this.equals = bind(this.equals, this);
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
    var currentChar, lastChar;
    currentChar = event.target.innerHTML;
    if (this.equation.length !== 0) {
      lastChar = this.equation.charAt(this.equation.length - 1);
      if (currentChar.match(/[^0-9XL]/)) {
        if (lastChar.match(/[^0-9XL]/)) {
          this.equation = this.equation.substr(0, this.equation.length - 1);
        }
      }
    } else {
      if (currentChar.match(/[^0-9XL-]/)) {
        currentChar = '';
      }
    }
    this.equation += currentChar;
    return this.outputDiv.innerHTML = this.equation;
  };

  Calculator.prototype.modeToggle = function() {
    this.equation = this.equation.toString();
    if (this.mode === 'DOZ') {
      if (this.equation !== '') {
        if (this.equation.match(/[^0-9XL]/)) {
          this.equation = this.convertEquation(this.equation);
        } else {
          this.equation = this.dozToDec(this.transform(this.equation));
        }
      }
      this.outputDiv.innerHTML = this.equation;
      this.modeDiv.innerHTML = 'DEC';
      return this.mode = 'DEC';
    } else {
      if (this.equation !== '') {
        if (this.equation.match(/[^0-9XL]/)) {
          this.equation = this.convertEquation(this.equation);
        } else {
          this.equation = this.transform(this.decToDoz(this.transform(this.equation)));
        }
      }
      this.outputDiv.innerHTML = this.equation;
      this.mode = 'DOZ';
      return this.modeDiv.innerHTML = 'DOZ';
    }
  };

  Calculator.prototype.equals = function() {
    var answer;
    answer = '';
    if (this.mode === 'DOZ') {
      answer = this.transform(this.decToDoz(eval(this.convertEquation(this.equation))));
    } else {
      answer = eval(this.equation).toString();
    }
    this.equation = answer;
    return this.outputDiv.innerHTML = this.equation;
  };

  Calculator.prototype.reset = function() {
    this.equation = '';
    return this.outputDiv.innerHTML = '';
  };

  Calculator.prototype.convertEquation = function(equation) {
    var i, inArr, j, outArr, ref;
    inArr = this.stringToArray(equation);
    outArr = [];
    for (i = j = 0, ref = inArr.length - 1; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
      if (inArr[i].match(/[^0-9XL]/)) {
        outArr[i] = inArr[i];
      } else {
        if (this.mode === 'DOZ') {
          outArr[i] = this.dozToDec(this.transform(inArr[i]));
        } else {
          outArr[i] = this.transform(this.decToDoz(this.transform(inArr[i])));
        }
      }
    }
    return outArr.join('');
  };

  Calculator.prototype.dozToDec = function(dozInt) {
    var d, i, j, n, neg, ref, res;
    dozInt = dozInt.toString();
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
    return res.toString();
  };

  Calculator.prototype.decToDoz = function(dec) {
    return parseInt(dec).toString(12);
  };

  Calculator.prototype.stringToArray = function(equation) {
    var output;
    equation = equation.replace(/\*/g, "#*#");
    equation = equation.replace(/\//g, "#/#");
    equation = equation.replace(/\-/g, "#-#");
    equation = equation.replace(/\+/g, "#+#");
    output = equation.split(/\#/g);
    return output;
  };

  Calculator.prototype.transform = function(input) {
    input = input.toString();
    if (input.match(/[XL]/g)) {
      input = input.replace(/X/g, 'a');
      input = input.replace(/L/g, 'b');
    } else {
      input = input.replace(/a/g, 'X');
      input = input.replace(/b/g, 'L');
    }
    return input;
  };

  return Calculator;

})();

window.onload = function() {
  console.log('loaded');
  calc = new Calculator;
  return calc.init();
};
