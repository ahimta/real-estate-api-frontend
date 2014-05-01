'use strict'

angular.module('realEstateFrontEndApp')
  .controller 'TradesCtrl', ($scope, $routeParams, Trade,
    ControllersTraits, EditableTrait, TranslatableTrait,
    PaginatableTrait) ->

    PaginatableTrait $scope, Trade, 'trades'

    TranslatableTrait $scope

    EditableTrait $scope

    invalidator = ControllersTraits.Crudable($scope, Trade, 'trades',
      [], ['trade'], $routeParams)

    invalidator()
