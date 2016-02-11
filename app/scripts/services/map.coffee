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
        center:
            lat: -6.81643
            lng: 39.2856
            zoom: 13
        title:
            text: ''
            size: 20
            font: 'Aria'
            style: 'bold'
            color: 'rgba(0,0,0,1.0)'
            position: 'topleft'
        attribution:
            size: 14
            font: 'Aria'
            style: 'normal'
            color: 'rgba(0,0,0,1.0)'
            position: 'bottomright'
        legend:
            size: 12
            font: 'Aria'
            style: 'normal'
            color: 'rgba(0,0,0,1.0)'
            background: 'rgba(255,255,255,0.8)'
            position: 'bottomleft'
            items: []
        controls: {}
        defaults:
            zoomControl: false

    angular.extend(this, defaults)
    return this
