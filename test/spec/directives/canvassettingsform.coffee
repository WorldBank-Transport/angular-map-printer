'use strict'

describe 'Directive: canvasSettingsForm', ->

  # load the directive's module
  beforeEach module 'mapPrinterApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<canvas-settings-form></canvas-settings-form>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the canvasSettingsForm directive'
