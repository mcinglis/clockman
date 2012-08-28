define [
  'text!templates/home.html'

  'views/home_sub'
], (template, HomeSubView) ->
  
  class HomeView extends Backbone.View

    el: '#container'

    template: _.template(template)

    render: ->
      @$el.html(@template)

      time_view = new HomeSubView('#time', 'Set time', 
      (new HomeSubView()).render()
      this

