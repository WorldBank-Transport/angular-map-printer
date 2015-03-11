'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
    .controller 'MainCtrl', ['$scope', '$location', '$timeout', 'leafletData', 'Map', ($scope, $location, $timeout, leafletData, Map) ->
        $scope.map = Map
        map = null # Leaflet Map instance

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

        angular.extend $scope,
            tiles: Map.tiles.default
            center: Map.center

        leafletData.getMap('map').then((_map) ->
            map = _map
        )

        $scope.print = () ->
            window.print()

        $scope.$on 'centerUrlHash', (event, centerHash) ->
            $location.search c: centerHash
            return

        $scope.$watch 'paper', ((newVal, oldVal) ->
            $timeout ->
                if map?
                    map.invalidateSize()
            , 1000
        )
    ]
