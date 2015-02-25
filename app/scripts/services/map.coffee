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
                url: 'http://{s}.tile.osm.org/{z}/{x}/{y}.png'
                options:
                    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        center:
            lat: -6.81643
            lng: 39.2856
            zoom: 13
    }
