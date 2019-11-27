public with sharing class LCCTR_OfferCtr {
    public LCCTR_OfferCtr() {

    }

        static Integer PAGE_SIZE = 9;

    public class Filters {
        public String searchKey { get;set; }
        public String[] categories { get;set; }
    }

    @AuraEnabled(Cacheable = true)
    public static List<OfferFamily__c>  findOfferFamily(id Recordid){
        try{
            // Gérer le filtre secteur d'activité From Contrat ou Utilisateur connecté
            string ActivityArea;
            string IdContract=String.valueof(Recordid);
            if ( Recordid!= null && IdContract.startsWithIgnoreCase('a0a')){
                Contracts__c ctc=[select id , AccountName__r.Activity_area__c from Contracts__c where id=:Recordid];
                ActivityArea=ctc.AccountName__r.Activity_area__c;
            } else {
                user usr =[select id, accountId from user where id=:UserInfo.getUserId() limit 1];
                if ( usr != null){ 
                    account acc=[select id , Activity_area__c from account where id=:usr.accountid limit 1];
                    ActivityArea=acc.Activity_area__c;
                }

            }
            
            List<OfferFamily__c> listOfferFamilyAll=new List <OfferFamily__c>();
            system.debug('rso activity area--'+ActivityArea);
            String query = 'SELECT Id,Name,Picture__c ,Url__c ,Detailsprices__c, description__c ,';
            query+='(select id , name  from childoffer__r  where TECH_QueryVisible__c=true ';
            
        

            //Filter secteur activity
            if ( String.isNotBlank(ActivityArea)){
            
            query+=' and ActivityAreas__c includes (:ActivityArea ) ';
            }
            query+=' ) FROM OfferFamily__c';
            system.debug('query--'+query);
        
                               
             listOfferFamilyAll = Database.query(query);

            // Get Url Ressource Static Url
             String url_file_ref= geturl_file_ref();                 
            
            List<OfferFamily__c> listOfferFamilyFiltred=new List <OfferFamily__c>();
            
            for ( OfferFamily__c family:listOfferFamilyAll ){
                
                if (family.childoffer__r.size()>0 ){
                    family.Url__c=url_file_ref+'/img/'+family.Url__c;
                    listOfferFamilyFiltred.add(family);
                }
            }
            system.debug('rso nb familly'+listOfferFamilyFiltred.size());
            return listOfferFamilyFiltred; 
            
        } 
        catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }   
    }

 @auraEnabled (Cacheable = true)
