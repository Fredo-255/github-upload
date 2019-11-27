@isTest
public with sharing class OPARequestTest {
    @isTest 
    public static void testGetRates() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        OPARequest request = new OPARequest(autorisation.id);
        Test.startTest();
        OPAResponse response = request.getRates();
        Test.stopTest();
        System.debug(response.rates.keySet());
        System.assertEquals(1,response.rates.size());
        System.assertEquals(160, response.rates.get('NUM_MT_HT_SACEM').ValueHT);
    }

    @isTest 
    public static void testCode500() {
        Test.setMock(HttpCalloutMock.class, OPACalloutMock.getHttpCalloutMock500());
        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);
        OPARequest request = new OPARequest(autorisation.id);
        Test.startTest();
        OPAResponse response = request.getRates();
        Test.stopTest();
        System.debug(response.rates.keySet());
        System.assertEquals(0,response.rates.size());
        System.assertEquals(-2500, response.OPARequestErrorCode);
    }
}