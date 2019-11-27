({
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
        
    },
    closeModel: function(component, event, helper){
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
    },
    SelectListValues: function(component, event, helper){
        var recordId =  component.get("v.recordId"); 
        var action  = component.get("c.getOptionsPicklist");   
        action.setParams( {"RecordId":recordId});
        action.setCallback(this, function(response){
            var state  = response.getState();
            
            if(state === 'SUCCESS'){
                
                var result = response.getReturnValue();
                
                console.log('response getOptionsPicklist : ' + JSON.stringify(result));
                component.set("v.criterion", result);
                var OptionsMap = [];
                // If Picklist / code APi ==7  **** Boutton Radio / Code API ==2
                if ( result.criterion__r.ListValues__c!= null && ( result.criterion__r.TypeCriterion__c=='7'|| result.criterion__r.TypeCriterion__c=='2')){
                    OptionsMap = result.criterion__r.ListValues__c.split(",");
                }
                
                component.set("v.ListValues", OptionsMap);
            }
            else{
                
                console.log('Erreur getOptionsPicklist');
            }
        });
        
        $A.enqueueAction(action);    
        
    } ,
    OpenCreateCriterion:function(component, event, helper) {
        var MainCriterion = component.get("v.recordId");
        var response      = component.get("v.valueSelected");
        var offer         = component.get("v.criterion.Offer__c");
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "OfferCriterion__c",
            "defaultFieldValues": {
            'IfResponse__c' : response ,
            'MainCriterion__c' : MainCriterion,
            'Status__c':'Secondaire'  ,
            'Offer__c': offer   
    }
        });
        createRecordEvent.fire(); 
        this.closeModel(component, event, helper);
        
    }, 
})