@isTest
public without sharing class OPACalloutMock {

    public static StaticResourceCalloutMock getHttpCalloutMock(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TestOPAResponseSELOLPortail');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        
        return mock;
    }
    
    public static StaticResourceCalloutMock getHttpCalloutMock500(){
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('TestOPAError500');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        
        return mock;
    }
}