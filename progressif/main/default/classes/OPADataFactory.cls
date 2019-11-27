@IsTest
public with sharing class OPADataFactory {



    private static List<Criterion__c> createCriteria() {
        List<Criterion__c> lstCriteres = new List<Criterion__c>();
        Criterion__c critere;
        // Critère numérique
        critere = new Criterion__c(
            Name = 'Critère numérique',
            Target__c = 'Standard',
            TypeCriterion__c = OPAConstants.TYPE_NOMBRE,
            LabelCriterion__c = 'Nombre',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 10);
        lstCriteres.add(critere);
        // Critère Booléen
        critere = new Criterion__c(
            Name = 'Critère booleen',
            Target__c = 'Standard',
            TypeCriterion__c = OPAConstants.TYPE_BOOLEEN,
            LabelCriterion__c = 'Booleen',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 20);
        lstCriteres.add(critere);
        // Critère chaîne
        critere = new Criterion__c(
            Name = 'Critère texte',
            Target__c = 'Standard',
            TypeCriterion__c = OPAConstants.TYPE_TEXTE,
            LabelCriterion__c = 'Texte',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 30);
        lstCriteres.add(critere);
        critere = new Criterion__c(
            Name = 'Critère date',
            Target__c = 'Standard',
            TypeCriterion__c = OPAConstants.TYPE_DATE,
            LabelCriterion__c = 'Date',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 40);
        lstCriteres.add(critere);  
        insert lstCriteres; 
        return lstCriteres;     
    }

    private static List<Criterion__c> createSpaceCriteria() {
        List<Criterion__c> lstCriteres = new List<Criterion__c>();
        Criterion__c critere;
        // Critère numérique
        critere = new Criterion__c(
            Name = 'Espace numérique',
            Target__c = OPAConstants.TARGET_SPACE,
            TypeCriterion__c = OPAConstants.TYPE_NOMBRE,
            LabelCriterion__c = 'Espace Nombre',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 10);
        lstCriteres.add(critere);
        // Critère chaîne
        critere = new Criterion__c(
            Name = 'Espace texte',
            Target__c = OPAConstants.TARGET_SPACE,
            TypeCriterion__c = OPAConstants.TYPE_TEXTE,
            LabelCriterion__c = 'Espace Texte',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 30);
        lstCriteres.add(critere);
        insert lstCriteres; 
        return lstCriteres;     
    }

    private static List<Criterion__c> createMoyenCriteria() {
        List<Criterion__c> lstCriteres = new List<Criterion__c>();
        Criterion__c critere;
        // Critère numérique
        critere = new Criterion__c(
            Name = 'Moyen numérique',
            Target__c = OPAConstants.TARGET_MOYEN,
            TypeCriterion__c = OPAConstants.TYPE_NOMBRE,
            LabelCriterion__c = 'Moyen Nombre',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 10);
        lstCriteres.add(critere);
        // Critère chaîne
        critere = new Criterion__c(
            Name = 'Moyen texte',
            Target__c = OPAConstants.TARGET_MOYEN,
            TypeCriterion__c = OPAConstants.TYPE_TEXTE,
            LabelCriterion__c = 'Moyen Texte',
            Section__c = 'Test',
            Mandatory__c = OPAConstants.BOOLEAN_NO,
            DisplayOrder__c = 30);
        lstCriteres.add(critere);
        insert lstCriteres; 
        return lstCriteres;     
    }


    private static List<BroadcastSpace__c> createEspaces(Asset autorisation) {
        List<BroadcastSpace__c> lstEspaces = new List<BroadcastSpace__c>();
        for(Integer i = 1;i<=3;i++) {
            lstEspaces.add(new BroadcastSpace__c(
                Name = 'ESPACE_' + i,
                Authorization__c = autorisation.Id
            ));
        }

        insert lstEspaces;
        return lstEspaces;
    }

    private static List<WayDiffusion__c> createMoyensDiffusion(List<BroadcastSpace__c> lstEspaces) {
        List<WayDiffusion__c> lstMoyens = new List<WayDiffusion__c>();
        for(BroadcastSpace__c espace : lstEspaces) {
            for(Integer i = 1;i<=3;i++) {
                lstMoyens.Add(new WayDiffusion__c(
                    Name = 'MOYEN_' + espace.Name.right(1) + '_' + i,
                    BroadcastSpace__c = espace.Id
                ));
            }          
        }
        insert lstMoyens;
        return lstMoyens;
    }

    private static List<OfferOutcome__c> createObjectifs(Offer__c offer) {
        List<OfferOutcome__c> lstObjectifs = new List<OfferOutcome__c>();
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_REDEV_SACEM_THEO_TG_GLOBAL',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_GENERAL,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_REDEV_SACEM_THEO_TG_GLOBAL'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_REDEV_SACEM_THEO_TR_GLOBAL',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_REDUIT,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_REDEV_SACEM_THEO_TR_GLOBAL'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_REDEV_SACEM_THEO_TRP_GLOBAL',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_REDUIT,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_REDEV_SACEM_THEO_TRP_GLOBAL'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_REDEV_SACEM',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_GENERAL,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_REDEV_SACEM'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_MT_SPRE',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SPRE,
            RateType__c = OPAConstants.TARIF_GENERAL,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_MT_SPRE'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_MT_HT_SACEM',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_GENERAL,
            OutcomeType__c = OPAConstants.OUTCOME_TARIF,
            AssociatedRateName__c = 'NUM_MT_HT_SACEM'
        ));
        lstObjectifs.add(new OfferOutcome__c(
            Name = 'NUM_MT_HT_SACEM_UTILE',
            Offer__c = offer.Id,
            Company__c = OPAConstants.COMPANY_SACEM,
            RateType__c = OPAConstants.TARIF_GENERAL,
            OutcomeType__c = OPAConstants.OUTCOME_REPARTITION,
            AssociatedRateName__c = 'NUM_MT_HT_SACEM'
        ));
        insert lstObjectifs;
        return lstObjectifs;

    }

    private static Offer__c createOffer() {
        return createOffer(false);
    }

    private static Offer__c createOffer(boolean complex) {
        Offer__c offer = new Offer__c(
            Name = 'Offre001',
            StartingDateValidity__c = Date.NewInstance(2020, 1, 1),
            PeriodicityOffer__c = 'Abonnement non renouvelable',
            CollectionFamily__c = 'Tous',
            TypeProcess__c = 'Prospection',
            ActivityAreas__c = OPAConstants.ACTIVITY_AREA_CASINO,
            LegalForm__c = 'Entreprise'
        );
        insert offer;
        
        List<Criterion__c> lstCriteres = createCriteria();
        if(complex) {
            lstCriteres.addAll(createSpaceCriteria());
            lstCriteres.addAll(createMoyenCriteria());
        }
        List<OfferCriterion__c> lstOfferCrit = new List<OfferCriterion__c>();
        for(Criterion__c critere: lstCriteres) {
            String critName = critere.LabelCriterion__c;
            String target = OPAConstants.TARGET_STANDARD;
            if(critName.startsWith('Espace')) {
                target = OPAConstants.TARGET_SPACE;
            } else if (critName.startsWith('Moyen')){
                target = OPAConstants.TARGET_MOYEN;
            }
            
            OfferCriterion__c offerCrit = new OfferCriterion__c (
                Offer__c = offer.Id,
                criterion__c = critere.Id,
                CriterionToSendToOPA__c = true,
                OPACriterionName__c = critName.toUpperCase() + '_OPA_CRIT',
                TargetCriterion__c = target               
            );
            lstOfferCrit.add(offerCrit);
        }
        insert lstOfferCrit;

        createObjectifs(offer);

        return offer;
    }

    public Static Asset createAuthorization() {
        return createAuthorization(false);
    }

    public static Asset createAuthorization(boolean complex) {
        Offer__c offer = createOffer(complex);
        Asset autorisation = new Asset (
            Name = 'Autorisation 001',
            CurrencyIsoCode = 'EUR',
            Offre__c = offer.Id 
        );
        insert autorisation;
        List<CriterionAuthorization__c> lstAutoCrit = new List<CriterionAuthorization__c>();
        List<OfferCriterion__c> lstOfferCrit = [
            SELECT Id, OPACriterionName__c, TargetCriterion__c, CriterionType__c
            FROM OfferCriterion__c
            WHERE Offer__c = :offer.Id
        ];

        List<BroadcastSpace__c> espaces = createEspaces(autorisation);
        List<WayDiffusion__c> moyens = createMoyensDiffusion(espaces);

        for(OfferCriterion__c offerCrit : lstOfferCrit) {
            String critValue = '';
            String critType = offerCrit.CriterionType__c;
            String critTarget = offerCrit.TargetCriterion__c;
            switch on offerCrit.OPACriterionName__c {
                when 'TEXTE_OPA_CRIT' {
                    critValue = 'AAA';
                }
                when 'NOMBRE_OPA_CRIT' {
                    critValue = '999';
                }
                when 'DATE_OPA_CRIT' {
                    critValue = '2020-01-01';
                }
                when 'BOOLEEN_OPA_CRIT' {
                    critValue = 'true';
                }
            }
            if(critValue <> '') {
                lstAutoCrit.add(new CriterionAuthorization__c (
                    CriterionResponseAuthz__c = critValue,
                    CriterionOffer__c = offerCrit.Id,
                    Authorization__c = autorisation.Id
                ));
            }
            if(critTarget == OPAConstants.TARGET_SPACE) {
                for(BroadcastSpace__c espace : espaces) {
                    critValue = (critType == OPAConstants.TYPE_NOMBRE)?'888':'BBB';
                    lstAutoCrit.add(new CriterionAuthorization__c (
                        CriterionResponseAuthz__c = critValue,
                        CriterionOffer__c = offerCrit.Id,
                        Authorization__c = autorisation.Id,
                        BroadcastSpace__c = espace.Id
                    ));
                }
            }
            if(critTarget == OPAConstants.TARGET_MOYEN) {
                for(WayDiffusion__c moyen : moyens) {
                    critValue = (critType == OPAConstants.TYPE_NOMBRE)?'777':'CCC';
                    lstAutoCrit.add(new CriterionAuthorization__c (
                        CriterionResponseAuthz__c = critValue,
                        CriterionOffer__c = offerCrit.Id,
                        Authorization__c = autorisation.Id,
                        WayDiffusion__c = moyen.Id
                    ));
                }
            }

        }

        insert lstAutoCrit;
        return autorisation;
    }


    public static OPAResponse createOPAResponse() {
        OPAResponse resp = new OPAResponse();
        OPAResponse.RateData rate;
        OPAResponse.RateLineData rateLine;
        
        rate = new OPAResponse.RateData();
        rate.Name = 'NUM_REDEV_SACEM_THEO_TG_GLOBAL';
        rate.ValueHT = 100.0;
        rateLine = new OPAResponse.RateLineData();
        rateLine.Name = 'OBJ_TG_LINE1' ;
        rateLine.ValueHT = 100.0;
        rateLine.Label = 'Tarif général : 100.0 EUR';
        rateLine.Level = 0;
        rateLine.EntityId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rateLine.InstanceId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rate.RateLines.add(rateLine);
        resp.rates.put(rate.Name, rate);

        rate = new OPAResponse.RateData();
        rate.Name = 'NUM_REDEV_SACEM_THEO_TR_GLOBAL';
        rate.ValueHT = 70.0;
        rateLine = new OPAResponse.RateLineData();
        rateLine.Name = 'OBJ_TR_LINE1' ;
        rateLine.ValueHT = 70.0;
        rateLine.Label = 'Tarif réduit 30% : 70.0 EUR';
        rateLine.Level = 0;
        rateLine.EntityId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rateLine.InstanceId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rate.RateLines.add(rateLine);
        rateLine = new OPAResponse.RateLineData();
        rateLine.Name = 'OBJ_TR_LINE2' ;
        rateLine.ValueHT = 100.0;
        rateLine.Label = 'Tarif général : 100.0 EUR';
        rateLine.Level = 1;
        rateLine.EntityId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rateLine.InstanceId = OPAConstants.ENTITY_TYPE_GLOBAL;
        rate.RateLines.add(rateLine);
        resp.rates.put(rate.Name, rate);

        return resp;
    }





    
}