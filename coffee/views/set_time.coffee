define [
  'text!templates/time.html'
], (timeTemplate) ->

  class TimeView extends Backbone.View

    el: '#time-view'

    template: timeTemplate

    render: ->
      $(@el).html(@template)
      this

