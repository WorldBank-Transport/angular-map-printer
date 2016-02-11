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
        legendCanvas = null

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
        defaultLegendEntry = color: '#000000', label: ''
        $scope.legendEntry = angular.copy(defaultLegendEntry)

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
          leafletImage map, (err, _canvas) ->
            # now you have canvas
            # example thing to do with that canvas:
            canvas = _canvas
            img = document.createElement('img')
            dimensions = map.getSize()
            img.width = dimensions.x
            img.height = dimensions.y
            ctx = canvas.getContext("2d")

            # draw map components on canvas
            writeOnCanvas($scope.map.title.text, $scope.map.title)
            writeOnCanvas($scope.map.tiles.default.options.attribution, $scope.map.attribution)
            drawOnCanvas(legendCanvas, $scope.map.legend)

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
                'map.title.text'
                'map.title.size'
                'map.title.font'
                'map.title.style'
                'map.title.color'
                'map.title.position'
                'map.legend.size'
                'map.legend.font'
                'map.legend.style'
                'map.legend.color'
                'map.legend.background'
                'map.legend.position'
            ],((newVal, oldVal) ->
                buildLegend()
                refreshUrlParams()
                refreshMapStyle()
        )

        $scope.$watch 'map.legend.items', ((newVal, oldVal) ->
            buildLegend()
            refreshUrlParams()
            refreshMapStyle()
        ), true

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
            # title
            if urlParams.t?
                $scope.map.title.text = urlParams.t
            if parseInt(urlParams.ts)
                $scope.map.title.size = parseInt(urlParams.ts)
            if urlParams.tf?
                $scope.map.title.font = urlParams.tf
            if urlParams.tt? and urlParams.tt in $scope.textStyles
                $scope.map.title.style = urlParams.tt
            if urlParams.tc?
                $scope.map.title.color = urlParams.tc
            if urlParams.tp? and urlParams.tp in $scope.positions
                $scope.map.title.position = urlParams.tp
            # attribution
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
            # legend
            if parseInt(urlParams.ls)
                $scope.map.legend.size = parseInt(urlParams.ls)
            if urlParams.lf?
                $scope.map.legend.font = urlParams.lf
            if urlParams.lt? and urlParams.lt in $scope.textStyles
                $scope.map.legend.style = urlParams.lt
            if urlParams.lc?
                $scope.map.legend.color = urlParams.lc
            if urlParams.lb?
                $scope.map.legend.background = urlParams.lb
            if urlParams.lp? and urlParams.lp in $scope.positions
                $scope.map.legend.position = urlParams.lp
            if urlParams.li?
                $scope.map.legend.items = JSON.parse(decodeURIComponent(urlParams.li))
        readUrlParams()

        refreshUrlParams = () ->
            urlParams = $location.search()
            urlParams.c = $scope.centerUrlHash
            urlParams.p = $scope.paper
            urlParams.u = $scope.map.tiles.default.url
            # title
            urlParams.t = $scope.map.title.text
            urlParams.ts = $scope.map.title.size
            urlParams.tf = $scope.map.title.font
            urlParams.tt = $scope.map.title.style
            urlParams.tc = $scope.map.title.color
            urlParams.tp = $scope.map.title.position
            # attribution
            urlParams.a = $scope.map.tiles.default.options.attribution
            urlParams.as = $scope.map.attribution.size
            urlParams.af = $scope.map.attribution.font
            urlParams.at = $scope.map.attribution.style
            urlParams.ac = $scope.map.attribution.color
            urlParams.ap = $scope.map.attribution.position
            # legend
            urlParams.ls = $scope.map.legend.size
            urlParams.lf = $scope.map.legend.font
            urlParams.lt = $scope.map.legend.style
            urlParams.lc = $scope.map.legend.color
            urlParams.lb = $scope.map.legend.background
            urlParams.lp = $scope.map.legend.position
            urlParams.li = encodeURIComponent(JSON.stringify($scope.map.legend.items))
            $location.search urlParams

        refreshMapStyle = () ->
            if map?
                map.titleControl.addTitle($scope.map.title.text)
                map.titleControl.setPosition($scope.map.title.position)
                map.legendControl.addLegend($scope.map.legend.text)
                map.legendControl.setPosition($scope.map.legend.position)
                buildLegend()
                map.attributionControl.setPrefix('')
                map.attributionControl.setPosition($scope.map.attribution.position)
            $rootScope.mapCss = "
            .leaflet-container .leaflet-control-attribution{
                background-color: none;
                background: none;
                font-size: #{ $scope.map.attribution.size }px;
                font-style: #{ $scope.map.attribution.style };
                font-family: #{ $scope.map.attribution.font };
                color: #{ $scope.map.attribution.color };
            }
            .leaflet-container .leaflet-control-title{
                background-color: none;
                background: none;
                font-size: #{ $scope.map.title.size }px;
                font-style: #{ $scope.map.title.style };
                font-family: #{ $scope.map.title.font };
                color: #{ $scope.map.title.color };
            }
            "
            if $scope.map.title.style.indexOf('bold') > -1
                $rootScope.mapCss += "
                .leaflet-container .leaflet-control-title{
                    font-weight: bold;
                }
                "
            if $scope.map.title.style.indexOf('italic') > -1
                $rootScope.mapCss += "
                .leaflet-container .leaflet-control-title{
                    font-style: italic;
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

        drawOnCanvas = (el, options) ->
            try
                corners =
                    'topleft':
                        x: 10
                        y: 10
                    'topright':
                        x: canvas.width - el.width
                        y: 10
                    'bottomleft':
                        x: 10
                        y: canvas.height - el.height
                    'bottomright':
                        x: canvas.width - el.width
                        y: canvas.height - el.height
                coords = corners[options.position]
                ctx.drawImage(el, coords.x, coords.y)
            catch e
                console.log e

        $scope.addLegendEntry = () ->
            $scope.map.legend.items.push(angular.copy($scope.legendEntry))
            $scope.legendEntry = angular.copy(defaultLegendEntry)

        $scope.removeLegendEntry = (i) ->
            $scope.map.legend.items.splice(i, 1);

        buildLegend = () ->
            # generate content
            _legend = ''
            extraStyle = {}
            if $scope.map.legend.style.indexOf('bold') > -1
                extraStyle['font-weight'] = 'bold'
            if $scope.map.legend.style.indexOf('italic') > -1
                extraStyle['font-style'] = 'italic'
            for item in $scope.map.legend.items
                _legend += "
                <div style='padding: 5px 10px'>
                    <i
                        style='
                            background-color:#{ item.color };
                            width: 25px;
                            height: 18px;
                            display: inline-block;
                            vertical-align: middle
                        '>
                    </i>
                    <span
                            style='padding: 4px;
                            font-style: #{ extraStyle['font-style'] };
                            font-weight: #{ extraStyle['font-weight'] };'>
                        #{ item.label }
                    </span><br>
                </div>
                "
            $scope.map.legend.text = "
            <div
                style='
                background-color: none;
                background: #{ $scope.map.legend.background };
                font-size: #{ $scope.map.legend.size }px;
                font-style: #{ $scope.map.legend.style };
                font-family: #{ $scope.map.legend.font };
                color: #{ $scope.map.legend.color };
                border-radius: 3px;'
                class='leaflet-control-legend-container'>
                #{ _legend }
            </div>
            "
            if map?
                legendCanvas = document.getElementById('_legend-canvas')
                legendCanvas.width = map.legendControl.getContainer().offsetWidth + 20
                legendCanvas.height = map.legendControl.getContainer().offsetHeight + 20
                legendCtx = legendCanvas.getContext("2d")
                rasterizeHTML.drawHTML($scope.map.legend.text, legendCanvas)
    ]
