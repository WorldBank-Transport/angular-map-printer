'use strict'

###*
 # @ngdoc directive
 # @name mapPrinterApp.directive:inputFilereader
 # @description
 # # inputFilereader
###

angular.module 'mapPrinterApp'
    .directive 'inputFilereader', ($q) ->
      slice = Array::slice

      {
        restrict: 'A'
        require: '?ngModel'
        link: (scope, element, attrs, ngModel) ->
          if !ngModel
            return

          ngModel.$render = ->

          element.bind 'change', (e) ->
            `var element`
            element = e.target

            readFile = (file) ->
              deferred = $q.defer()
              reader = new FileReader

              reader.onload = (e) ->
                deferred.resolve e.target.result
                return

              reader.onerror = (e) ->
                deferred.reject e
                return

              reader.readAsDataURL file
              deferred.promise

            $q.all(slice.call(element.files, 0).map(readFile)).then (values) ->
              if element.multiple
                ngModel.$setViewValue values
              else
                ngModel.$setViewValue if values.length then values[0] else null
              return
            return

          return

      }

