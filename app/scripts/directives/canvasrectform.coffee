'use strict'

###*
 # @ngdoc directive
 # @name mapPrinterApp.directive:canvasRectForm
 # @description
 # # canvasRectForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasRectForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-rect-form.html'
        link: (scope, element, attrs) ->
            
