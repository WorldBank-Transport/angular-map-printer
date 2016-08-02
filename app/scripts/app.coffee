'use strict'

###*
 # @ngdoc overview
 # @name mapPrinterApp
 # @description
 # # mapPrinterApp
 # #
 # Main module of the application.
### #
angular
  .module('mapPrinterApp', [
    'ngAnimate',
    'ngAria',
    'ngCookies',
    'ngMessages',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch',
    'leaflet-directive',
    'jdFontselect',
    'colorpicker.module'
  ])
  .config ($routeProvider, $compileProvider) ->
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file|blob):|data:image\//)
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
        reloadOnSearch: false
      .when '/home',
        redirectTo: '/'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .otherwise
        redirectTo: '/'