public static string geturl_file_ref (){
    StaticResource static_resource = [SELECT Id, SystemModStamp
                                            FROM StaticResource 
                                            WHERE Name = 'StyleCriterionComponent'
                                            LIMIT 1];
    String url_file_ref = '/resource/'
                                + String.valueOf(((DateTime)static_resource.get('SystemModStamp')).getTime())
                                + '/' 
                                + 'StyleCriterionComponent';
 return url_file_ref;                               
}

   

 @auraEnabled (Cacheable = true)
    public static List<OfferCriterion__c> getCriteres (Id RecordId){
        
        List<OfferCriterion__c> crits= new list <OfferCriterion__c>();
        
        crits = [SELECT Id, MessageRangeUnderFlow__c,MessageValueMissing__c , MessageRangeOverFlow__c ,CriterionResponse__c ,criterion__r.Name,criterion__r.Target__c, 
                 criterion__r.LabelCriterion__c , criterion__r.TypeCriterion__c ,FormatCriterion__c, 
                 criterion__r.ListValues__c, Mandatory__c,Offer__c , Maxlength__c,Minlength__c,Maximum__c , MessageWhenTooLong__c ,Minimum__c, MessageWhenTooShort__c ,
                 OrderDisplay__c, criterion__r.Section__c,criterion__r.PlaceHolder__c,criterion__r.DefaultValue__c,helpText__c,replaceLabel__c,Tech_LabelToDisplay__c,
                 messageWhenPatternMismatch__c,
                 (SELECT Id
                 FROM ChildSecondaryCriterionOfferCriterion__r )
                 FROM OfferCriterion__c 
                 WHERE Offer__c =:RecordId AND status__c='Principal' AND criterion__r.Target__c='Standard' AND Visible__c=true
              
                 ORDER BY  OrderDisplay__c ASC
                ];
        system.debug('rso crit size'+ crits.size());
        //Annule Groupement par section
       /* Map<string,List<OfferCriterion__c>> mapSectionCriteres = new Map <string,List<OfferCriterion__c>>();
       
        for ( OfferCriterion__c crit:crits){
            if ( mapSectionCriteres.containskey(crit.criterion__r.Section__c) ){
                system.debug('rso order'+crit.criterion__r.Section__c + crit.criterion__r.Name + crit.OrderDisplay__c);
                mapSectionCriteres.get(crit.criterion__r.Section__c).add(crit);
                system.debug('map'+mapSectionCriteres);
            }else {
                List<OfferCriterion__c> critssection=new list <OfferCriterion__c>();
                
                system.debug('rso order'+crit.criterion__r.Section__c + crit.criterion__r.Name + crit.OrderDisplay__c);
                critssection.add(crit);
                mapSectionCriteres.put(crit.criterion__r.Section__c,critssection);
                 system.debug('map'+mapSectionCriteres);
            }   
        }*/
             
        system.debug('RSO Inside apex'+crits);
        return crits;

    }
    

    @auraEnabled (Cacheable = true)
    public static List<OfferCriterion__c> getCriteressecondaires (Id RecordId , string Response){
       
        List<OfferCriterion__c> crits= new list <OfferCriterion__c>();
        
        crits = [SELECT Id,Name, criterion__r.Name, criterion__r.LabelCriterion__c , criterion__r.TypeCriterion__c , FormatCriterion__c, 
                 criterion__r.ListValues__c , Mandatory__c ,Offer__c , Maxlength__c ,Minlength__c ,Maximum__c ,MessageWhenTooLong__c,Minimum__c,MessageWhenTooShort__c, 
                 OrderDisplay__c , IfResponse__c , MessageRangeUnderFlow__c ,MessageValueMissing__c, MessageRangeOverFlow__c ,CriterionResponse__c,criterion__r.PlaceHolder__c,
                 criterion__r.DefaultValue__c,helpText__c,replaceLabel__c,Tech_LabelToDisplay__c, messageWhenPatternMismatch__c
                 
                 FROM OfferCriterion__c 
                 WHERE MainCriterion__c =:RecordId  AND IfResponse__c=:Response.trim() AND Visible__c=true
              
                 ORDER BY  OrderDisplay__c ASC
                ];
        return crits;

    }
    
    @auraEnabled (Cacheable = true)
    public static List<Offer__c> getOffersList(Id FamillyId, Id Recordid){
        system.debug('rso FamillyId'+FamillyId);
        
        // Gérer le filtre secteur d'activité From Contrat ou Utilisateur connecté
            string ActivityArea;
            string IdContract=String.valueof(Recordid);
            if ( Recordid!= null && IdContract.startsWithIgnoreCase('a0a')){
                Contracts__c ctc=[select id , AccountName__r.Activity_area__c from Contracts__c where id=:Recordid];
                ActivityArea=ctc.AccountName__r.Activity_area__c;
            } else {
                user usr =[select id, accountId from user where id=:UserInfo.getUserId() limit 1];
                if ( usr != null){ 
                    account acc=[select id , Activity_area__c from account where id=:usr.accountid limit 1];
                    ActivityArea=acc.Activity_area__c;
                }

            }

        List<Offer__c> OfferList = new List<Offer__c>();
         String query = 'SELECT Id, Name, Picture__c FROM Offer__c WHERE ValueOfferFamily__c=:FamillyId and TECH_QueryVisible__c=true ';

            if ( String.isNotBlank(ActivityArea) ){
                
            query+=' and ActivityAreas__c includes (:ActivityArea ) ';
            }
            query+=' ORDER BY createddate DESC';

            offerList = Database.query(query);

           // Get Url Ressource Static Url
            String url_file = geturl_file_ref();                 
            
            List<Offer__c> listOfferFiltred = new List <Offer__c>();
            
            for ( Offer__c offre:offerList ){
                
                    offre.Picture__c=url_file+'/img/'+offre.Picture__c;
                    listOfferFiltred.add(offre);
                
            }


        return listOfferFiltred;
    }

    // Save Autorisation + Criterion List
  @AuraEnabled 
    public static asset saveAutorisation(string RecordId , string Offer , string Criteres , string  Espaces){
        
        try {
            if(RecordId.countMatches('a0a')==0)    {
                
               Contracts__c  c  = new Contracts__c (); 
               c.AccountName__c = '0011w00000HxcAEAAZ';
               c.Status__c 	    ='En cours';
               c.ContractStartingDate__c = date.newInstance(2019, 10, 21);
               c.ClosingDate__c          = date.newInstance(2019, 11, 21);
                
               insert c;
               RecordId = c.Id; 
            }  
            
            //L'offre sélectionné
            Offer__c o = new Offer__c();
            o = [SELECT id , name FROM Offer__c WHERE id =:Offer LIMIT 1];
            
            //Le contract encours
            Contracts__c  c = new Contracts__c ();
            c = [SELECT id , AccountName__c  FROM Contracts__c  WHERE id=:RecordId LIMIT 1];
            
            //Créer Asset
            asset a        = new asset();
            a.Contracts__c = RecordId;
            a.AccountId    = c.AccountName__c ;
            a.Offre__c     = o.Id;
            a.Name		   = o.Name;
            
            system.debug ( 'insert a' + a);
            insert a;
            
            //Créer Critères autorisation Standard
            system.debug('CritListJson input : ' + Criteres);
            
            List <JSON2ApexCriterion> criteresparser=(List<JSON2ApexCriterion>)JSON.deserialize(Criteres,List<JSON2ApexCriterion>.class);
            List<CriterionAuthorization__c> CriterestoInsert = new List<CriterionAuthorization__c>();
            for (JSON2ApexCriterion crit:criteresparser ){
                //system.debug('test item crit '+crit.Id + 'val ' + crit.Value);
                CriterestoInsert.add( new CriterionAuthorization__c  (Authorization__c=a.id,CriterionOffer__c=crit.Id,CriterionResponseAuthz__c = crit.Value));
            }
                     
           
            //Créer Espaces 
            system.debug('EspacesJson input : ' + Espaces);
            
            List <JSON2ApexEspace> espacesparser=(List<JSON2ApexEspace>)JSON.deserialize(Espaces,List<JSON2ApexEspace>.class);
            
            //List <BroadcastSpace__c> EspacestoInsert = new List<BroadcastSpace__c>();
            for (JSON2ApexEspace Espace:espacesparser ){
                //system.debug('test item Espace '+Espace.Key);
                //EspacestoInsert.add ( new broadcast_space__c ( Autorisation__c=a.Id,Name= string.valueOf(Espace.Key)));
                BroadcastSpace__c  EspaceToinsert= new BroadcastSpace__c();
                EspaceToinsert.Authorization__c = a.Id;
                EspaceToinsert.Name=string.valueOf(Espace.Key);
                insert EspaceToinsert;
                
                for (JSON2ApexCriterion crit:Espace.Criteres ){
                 system.debug('Espace Crit'+crit) ;
                 CriterestoInsert.add( new CriterionAuthorization__c  (Authorization__c=a.id,CriterionOffer__c=crit.Id,
                                                                          CriterionResponseAuthz__c  = crit.Value,
																		  BroadcastSpace__c  = EspaceToinsert.Id
                                                                         ));
           
                }
                for (JSON2ApexMoyen moyen:Espace.Moyens ){
                    //system.debug('Espace Moyen'+moyen) ;
                    
                    WayDiffusion__c  MoyenToinsert  = new WayDiffusion__c();
                    MoyenToinsert.BroadcastSpace__c = EspaceToinsert.Id;
                    MoyenToinsert.Name=string.valueOf(moyen.Key);
                    //MoyenToinsert.Autorisation__c=a.Id;
                    
                    insert MoyenToinsert;
                    
                     for (JSON2ApexCriterion crit:moyen.Criteres ){
                     //system.debug('Moyen Crit'+crit) ;
                     CriterestoInsert.add( new CriterionAuthorization__c  (Authorization__c=a.id,CriterionOffer__c =crit.Id,
                                                                              CriterionResponseAuthz__c  = crit.Value,
                                                                              BroadcastSpace__c   = EspaceToinsert.Id,
                                                                              WayDiffusion__c  =MoyenToinsert.Id
                                                                             ));
           
                }
                    
                    
                }
                
                
             }
          
            
              //system.debug(CriterestoInsert.size());
             if (CriterestoInsert.size()>0 ){
                insert CriterestoInsert;
            }
            
            
            asset newasset = [SELECT id , name , Offre__c , (SELECT id , name , CriterionOffer__c, 
                                                             CriterionLabel__c ,
                                                             CriterionResponseAuthz__c  FROM ChildCriterionAuthorization__r) FROM asset WHERE id=:a.Id];
            
   			return newasset;
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            return null;
        }
        
    } 
    
    public class JSON2ApexCriterion {
        public String Id;
        public String Value;
    }
    public class JSON2ApexMoyen {
       	public Integer Key;
        public List<JSON2ApexCriterion> Criteres;
    }
        
    public class JSON2ApexEspace {
     	public Integer Key;
		public List<JSON2ApexCriterion> Criteres;
        public List<JSON2ApexMoyen> Moyens;
    }

}