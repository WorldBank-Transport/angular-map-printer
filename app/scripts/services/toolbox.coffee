'use strict'

###*
 # @ngdoc service
 # @name mpPrinterApp.toolbox
 # @description
 # # toolbox
 # Factory in the mapPrinterApp.
###
angular.module 'mapPrinterApp'
    .factory 'toolbox', ->
        # Service logic
        # ...

        @canvasProperties = backgroundColor: 'rgba(255,255,255,1)'

        @activeTool = null
        
        @activeObject = null

        # Tools list
        # Trying to make things compatible with angular-schema-forms
        @tools = {
            'textbox':
                type: 'object'
                properties:
                    text:
                        type: 'string'
                        'default': 'Write here'
                    fill:
                        title: 'color'
                        type: 'string'
                    fontSize:
                        title: 'size'
                        type: 'number'
                    fontStyle:
                        title: 'style'
                        type: 'string'
                    fontFamily:
                        title: 'font'
                        type: 'string'
                    fontWeight:
                        title: 'weight'
                        type: 'string'
                    textDecoration:
                        title: 'decoration'
                        type: 'string'
                    textAlign:
                        title: 'align'
                        type: 'string'
                    opacity:
                        title: 'opacity'
                        type: 'integer'
                    backgroundColor:
                        type: 'string'
                        title: 'background color'
                    type:
                        type: 'string'
                        title : 'type'
                    id:
                        type: 'string'
                        title: 'id'
                icon: 'fa-font'
                title: 'Text'
                default:
                    fill: 'rgba(0,0,0,1)'
                    fontSize: 50
                    text: 'Write here'
                    width: 300
                    backgroundColor: null
            rect:
                type: 'object'
                properties:
                    width:
                        type: 'integer'
                        title: 'width'
                    height:
                        type: 'integer'
                        title: 'height'
                    fill:
                        type: 'string'
                        title: 'fill color'
                    strokeWidth:
                        type: 'number'
                        title: 'stoke width'
                    stroke:
                        type: 'string'
                        title: 'stroke color'
                    opacity:
                        type: 'integer'
                        title: 'opacity'
                    type:
                        type: 'string'
                        title : 'type'
                    id:
                        type: 'string'
                        title: 'id'
                icon: 'fa-square-o'
                title: 'Rectangle'
                default:
                    width: 100
                    height: 100
                    strokeWidth: 0
                    stroke: 'rgba(0,0,0,1)'
            circle:
                type: 'object'
                properties:
                    radius:
                        type: 'integer'
                        title: 'radius'
                    scaleX:
                        type: 'integer'
                        title: 'scale X'
                    scaleY:
                        type: 'integer'
                        title: 'scale Y'
                    fill:
                        type: 'string'
                        title: 'fill color'
                    strokeWidth:
                        type: 'number'
                        title: 'stoke width'
                    stroke:
                        type: 'string'
                        title: 'stroke color'
                    opacity:
                        type: 'integer'
                        title: 'opacity'
                    type:
                        type: 'string'
                        title : 'type'
                    id:
                        type: 'string'
                        title: 'id'
                icon: 'fa-circle-thin'
                title: 'Circle'
                default:
                    radius: 100
                    strokeWidth: 0
                    stroke: 'rgba(0,0,0,1)'
            path:
                type: 'object'
                properties:
                    stroke:
                        type: 'string'
                        title: 'stoke color'
                    strokeWidth:
                        type: 'interger'
                        title: 'stroke width'
                    type:
                        type: 'string'
                        title : 'type'
                    id:
                        type: 'string'
                        title: 'id'
                icon: 'fa-pencil'
                title: 'Free drawing'
                default:
                    strokeWidth: 2
                    stroke: 'rgba(0,0,0,1)'
            image:
                type: 'object'
                properties:
                    width:
                        type: 'integer'
                        title: 'width'
                    height:
                        type: 'integer'
                        title: 'height'
                    scaleX:
                        type: 'integer'
                        title: 'scale X'
                    scaleY:
                        type: 'integer'
                        title: 'scale Y'
                    opacity:
                        type: 'integer'
                        title: 'opacity'
                    stroke:
                        type: 'string'
                        title: 'stoke color'
                    strokeWidth:
                        type: 'interger'
                        title: 'stroke width'
                    type:
                        type: 'string'
                        title : 'type'
                    id:
                        type: 'string'
                        title: 'id'
                icon: 'fa-picture-o'
                title: 'Image'
                default:
                    strokeWidth: 0
                    stroke: 'rgba(0,0,0,1)'
            canvas:
                type: 'object'
                properties:
                    backgroundColor:
                        type: 'string'
                        title: 'background color'
                    type:
                        type: 'string'
                        title : 'type'
                icon: 'fa-cog'
                title: 'General settings'
                default:
                    backgroundColor: 'rgba(255,255,255,1)'
                    preserveObjectStacking: true
            hand:
                type: 'object'
                properties:
                    type:
                        type: 'string'
                        title : 'type'
                icon: 'fa-hand-pointer-o'
                title: 'pointer'
                default: {}

            }

        return this
