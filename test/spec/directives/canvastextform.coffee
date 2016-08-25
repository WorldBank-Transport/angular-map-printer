'use strict'

describe 'Directive: canvasTextForm', ->

  # load the directive's module
  beforeEach module 'mapPrinterApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<canvas-text-form></canvas-text-form>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the canvasTextForm directive'
