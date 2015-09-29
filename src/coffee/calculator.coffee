class Calculator

  init: ->
    keys = document.getElementsByClassName 'key'
    for key in keys
      key.addEventListener 'click', @clickHandler
    return true

  clickHandler: ->
    console.log 'clicked'

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

calc = new Calculator
calc.init()

