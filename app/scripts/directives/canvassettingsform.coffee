'use strict'

###*
 # @ngdoc directive
 # @name mapPrinterApp.directive:canvasSettingsForm
 # @description
 # # canvasSettingsForm
###
angular.module 'mapPrinterApp'
    .directive 'canvasSettingsForm', ->
        restrict: 'EA'
        require: '^ngModel'
        scope:
            _model: '=ngModel'
        templateUrl: 'views/directives/canvas-settings-form.html'
        link: (scope, element, attrs) ->
