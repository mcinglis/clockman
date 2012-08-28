define [
  'views/home'
], (HomeView) ->

  class AppRouter extends Backbone.Router
    routes:
      '': 'index'

    index: -> (new HomeView()).render()

