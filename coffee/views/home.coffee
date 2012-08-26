define [
  'views/set_time'
  'views/set_alarm',

  'text!templates/home.html'
], (homeTemplate, SetTimeView, SetAlarmView) ->
  
  class HomeView extends Backbone.View

    el: '#container'

    template: homeTemplate

    events:
      'click #time': ->
        (new SetTimeView()).render()

      'click #alarm': ->
        (new SetAlarmView()).render()

      'click #weather': ->
        $('#weather-form').toggle()

    render: ->
      $(@el).html(@template)
      this

