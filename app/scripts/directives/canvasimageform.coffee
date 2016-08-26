'use strict'

###*
 # @ngdoc directive
 # @name angularMapPrinterApp.directive:canvasImageForm
 # @description
 # # canvasImageForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasImageForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-image-form.html'
        link: (scope, element, attrs) ->
