'use strict'

###*
 # @ngdoc directive
 # @name mapPrinterApp.directive:canvasCircleForm
 # @description
 # # canvasCircleForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasCircleForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-circle-form.html'
        link: (scope, element, attrs) ->
