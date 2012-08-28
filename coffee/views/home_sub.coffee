define [
  'text!templates/home_sub.html'
], (templateHomeSub) ->

  class HomeSubView extends Backbone.View

    tagName: 'div'

    events:
      'click button': -> @toggleContent()

    initialize: (id, label, content) ->
      @id = id
      @template = _.template(templateHomeSub)
        label: label
        content: content

    render: ->
      @$el.html(@template)
      @toggleContent()
      this

    toggleContent: ->
      @$('#content').toggle()

