'use strict'

describe 'Service: toolbox', ->

  # load the service's module
  beforeEach module 'mapPrinterApp'

  # instantiate service
  toolbox = {}
  beforeEach inject (_toolbox_) ->
    toolbox = _toolbox_

  it 'should do something', ->
    expect(!!toolbox).toBe true
