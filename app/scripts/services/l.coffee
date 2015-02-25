'use strict'

###*
 # @ngdoc service
 # @name mapPrinterApp.L
 # @description
 # # L
 # Factory in the mapPrinterApp.
###
angular.module('mapPrinterApp')
    .factory 'L', ->
        window.L
