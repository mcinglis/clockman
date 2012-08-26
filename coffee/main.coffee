# Require.js allows us to configure shortcut alias
require.config
  # The shim config allows us to configure dependencies for scripts
  # that do not call define() to register a module
  shim:
    underscore:
      exports: '_'
    backbone:
      deps: [
        'underscore'
        'jquery'
      ]
      exports: 'Backbone'

  paths:
    text: 'lib/require/text'
    jquery: 'lib/jquery'
    underscore: 'lib/underscore'
    backbone: 'lib/backbone'


require [
  'backbone'

  'router'
], (Backbone, AppRouter) ->

  new AppRouter()
  Backbone.history.start()
