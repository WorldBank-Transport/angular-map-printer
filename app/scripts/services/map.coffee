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
        tiles:
            default:
                url: 'http://{s}.tiles.mapbox.com/v3/markiliffe.551ae569/{z}/{x}/{y}.png'
                options:
                    attribution: '&copy; TODI, &copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        center:
            lat: -6.81643
            lng: 39.2856
            zoom: 13
    }
