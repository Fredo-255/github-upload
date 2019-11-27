@isTest
public with sharing class OPAResponseTest {
    
    @isTest
    public static void testReadJsonResponse() {
        String jsonResponse = [
            SELECT body 
            FROM StaticResource 
            WHERE Name = 'TestOPAAssessResponse'
            ].body.toString();

        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);

        Test.startTest();
        OPAResponse response = new OPAResponse(jsonResponse);
        Test.stopTest();

        System.debug(response);

        System.assertEquals(3, response.rates.size()); // Il y a 3 tarifs dans le fichier de test
        System.assertEquals(6, response.rates.values()[0].ratelines.size()); // Il y a 6 lignes dans le premier tarif

        System.assertEquals('NUM_REDEV_SACEM_THEO_TR_GLOBAL', response.rates.values()[1].Name); // Nom du deuxième tarif
        System.assertEquals(105.52, response.rates.values()[2].ValueHT); // Valeur du 3e tarif
        System.assertEquals('NUM_REDEV_SACEM_THEO_TG', response.rates.values()[0].ratelines[1].Name); 
            // Nom de la dexièpme ligne du premier tarif
        System.assertEquals('Tarif réduit SACEM HT: €157,49.', response.rates.values()[1].ratelines[0].Label);
            // Libellé de la première ligne du deuxième tarif
        System.assertEquals(105.51696, response.rates.values()[2].ratelines[2].valueHT);
            // Valeur de la troisième ligne du 3ème tarif
    }


    @isTest
    public static void testReadJsonResponsePortail() {
        String jsonResponse = [
            SELECT body 
            FROM StaticResource 
            WHERE Name = 'TestOPAResponseSELOLPortail'
            ].body.toString();

        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);

        Test.startTest();
        OPAResponse response = new OPAResponse(jsonResponse);
        Test.stopTest();

        System.debug(response);
        System.debug(response.rates.get('NUM_MT_HT_SACEM').RateLines);
        System.debug(response.rates.get('NUM_MT_HT_SACEM').BillingLines);


        // System.assertEquals(3, response.rates.size()); // Il y a 3 tarifs dans le fichier de test
        // System.assertEquals(6, response.rates.values()[0].ratelines.size()); // Il y a 6 lignes dans le premier tarif

        // System.assertEquals('NUM_REDEV_SACEM_THEO_TR_GLOBAL', response.rates.values()[1].Name); // Nom du deuxième tarif
        // System.assertEquals(105.52, response.rates.values()[2].ValueHT); // Valeur du 3e tarif
        // System.assertEquals('NUM_REDEV_SACEM_THEO_TG', response.rates.values()[0].ratelines[1].Name); 
        //     // Nom de la dexièpme ligne du premier tarif
        // System.assertEquals('Tarif réduit SACEM HT: €157,49.', response.rates.values()[1].ratelines[0].Label);
        //     // Libellé de la première ligne du deuxième tarif
        // System.assertEquals(105.51696, response.rates.values()[2].ratelines[2].valueHT);
        //     // Valeur de la troisième ligne du 3ème tarif
    }

    @isTest
    public static void testReadComplexJsonResponse() {
        String jsonResponse = [
            SELECT body 
            FROM StaticResource 
            WHERE Name = 'TestOPAResponse2'
            ].body.toString();

        Asset autorisation = OPADataFactory.createAuthorization();
        OPADAO.setAuthorizationId(autorisation.id);

        for(BroadcastSpace__c space : OPADAO.mapSpaces.values()) {
            jsonResponse = jsonResponse.replace('@' + space.Name, space.id);
            for (WayDiffusion__c waydiff : OPADAO.mapWaysDiffusion.values()) {
                jsonResponse = jsonResponse.replace('@' + waydiff.Name, waydiff.id);
            }
        }

        Test.startTest();
        OPAResponse response = new OPAResponse(jsonResponse);
        Test.stopTest();

        System.debug(response.rates.keySet());
        System.debug(response.rates);

        System.assertEquals(5, response.rates.size()); // Il y a 3 tarifs dans le fichier de test
        System.assertEquals(12, response.rates.values()[0].ratelines.size()); // Il y a 6 lignes dans le premier tarif

        System.assertEquals('NUM_MT_SPRE', response.rates.values()[1].Name); // Nom du deuxième tarif
        System.assertEquals(2846.61, response.rates.values()[2].ValueHT); // Valeur du 3e tarif
        System.assertEquals('NUM_REDEV_SACEM_ESPACE_SONO', response.rates.values()[0].ratelines[1].Name); 
            // Nom de la dexièpme ligne du premier tarif
        System.assertEquals('Montant SPRE théorique: €558,26.', response.rates.values()[1].ratelines[0].Label);
            // Libellé de la première ligne du deuxième tarif
        System.assertEquals(1028.88675, response.rates.values()[2].ratelines[2].valueHT);
            // Valeur de la troisième ligne du 3ème tarif
    }

    @isTest
    public static void testWriteLines() {

        Asset autorisation = OPADataFactory.createAuthorization();
        OPAResponse response = OPADataFactory.createOPAResponse();
        OPADAO.setAuthorizationId(autorisation.id);

        System.debug('OPA response : ' + response);

        Test.startTest();
        response.writeRatesToAuthorization(autorisation.id);
        Test.stopTest();

        List<Rate__c> lstRates = [
            SELECT Id, Name, Company__c, RateType__c, DutyFreeRealAmount__c, DutyFreeTheoreticalAmount__c, 
                (
                    SELECT Id, Name, Description__c, DutyFreeAmount__c, Rank__c
                    FROM ChildRateLine__r
                    ORDER BY Rank__c
                )
            FROM Rate__c
        ];
        System.debug(lstRates);
        for(Rate__c rate : lstRates) {
            System.debug('Tarif ' + rate.Name + ' : ' + rate);
            for(RateLine__c rateLine : rate.ChildRateLine__r) {
                System.debug('> ' + rateLine.rank__c + ' : ' + rateLine);
            }
        }
        System.assertEquals(2, lstRates.size());
        System.assertEquals(1, lstRates[0].ChildRateLine__r.size()); // 1 ligne de tarif pour le tarif 1
        System.assertEquals(2, lstRates[1].ChildRateLine__r.size()); // 2 lignes de tarif pour le tarif 2
        System.assertEquals(OPAConstants.TARIF_GENERAL, lstRates[0].RateType__c); // Le tarif 1 est de type tarif général
        System.assertEquals(OPAConstants.COMPANY_SACEM, lstRates[1].Company__c);  // Le tarif 2 est pour la Sacem

    }
}