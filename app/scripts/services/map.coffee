'use strict'

###*
 # @ngdoc service
 # @name mapPrinterApp.Map
 # @description
 # # Map
 # Factory in the mapPrinterApp.
###
angular.module('mapPrinterApp')
  .factory 'Map', ->

    {
      tileLayer: 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
      center:
        lat: -6.81643
        lng: 39.2856
        zoom: 13
    }
