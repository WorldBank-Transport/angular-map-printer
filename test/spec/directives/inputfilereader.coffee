'use strict'

describe 'Directive: inputFilereader', ->

  # load the directive's module
  beforeEach module 'mapPrinterApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<input-filereader></input-filereader>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the inputFilereader directive'
