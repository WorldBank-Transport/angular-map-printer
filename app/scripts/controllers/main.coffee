'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
    .controller 'MainCtrl', ['$scope', 'leafletData', 'Map', ($scope, leafletData, Map) ->
        $scope.map = null
        $scope.papers =[
            {'name': 'A0', 'class': 'a0'}
            {'name': 'A0 Landscape', 'class': 'a0-landscape'}
            {'name': 'A1', 'class': 'a1'}
            {'name': 'A1 Landscape', 'class': 'a1-landscape'}
            {'name': 'A2', 'class': 'a2'}
            {'name': 'A2 Landscape', 'class': 'a2-landscape'}
            {'name': 'A3', 'class': 'a3'}
            {'name': 'A3 Landscape', 'class': 'a3-landscape'}
            {'name': 'A4', 'class': 'a4'}
            {'name': 'A4 Landscape', 'class': 'a4-landscape'}
            {'name': 'A5', 'class': 'a5'}
            {'name': 'A5 Landscape', 'class': 'a5-landscape'}
        ]
        $scope.paper = $scope.papers[8].class

        angular.extend $scope, defaults:
            tileLayer: Map.tileLayer
            center: Map.center

        leafletData.getMap('map').then((map) ->
            $scope.map = map
            $scope.map.invalidateSize()
        )

        $scope.print = () ->
            window.print()
    ]
