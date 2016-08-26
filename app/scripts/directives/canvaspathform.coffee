'use strict'

###*
 # @ngdoc directive
 # @name angularMapPrinterApp.directive:canvasPathForm
 # @description
 # # canvasPathForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasPathForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-path-form.html'
        link: (scope, element, attrs) ->
