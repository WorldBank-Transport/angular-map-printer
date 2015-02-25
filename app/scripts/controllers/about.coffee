'use strict'

###*
 # @ngdoc function
 # @name mapPrinterApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the mapPrinterApp
###
angular.module('mapPrinterApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
