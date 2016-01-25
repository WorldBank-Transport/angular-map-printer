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

        urlParams = $location.search()
        $scope.centerUrlHash = ''

        defaults =
            paper: 8

        if urlParams.p? and $filter('filter')($scope.papers, {class: urlParams.p})[0]?
            $scope.paper = urlParams.p
        else
            $scope.paper = $scope.papers[defaults.paper].class

        $scope.snapshotURL = null

        if urlParams.u?
            $scope.map.tiles.default.url = urlParams.u

        if urlParams.a?
            $scope.map.tiles.default.options.attribution = urlParams.a

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
            ctx.fillText($scope.map.tiles.default.options.attribution, canvas.width-10, canvas.height - 10)
            img.src = canvas.toDataURL()
            $scope.snapshotURL = img.src
            $scope.canvasIsLoading = false
            document.getElementById('snapshot').innerHTML = ''
            document.getElementById('snapshot').appendChild img
            # force #snapshot .modal-backdrop to reach beyond window height if necessary
            $timeout ->
                window.dispatchEvent(new Event('resize'));
            , 1000

        $scope.$on 'centerUrlHash', (event, centerHash) ->
            $scope.centerUrlHash = centerHash
            refreshUrlParams()
            return

        $scope.$watch 'paper', ((newVal, oldVal) ->
            try
                $scope.paperName = $filter('filter')($scope.papers, {class: newVal})[0].name
            catch e
                $scope.paper = $scope.papers[defaults.paper].class
            refreshUrlParams()
            $timeout ->
                if map?
                    map.invalidateSize()
            , 1000
        )

        $scope.$watchGroup ['map.tiles.default.url', 'map.tiles.default.options.attribution'], ((newVal, oldVal) ->
            refreshUrlParams()
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

        refreshUrlParams = () ->
            urlParams = $location.search()
            urlParams.c = $scope.centerUrlHash
            urlParams.p = $scope.paper
            urlParams.u = $scope.map.tiles.default.url
            urlParams.a = $scope.map.tiles.default.options.attribution
            $location.search urlParams
    ]
