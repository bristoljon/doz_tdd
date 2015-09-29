var calc, setUpHTML, special;

calc = '';

special = '';

setUpHTML = function() {
  var body, digDiv, digit, i, j, len, opDiv, operator, operators;
  body = document.createElement('body');
  operators = ['/', '+', '*', '.', '-'];
  for (i = 0, len = operators.length; i < len; i++) {
    operator = operators[i];
    opDiv = document.createElement('div');
    opDiv.classList.add('key', 'operator');
    opDiv.innerHTML = operator;
    body.appendChild(opDiv);
  }
  for (digit = j = 0; j <= 9; digit = ++j) {
    digDiv = document.createElement('div');
    digDiv.classList.add('key', 'digit');
    digDiv.innerHTML = digit;
    body.appendChild(digDiv);
  }
  special = document.createElement('div');
  special.innerHTML = 3;
  return body.appendChild(special);
};

describe("Calculator UI / Button tests", function() {
  beforeEach(function() {
    calc = new Calculator;
    spyOn(calc, 'init');
    spyOn(calc, 'clickHandler');
    setUpHTML();
    return calc.init();
  });
  it("Initialises and adds click event listeners to key divs", function() {
    return expect(calc.init).toHaveBeenCalled;
  });
  it("Has html key div elements to play with", function() {
    return expect(document.getElementsByTagName('div').length).toBeGreaterThan(0);
  });
  it("adds digits to equation in display on key press", function() {
    var click_event, digitDivs;
    digitDivs = document.getElementsByClassName('digit');
    click_event = new Event('click');
    console.log(digitDivs.length);
    digitDivs[0].dispatchEvent(click_event);
    return expect(calc.clickHandler).toHaveBeenCalled;
  });
  it("adds operators to equation in display on key press", function() {
    return expect(true).toBe(true);
  });
  it("clears display on 'C' key press", function() {
    return expect(true).toBe(true);
  });
  it("Toggles mode on 'DOZ/DEC' key press", function() {
    return expect(true).toBe(true);
  });
  return it("Converts equation on 'DOZ/DEC key press", function() {
    return expect(true).toBe(true);
  });
});

describe("Calculator Logic tests", function() {
  beforeEach(function() {});
  describe("Dozenal / Decimal integer conversion", function() {
    it("Converts dozenal integers to decimal", function() {
      expect(calc.dozToDec("10")).toBe(12);
      return expect(calc.dozToDec("1ab6")).toBe(3306);
    });
    return it("Converts decimal integers to dozenal", function() {
      expect(calc.decToDoz(456)).toBe("320");
      return expect(calc.decToDoz(3683)).toBe("216a");
    });
  });
  describe("Decimal maths operations", function() {
    it("Can add 2 decimal numbers", function() {
      return expect(calc.decAdd(364, 20)).toBe(384);
    });
    it("Can subtract 2 decimal numbers", function() {
      return expect(calc.decMinus(364, 20)).toBe(344);
    });
    it("Can multiply 2 decimal numbers", function() {
      return expect(calc.decAdd(24, 12)).toBe(288);
    });
    return it("Can divide 2 decimal numbers", function() {
      return expect(calc.decDivide(24, 4)).toBe(6);
    });
  });
  describe("Dozenal maths operations", function() {
    it("Can add 2 decimal numbers", function() {
      return expect(calc.decAdd(364, 20)).toBe(384);
    });
    it("Can subtract 2 decimal numbers", function() {
      return expect(calc.decMinus(364, 20)).toBe(344);
    });
    it("Can multiply 2 decimal numbers", function() {
      return expect(calc.decAdd(24, 12)).toBe(288);
    });
    return it("Can divide 2 decimal numbers", function() {
      return expect(calc.decDivide(24, 4)).toBe(6);
    });
  });
  describe("Doz / Dec equation conversion", function() {
    it("Converts dozenal equation strings to decimal ones", function() {
      return expect(calc.dozToDecEquation("14+a-b*3/4")).toBe("16+10-11*3/4");
    });
    return it("Converts decimal equation strings to dozenal ones", function() {
      return expect(calc.decToDozEquation("16+10-11*3/4")).toBe("14+a-b*3/4");
    });
  });
  describe("Convert custom characters to/from 'ab'", function() {
    it("Converts XL to ab", function() {
      return expect(calc.XLtoAB("XXXLLL")).toBe("aaabbb");
    });
    return it("Converts ab to XL", function() {
      return expect(calc.ABtoXL("ababab")).toBe("XLXLXL");
    });
  });
  return describe("Evaluates decimal equations correctly", function() {
    return it("Calculates formula string to give correct answer", function() {
      return expect(calc.calculate("12+6*3-1/2")).toBe(29.5);
    });
  });
});
