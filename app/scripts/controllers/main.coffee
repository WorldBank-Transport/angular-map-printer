'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
    .controller 'MainCtrl', ['$scope', '$rootScope', '$location', '$timeout', '$filter', 'leafletData', 'Map', ($scope, $rootScope, $location, $timeout, $filter, leafletData, Map) ->
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

        $scope.textStyles = [
            'normal'
            'bold'
            'italic'
            'italic bold'
        ]

        $scope.positions = [
            'topleft'
            'topright'
            'bottomleft'
            'bottomright'
        ]

        urlParams = $location.search()
        $scope.centerUrlHash = ''
        $scope.snapshotURL = null
        ctx = null
        canvas = null
        defaults =
            paper: 8

        leafletData.getMap('map').then((_map) ->
            map = _map
            refreshMapStyle()
        )

        $scope.print = () ->
          $scope.canvasIsLoading = true
          $scope.snapshotURL = null
          document.getElementById('snapshot').innerHTML = ''
          leafletImage map, (err, cnvs) ->
            # now you have canvas
            # example thing to do with that canvas:
            canvas = cnvs
            img = document.createElement('img')
            dimensions = map.getSize()
            img.width = dimensions.x
            img.height = dimensions.y
            ctx = canvas.getContext("2d")
            writeOnCanvas($scope.map.tiles.default.options.attribution, $scope.map.attribution)
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

        $scope.$watchGroup [
                'map.tiles.default.url'
                'map.tiles.default.options.attribution'
                'map.attribution.size'
                'map.attribution.font'
                'map.attribution.style'
                'map.attribution.color'
                'map.attribution.position'
            ],((newVal, oldVal) ->
                refreshUrlParams()
                refreshMapStyle()
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

        readUrlParams = () ->
            urlParams = $location.search()
            if urlParams.p? and $filter('filter')($scope.papers, {class: urlParams.p})[0]?
                $scope.paper = urlParams.p
            else
                $scope.paper = $scope.papers[defaults.paper].class
            if urlParams.u?
                $scope.map.tiles.default.url = urlParams.u
            if urlParams.a?
                $scope.map.tiles.default.options.attribution = urlParams.a
            if parseInt(urlParams.as)
                $scope.map.attribution.size = parseInt(urlParams.as)
            if urlParams.af?
                $scope.map.attribution.font = urlParams.af
            if urlParams.at? and urlParams.at in $scope.textStyles
                $scope.map.attribution.style = urlParams.at
            if urlParams.ac?
                $scope.map.attribution.color = urlParams.ac
            if urlParams.ap? and urlParams.ap in $scope.positions
                $scope.map.attribution.position = urlParams.ap
        readUrlParams()

        refreshUrlParams = () ->
            urlParams = $location.search()
            urlParams.c = $scope.centerUrlHash
            urlParams.p = $scope.paper
            urlParams.u = $scope.map.tiles.default.url
            urlParams.a = $scope.map.tiles.default.options.attribution
            urlParams.as = $scope.map.attribution.size
            urlParams.af = $scope.map.attribution.font
            urlParams.at = $scope.map.attribution.style
            urlParams.ac = $scope.map.attribution.color
            urlParams.ap = $scope.map.attribution.position
            $location.search urlParams

        refreshMapStyle = () ->
            if map?
                map.attributionControl.setPrefix('');
                map.attributionControl.setPosition($scope.map.attribution.position);
            $rootScope.mapCss = "
            .leaflet-container .leaflet-control-attribution{
                background-color: none;
                background: none;
                font-size: #{ $scope.map.attribution.size }px;
                font-style: #{ $scope.map.attribution.style };
                font-family: #{ $scope.map.attribution.font };
                color: #{ $scope.map.attribution.color };
            }
            "
            if $scope.map.attribution.style.indexOf('bold') > -1
                $rootScope.mapCss += "
                .leaflet-container .leaflet-control-attribution{
                    font-weight: bold;
                }
                "
            if $scope.map.attribution.style.indexOf('italic') > -1
                $rootScope.mapCss += "
                .leaflet-container .leaflet-control-attribution{
                    font-style: italic;
                }
                "
        writeOnCanvas = (text, options) ->
            try
                ctx.font = "#{ options.style } #{ options.size }px #{ options.font }"
                ctx.fillStyle = options.color
                corners =
                    'topleft':
                        x: 10
                        y: 10
                    'topright':
                        x: canvas.width-10
                        y: 10
                    'bottomleft':
                        x: 10
                        y: canvas.height - 10
                    'bottomright':
                        x: canvas.width - 10
                        y: canvas.height - 10
                textAlignPosition =
                    'topleft': 'start'
                    'topright': 'end'
                    'bottomleft': 'start'
                    'bottomright': 'end'
                textBaselinePosition =
                    'topleft': 'top'
                    'topright': 'top'
                    'bottomleft': 'bottom'
                    'bottomright': 'bottom'
                ctx.textAlign = textAlignPosition[options.position]
                ctx.textBaseline=textBaselinePosition[options.position]
                coords = corners[options.position]
                ctx.fillText(text, coords.x, coords.y)
            catch e
                console.log e
    ]
