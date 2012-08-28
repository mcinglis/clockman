define [
  'text!templates/home_sub.html'
  'text!templates/time_input.html'
], (templateHomeSub, templateTimeInput) ->

  class TimeView extends Backbone.View

    el: '#time'

    template: _.template(templateHomeSub)
      label: 'Set alarm'
      content: _.template(templateTimeInput)

    events:
      'click button': -> @toggleContent()

    render: ->
      @$el.html(@template)
      @toggleContent()
      this

    toggleContent: ->
      @$('#content').toggle()

