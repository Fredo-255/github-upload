public without sharing class OPAResponse {

    private static Integer INITIAL_LEVEL = 0; 
    // Niveau d'indentation des lignes de plus haut niveau

    // Attributes
    public Map<String, RateData> rates;
    public Integer HTTPStatusCode;
    public String jsonResponse;
    public Integer OPARequestErrorCode;


    // Constructors
    public OPAResponse() {
        rates = new Map<String, RateData>();
    }

    public OPAResponse(String jsonResponse) {

        System.debug('///// REPONSE ///');
        System.Debug(JSON.serializePretty(JSON.deserializeUntyped(jsonResponse)));   
        System.debug('/// FIN REPONSE ///');
        rates = new Map<String, RateData>();
        Integer ratesCreated = createRateData(jsonResponse);
       
        System.debug(ratesCreated);
    }

    // Public Method

    // Ecritures des données de lignes dans les sObjects correspondants: Tarifs (Rate__c), lignes de Tarif (RateLine__c) 
    // et lignes de répartition (BillingLine__c)
    public void writeRatesToAuthorization(Id authorizationId) {
        Map<String, Rate__c> mapRates = new Map<String, Rate__c>();
        List<RateLine__c> lstRateLines = new List<RateLine__c>();
        List<InvoicingLine__c> lstInvoicingLines = new List<InvoicingLine__c>();

        Map<String, OfferOutcome__c> OutcomeProperties = OPADAO.mapOutcomesByName;
        System.debug(OutcomeProperties);
        Map<Id, BroadcastSpace__c> mapSpaces = OPADAO.mapSpaces;

        //  Ecriture en base des objets tarif
        System.debug(outcomeProperties.keyset());
        for(RateData rate : rates.values()) {
            system.debug('Rate name : ' + rate.name);
            system.debug('Corresponding putcome : ' + OutcomeProperties.get(rate.Name));
            mapRates.put(rate.Name, new Rate__c(
                Name = rate.Name,
                CurrencyIsoCode = 'EUR',
                Company__c = OutcomeProperties.get(rate.Name).Company__c,
                RateType__c = OutcomeProperties.get(rate.Name).RateType__c,
                DutyFreeTheoreticalAmount__c = rate.ValueHT,
                DutyFreeRealAmount__c = rate.ValueHT,
                Asset__c = authorizationId
            ));
            if(OutcomeProperties.get(rate.Name).Company__c == 'SPRE') {
                // TODO : compute real amout for SPRE
                // lstRates.get(rate.Name).DutyFreeRealAmount__c = computeSpreRealAmount(rate.ValueHT);
            }
        }
        insert mapRates.values();


        // Ecriture en base des lignes de tarif et des lignes de répartition
        for(RateData rate : rates.values()) {
            Integer rank = 1;
            for(RateLineData rateLine : rate.RateLines) {
                lstRateLines.add(new RateLine__c(
                    Name = rateLine.Name,
                    Description__c = rateLine.Label,
                    CurrencyIsoCode = 'EUR',
                    Rank__c = rank++,
                    Rate__c = mapRates.get(rate.Name).Id,
                    Level__c = rateLine.Level,
                    DutyFreeAmount__c = rateLine.ValueHT,
                    BroadcastSpace__c = rateLine.entityId==OPAConstants.ENTITY_TYPE_SPACE?rateLine.instanceId:null
                ));
            }

            for(BillingLineData billingLine : rate.BillingLines) {
                lstInvoicingLines.add(new InvoicingLine__c(
                    Name = billingLine.Name,
                    Rate__c = mapRates.get(rate.Name).Id,
                    UseType__c = billingLine.TypeUtile,
                    Article__c = billingLine.Article,
                    DutyFreeAmount__c = billingLine.ValueHT,
                    CurrencyIsoCode = 'EUR'
                ));
            }
        }
        if(lstRateLines.size() > 0) {
            insert lstRateLines;
        }
        if(lstInvoicingLines.size() > 0)  {
            insert lstInvoicingLines;
        }

    }

    // Subclasses
    public class RateData {
        public String Name;
        public Double ValueHT;
        public List<RateLineData> RateLines;
        public List<BillingLineData> BillingLines;

        public RateData() {
            RateLines = new List<RateLineData>();
            BillingLines = new List<BillingLineData>();
        }
    }
    
    public class RateLineData {
        public String Name;
        public String Label;
        public Double ValueHT;
        public Integer Level;
        public String EntityId;
        public String InstanceId;
    }

    public class BillingLineData {
        public String Name;
        public String Label;
        public Double ValueHT;
        public String TypeUtile;
        public String Article;
    }


    // Private methods
    private Integer createRateData(String jsonResponse) {
        System.debug('OPA response : ' + jsonResponse);

        Map<String, Object> responseMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResponse);
        Map<String, Object> assessResponse = (Map<String, Object>)responseMap.get('assess-response');
        Map<String, Object> globalInstance = (Map<String, Object>)assessResponse.get('global-instance');
        List<Object> attributes = (List<Object>)globalInstance.get('attribute');

        Rates.clear();

        for(Object item:attributes) {
            Map<String, Object> attribute = (Map<String, Object>)item;
            if((String)attribute.get('@inferred') == 'true') {
                String rateName = getRateName(attribute);
                if(!rates.containsKey(rateName)) {
                    rates.put(rateName, new RateData());
                }
                RateData rate = rates.get(rateName);
                rate.Name = rateName;
                rate.ValueHT = (Double)attribute.get('number-val');
                Map<String, Object> decisionReport = (Map<String,Object>)attribute.get('decision-report');

                if(containsRateLines(attribute)) {
                    rate.RateLines = createRateLineData(decisionReport);
                } else {
                    rate.BillingLines = createBillingLineData(decisionReport);
                }
            }
        }
        return rates.size();
    }

    private Boolean containsRateLines(Map<String, Object> attribute) {
        // returns true if rate describes rate lines, false if it describes billing lines
        String rateName = (String)attribute.get('@id');
        return OPADAO.mapOutcomesByName.get(rateName).OutcomeType__c == OPAConstants.OUTCOME_TARIF;
    }

    private String getRateName(Map<String, Object> attribute) {
        System.debug(attribute);
        String rateName = (String)attribute.get('@id');
        return OPADAO.mapOutcomesByName.get(rateName).AssociatedRateName__c;
    }
    
    // Lecture des lignes de tarif 

    private List<RateLineData> createRateLineData(Map<String, Object> decisionReport) {
        List<Map<String, Object>> attributeNodes = getAttributeNodes(decisionReport);
        List<RateLineData> rateLines = readAttributeNodeList(attributeNodes, INITIAL_LEVEL);
        return rateLines;       
    }


    private List<Map<String, Object>> getAttributeNodes(Map<String, Object> parentAttributeNode) {
        // récupère une liste d'attrinute-nodes. Convertit l'objet isolé en liste si nécessaire
        List<Map<String,Object>> attributeNodes;
        if(parentAttributeNode.get('attribute-node') == null) {
            // Il n'y a pas de sous noeud ==> Retour null
            attributeNodes = null;
        } else if(parentAttributeNode.get('attribute-node') instanceof List<Object>) {
            // Le sous noeud est une liste de noeuds ==> On récupère ditrectement la liste
            attributeNodes = new List<Map<String,Object>>();
            for(Object obj : (List<Object>)parentAttributeNode.get('attribute-node')) {
                attributeNodes.add((Map<String,Object>)obj);
            }
        } else {
            // Le sous noeud est un objet isolé ==> On l'ajoute à une liste vide
            attributeNodes = new List<Map<String,Object>>();
            attributeNodes.add((Map<String,Object>)parentAttributeNode.get('attribute-node'));
        }
        return attributeNodes;
    }

    private List<RateLineData> readAttributeNodeList(List<Map<String, Object>> attributeNodes, Integer level) {
    // Méthode récursive de lecture des noeuds d'attibuts
    // Ecrit les attibuts du noeud en cours, et, si ce dernier contient un autre noeud d'attributs, 
    // est rappelée récursivement pour l'écriture de cet autre noeud avec un niveau incrémenté de 1.
        List<RateLineData> lstRateLines = new List<RateLineData>();
        for(Map<String, Object> attributeNode : attributeNodes) {
            RateLineData rateLine = new RateLineData();
            rateLine.Name = (String)attributeNode.get('@attribute-id');
            if((String)attributeNode.get('@type') == 'currency') {
                // On ne récupère la valeur numéroqie que pour les lignes associées à des montants (type = currency)
                rateLine.ValueHT = (Double)attributeNode.get('number-val');
            }
            rateLine.Label = (String)attributeNode.get('@text');
            rateLine.EntityId = (String)attributeNode.get('@entity-id');
            rateLine.InstanceId = (String)attributeNode.get('@instance-id');
            rateLine.Level = level;
            lstRateLines.add(rateLine);
            List<Map<String, Object>> childNodes = getAttributeNodes(attributeNode);
            if(childNodes <> null) {
                lstRateLines.addAll(readAttributeNodeList(childNodes, level +1));
            }
        }
        return lstRateLines;
    }

    // Lecture des lignes de répartition
    private List<BillingLineData> createBillingLineData(Map<String, Object> decisionReport) {
        List<BillingLineData> billingLines = new List<BillingLineData>();
        BillingLineData billingLine;
        // Niveau 1 : total
        Map<String, Object> attributeNode = (Map<String,Object>)decisionReport.get('attribute-node');
        String rateLineDataName = (String)attributeNode.get('@attribute-id');
        // Niveau 2 : codes utiles
        List<Map<String,Object>> typeUtileNodes = getAttributeNodes(attributeNode);
        for(Map<String, Object> typeUtileNode : typeUtileNodes) {
            String typeUtile = (String)typeUtileNode.get('@attribute-id');
            // Niveau 3 : articles
            List<Map<String,Object>> articleNodes = getAttributeNodes(typeUtileNode);

            for(Map<String, Object> articleNode : articleNodes) {
                billingLine = new BillingLineData();
                billingLine.Label = (String)articleNode.get('@text');
                billingLine.Name = rateLineDataName;
                billingLine.TypeUtile = typeUtile;
                billingLine.Article = (String)articleNode.get('@attribute-id');
                billingLine.ValueHT = (Double)articleNode.get('number-val');
                billingLines.add(billingLine);
            }           
        }

        return billingLines;
    }



}