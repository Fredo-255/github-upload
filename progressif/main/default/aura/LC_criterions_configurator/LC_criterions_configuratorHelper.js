({
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
                
    },
    
    
    findOfferFamily: function (component, event, helper) {
        
        var action  = component.get("c.findOfferFamily");
        
        action.setCallback(this, function(response){
            var state  = response.getState();
            
            if(state === 'SUCCESS'){
                
                var result = response.getReturnValue();
                
                console.log('response getFamilyOffers : ' + JSON.stringify(result));
                component.set("v.familyOffer",result);
            }
            else{
                
                console.log('Erreur getFamily Offers');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    
    
    SelectOffre: function (component, event, helper) {
        
        var action  = component.get("c.getOffers");
        
        action.setCallback(this, function(response){
            var state  = response.getState();
            
            if(state === 'SUCCESS'){
                
                var result = response.getReturnValue();
                
                console.log('response getOffers : ' + JSON.stringify(result));
                component.set("v.offers",result);
            }
            else{
                
                console.log('Erreur getOffers');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    SelectAreaActivity: function (component, event, helper) {
        
        var action  = component.get("c.getActivityArea");
        
        action.setCallback(this, function(response){
            var state  = response.getState();
            
            if(state === 'SUCCESS'){
                
                var result = response.getReturnValue();
                
                console.log('response getAreaActivity : ' + JSON.stringify(result));
                //component.set("v.areaActivity",result);
                
                
                var industryMap = [];
                for(var key in result){
                    industryMap.push({key: key, value: result[key]});
                }
                component.set("v.areaActivity", industryMap);
            }
            else{
                
                console.log('Erreur getAreaActivity');
            }
        });
        
        $A.enqueueAction(action);
        
    },
    
    
    closeModel: function(component, event, helper){
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        this.closeCallback(component, event, helper);
    },
    moveNext  : function(component,event,helper){
        // control the next button based on 'currentStep' attribute value    
        var getCurrentStep = component.get("v.currentStep");
        if(getCurrentStep == "1"){
            component.set("v.currentStep", "2");
        }
        else if(getCurrentStep == "2"){
            component.set("v.currentStep", "3");
        }
        
    },
    moveBack  : function(component,event,helper){
        // control the back button based on 'currentStep' attribute value    
        var getCurrentStep = component.get("v.currentStep");
        if(getCurrentStep == "2"){
            component.set("v.currentStep", "1");
        }
        else if(getCurrentStep == "3"){
            component.set("v.currentStep", "2");
        }
        
    },
    reloadPage : function(component,event,helper){
        location.reload();
    },
    
    // when user click direactly on step 1,step 2 or step 3 indicator then showing appropriate step using set 'currentStep'   
    selectFromHeaderStep1 : function(component,event,helper){
        component.set("v.currentStep", "1");
    },
    selectFromHeaderStep2 : function(component,event,helper){
        component.set("v.currentStep", "2");
    },
    selectFromHeaderStep3 : function(component,event,helper){
        component.set("v.currentStep", "3");
    },
    selectFromHeaderStep4 : function(component,event,helper){
        component.set("v.currentStep", "4");
    },
   
     DisplayCaneaux : function(component, event, helper){
         
         console.log("DisplayCanaux1");
         
         //var offerId = event.currentTarget.id;
         //var offerid = event.getSource().get("v.value");
         var offerid = component.get("v.offer");
         
         console.log("DisplayCanaux11");
         
         var action  = component.get("c.getCaneaux");
         
         component.set("v.caneauxTmp",[]);
         component.set("v.caneauxTmpNew",[]);
         action.setParams({"RecordId":offerid});
        	action.setCallback(this, 
                     function(response){
             			var state  = response.getState();
             			if(state === 'SUCCESS'){
                            var result = response.getReturnValue();
                            
         					console.log("DisplayCanaux2");
                            var maMap = [];
                            var Crits = [];
                            var newcanal=[];
                            var newmoyen=[];
                            var Moyens=[];
                            for(var i=0; i<result.length; i++){
                                
                               //Format Crit
                                 if (result[i].criterion__r.Target__c =='Espace de diffusion' ){
                                    var crit= this.CritFormat(result[i]);
                                    Crits.push(crit);  
                                 }
                            }
                            //Construire Espace
                            if(Crits.length>0){
                                maMap.push({value:Crits, key:1 , moyens:Moyens});
                        	}
                            
                            component.set("v.caneauxTmp",maMap);
                            
                            // Initier Nouveau canal/Espace
                            for (var i=0; i<result.length; i++){
                                
                                if (result[i].criterion__r.Target__c =='Espace de diffusion' ){
                                    var crit= this.CritFormat(result[i]);
                                    newcanal.push(crit);
                                }
                                if (result[i].criterion__r.Target__c =='Moyen de diffusion' ){
                                    var crit= this.CritFormat(result[i]);
                                    newmoyen.push(crit);
                                }
                            }
                            component.set("v.caneauxTmpNew",newcanal);
                            
                            component.set("v.critMoyenTmpNew",newmoyen);
                            
                            console.log('Init caneauxTmpNew ' + JSON.stringify(newcanal));
                            
                            console.log('Init critMoyenTmpNew ' + JSON.stringify(newmoyen));
                            component.set("v.currentStep","3");
             			}else{
                 			console.log('Erreur getCaneaux');
             			}
         			});
         
           $A.enqueueAction(action);  
    },
        
 	 DisplayCriteres : function (component, event, helper) {

         //var OfferId = event.getSource().get("v.id");
          var OfferId = event.currentTarget.id;
         
         component.set("v.offer",OfferId);
         console.log('STEP 3 - OFFRE SELECTIONEE  = '+ OfferId);
         
         var action  = component.get("c.getCriteres"); 
         action.setParams({"RecordId":  OfferId});
         action.setCallback(this, function(response){
             var state  = response.getState();
             
             if(state === 'SUCCESS'){
                 
                 var result = response.getReturnValue();
                 
                 console.log('STEP 3 - LISTE CRITERES OFFRE  =  ' + JSON.stringify(result));
                 component.set("v.criteres",result);
                 
                 var Crits = [];
                 for(var i=0; i<result.length; i++){
                     
                     //Format Un critère 
					 var Crit= this.CritFormat(result[i]);
                     Crits.push(Crit);
                   
                 }
                 
                
                 component.set("v.criteresTmp",Crits);
                 console.log('STEP 3 - CRIT TMP  =  ' + JSON.stringify(component.get("v.criteresTmp"))); 
                 component.set("v.currentStep","3");
                 console.log('Fin DisplayCrit');
             }
             else{
                 
                 console.log('Erreur getCriteres');
             }
         });
         
           $A.enqueueAction(action);   
  
 },
    // Save 
     saveCriteres : function (component, event, helper) {
         
         console.log('STEP 3 - CRITERE OFFRE = ' + JSON.stringify(component.get("v.criteresTmp")));  

         var Criteres= component.get("v.criteresTmp");
         
         var Espaces= component.get("v.caneauxTmp");
         var inputListCrit=[];
         var inputEspaces=[];
         // Input Param Critères Standard
         for(var i=0; i<Criteres.length; i++){
             console.log('crit Std')
             var inputPrincipalCrit={Id:"",Value:""};
             inputPrincipalCrit.Id=Criteres[i].Id;
             inputPrincipalCrit.Value=Criteres[i].CriterionResponse__c;
             inputListCrit.push(inputPrincipalCrit);
             
             for(var l=0; l<Criteres[i].SecondCriteresValues.length; l++){
                 if ( Criteres[i].CriterionResponse__c ==Criteres[i].SecondCriteresValues[l].IfResponse__c){
                     
                 var inputSecondCrit={Id:"",Value:""};
                     
                 inputSecondCrit.Id		= Criteres[i].SecondCriteresValues[l].Id;
                 inputSecondCrit.Value  = Criteres[i].SecondCriteresValues[l].Valeur__c;
                 inputListCrit.push(inputSecondCrit);
                 }
                 
             } 
         } 
         
         console.log("inputListCrit"+JSON.stringify(inputListCrit));
         
         console.log("Espaces"+JSON.stringify(Espaces));
         // Input Param Critères Espace
         for ( var i=0; i<Espaces.length; i++){
             var inputOneEspace={Key:"",Criteres:"",Moyens:""};
             
             //Key
             inputOneEspace.Key=Espaces[i].key;
             
             //Critères Espace
             var inputCriteresEspace=[];
                 for ( var l=0; l<Espaces[i].value.length; l++){
                     var inputOneCrit={Id:"",Value:""};    
                     inputOneCrit.Id=Espaces[i].value[l].Id;
                     inputOneCrit.Value=Espaces[i].value[l].CriterionResponse__c;
                     console.log('OneEspace'+JSON.stringify(inputOneEspace));
                     inputCriteresEspace.push(inputOneCrit);  
                 }
             inputOneEspace.Criteres=inputCriteresEspace;
             
             //Critères Moyen
             var inputMoyensEspace=[];
             for ( var l=0; l<Espaces[i].moyens.length; l++){
                     var inputOneMoyen={Key:"",Criteres:""};    
                     inputOneMoyen.Key=Espaces[i].moyens[l].key;
                 			var inputCriteresMoyen=[];
                 			  for ( var j=0; j<Espaces[i].moyens[l].value.length; j++){
                                  var inputOneCrit={Id:"",Value:""};     
                                  inputOneCrit.Id=Espaces[i].moyens[l].value[j].Id;
                     			  inputOneCrit.Value=Espaces[i].moyens[l].value[j].CriterionResponse__c;
                                  inputCriteresMoyen.push(inputOneCrit);
                              }
                     inputOneMoyen.Criteres=inputCriteresMoyen;
                     console.log('inputOneMoyen'+JSON.stringify(inputOneMoyen));
                     inputMoyensEspace.push(inputOneMoyen);  
                 }
             
             inputOneEspace.Moyens=inputMoyensEspace;
             inputEspaces.push(inputOneEspace);
         }
         
         console.log("inputEspaces"+JSON.stringify(inputEspaces));
         //Create Autorisation - Critères Autorisation
       
        var action  = component.get("c.saveAutorisation");
          action.setParams({"RecordId":component.get("v.recordId") , 
                            "Offer":component.get("v.offer"),
                            "Criteres": JSON.stringify(inputListCrit),
                            "Espaces": JSON.stringify(inputEspaces)
                           });
         
		  	action.setCallback(this, function(response){
            var state  = response.getState();
               
            if(state === 'SUCCESS'){
                var result = response.getReturnValue();
                component.set("v.newasset",result);
                console.log('response save : ' + JSON.stringify(result));
                

                this.showToast(component, event, helper,result);
                
                component.set("v.currentStep","4");
                console.log('pass to 4 step');
                //this.closeCallback(component, event, helper);

            }
            else{
                console.log('Erreur saveAutorisation');
            }
        });
        
        	$A.enqueueAction(action);
            
     
     } ,
    
    displayOffre : function (component, event, helper) {  
        //var OfferId  = event.getSource().get("v.value");
        var OfferId = event.currentTarget.id;
        /*var urlEvent = $A.get("e.force:navigateToURL");
        
        urlEvent.setParams({"url": "/"+ OfferId});
        urlEvent.fire();*/
        var url ="https://sacem--salsadev4.lightning.force.com/"+OfferId;
        window.open(url);
    },     

    addNewCanal : function (component, event, helper) { 
        var NewCanal =[];
        //var caneauxTmpNew  =  component.get("v.caneauxTmpNew");
        var caneauxTmpNew = JSON.parse(JSON.stringify(component.get("v.caneauxTmpNew")));
        
        console.log('Add new canal -caneauxTmpNew'+caneauxTmpNew);
        var NbCanal=component.get("v.NbCanal")+1;
        component.set("v.NbCanal",NbCanal);
        NewCanal.push({value:caneauxTmpNew, key:NbCanal , moyens:[]});
        var AllCanal	   =  component.get("v.caneauxTmp");
        
        console.log('caneauxTmpNew' + JSON.stringify(caneauxTmpNew));
        console.log('AllCanal before push'+ JSON.stringify(AllCanal));
        
        AllCanal.push.apply(AllCanal, NewCanal);
        console.log('AllCanal after push'+ JSON.stringify(AllCanal));
        component.set("v.caneauxTmp",AllCanal);
        
        console.log('caneauxTmp Final' + JSON.stringify(component.get("v.caneauxTmp")));                       
    }, 
    
    showToast : function(component, event, helper, object) {
        var toastEvent = $A.get("e.force:showToast");
        var userName   = component.get("v.Name");
        toastEvent.setParams({
            "title": " SACEM : Success!",
            "message": " Bravo  " + userName.toUpperCase() +  " :  l'autorisation " + object.Name +" a été crée avec succès !!!!"
        });
        toastEvent.fire();
    },

    getUserInf: function(component, event, helper){
        var action = component.get("c.getUserName");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Name", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    
    closeCallback: function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            'url': '/'+component.get("v.recordId")
        });
        urlEvent.fire(); 	
    }, 
    
    afficher:  function(component, event, helper) {
    component.set("v.verif",true);	
    }, 
    
    addNewMoyen : function (component, event, helper) { 
        var NewMoyen ={value:"",key:""};
        var caneauxTmpNew  =  component.get("v.caneauxTmpNew");
        //var critMoyenTmpNew  =  component.get("v.critMoyenTmpNew");
        
        var critMoyenTmpNew = JSON.parse(JSON.stringify(component.get("v.critMoyenTmpNew")));
        var Espace  =event.getSource().get("v.name") 
        //var Espace = event.currentTarget.id;
       console.log('Espace Id'+Espace);
        
        var NbMoyen=component.get("v.NbMoyen")+1;
        component.set("v.NbMoyen",NbMoyen);
        console.log('critMoyenTmpNew' + JSON.stringify(critMoyenTmpNew));
        NewMoyen.value=critMoyenTmpNew;
        NewMoyen.key=NbMoyen;
        //NewMoyen.push({value:critMoyenTmpNew, key:NbMoyen});
        
         console.log('NewMoyen--Add'+JSON.stringify(NewMoyen));
        //Add NewMoyen to AllMoyen For Current Espace
       
        var AllCanal	   =  component.get("v.caneauxTmp");
        
        console.log('AllCanal before push'+ JSON.stringify(AllCanal));
        var CurrentEspaceMoyenNew=[];
        var CurrentEspaceMoyenOld=AllCanal[Espace-1].moyens;
        console.log('CurrentEspaceMoyenOld'+CurrentEspaceMoyenOld);
        
        //var CurrentEspaceMoyenNew=CurrentEspaceMoyenOld.push.apply(CurrentEspaceMoyenOld, NewMoyen);
    	CurrentEspaceMoyenOld.push(NewMoyen);
        //CurrentEspaceMoyenOld.push.apply(CurrentEspaceMoyenOld, NewMoyen);
        console.log('CurrentEspaceMoyenNew'+CurrentEspaceMoyenOld);
        AllCanal[Espace-1].moyens=CurrentEspaceMoyenOld;
          
        component.set("v.caneauxTmp",AllCanal);
        
        console.log('AllCanal after push'+ JSON.stringify(AllCanal));
                             
    }, 
    
    CritFormat : function (result){
    
          var Crit = {Id:"", CriterionResponse__c :"",Name:"", LabelCriterion__c :"",
                                 TypeCriterion__c :"",Format_du_critere__c:"",ListValues__c :"", 
                                 Mandatory__c :"",OrderDisplay__c :"",Offer__c :"",CriteresValues:[], 
                                 Valeur__c:"",Minimum__c:"",Target__c  :"",Maximum__c:"",
                                 Status__c:"",MessageRangeUnderFlow__c :"",MessageValueMissing__c :"", 
                                 MessageRangeOverFlow__c :"",SecondCriteresValues:[]
                                };
                     
                     Crit.Id	= result.Id;
                     Crit.Name 	= result.criterion__r.Name; 
                     Crit.LabelCriterion__c= result.criterion__r.LabelCriterion__c; 
                     Crit.TypeCriterion__c= result.criterion__r.TypeCriterion__c ;
                     Crit.Format_du_critere__c= result.criterion__r.Format_du_critere__c; 
                     Crit.ListValues__c = result.criterion__r.ListValues__c ; 
                     Crit.Mandatory__c = result.Mandatory__c ;
                     Crit.OrderDisplay__c = result.OrderDisplay__c; 
                     Crit.Offer__c = result.Offer__c;
                     Crit.Minimum__c = result.Minimum__c;
                     Crit.Maximum__c = result.Maximum__c;
        			 Crit.MessageRangeUnderFlow__c  = result.MessageRangeUnderFlow__c ;
        			 Crit.MessageValueMissing__c    = result.MessageValueMissing__c ;
        			 Crit.MessageRangeOverFlow__c   = result.MessageRangeOverFlow__c;
                     Crit.CriterionResponse__c  = result.CriterionResponse__c ;
                     Crit.Target__c  = result.criterion__r.Target__c  ;
                     Crit.Status__c = result.Status__c;  
                     

                     (result.SecondaryCriterionOfferCriterion__r == undefined ?  Crit.SecondCriteresValues = [] : Crit.SecondCriteresValues = result.SecondaryCriterionOfferCriterion__r)
                     
                     for(var i=0; i<Crit.SecondCriteresValues.length; i++){
                         if ( Crit.SecondCriteresValues[i].criterion__r.ListValues__c != null){
                             Crit.SecondCriteresValues[i].CriteresValues = Crit.SecondCriteresValues[i].criterion__r.ListValues__c.split(",");
                         }
                     }    
                     
                     if ( result.criterion__r.ListValues__c != null){
                         Crit.CriteresValues = result.criterion__r.ListValues__c.split(",");
                     }
        return Crit;
        
    }
})