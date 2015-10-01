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
    currentChar = event.target.innerHTML
    digit = event.target.className.match /\bdigit\b/

    if @equation.length != 0
      lastChar = @equation.charAt(@equation.length-1)

      # If key pressed is an operator (not digit)...
      if !digit
      # Check whether last character in equation is also an operator...
        if lastChar.match /[^0-9XL]/
          # Remove the last charcter
          @equation = @equation.substr(0, @equation.length-1)

    # And add current character to equation and output
    @equation += currentChar
    @outputDiv.innerHTML = @equation


  modeToggle: =>
    if @mode is 'DOZ'
      @mode = 'DEC'
      @equation = @dozToDec(@equation)
      @outputDiv.innerHTML = @equation
      @modeDiv.innerHTML = 'DEC'
    else
      @mode = 'DOZ'
      @equation = @decToDoz(@equation)
      @outputDiv.innerHTML = @equation
      @modeDiv.innerHTML = 'DOZ'

  equals: ->
    console.log 'equals pressed'

  reset: =>
    @equation = ''
    @outputDiv.innerHTML = ''


  dozToDec: (dozInt) ->

    console.log 'dozToDec ran with: ' + dozInt

    dozInt = @transform(dozInt)

    if dozInt != ''
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

      console.log 'dozToDec end with: ' + res

      return @transform(res)

    else return ''

  decToDoz: (dec) ->
    console.log 'decToDoz ran with: ' + dec
    dec = @transform(dec)
    if dec != ''

      console.log 'decToDoz ends with: ' + parseInt(dec).toString(12)

      return @transform(parseInt(dec).toString(12))

    else return ''

  transform: (input) =>

    console.log 'Transform ran with: ' + input
    # Convert input to string
    input = input.toString()

    # Determine if input is an equation i.e. contains operators
    if input.match /[^0-9XLab]/g
      console.log 'is an equation'

      output = []

      console.log "Input is an equation"
      # Split the string at operators
      equation = input.replace /\*/g, "#*#"
      equation = equation.replace /\//g, "#/#"
      equation = equation.replace /\-/g, "#-#"
      equation = equation.replace /\+/g, "#+#"
      equation = equation.split /\#/g

      # Swap AB for XL characters
      for i in [0..equation.length-1]
        if equation[i].match(/[0-9XLab]/)
          output[i] = this.transform equation[i]
        else
          output[i] = equation[i]

      return output.join('')

    # Input is a number
    else
      console.log 'isnt an equation'
      if input.match /[XL]/g
        input = input.replace /X/g, 'a'
        input = input.replace /L/g, 'b'
      else
        input = input.replace /a/g, 'X'
        input = input.replace /b/g, 'L'
      console.log 'returned: ' + input
      return input

window.onload = ->
  console.log 'loaded'
  calc = new Calculator
  calc.init()

