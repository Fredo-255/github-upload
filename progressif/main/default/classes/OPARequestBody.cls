public without sharing class OPARequestBody {

    public static String create(Id id) {
        Asset autorisation = OPADAO.mapAuthorizations.get(id);
        return create(autorisation); 
    }

    public static String create(Asset autorisation) { 
        String strBody = '';

        // Récupération des critères
        List<CriterionAuthorization__c> lstCriteres = OPADAO.mapAuthorizationCriteriaByAuthorizationId.get(autorisation.Id);
        if(lstCriteres == null) {
            throw new OPAService.OPAException('Pas de critères définis pour cette autorisation');
        }

        // Stockage des critères dans une permettant de les récupérer à partir des Id d'espace et de moyen (éventuellement à null pour les critères globaux ou juste liés à l'espace)
        Map<Id, Map<Id, List<CriterionAuthorization__c>>> mapEspaceMoyenToLstCritere = new Map<Id, Map<Id, List<CriterionAuthorization__c>>>();
        // Création du noeud "global" (null, null). Ainsi on est sur qu'il existe pour la suite (même s'il ne contient aps de critères)
        mapEspaceMoyenToLstCritere.put(null, new Map<Id, List<CriterionAuthorization__c>>());
        mapEspaceMoyenToLstCritere.get(null).put(null, new List<CriterionAuthorization__c>());
        // Création du noeud "global" (null, null) 
        for(CriterionAuthorization__c critAutorisation : lstCriteres) {
            Id moyenId = critAutorisation.WayDiffusion__c;
            Id espaceId = critAutorisation.BroadcastSpace__c;
            if(critAutorisation.WayDiffusion__c != null) {
                // A vérifier, n'est utile que si l'espâce n'est pas renseigné dans le cas d'un critère lié à un moyen
                espaceId = OPADAO.mapWaysDiffusion.get(moyenId).BroadcastSpace__c;
            }
            if(mapEspaceMoyenToLstCritere.get(espaceId) == null) {
                mapEspaceMoyenToLstCritere.put(espaceId, new Map<Id, List<CriterionAuthorization__c>>());
            }

            if(mapEspaceMoyenToLstCritere.get(espaceId).get(moyenId) == null) {
                mapEspaceMoyenToLstCritere.get(espaceId).put(moyenId, new List<CriterionAuthorization__c>());
            }

            mapEspaceMoyenToLstCritere.get(espaceId).get(moyenId).add(critAutorisation);
        }

        // Récupération des objectifs de l'offre
        List<OfferOutcome__c> lstObjectifs = OPADAO.mapLstOutcomesByOfferId.get(autorisation.Offre__c);
        if(lstObjectifs == null) {
            throw new OPAService.OPAException('Pas d\'objectifs définis pour l\'offre de cette autorisation');
        }

        // Création du document

        JSONGenerator gen = JSON.createGenerator(true);        

        // Début du body
        gen.writeStartObject(); // Body

        gen.writeFieldName('assess-request');
        gen.writeStartObject(); // assess-request


        // Génération des objectifs
        gen.writeFieldName('config');
        gen.writeStartObject(); // config
        // permet de récupérer le détail
        gen.writeBooleanField('show-properties', true);
        // liste des objectifs
        gen.writeFieldName('outcome');
        gen.writeStartObject(); // outcome
        gen.writeFieldName('entity');
        gen.writeStartObject(); // entity

        gen.writeStringField('@id', OPAConstants.ENTITY_TYPE_GLOBAL);
        gen.writeFieldName('attribute-outcome');
        gen.writeStartArray(); // attribute outcome
        for(OfferOutcome__c objectif : lstObjectifs) {
            gen.writeStartObject();
            gen.writeStringField('@id', objectif.Name);
            gen.writeStringField('@outcome-style', 'decision-report');
            gen.writeEndObject(); // attribute-outcome item
        }
        gen.writeEndArray(); // attribute-outcome
        gen.writeEndObject(); // entity
        gen.writeEndObject(); // outcome
        gen.writeEndObject(); // congig

        // Gestion des critères
        gen.writeFieldName('global-instance');
        gen.writeStartObject(); // global-instance

        gen.writeFieldName('attribute');
        gen.writeStartArray(); // attribute pour les critères globaux
        // Liste des critères 
        for(CriterionAuthorization__c critere:mapEspaceMoyenToLstCritere.get(null).get(null)) {
            writeCritere(gen, critere);
        }
        gen.writeEndArray(); // attribute pour les critères globaux
        // A voir, s'il y  a des moyens non ratachés à un espace . Dasn ce cas traiter ici le noeud mapEspaceMoyenToLstCritere.get(null) après avoir retiré
        // les critères du noeud

        mapEspaceMoyenToLstCritere.remove(null); // On ne garde plus que les critères liés à un espace

        if(mapEspaceMoyenToLstCritere.size() > 0) {
            gen.writeFieldName('entity'); 
            gen.writeStartObject(); // entityespaces
            gen.writeStringField('@id', OPAConstants.ENTITY_TYPE_SPACE);
            gen.writeFieldName('instance');
            gen.writeStartArray(); // instance espaces sono
            for(Id espaceId : mapEspaceMoyenToLstCritere.keyset()) {
                gen.writeStartObject(); // Objet espace sono
                gen.writeStringField('@id', espaceId);
                if(mapEspaceMoyenToLstCritere.get(espaceId).get(null).size() > 0) { // Il y a des critères au niveau de l'espace non liés à des moyens
                    gen.writeFieldName('attribute');
                    gen.writeStartArray(); // attributes espace de diff
                    for(CriterionAuthorization__c critere : mapEspaceMoyenToLstCritere.get(espaceId).get(null)) {
                        writeCritere(gen, critere);
                    }
                    gen.writeEndArray(); // attributes espace de diff
                    mapEspaceMoyenToLstCritere.get(espaceId).remove(null);
                }
                if(mapEspaceMoyenToLstCritere.get(espaceId).size() > 0) { // Il y a des critères sur les moyens de diffusion
                    gen.writeFieldName('entity');
                    gen.writeStartObject(); // entity moyens de l'espace de diff
                    gen.writeStringField('@id', OPAConstants.ENTITY_TYPE_WAY_DIFFUSION);
                    gen.writeFieldName('instance');
                    gen.WriteStartArray(); // instance moyens de l'espace de diff
                    for(Id moyenId : mapEspaceMoyenToLstCritere.get(espaceId).keySet()) {
                        gen.writeStartObject(); // Moyen de diff
                        gen.writeStringField('@id', moyenId);
                        gen.writeFieldName('attribute');
                        gen.writeStartArray(); // attributes moyen de diff
                        for(CriterionAuthorization__c critere : mapEspaceMoyenToLstCritere.get(espaceId).get(moyenId)) {
                            writeCritere(gen, critere);
                        }
                        gen.writeEndArray(); // attributes moyen de diff
                        gen.writeEndObject(); // Moyen de diff                        
                    }
                    gen.writeEndArray(); // instance moyens de l'espace de diff
                    gen.writeEndObject(); // entity moyens de l'espace de diff
                }
                gen.writeEndObject(); // Object espace sono
            }
            gen.writeEndArray(); // instance espaces sono
            gen.writeEndObject(); // entity espaces
        }

        gen.writeEndObject(); // global-instance

        // Fin de l'objet
        gen.writeEndObject(); // assess-request
        gen.writeEndObject(); // Body

        return gen.getAsString();

    }


    private static void writeCritere(JSONGenerator gen, CriterionAuthorization__c critere) {
    // Ecrit un objet critère d'autorisation dans la chaine json associée au générateur de la forme :
    // {"@id" : "nom_du_critere", "type_du_critere" : valeur_du_critere"}, la valeur_critere étant formatée
    // confiormément au type du critère
        String typeCritere = critere.CriterionOffer__r.criterion__r.TypeCriterion__c;
        String nomCritere = critere.CriterionOffer__r.OPACriterionName__c;
        String valeurCritere = critere.CriterionResponseAuthz__c;
        // Règle à valider. Si null, champ non envoyé
        if(valeurCritere != null){
            gen.writeStartObject(); // attribute item
            gen.writeStringField('@id', nomCritere);
            switch on typeCritere {
                when '3' { // Boolean
                    gen.writeBooleanField('boolean-val', valeurCritere == 'true');
                }
                when '5', '6' // Nombre, Devise
                {
                    gen.writeNumberField('number-val', Double.valueOf(valeurCritere));
                }
                when '4' // date
                {
                    gen.writeStringField('date-val', valeurCritere);
                }
                when else {
                    gen.writeStringField('text-val', valeurCritere);
                }
            }
            gen.writeEndObject(); // attribute item
        }
    }
}