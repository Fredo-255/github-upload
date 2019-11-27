public class LCCTRL_OfferController {

    @AuraEnabled(cacheable=true)
        public static User getUserDetails(String recId) {
            return  [Select Id , Name ,ProfileId,Profile.name from User where Id =:recId];
        }
    

    @AuraEnabled(Cacheable = true)
    public static List<OfferFamily__c>  findOfferFamily(){
        try{
            // Gérer le filtre pour la visibilité des offres par profils 
            Profile CurrentProfile = [select id , name from profile where id=:userinfo.getProfileId() limit 1];
            
            
            //Profil client + Admin
            boolean IsVisibleCustomer;
            
             if (CurrentProfile.Name== 'Customer Community Plus Login User SACEM'   || CurrentProfile.Name=='Customer Community Plus Login User' 
                ||  CurrentProfile.Name== 'System Administrator' ||  CurrentProfile.Name =='Administrateur système'){
             IsVisibleCustomer = true   ;
            }
            
            // Profil onLine et réseau  + Admin
            boolean IsVisibleInternal;
            
            if (CurrentProfile.Name=='Chargé de clientèle réseau'|| CurrentProfile.Name== 'Chargé de clientèle online' 
                ||  CurrentProfile.Name== 'System Administrator' ||  CurrentProfile.Name== 'Administrateur système' ){
             IsVisibleInternal  = true; 
            }

            system.debug('rso visibvilité'+IsVisibleCustomer+ IsVisibleInternal);	
            List<OfferFamily__c> listOfferFamilyAll=new List <OfferFamily__c>();
            listOfferFamilyAll = [SELECT Id,Name,Picture__c ,Url__c , description__c , 
                               (select id , name , customerProfiles__c, cdconlineProfiles__c 
                                from childoffer__r 
                                where (customerProfiles__c=:IsVisibleCustomer or cdconlineProfiles__c=:IsVisibleInternal) )

                               FROM OfferFamily__c];
            
             List<OfferFamily__c> listOfferFamilyFiltred=new List <OfferFamily__c>();
            
            for ( OfferFamily__c family:listOfferFamilyAll ){
                
                system.debug('rso child family'+family.childoffer__r.size());
                if (family.childoffer__r.size()>0 ){
                    listOfferFamilyFiltred.add(family);
                }
            }
            
            system.debug('rso retour filtre family'+listOfferFamilyFiltred);
            return listOfferFamilyFiltred; 
            
        } 
        catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }   
    }
    
 
    @AuraEnabled(Cacheable = true)
    public static List<Offer__c>  getOffers(){
        try{
            List<Offer__c> listOffer = new List<Offer__c>();
            
            listOffer  =[SELECT Id, name FROM Offer__c];
            
            return listOffer; 
            
        } 
        catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }   
    }
    
	/*    
    @auraEnabled 
    public static List<Offer__c>  getOffersById(){
        try{
            List<Offer__c> listOfferById = new List<Offer__c>();
            
            listOfferById = [SELECT Id, name FROM Offer__c WHERE Id IN ('a0L6E000003fgQQUAY','a0L6E000003fgQfUAI','a0L6E000003fgQVUAY')];
            
            return listOfferById; 
            
        } 
        catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }   
    }
*/
    
    @auraEnabled 
    public static List<Offer__c>  getOffersByFamily(Id RecordId){
        try{
            List<Offer__c> listFamilyOff = new List<Offer__c>();
            
            listFamilyOff  =[SELECT Id, name,CurrentOffer__c  ,ActivityAreas__c ,ValueOfferFamily__c  FROM Offer__c WHERE ValueOfferFamily__c =:RecordId ];
           
            return listFamilyOff; 
            
        } 
        catch(Exception e) {
            
            System.debug('An exception occurred: ' + e.getMessage());
            return null;
        }   
    }
    
    
    
    @auraEnabled (Cacheable = true)
    public static List<OfferCriterion__c> getCriteres (Id RecordId){
        
        List<OfferCriterion__c> crits= new list <OfferCriterion__c>();
        
        crits = [SELECT Id, MessageRangeUnderFlow__c,MessageValueMissing__c , MessageRangeOverFlow__c ,CriterionResponse__c ,criterion__r.Name,criterion__r.Target__c, criterion__r.LabelCriterion__c , criterion__r.TypeCriterion__c , criterion__r.FormatCriterion__c, 
                 criterion__r.ListValues__c, Mandatory__c,Offer__c , Maxlength__c,Minlength__c,Maximum__c , MessageWhenTooLong__c ,Minimum__c, MessageWhenTooShort__c , OrderDisplay__c, 
                 (SELECT Id,Name, criterion__r.Name, criterion__r.LabelCriterion__c , criterion__r.TypeCriterion__c , criterion__r.FormatCriterion__c, 
                 criterion__r.ListValues__c , Mandatory__c ,Offer__c , Maxlength__c ,Minlength__c ,Maximum__c ,MessageWhenTooLong__c,Minimum__c,MessageWhenTooShort__c, OrderDisplay__c , IfResponse__c , MessageRangeUnderFlow__c ,MessageValueMissing__c, MessageRangeOverFlow__c  
                 FROM ChildSecondaryCriterionOfferCriterion__r )
                 FROM OfferCriterion__c 
                 WHERE Offer__c =:RecordId AND status__c='Principal' AND criterion__r.Target__c='Standard'
                 ORDER BY  OrderDisplay__c ASC];
        
        return crits;

    }
    
    @auraEnabled 
    public static List<OfferCriterion__c> getCaneaux (Id RecordId){
        
        List<OfferCriterion__c> caneaux= new list <OfferCriterion__c>();
        
        caneaux = [SELECT Id, CriterionResponse__c  ,criterion__r.Name,criterion__r.Target__c, criterion__r.LabelCriterion__c , criterion__r.TypeCriterion__c , criterion__r.FormatCriterion__c, 
                 criterion__r.ListValues__c ,Maxlength__c,MessageWhenTooLong__c ,Minlength__c,MessageWhenTooShort__c, Mandatory__c,Offer__c , Maximum__c ,Minimum__c, OrderDisplay__c 
                 FROM OfferCriterion__c 
                 WHERE Offer__c =:RecordId AND status__c='Principal' AND criterion__r.target__c in ('Espace de diffusion','Moyen de diffusion')
                 ORDER BY  OrderDisplay__c  ASC];
        
        return caneaux;

    }
    
    //Get Offer Area activity Picklist Values
    @auraEnabled (Cacheable = true)
    public static Map<String, String> getActivityArea(){
        Map<String, String> options = new Map<String, String>();
        //get Offer area activity Field Describe
        Schema.DescribeFieldResult fieldResult = Offer__c.ActivityAreas__c.getDescribe();
        //get Offer area activity Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        
        //system.debug('Area : '+ options );
        return options;
    }
    
    // Get Primary Criterion Options

    @AuraEnabled
    public static OfferCriterion__c  getOptionsPicklist(id RecordId){
   	//get criterion Picklist Values
        OfferCriterion__c  Criterion = [ SELECT id , criterion__r.ListValues__c,Offer__c,criterion__r.TypeCriterion__c  FROM OfferCriterion__c   WHERE id =:RecordId]; 
		return Criterion;
    }    
       
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
            a.Offre__c     = Offer;
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
    
    @AuraEnabled
    public static String getUserName() {
        return userinfo.getName();
    }
    
    @AuraEnabled 
    public static List<Offer__c> fetchUser(){ 

        User oUser = [SELECT id,Name,paramsWebMo__c  FROM User WHERE id =:userInfo.getUserId()];
      
        if(oUser.paramsWebMo__c !=null && String.isNotBlank(oUser.paramsWebMo__c) && String.isNotEmpty(oUser.paramsWebMo__c)){
            
            List<String> idOffer = new List<String>();
            
            for(String id : oUser.paramsWebMo__c.split('-'))
            {
                idOffer.add(id);
            }
            
            List<Offer__c> oOffer = [SELECT Id,Name FROM Offer__c WHERE TECH_id_webmo__c IN:idOffer];
            
            return (oOffer.size()>0) ? oOffer : null ;
            
        }else{
            return null;
        }
    }
    
    @AuraEnabled 
    public static void deleteParamWebMo(){
         User oUser = [SELECT id,Name,paramsWebMo__c  FROM User WHERE id =:userInfo.getUserId()];
         oUser.paramsWebMo__c = null;
        try {
            User u = new User();
            u.paramsWebMo__c = oUser.paramsWebMo__c;
            Update u;
        } catch (DmlException e) {
            system.debug('Erreur updating param');
        }  
    }

}