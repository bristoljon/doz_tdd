calc = ''

class Calculator

  mode: 'DOZ'
  modeDiv: document.getElementById('mode')

  init: ->
    # Add generic click handler to digits and operator keys
    keys = document.getElementsByClassName 'key'
    for key in keys
      key.addEventListener 'click', (event) =>
        @clickHandler event

    # Add specific handlers to 'Clear', 'Equals' and 'Mode' keys
    document.getElementById('mode').addEventListener('click', @modeToggle)
    document.getElementById('equals').addEventListener('click', @equals)
    document.getElementById('clear').addEventListener('click', @reset)

    @outputDiv = document.getElementById 'output'
    @mode = 'DOZ'
    @equation = ''
    return true

  clickHandler: (event) ->
    current = event.target.innerHTML
    console.log current
    @equation += current
    @display(@equation)

  modeToggle: ->
    if @mode = 'DOZ'
      @mode = 'DEC'
      @modeDiv.innerHTML = 'DEC'
    else
      @mode = 'DOZ'
      @modeDiv.innerHTML ='DOZ'

  reset: ->
    @equation = ''
    @outputDiv.innerHTML = ''

  display: (output) ->
    @outputDiv.innerHTML = output

  dozToDec: (dozInt) ->
    neg = false
    if dozInt.charAt(0) is '-'
      dozInt= dozInt.substring 1
      neg = true

    res = 0
    n = 0

    for i in dozInt.length
      d = dozInt.charAt i
      if d is 'b' then n = 11
      else if d is 'a' then n = 10
      else n = parseInt d

      res += n*Math.pow(12, dozInt.length-i-1)

    if neg then res = '-' + res

    res

window.onload = ->
  console.log 'loaded'
  calc = new Calculator
  calc.init()

