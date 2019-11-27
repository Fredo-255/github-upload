@isTest
public with sharing class OPAServiceTest {
    
    @isTest
    public static void testRetrieveRates() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        Test.startTest();
        OPAService.retrieveRates(autorisation.id);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(1, rates.size());
        System.assertEquals('NUM_MT_HT_SACEM', rates[0].Name);


    }

    @isTest
    public static void testRetrieveRatesInvocable() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        List<Id> lstIds = new List<Id>();
        lstIds.add(autorisation.id);
        Test.startTest();
        OPAService.retrieveRates(lstIds);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(1, rates.size());
        System.assertEquals('NUM_MT_HT_SACEM', rates[0].Name);


    }



    @isTest
    public static void testCode500() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock500());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        Test.startTest();
        OPAService.OPAResult result = OPAService.retrieveRates(autorisation.id);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(0, rates.size());
        System.assertEquals(-2500, result.resultCode);
    }

    @isTest
    public static void testOtherOPAFail() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock500());
        FailTest.addFailure('OtherOPAFail');
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        Test.startTest();
        OPAService.OPAResult result = OPAService.retrieveRates(autorisation.id);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(0, rates.size());
        System.assertEquals(-2000, result.resultCode);
    }

   
    @isTest
    public static void testCalloutFail() {
        Test.setMock(HttpCalloutMock.class, new UnauthorizedEndpointResponse());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        Test.startTest();
        OPAService.OPAResult result = OPAService.retrieveRates(autorisation.id);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(0, rates.size());
        System.assertEquals(-2001, result.resultCode);
    }

    @isTest
    public static void testWriteFail() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock());
        FailTest.addFailure('WriteFail');
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        Test.startTest();
        OPAService.OPAResult result = OPAService.retrieveRates(autorisation.id);
        Test.stopTest();
        List<Rate__c> rates = [
            SELECT Id, Name
            FROM Rate__c
        ];
        System.assertEquals(0, rates.size());
        System.assertEquals(-3000, result.resultCode);
    }
}