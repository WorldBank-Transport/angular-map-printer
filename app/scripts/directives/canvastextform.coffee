'use strict'

###*
 # @ngdoc directive
 # @name mapPrinterApp.directive:canvasTextForm
 # @description
 # # canvasTextForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasTextForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-text-form.html'
        link: (scope, element, attrs) ->
            scope.bold = () ->
                if scope._model.fontWeight == 'bold' 
                    scope._model.fontWeight = 'normal'
                else
                    scope._model.fontWeight = 'bold'
            scope.italic = () ->
                if scope._model.fontStyle == 'italic' 
                    scope._model.fontStyle = 'normal'
                else
                    scope._model.fontStyle = 'italic'
            scope.textDecoration = (decoration) ->
                if scope._model.textDecoration == decoration
                    scope._model.textDecoration = 'none'
                else
                    scope._model.textDecoration = decoration
            scope.textAlign = (orientation) ->
                if orientation in ['left', 'right', 'center', 'justify']
                    scope._model.textAlign = orientation
                else
                    scope._model.textAlign = 'left'

