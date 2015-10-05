
setUpHTML = ->
  body = (document.createElement 'body')
  body = document.getElementsByTagName('body')[0]
  body.innerHTML = ''

  # Add operator key divs to body
  operators = ['+','-','*','/','.']
  for operator in operators
    opDiv = document.createElement 'div'
    opDiv.classList.add 'key', 'operator'
    opDiv.innerHTML = operator
    body.appendChild opDiv

  # Add digit key divs to body
  for digit in [0..9]
    digDiv = document.createElement 'div'
    digDiv.classList.add 'key', 'digit'
    digDiv.innerHTML = digit
    body.appendChild digDiv

  # Add X/L keys to DOM
  for char in ['X','L']
    xDiv = document.createElement 'div'
    xDiv.classList.add 'key', 'digit', 'xl'
    xDiv.innerHTML = char
    body.appendChild xDiv

  # Add cancel, mode and output divs
  canDiv = document.createElement 'div'
  canDiv.id = 'clear'
  canDiv.innerHTML = 'C'
  body.appendChild canDiv

  modDiv = document.createElement 'div'
  modDiv.id = 'mode'
  modDiv.innerHTML = 'DOZ'
  body.appendChild modDiv

  equDiv = document.createElement 'div'
  equDiv.id = 'equals'
  equDiv.innerHTML = '='
  body.appendChild equDiv

  outDiv = document.createElement 'div'
  outDiv.id = 'output'
  body.appendChild outDiv

  dom =
    keys: document.getElementsByClassName 'key'
    digits: document.getElementsByClassName 'digit'
    ops: document.getElementsByClassName 'operator'
    output: document.getElementById 'output'
    cancel: document.getElementById 'clear'
    mode: document.getElementById 'mode'
    equals: document.getElementById 'equals'
  return dom

dom = setUpHTML()
calc = {}
click_event = new MouseEvent 'click'

describe "Test sets up DOM and calc objects for testing", ->

  beforeAll ->
    calc = new Calculator
    spyOn(calc, 'init').and.callThrough()
    calc.init()

  it "Initialises and makes calc object properties available", ->
    expect(calc.init).toHaveBeenCalled()
    expect(calc.mode).toBeDefined()
    expect(calc.fakeProperty).not.toBeDefined()

  it "Has html key div elements to play with", ->
    expect(dom.keys.length).toBeGreaterThan(9)


describe "Calculator UI tests", ->

  beforeAll ->
    calc = new Calculator
    spyOn(calc, 'clickHandler').and.callThrough()
    spyOn(calc, 'reset').and.callThrough()
    spyOn(calc, 'equals').and.callThrough()

    calc.init()

  it "Starts in dozenal mode...", ->
    expect(mode.innerHTML).toBe 'DOZ'
    expect(calc.mode).toBe 'DOZ'

  it "..with .current and .equation properties empty", ->
    expect(calc.equation).toBe ''

  it "Toggles mode to Decimal on mode div click", ->
    mode.dispatchEvent click_event
    expect(mode.innerHTML).toBe 'DEC'
    expect(calc.mode).toBe 'DEC'

  it "Calls clickHandler on key div click event", ->
    dom.digits[2].dispatchEvent click_event
    expect(calc.clickHandler).toHaveBeenCalled()

  it "adds digits to equation in display on key press", ->
    dom.digits[3].dispatchEvent click_event
    dom.digits[4].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234'

  it "adds operators to equation in display on key press", ->
    dom.ops[1].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234-'

  it "Prevents more than one operator being entered in a row", ->
    dom.ops[0].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234+'

  it "Calls calc.equals on equals click", ->
    dom.digits[4].dispatchEvent click_event
    dom.equals.dispatchEvent click_event
    expect(calc.equals).toHaveBeenCalled()

  it "calls 'reset' method and clears display on 'C' key press", ->
    dom.cancel.dispatchEvent click_event
    expect(calc.reset).toHaveBeenCalled()
    expect(calc.equation).toBe ''
    expect(dom.output.innerHTML).toBe ''

  it "Converts number from decimal to dozenal on 'mode' click", ->
    dom.digits[1].dispatchEvent click_event
    dom.digits[2].dispatchEvent click_event
    dom.mode.dispatchEvent click_event
    expect(output.innerHTML).toBe '10'

  it "Converts number from dozenal to decimal on 'mode' click", ->
    dom.mode.dispatchEvent click_event
    expect(output.innerHTML).toBe '12'

  it "Prevents starting equation with anything other than '-' or digit", ->
    dom.cancel.dispatchEvent click_event
    dom.ops[0].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe ''

describe "Calculator Logic tests", ->

  beforeAll ->
    calc = new Calculator
    calc.init()

  describe "Dozenal / Decimal conversion", ->

    it "Converts XL to ab strings and vice versa", ->
      expect(calc.transform "XLXL").toBe "abab"
      expect(calc.transform "abba").toBe "XLLX"

    it "Converts dozenal equation strings to decimal ones", ->
      expect(calc.convertEquation "14+X-L*3/4").toBe "16+10-11*3/4"

    it "Converts decimal equation strings to dozenal ones", ->
      dom.mode.dispatchEvent click_event
      expect(calc.convertEquation "16+10-11*3/4").toBe "14+X-L*3/4"

    it "Converts dozenal integers to decimal", ->
      expect(calc.dozToDec "10").toBe '12'
      expect(calc.dozToDec "1ab6").toBe '3306'

    it "Converts decimal integers to dozenal", ->
      expect(calc.decToDoz '456').toBe "320"
      expect(calc.decToDoz '3683').toBe "216b"



  describe "Dozenal maths operations", ->

    beforeEach ->
      calc = new Calculator
      calc.init()
      calc.mode = 'DOZ'

    it "Can add 2 dozenal numbers", ->
      calc.equation = 'X+L'
      expect(calc.equals()).toBe '19'

    it "Can subtract 2 dozenal numbers", ->
      calc.equation = '10-L'
      expect(calc.equals()).toBe '1'

    it "Can multiply 2 dozenal numbers", ->
      calc.equation = '2*X'
      expect(calc.equals()).toBe '18'

    it "Can divide 2 dozenal numbers", ->
      calc.equation = 'X0/2'
      expect(calc.equals()).toBe '50'

    it "Calculates dozenal formula to give correct answer", ->
      calc.equation = "X+L*3-1"
      expect(calc.equals()).toBe '36'

  describe "Decimal maths operations", ->

    beforeEach ->
      calc.mode = 'DEC'

    it "Can add 2 decimal numbers", ->
      calc.equation = '364+6'
      expect(calc.equals()).toBe '370'

    it "Can subtract 2 decimal numbers", ->
      calc.equation = "24-5"
      expect(calc.equals()).toBe '19'

    it "Can multiply 2 decimal numbers", ->
      calc.equation = "2*6"
      expect(calc.equals()).toBe '12'

    it "Can divide 2 decimal numbers", ->
      calc.equation = "24/3"
      expect(calc.equals()).toBe '8'

    it "Calculates decimal formula to give correct answer", ->
      calc.equation = "12+6*3-1/2"
      expect(calc.equals()).toBe '29.5'

