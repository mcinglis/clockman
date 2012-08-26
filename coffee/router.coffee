define [
  'views/home'
  'views/time'
], (HomeView, TimeView) ->

  class AppRouter extends Backbone.Router
    routes:
      '': 'index'

    index: -> (new HomeView()).render()

