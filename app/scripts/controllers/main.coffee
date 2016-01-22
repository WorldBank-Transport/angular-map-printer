'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
    .controller 'MainCtrl', ['$scope', '$location', '$timeout', '$filter', 'leafletData', 'Map', ($scope, $location, $timeout, $filter, leafletData, Map) ->
        $scope.map = Map
        map = null # Leaflet Map instance
        $scope.canvasIsLoading = false

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
        $scope.paperName = $scope.papers[8].name
        $scope.snapshotURL = null

        angular.extend $scope,
            tiles: Map.tiles.default
            center: Map.center

        leafletData.getMap('map').then((_map) ->
            map = _map
        )

        $scope.print = () ->
          $scope.canvasIsLoading = true
          $scope.snapshotURL = null
          document.getElementById('snapshot').innerHTML = ''
          leafletImage map, (err, canvas) ->
            # now you have canvas
            # example thing to do with that canvas:
            img = document.createElement('img')
            dimensions = map.getSize()
            img.width = dimensions.x
            img.height = dimensions.y
            ctx = canvas.getContext("2d")
            ctx.font = "14px Arial"
            ctx.textAlign = "end"
            ctx.textBaseline="bottom"
            ctx.fillText($scope.tiles.options.attribution, canvas.width-10, canvas.height - 10)
            img.src = canvas.toDataURL()
            $scope.snapshotURL = img.src
            $scope.canvasIsLoading = false
            $scope.$apply()
            document.getElementById('snapshot').innerHTML = ''
            document.getElementById('snapshot').appendChild img
            # force #snapshot .modal-backdrop to reach beyond window height if necessary
            $timeout ->
                window.dispatchEvent(new Event('resize'));
            , 1000

        $scope.$on 'centerUrlHash', (event, centerHash) ->
            $location.search c: centerHash
            return

        $scope.$watch 'paper', ((newVal, oldVal) ->
            $scope.paperName = $filter('filter')($scope.papers, {class: newVal})[0].name
            $timeout ->
                if map?
                    map.invalidateSize()
            , 1000
        )

        $scope.printSnapshot = () ->
            imagepage = "
                <!DOCTYPE html>
                <html>
                <head><title></title></head>
                <body onload='window.focus(); window.print(); window.close();'>
                <img src='#{ $scope.snapshotURL }' style='width: 100%;' />
                </body>
                </html>
                "
            printWindow = window.open('', 'print')
            printWindow.document.open()
            printWindow.document.write(imagepage)
            printWindow.document.close()
            printWindow.focus()
    ]
