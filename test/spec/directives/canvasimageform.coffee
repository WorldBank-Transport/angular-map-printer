'use strict'

describe 'Directive: canvasImageForm', ->

  # load the directive's module
  beforeEach module 'mapPrinterApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<canvas-image-form></canvas-image-form>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the canvasImageForm directive'
