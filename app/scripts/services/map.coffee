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

    defaults =
        tiles:
            default:
                url: 'http://{s}.tiles.mapbox.com/v3/markiliffe.551ae569/{z}/{x}/{y}.png'
                options:
                    attribution: '© TODI, © OpenStreetMap contributors'
        cartodb:
            vis: ''
            options:
                shareable: false
                title: false
                description: false
                search: false
                carto_logo: false
                time_slider: true
                layer_selector: true
                legends: false
        center:
            lat: -6.81643
            lng: 39.2856
            zoom: 13
        controls: {}
        defaults:
            zoomControl: false

    angular.extend(this, defaults)
    return this
