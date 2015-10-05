calc = ''

class Calculator


  init: ->
    # Add generic click handler to digits and operator keys
    digits = document.getElementsByClassName 'digit'
    ops = document.getElementsByClassName 'operator'

    for thing in [digits,ops]
      for key in thing
        key.addEventListener 'click', (event) =>
          @clickHandler event

    # Add specific handlers to 'Clear', 'Equals' and 'Mode' keys
    document.getElementById('mode').addEventListener('click', @modeToggle)
    document.getElementById('equals').addEventListener('click', @equals)
    document.getElementById('clear').addEventListener('click', @reset)

    @outputDiv = document.getElementById('output')
    @modeDiv = document.getElementById('mode')

    @mode = 'DOZ'
    @equation = ''
    return true

  clickHandler: (event) =>
    # Get key clicked from event target
    currentChar = event.target.innerHTML

    if @equation.length != 0
      # Get last character in equation
      lastChar = @equation.charAt(@equation.length-1)

      # If key pressed is an operator (not digit)...
      if currentChar.match /[^0-9XL]/
        # Check whether last character in equation is also an operator...
        if lastChar.match /[^0-9XL]/
          # Remove the last character
          @equation = @equation.substr(0, @equation.length-1)
    else
      # Prevent starting equation with anything other than - or digit
      if currentChar.match /[^0-9XL-]/
        currentChar = ''

    # And add current character to equation and output
    @equation += currentChar
    @outputDiv.innerHTML = @equation


  modeToggle: =>
    @equation = @equation.toString()
    if @mode is 'DOZ'
      if @equation != ''
        # If number in display is an equation
        if @equation.match(/[^0-9XL]/)
          @equation = @convertEquation @equation
        else
          @equation = @dozToDec(@transform @equation)

      @outputDiv.innerHTML = @equation
      @modeDiv.innerHTML = 'DEC'
      @mode = 'DEC'
    else
      if @equation!= ''
        if @equation.match(/[^0-9XL]/)
          @equation = @convertEquation @equation
        else
          @equation = @transform(@decToDoz(@transform @equation))
      @outputDiv.innerHTML = @equation
      @mode = 'DOZ'
      @modeDiv.innerHTML = 'DOZ'

  equals: =>
    answer = ''
    if @mode is 'DOZ'
      answer = @transform(@decToDoz(eval(@convertEquation @equation)))
    else
      answer = eval(@equation).toString()

    @equation = answer
    @outputDiv.innerHTML = @equation


  reset: =>
    @equation = ''
    @outputDiv.innerHTML = ''

  convertEquation: (equation) =>
    inArr = @stringToArray(equation)

    outArr = []

    for i in [0..inArr.length-1]
      if inArr[i].match(/[^0-9XL]/)
        outArr[i] = inArr[i]
      else
        if @mode is 'DOZ'
          outArr[i] = @dozToDec(@transform inArr[i])
        else
          outArr[i] = @transform(@decToDoz(@transform inArr[i]))

    return outArr.join('')

  dozToDec: (dozInt) ->
    dozInt = dozInt.toString()
    neg = false
    if dozInt.charAt(0) is '-'
      dozInt= dozInt.substring 1
      neg = true

    res = 0
    n = 0

    for i in [0..dozInt.length-1]
      d = dozInt.charAt i
      if d is 'b' then n = 11
      else if d is 'a' then n = 10
      else n = parseInt d
      res += n * Math.pow(12, dozInt.length-i-1)

    if neg then res = '-' + res

    return res.toString()

  decToDoz: (dec) ->

    return parseInt(dec).toString(12)


  stringToArray: (equation) ->
    # Split the string at operators
    equation = equation.replace /\*/g, "#*#"
    equation = equation.replace /\//g, "#/#"
    equation = equation.replace /\-/g, "#-#"
    equation = equation.replace /\+/g, "#+#"
    output = equation.split /\#/g


    return output

  transform: (input) ->
    # Replaces XL's with AB's and vice versa

    input = input.toString()

    if input.match /[XL]/g
      input = input.replace /X/g, 'a'
      input = input.replace /L/g, 'b'

    else
      input = input.replace /a/g, 'X'
      input = input.replace /b/g, 'L'

    return input

window.onload = ->
  console.log 'loaded'
  calc = new Calculator
  calc.init()

