calc =''
special = ''

setUpHTML = ->
  body = document.createElement 'body'

  operators = ['/','+','*','.','-']

  for operator in operators
    opDiv = document.createElement 'div'
    opDiv.classList.add 'key', 'operator'
    opDiv.innerHTML = operator
    body.appendChild opDiv

  for digit in [0..9]
    digDiv = document.createElement 'div'
    digDiv.classList.add 'key', 'digit'
    digDiv.innerHTML = digit
    body.appendChild digDiv

  special = document.createElement 'div'

  special.innerHTML = 3
  body.appendChild special

describe "Calculator UI / Button tests", ->

  beforeEach ->
    calc = new Calculator
    spyOn calc, 'init'
    spyOn calc, 'clickHandler'
    setUpHTML()
    calc.init()

  it "Initialises and adds click event listeners to key divs", ->
    expect(calc.init).toHaveBeenCalled

  it "Has html key div elements to play with", ->
    expect(document.getElementsByClassName 'key').toBeGreaterThan(0)

  it "adds digits to equation in display on key press", ->
    digitDivs = document.getElementsByClassName('digit')
    click_event = new Event 'click'
    console.log digitDivs.length

    digitDivs[0].dispatchEvent click_event
    expect(calc.clickHandler).toHaveBeenCalled

  it "adds operators to equation in display on key press", ->
    expect(true).toBe true

  it "clears display on 'C' key press", ->
    expect(true).toBe true

  it "Toggles mode on 'DOZ/DEC' key press", ->
    expect(true).toBe true

  it "Converts equation on 'DOZ/DEC key press", ->
    expect(true).toBe true

describe "Calculator Logic tests", ->

  beforeEach ->


  describe "Dozenal / Decimal integer conversion", ->
    it "Converts dozenal integers to decimal", ->
      expect(calc.dozToDec "10").toBe 12
      expect(calc.dozToDec "1ab6").toBe 3306

    it "Converts decimal integers to dozenal", ->
      expect(calc.decToDoz 456).toBe "320"
      expect(calc.decToDoz 3683).toBe "216a"

  describe "Decimal maths operations", ->
    it "Can add 2 decimal numbers", ->
      expect(calc.decAdd 364, 20).toBe 384

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

  describe "Doz / Dec equation conversion", ->
    it "Converts dozenal equation strings to decimal ones", ->
      expect(calc.dozToDecEquation "14+a-b*3/4").toBe "16+10-11*3/4"

    it "Converts decimal equation strings to dozenal ones", ->
      expect(calc.decToDozEquation "16+10-11*3/4").toBe "14+a-b*3/4"

  describe "Convert custom characters to/from 'ab'", ->
    it "Converts XL to ab", ->
      expect(calc.XLtoAB "XXXLLL").toBe "aaabbb"
    it "Converts ab to XL", ->
      expect(calc.ABtoXL "ababab").toBe "XLXLXL"

  describe "Evaluates decimal equations correctly", ->
    it "Calculates formula string to give correct answer", ->
      expect(calc.calculate "12+6*3-1/2").toBe 29.5

