var calc, click_event, dom, setUpHTML;

setUpHTML = function() {
  var body, canDiv, char, digDiv, digit, dom, equDiv, i, j, k, len, len1, modDiv, opDiv, operator, operators, outDiv, ref, xDiv;
  body = document.createElement('body');
  body = document.getElementsByTagName('body')[0];
  body.innerHTML = '';
  operators = ['+', '-', '*', '/', '.'];
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
  ref = ['X', 'L'];
  for (k = 0, len1 = ref.length; k < len1; k++) {
    char = ref[k];
    xDiv = document.createElement('div');
    xDiv.classList.add('key', 'digit', 'xl');
    xDiv.innerHTML = char;
    body.appendChild(xDiv);
  }
  canDiv = document.createElement('div');
  canDiv.id = 'clear';
  canDiv.innerHTML = 'C';
  body.appendChild(canDiv);
  modDiv = document.createElement('div');
  modDiv.id = 'mode';
  modDiv.innerHTML = 'DOZ';
  body.appendChild(modDiv);
  equDiv = document.createElement('div');
  equDiv.id = 'equals';
  equDiv.innerHTML = '=';
  body.appendChild(equDiv);
  outDiv = document.createElement('div');
  outDiv.id = 'output';
  body.appendChild(outDiv);
  dom = {
    keys: document.getElementsByClassName('key'),
    digits: document.getElementsByClassName('digit'),
    ops: document.getElementsByClassName('operator'),
    output: document.getElementById('output'),
    cancel: document.getElementById('clear'),
    mode: document.getElementById('mode'),
    equals: document.getElementById('equals')
  };
  return dom;
};

dom = setUpHTML();

calc = {};

click_event = {};

describe("Test sets up DOM and calc objects for testing", function() {
  beforeAll(function() {
    calc = new Calculator;
    spyOn(calc, 'init').and.callThrough();
    return calc.init();
  });
  it("Initialises and makes calc object properties available", function() {
    expect(calc.init).toHaveBeenCalled();
    expect(calc.mode).toBeDefined();
    return expect(calc.fakeProperty).not.toBeDefined();
  });
  return it("Has html key div elements to play with", function() {
    return expect(dom.keys.length).toBeGreaterThan(9);
  });
});

describe("Calculator UI tests", function() {
  beforeAll(function() {
    calc = new Calculator;
    spyOn(calc, 'clickHandler').and.callThrough();
    spyOn(calc, 'reset').and.callThrough();
    spyOn(calc, 'equals').and.callThrough();
    click_event = new MouseEvent('click');
    return calc.init();
  });
  it("Starts in dozenal mode...", function() {
    expect(mode.innerHTML).toBe('DOZ');
    return expect(calc.mode).toBe('DOZ');
  });
  it("..with .current and .equation properties empty", function() {
    return expect(calc.equation).toBe('');
  });
  it("Toggles mode to Decimal on mode div click", function() {
    mode.dispatchEvent(click_event);
    expect(mode.innerHTML).toBe('DEC');
    return expect(calc.mode).toBe('DEC');
  });
  it("Calls clickHandler on key div click event", function() {
    dom.digits[2].dispatchEvent(click_event);
    return expect(calc.clickHandler).toHaveBeenCalled();
  });
  it("adds digits to equation in display on key press", function() {
    dom.digits[3].dispatchEvent(click_event);
    dom.digits[4].dispatchEvent(click_event);
    return expect(dom.output.innerHTML).toBe('234');
  });
  it("adds operators to equation in display on key press", function() {
    dom.ops[1].dispatchEvent(click_event);
    return expect(dom.output.innerHTML).toBe('234-');
  });
  it("Prevents more than one operator being entered in a row", function() {
    dom.ops[0].dispatchEvent(click_event);
    return expect(dom.output.innerHTML).toBe('234+');
  });
  it("Calls calc.equals on equals click", function() {
    dom.digits[4].dispatchEvent(click_event);
    dom.equals.dispatchEvent(click_event);
    expect(calc.equals).toHaveBeenCalled();
    expect(calc.equation).toBe('234');
    return expect(dom.output.innerHTML).toBe('234');
  });
  it("calls 'reset' method and clears display on 'C' key press", function() {
    dom.cancel.dispatchEvent(click_event);
    expect(calc.reset).toHaveBeenCalled();
    expect(calc.equation).toBe('');
    return expect(dom.output.innerHTML).toBe('');
  });
  it("Prevents starting equation with anything other than '-' or digit", function() {
    click_event = new MouseEvent('click');
    dom.ops[0].dispatchEvent(click_event);
    return expect(dom.output.innerHTML).toBe('');
  });
  it("Converts number from decimal to dozenal on 'mode' click", function() {
    dom.digits[1].dispatchEvent(click_event);
    dom.digits[2].dispatchEvent(click_event);
    dom.mode.dispatchEvent(click_event);
    return expect(output.innerHTML).toBe('X');
  });
  return it("Converts number from dozenal to decimal on 'mode' click", function() {
    dom.mode.dispatchEvent(click_event);
    return expect(output.innerHTML).toBe('10');
  });
});

describe("Calculator Logic tests", function() {
  beforeEach(function() {
    calc = new Calculator;
    return calc.init();
  });
  describe("Dozenal / Decimal conversion", function() {
    it("Converts XL to ab strings and vice versa", function() {
      expect(calc.transform("XLXL")).toBe("abab");
      return expect(calc.transform("abba")).toBe("XLLX");
    });
    xit("Converts dozenal equation strings to decimal ones", function() {
      return expect(calc.transform("14+a-b*3/4")).toBe("16+10-11*3/4");
    });
    xit("Converts decimal equation strings to dozenal ones", function() {
      dom.mode.dispatchEvent(click_event);
      console.log(calc.mode);
      return expect(calc.transform("16+10-11*3/4")).toBe("14+a-b*3/4");
    });
    it("Converts dozenal integers to decimal", function() {
      expect(calc.dozToDec("10")).toBe('12');
      return expect(calc.dozToDec("1ab6")).toBe('3306');
    });
    return it("Converts decimal integers to dozenal", function() {
      expect(calc.decToDoz('456')).toBe("320");
      return expect(calc.decToDoz('3683')).toBe("216b");
    });
  });
  describe("Decimal maths operations", function() {
    it("Can add 2 decimal numbers", function() {
      calc.equation = '364+20';
      return expect(calc.equals()).toBe('384');
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
  return describe("Evaluates equations correctly", function() {
    return it("Calculates formula string to give correct answer", function() {
      return expect(calc.equals("12+6*3-1/2")).toBe('29.5');
    });
  });
});
