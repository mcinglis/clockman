
inlineTemplate = (selector) -> _.template $(selector).html()

zeroPad = (x, length) ->
  (new Array(length + 1 - x.toString().length)).join('0') + x

class Code
  constructor: (code, radix) ->
    @code = parseInt(code, radix).toString(2)

  

class Time
  constructor: (text) ->
    @valid = @parse(text)
    @_hours = @valid?.hours
    @_minutes = @valid?.minutes

  code: (command) ->
    code = command << 11
    code += @_hours << 6
    code += @_minutes
    return code

  parse: (text) ->
    for pattern, parser of @patterns
      split = pattern.split('/')
      re = new RegExp(split[1], split[2])
      if re.test(text)
        return parser(re.exec(text))
    return null

  patterns:
    "/^(0?[1-9]|1[0-2]):([0-5][0-9])\\s*(am|pm)$/i": (exec) ->
      hours = parseInt(exec[1], 10)
      if exec[3].toLowerCase() == 'pm' and hours != 12
        hours += 12
      minutes = parseInt(exec[2], 10)
      return hours: hours, minutes: minutes

    "/^([0-1]\\d|2[0-3]):?([0-5]\\d)$/i": (exec) ->
      return hours: parseInt(exec[1], 10), minutes: parseInt(exec[2], 10)

class Router extends Backbone.Router
  routes:
    '': 'home'
    'transmit/:code': 'transmit'

  home: ->
    (new HomeView()).render()

  transmit: (code) ->
    (new TransmissionView(code)).render()

class HomeView extends Backbone.View
  el: '#container'

  template: inlineTemplate('#home-template')

  events:
    'change #time': 'validateTimeInput'
    'click #set-time': 'setTime'
    'click #set-alarm': 'setAlarm'

  render: ->
    @$el.html(@template)
    this

  validateTimeInput: (e) ->
    value = @$('#time').val()
    @time = new Time(value)
    @setInputClass(@time.valid?)

  setInputClass: (valid) ->
    if valid
      @$('#time').parent().removeClass('error').addClass('success')
    else
      @$('#time').parent().removeClass('success').addClass('error')

  startTransmission: (command) ->
    if @time?.valid?
      code = @time.code(command).toString(16)
      Backbone.history.navigate("transmit/#{code}", trigger: true)

  setTime: (e) ->
    e.preventDefault()
    @startTransmission(0)

  setAlarm: (e) ->
    e.preventDefault()
    @startTransmission(1)

class TransmissionView extends Backbone.View
  el: '#container'

  template: inlineTemplate('#transmission-template')

  waitTime: 1000
  flashFrequency: 200
  initCode: '100100'

  constructor: (code) ->
    @code = parseInt(code, 16).toString(2)
    super()

  render: ->
    @$el.html(@template(waitTime: @waitTime))

    setTimeout(@flash, @waitTime, @initCode)

    time1 = @waitTime + @timeNeeded(@initCode)
    time2 = time1 + @timeNeeded(@code)

    setTimeout(@flash, time1, @code)

    setTimeout((-> Backbone.history.navigate('', trigger: true)), time2)

    this

  clear: ->
    @$el.empty()
    $('body').css(background: '#fff')

  timeNeeded: (code) -> (code.length * @flashFrequency)

  flash: (code) =>
    @clear()
    f = =>
      if code[0] is '1'
        console.log('black')
        $('body').css(background: '#000')
      else
        console.log('white')
        $('body').css(background: '#FFF')
      code = code.slice(1)
      if code == ''
        @clear()
      else
        setTimeout(f, @flashFrequency) 
    f()

$ ->
  new Router()
  Backbone.history.start()

