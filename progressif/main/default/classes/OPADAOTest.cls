@isTest
public with sharing class OPADAOTest {
    //Ces tests ont pour but de valider l'aspect statique des méthodes et la non répétition des 
    //requpetes SOQL

    @isTest
    public static void testMapAuthorizations() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, Asset> myMap = OPADAO.mapAuthorizations;
        Map<Id, Asset> myOtherMap = OPADAO.mapAuthorizations;
        System.assertEquals(1, system.Limits.getQueries()); // La requête SOQL ne doit avoir été appelée qu'une fois
        test.stopTest();
        System.debug(myMap);
    }

    @isTest
    public static void testMapSpaces() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, BroadcastSpace__c> myMap = OPADAO.mapSpaces;
        Map<Id, BroadcastSpace__c> myOtherMap = OPADAO.mapSpaces;
        System.assertEquals(1, system.Limits.getQueries()); // La requête SOQL ne doit avoir été appelée qu'une fois
        test.stopTest();
        System.debug(myMap);
    }

    @isTest
    public static void testMapWaysDiffusion() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, WayDiffusion__c> myMap = OPADAO.mapWaysDiffusion;
        Map<Id, WayDiffusion__c> myOtherMap = OPADAO.mapWaysDiffusion;
        Map<Id, BroadcastSpace__c> MySpacesMap = OPADAO.mapSpaces;
        System.assertEquals(2, system.Limits.getQueries()); 
        // ways diffusion fait un premier appel à mapSpaces. Il y a donc deux requpetes SOQL
        // l'appel à mapSpaces vérifie que l'on ne recrée pas cette map à nouveau.
        test.stopTest();
        System.debug(myMap);
    }


    @isTest
    public static void testMapOfferIdByAuthorizationId() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, Id> myMap = OPADAO.mapOfferIdByAuthorizationId;
        Map<Id, Id> myOtherMap = OPADAO.mapOfferIdByAuthorizationId;
        System.assertEquals(1, system.Limits.getQueries()); // La requête SOQL ne doit avoir été appelée qu'une fois
        test.stopTest();
        System.debug(myMap);
    }

    @isTest
    public static void testMapLstOutcomesByOfferId() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, List<OfferOutcome__c>> myMap = OPADAO.mapLstOutcomesByOfferId;
        Map<Id, List<OfferOutcome__c>> myOtherMap = OPADAO.mapLstOutcomesByOfferId;
        Map<Id, Id> myOfferMap = OPADAO.mapOfferIdByAuthorizationId;
        System.assertEquals(2, system.Limits.getQueries()); 
        // Fait un premier appel à mapOfferIdByAuthorizationId. Il y a donc deux requpetes SOQL
        // l'appel à mapOfferIdByAuthorizationId vérifie que l'on ne recrée pas cette map à nouveau.
        test.stopTest();
        System.debug(myMap);
    }

    @isTest
    public static void testMapOutcomesByName() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<String, OfferOutcome__c> myMap = OPADAO.mapOutcomesByName;
        Map<String, OfferOutcome__c> myOtherMap = OPADAO.mapOutcomesByName;
        Map<Id, Id> myOfferMap = OPADAO.mapOfferIdByAuthorizationId;
        System.assertEquals(2, system.Limits.getQueries()); 
        // Fait un premier appel à mapOfferIdByAuthorizationId. Il y a donc deux requpetes SOQL
        // l'appel à mapOfferIdByAuthorizationId vérifie que l'on ne recrée pas cette map à nouveau.
        test.stopTest();
        System.debug(myMap);
    }

    @isTest
    public static void testMapAuthorizationCriteriaByAuthorizationId() {
        Id autorisationId = OPADataFactory.createAuthorization(true).Id;
        OPADAO.setAuthorizationId(autorisationId);

        test.startTest();
        Map<Id, List<CriterionAuthorization__c>> myMap = OPADAO.mapAuthorizationCriteriaByAuthorizationId;
        Map<Id, List<CriterionAuthorization__c>> myOtherMap = OPADAO.mapAuthorizationCriteriaByAuthorizationId;
        System.assertEquals(1, system.Limits.getQueries()); // La requête SOQL ne doit avoir été appelée qu'une fois
        test.stopTest();
        System.debug(myMap);
    }
}