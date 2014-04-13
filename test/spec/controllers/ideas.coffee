'use strict'

describe 'Controller: IdeasCtrl', () ->

  # load the controller's module
  beforeEach module 'realEstateFrontEndApp'

  IdeasCtrl = {}
  timeout = undefined
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, $httpBackend, REALESTATEAPI,
    $timeout) ->
    timeout = $timeout
    scope = $rootScope.$new()
    IdeasCtrl = $controller 'IdeasCtrl', {
      $scope: scope
    }


  describe 'Crudable', () ->
    mainResource = 'ideas'
    otherResources = ['trades']

    mainUrl = undefined
    otherUrls = undefined
    httpBackend = undefined
    API = undefined

    beforeEach inject ($httpBackend, REALESTATEAPI) ->
      httpBackend = $httpBackend
      API = REALESTATEAPI

      mainUrl = "#{API}/#{mainResource}"
      otherUrls = _.map otherResources, (resource) ->
        "#{API}/#{resource}"

    describe 'Editable', () ->
      it 'initial state', () ->
        expect(scope.isEditing(id)).toBe false for id in [1..31]

      it '.edit, .isEditing', () ->
        for id in [1..7]
          expect(scope.isEditing(id)).toBe false
          scope.edit id

          expect(scope.isEditing(i)).toBe true for i in [1..id]

          if id != 7
            for i in [(id+1)..7]
              expect(scope.isEditing(i)).toBe false

      it '.reset', () ->
        for id in [1..7]
          scope.edit id
          scope.reset id

          expect(scope.isEditing(id)).toBe false


    describe '.create, .update, .destroy', () ->

      beforeEach () ->
        httpBackend.whenGET(url).respond [{}] for url in otherUrls
        httpBackend.whenGET(mainUrl).respond [{}]

        httpBackend.expectGET url for url in otherUrls
        httpBackend.expectGET mainUrl

      afterEach () ->
        httpBackend.expectGET url for url in otherUrls
        httpBackend.expectGET mainUrl

        httpBackend.flush()
        httpBackend.verifyNoOutstandingExpectation()
        httpBackend.verifyNoOutstandingRequest()


      it '.create', () ->
        record = {a: 1, b: 2}

        httpBackend.whenPOST(mainUrl).respond record
        httpBackend.expectPOST(mainUrl, record)

        scope.create record

      it '.update', () ->
        record = {id: 7, a: 1, b: 2}
        updatedRecord = {id: 7, a: 2, b: 1}

        httpBackend.whenPUT("#{API}/#{mainResource}/#{record.id}").respond updatedRecord
        httpBackend.expectPUT("#{API}/#{mainResource}/#{record.id}", updatedRecord)

        scope.update updatedRecord

      it '.destroy', () ->
        record = {id: 3, a: 1, b: 2}

        httpBackend.whenDELETE("#{API}/#{mainResource}/#{record.id}").respond record
        httpBackend.expectDELETE("#{API}/#{mainResource}/#{record.id}")

        scope.destroy record.id

        
    it 'initial state', (done) ->
      trades = [{a:1,b:2}]
      ideas  = [{x:1,b:2}]

      httpBackend.whenGET("#{API}/trades").respond trades
      httpBackend.whenGET(mainUrl).respond ideas

      expect(scope.trades).toBe undefined
      expect(scope.ideas).toBe undefined

      window.setTimeout () ->
        expect(angular.equals(scope.ideas, ideas)).toBe true
        expect(angular.equals(scope.trades, trades)).toBe true

        done()

      httpBackend.flush()

  window.MyApp.itBehavesLike 'Selectable', 'IdeasCtrl', ['Trade']
