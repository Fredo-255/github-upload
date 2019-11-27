public without sharing class OPADAO {
// Classe DAO pour l'interface OPA

// Authorization Ids have to be set before use

    private static Set<Id> authorizationIds = new Set<Id>();

    

    public static void setAuthorizationId(Id id) {
        authorizationIds.add(id);
    }

    // Maps as readeable properties

    public static Map<Id, Asset> mapAuthorizations {
        get {
            if(mapAuthorizations == null) buildAuthorizationMap();
            return mapAuthorizations;
        }
        private set;
    }

    public static Map<Id, BroadcastSpace__c> mapSpaces {
        get {
            if(mapSpaces == null) buildSpacesMap();
            return mapSpaces;
        }
        private set;
    }

    public static Map<Id, WayDiffusion__c> mapWaysDiffusion {
        get {
            if(mapWaysDiffusion == null) buildWaysDiffusionMap();
            return mapWaysDiffusion;
        }
        private set;
    }

    public static Map<Id, Id> mapOfferIdByAuthorizationId {
        get {
            if(mapOfferIdByAuthorizationId == null) buildMapOfferIdByAuthorizationId();
            return mapOfferIdByAuthorizationId;
        }
        private set;
    }

    public static Map<Id, List<OfferOutcome__c>> mapLstOutcomesByOfferId {
        get {
            if(mapLstOutcomesByOfferId == null) buildOutcomeMaps();
            return mapLstOutcomesByOfferId;
        }
        private set;
    }

    public static Map<String, OfferOutcome__c> mapOutcomesByName {
        get {
            if(mapOutcomesByName == null) buildOutcomeMaps();
            return mapOutcomesByName;
        }
        private set;
    }

    public static Map<Id, List<CriterionAuthorization__c>> mapAuthorizationCriteriaByAuthorizationId {
        get {
            if(mapAuthorizationCriteriaByAuthorizationId == null) buildMapAuthorizationCriteriaByAuthorizationId();
            return mapAuthorizationCriteriaByAuthorizationId;
        }
        private set;
    }


// Map builders 

    private static void buildAuthorizationMap() {
        mapAuthorizations = new Map<Id, Asset>([
            SELECT Id, Name, Offre__c, Offre__r.Scale__c
            FROM Asset
            WHERE Id in :authorizationIds
        ]);
    }


    private static void buildSpacesMap() {        
        mapSpaces = new Map<Id, BroadcastSpace__c>([
            SELECT Id, Name
            FROM BroadcastSpace__c
            WHERE Authorization__c in :authorizationIds
        ]);
    }

    private static void buildWaysDiffusionMap() {
        mapWaysDiffusion = new Map<Id, WayDiffusion__c>([
            SELECT Id, BroadcastSpace__c, Name, DiffusionPoint__c
            FROM WayDiffusion__c
            WHERE BroadcastSpace__c in :mapSpaces.keySet()
        ]);
    } 

    private static void buildMapOfferIdByAuthorizationId() {
        mapOfferIdByAuthorizationId = new Map<Id, Id>();
        for(Asset autorisation : [
            SELECT Id, Name, Offre__c
            FROM Asset
            WHERE Id in :authorizationIds
        ]) {
            mapOfferIdByAuthorizationId.put(autorisation.Id, autorisation.Offre__c);
        }
    }

    private static void buildOutcomeMaps() {
    // Construction des maps mapLisOutcomesByOfferId et mapOutcomesByName
        mapLstOutcomesByOfferId = new Map<Id, List<OfferOutcome__c>>();
        mapOutcomesByName = new Map<String, OfferOutcome__c>();

        for(OfferOutcome__c outcome : [
            SELECT Id, Name, Offer__c, OutcomeType__c, AssociatedRateName__c, Company__c, RateType__c
            FROM OfferOutcome__c
            WHERE Offer__c in :mapOfferIdByAuthorizationId.values()
        ]) {
            if(!mapLstOutcomesByOfferId.containsKey(outcome.Offer__c)) {
                mapLstOutcomesByOfferId.put(outcome.Offer__c, new List<OfferOutcome__c>());
            }
            mapLstOutcomesByOfferId.get(outcome.Offer__c).add(outcome);

            mapOutcomesByName.put(outcome.Name, outcome);

        }
    }

    private static void buildMapAuthorizationCriteriaByAuthorizationId() {

        mapAuthorizationCriteriaByAuthorizationId = new Map<Id, List<CriterionAuthorization__c>>();
        for(CriterionAuthorization__c critere : [
            SELECT Authorization__c, CriterionResponseAuthz__c, CriterionOffer__r.OPACriterionName__c, CriterionOffer__r.criterion__r.TypeCriterion__c, BroadcastSpace__c, WayDiffusion__c
            FROM CriterionAuthorization__c
            WHERE Authorization__c in :authorizationIds AND CriterionToSendToOPA__c = true
            ORDER BY Id ASC NULLS FIRST
        ]) {
            if(!mapAuthorizationCriteriaByAuthorizationId.containsKey(critere.Authorization__c)) {
                mapAuthorizationCriteriaByAuthorizationId.put(critere.Authorization__c, new List<CriterionAuthorization__c>());
            }
            mapAuthorizationCriteriaByAuthorizationId.get(critere.Authorization__c).add(critere);
        }

    }

    





}