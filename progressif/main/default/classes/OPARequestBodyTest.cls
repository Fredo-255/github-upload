@IsTest
public without sharing class OPARequestBodyTest {

    @IsTest 
    public static void testBodyCreation() {
        Asset autorisation = OPADataFactory.createAuthorization();
        System.debug(autorisation);
        OPADAO.setAuthorizationId(autorisation.Id);

        Test.startTest();
        String body = OPARequestBody.create(autorisation.Id);
        Test.stopTest();

        System.debug(body);

        Map<String, Object> bodyObj = (Map<String, Object>)JSON.deserializeUntyped(body);

        // Vérification des critères
        /*
        List<Object> cases = (List<Object>)bodyObj.get('cases');
        Map<String, Object> criteres = (Map<String, Object>)cases[0];
        System.debug(criteres);
        System.assertEquals('AAA', (String)criteres.get('TEXTE_OPA_CRIT'));
        System.assertEquals(999.0, (Double)criteres.get('NOMBRE_OPA_CRIT'));
        System.assertEquals('2020-01-01', (String)criteres.get('DATE_OPA_CRIT'));
        System.assert((Boolean)criteres.get('BOOLEEN_OPA_CRIT'));

        // Vérification des objectifs
        List<Object> outcomes = (List<Object>)bodyObj.get('outcomes');
        System.debug(outcomes);
        System.assert(outcomes.contains('OBJ_TR'));
        System.assert(outcomes.contains('OBJ_TG'));
        */
    }

    @isTest
    public static void testComplexBodyCreation() {
        Asset autorisation = OPADataFactory.createAuthorization(true);
        System.debug(autorisation);

        for(CriterionAuthorization__c critere : [
            SELECT Id, Name, CriterionResponseAuthz__c, BroadcastSpace__r.Name, WayDiffusion__r.Name, CriterionOffer__r.Name
            FROM CriterionAuthorization__c
            ]) {
                System.debug(critere);
        }
        OPADAO.setAuthorizationId(autorisation.Id);

        Test.startTest();
        String body = OPARequestBody.create(autorisation.Id);
        Test.stopTest();

        System.debug(body);

        Map<String, Object> bodyObj = (Map<String, Object>)JSON.deserializeUntyped(body);

        // Vérification des critères
        /*
        List<Object> cases = (List<Object>)bodyObj.get('cases');
        Map<String, Object> criteres = (Map<String, Object>)cases[0];
        System.debug(criteres);
        System.assertEquals('AAA', (String)criteres.get('TEXTE_OPA_CRIT'));
        System.assertEquals(999.0, (Double)criteres.get('NOMBRE_OPA_CRIT'));
        System.assertEquals('2020-01-01', (String)criteres.get('DATE_OPA_CRIT'));
        System.assert((Boolean)criteres.get('BOOLEEN_OPA_CRIT'));

        // Vérification des objectifs
        List<Object> outcomes = (List<Object>)bodyObj.get('outcomes');
        System.debug(outcomes);
        System.assert(outcomes.contains('OBJ_TR'));
        System.assert(outcomes.contains('OBJ_TG'));
        */
    }
}