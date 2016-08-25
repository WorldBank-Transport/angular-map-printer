'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
    .controller 'MainCtrl', ['$scope', '$rootScope', '$location', '$timeout', '$filter', 'leafletData', 'Map', 'toolbox', ($scope, $rootScope, $location, $timeout, $filter, leafletData, Map, toolbox) ->
        $scope.map = Map
        $scope.toolbox = toolbox
  
        $scope.canvasIsLoading = false
        $scope.canvasNewImage = null
        canvas = new fabric.Canvas('snapshot-canvas', toolbox.tools.canvas.default);

        map = null # Leaflet Map instance
        cartodbLayer = null

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

        defaults =
            paper: 8

        urlParams = $location.search()
        $scope.centerUrlHash = ''
        $scope.canvasDataURL = null

        leafletData.getMap('map').then((_map) ->
            map = _map
            refreshMapStyle()
        )

        $scope.canvasOnToolClicked = (tool) ->
            toolbox.activeObject = null
            canvas.deactivateAll().renderAll()
            newObj = null
            # Activate drawing mode if freehand is selected
            if tool is 'path'
                canvas.freeDrawingBrush.color = toolbox.tools.path.default.stroke
                canvas.freeDrawingBrush.width = toolbox.tools.path.default.strokeWidth
                canvas.isDrawingMode = true
            else
                canvas.isDrawingMode = false
            if tool is toolbox.activeTool
                # Create selected tool object
                switch tool
                    when 'textbox'
                        newObj = new fabric.Textbox(toolbox.tools.textbox.default.text, toolbox.tools['textbox'].default)
                    when 'rect'
                        newObj = new fabric.Rect toolbox.tools.rect.default
                    when 'circle'
                        newObj = new fabric.Circle toolbox.tools.circle.default
                    when 'path'
                        canvas.isDrawingMode = false
                        toolbox.activeTool = null
                    when 'image', 'canvas'
                        toolbox.activeTool = null
            else
                # Set active tool
                toolbox.activeTool = tool
            if newObj?
                newObj.set( {id: "#{ newObj.type }-#{ Date.now() }"} )
                canvas.add(newObj)
                canvas.setActiveObject(newObj)

        $scope.canvasDeleteObject = (id) ->
            obj = _.findWhere(canvas.getObjects(), {id: id})
            if obj?
                obj.remove()
            if toolbox.activeObject? and toolbox.activeObject.id == id
                toolbox.activeObject = null
            canvas.renderAll()

        $scope.canvasLevelObject = (level) ->
            obj = canvas.getActiveObject()
            if obj?
                switch level
                    when 'top'
                        obj.bringToFront()
                    when 'bottom'
                        obj.sendToBack()
                    when 'raise'
                        obj.bringForward()
                    when 'lower'
                        obj.sendBackwards()

        $scope.initializeCanvas = () ->
            $scope.canvasIsLoading = true
            $scope.canvasDataURL= null
            canvas.clear()
            dimensions = map.getSize()
            canvas.setHeight(dimensions.y)
            canvas.setWidth(dimensions.x)
            canvas.on 'object:modified', (e) ->
                _.debounce refreshCanvasScope(e), 1000
            canvas.on 'text:changed', (e) ->
                _.debounce refreshCanvasScope(e), 1000
            canvas.on 'path:created', (e) ->
                e.path.set( {id: "path-#{ Date.now() }"} )
                canvas.setActiveObject(e.path)
            canvas.on 'object:selected', (e) ->
                $timeout ->
                    if e.target.type in _.keys(toolbox.tools)
                        kys = _.keys(toolbox.tools[e.target.type].properties)
                        obj = _.pick(e.target.toObject(kys), kys)
                        toolbox.activeObject = obj
                        toolbox.activeTool = obj.type
                    else
                        toolbox.activeObject = null
                        toolbox.activeTool = null
            canvas.on 'object:scaling', (e) ->
                target = e.target
                if target.type in ['rect']
                    sX = target.scaleX
                    sY = target.scaleY
                    target.width *= sX
                    target.height *= sY
                    target.scaleX = 1
                    target.scaleY = 1
                        
            leafletImage map, (err, mapCanvas) ->
                # now you have canvas
                $scope.canvasIsLoading = false
                canvasAddImage mapCanvas.toDataURL()
                $timeout ->
                    # force #snapshot .modal-backdrop to reach beyond window height if necessary
                    window.dispatchEvent(new Event('resize'));
                    if $scope.map.tiles.default.options.attribution
                        # add attribution
                        attribution = new fabric.Textbox(
                            $scope.map.tiles.default.options.attribution,
                            {fontSize: 11, width: 200, left: canvas.width-200})
                        attribution.set {top: canvas.height-attribution.height - 10}
                        canvas.add(attribution)
                        canvas.renderAll()
                , 1000
            canvas.renderAll()

        $scope.downloadCanvas = () ->
            canvas.deactivateAll().renderAll()
            $scope.canvasDataURL = canvas.toDataURL()
            toolbox.activeObject = null

        $scope.printCanvas = () ->
            canvas.deactivateAll().renderAll()
            $scope.canvasDataURL = canvas.toDataURL()
            imagepage = "
                <!DOCTYPE html>
                <html>
                <head><title></title></head>
                <body onload='window.focus(); window.print(); window.close();'>
                <img src='#{ $scope.canvasDataURL }' style='width: 100%;' />
                </body>
                </html>
                "
            printWindow = window.open('', 'print')
            printWindow.document.open()
            printWindow.document.write(imagepage)
            printWindow.document.close()
            printWindow.focus()

        refreshMapStyle = () ->
            if map?
                if cartodbLayer?
                    map.removeLayer(cartodbLayer)
                if $scope.map.cartodb.vis? and $scope.map.cartodb.vis != ''
                    cartodb.createLayer(map, $scope.map.cartodb.vis, $scope.map.cartodb.options).addTo(map)
                      .on 'done', (layer) ->
                        cartodbLayer = layer
                      .on 'error', ->
                        console.log 'error adding cartodb layer'

        refreshCanvasScope = (e) ->
            if e? and toolbox.activeObject? and e.target.id == toolbox.activeObject.id
                kys = _.keys(toolbox.tools[e.target.type].properties)
                obj = _.pick(e.target.toObject(kys), kys)
                toolbox.activeObject = obj

        canvasAddImage = (data) ->
            fabric.Image.fromURL data, (oImg) ->
                canvasBaseImg = oImg
                canvasBaseImg.set(toolbox.tools.image.default)
                canvasBaseImg.set({id: "image-#{ Date.now() }", type: 'image'})
                canvas.add(canvasBaseImg)
                canvas.setActiveObject(canvasBaseImg)
                refreshCanvasScope()

        readUrlParams = () ->
            urlParams = $location.search()
            if urlParams.p? and $filter('filter')($scope.papers, {class: urlParams.p})[0]?
                $scope.paper = urlParams.p
            else
                $scope.paper = $scope.papers[defaults.paper].class
            if urlParams.u?
                $scope.map.tiles.default.url = urlParams.u
            # cartodb
            if urlParams.cu?
                $scope.map.cartodb.vis = urlParams.cu
            # attribution
            if urlParams.a?
                $scope.map.tiles.default.options.attribution = urlParams.a
        readUrlParams()

        refreshUrlParams = () ->
            urlParams = $location.search()
            urlParams.c = $scope.centerUrlHash
            urlParams.p = $scope.paper
            # cartodb
            urlParams.cu = $scope.map.cartodb.vis
            # attribution
            urlParams.a = $scope.map.tiles.default.options.attribution
            $location.search urlParams

        # watchdogs
        $scope.$watch 'toolbox.activeObject', ((newVal, oldVal) ->
            if newVal?
                obj = _.findWhere(canvas.getObjects(), {id: newVal.id})
            if obj?
                obj.setOptions(newVal)
                canvas.renderAll()
        ), true

        $scope.$watch 'canvasNewImage', ((newVal, oldVal) ->
            if newVal?
                canvasAddImage(newVal)
        )

        $scope.$watch 'toolbox.canvasProperties', ((newVal, oldVal) ->
            if canvas? and newVal?
               canvas.setBackgroundColor newVal.backgroundColor
               canvas.renderAll()
        ), true

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
                'map.cartodb.vis'
                'map.tiles.default.options.attribution'
            ],((newVal, oldVal) ->
                refreshUrlParams()
                refreshMapStyle()
        )

        $scope.$on 'centerUrlHash', (event, centerHash) ->
            $scope.centerUrlHash = centerHash
            refreshUrlParams()
            return

    ]
