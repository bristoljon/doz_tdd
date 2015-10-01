
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
    calc.init()

  it "Starts in dozenal mode...", ->
    expect(mode.innerHTML).toBe 'DOZ'
    expect(calc.mode).toBe 'DOZ'

  it "..with .current and .equation properties empty", ->
    expect(calc.equation).toBe ''

  it "Calls clickHandler on key div click event", ->
    click_event = new MouseEvent 'click'
    dom.digits[2].dispatchEvent click_event
    expect(calc.clickHandler).toHaveBeenCalled()

  it "adds digits to equation in display on key press", ->
    click_event = new MouseEvent 'click'
    dom.digits[3].dispatchEvent click_event
    dom.digits[4].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234'

  it "adds operators to equation in display on key press", ->
    click_event = new MouseEvent 'click'
    dom.ops[1].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234-'

  it "Prevents more than one operator being entered in a row", ->
    click_event = new MouseEvent 'click'
    dom.ops[3].dispatchEvent click_event
    expect(dom.output.innerHTML).toBe '234-'

  it "Calls calc.equals on equals click", ->
    click_event = new MouseEvent 'click'
    dom.digits[4].dispatchEvent click_event
    dom.equals.dispatchEvent click_event
    expect(calc.equals).toHaveBeenCalled()
    expect(calc.equation).toBe '230'
    expect(dom.output.innerHTML).toBe '230'

  it "calls 'reset' method and clears display on 'C' key press", ->
    click_event = new MouseEvent 'click'
    dom.cancel.dispatchEvent click_event
    expect(calc.reset).toHaveBeenCalled()
    expect(calc.equation).toBe ''
    expect(output.innerHTML).toBe ''

  it "Toggles mode to Decimal on mode div click", ->
    click_event = new MouseEvent 'click'
    mode.dispatchEvent click_event
    expect(mode.innerHTML).toBe 'DEC'
    expect(calc.mode).toBe 'DEC'

  xit "Converts equation from decimal to dozenal on 'mode' click", ->
    click_event = new MouseEvent 'click'
    dom.digits[1].dispatchEvent click_event
    dom.digits[2].dispatchEvent click_event
    dom.mode.dispatchEvent click_event
    expect(output.innerHTML).toBe 'X'

  xit "Converts equation from dozenal to decimal on 'mode' click", ->
    dom.mode.dispatchEvent click_event
    expect(output.innerHTML).toBe '10'

xdescribe "Calculator Logic tests", ->

  beforeEach ->
    calc = new Calculator
    calc.init()

  describe "Dozenal / Decimal conversion", ->

    it "Converts XL to ab strings and vice versa", ->
      expect(calc.transform "XLXL").toBe "abab"
      expect(calc.transform "abba").toBe "XLXL"

    it "Converts dozenal equation strings to decimal ones", ->
      expect(calc.transform "14+a-b*3/4").toBe "16+10-11*3/4"

    it "Converts decimal equation strings to dozenal ones", ->
      expect(calc.transform "16+10-11*3/4").toBe "14+a-b*3/4"

    it "Converts dozenal integers to decimal", ->
      expect(calc.dozToDec "10").toBe 12
      expect(calc.dozToDec "1ab6").toBe 3306

    it "Converts decimal integers to dozenal", ->
      expect(calc.decToDoz 456).toBe "320"
      expect(calc.decToDoz 3683).toBe "216a"

  describe "Decimal maths operations", ->
    it "Can add 2 decimal numbers", ->
      calc.equation = '364+20'
      expect(calc.equals()).toBe 384

    it "Can subtract 2 decimal numbers", ->
      expect(calc.decMinus 364, 20).toBe 344

    it "Can multiply 2 decimal numbers", ->
      expect(calc.decAdd 24, 12).toBe 288

    it "Can divide 2 decimal numbers", ->
      expect(calc.decDivide 24, 4).toBe 6

  describe "Dozenal maths operations", ->
    it "Can add 2 decimal numbers", ->
      expect(calc.decAdd 364, 20).toBe 384

    it "Can subtract 2 decimal numbers", ->
      expect(calc.decMinus 364, 20).toBe 344

    it "Can multiply 2 decimal numbers", ->
      expect(calc.decAdd 24, 12).toBe 288

    it "Can divide 2 decimal numbers", ->
      expect(calc.decDivide 24, 4).toBe 6



  describe "Evaluates equations correctly", ->
    it "Calculates formula string to give correct answer", ->
      expect(calc.equals "12+6*3-1/2").toBe 29.5

