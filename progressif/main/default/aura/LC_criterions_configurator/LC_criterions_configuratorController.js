({
    loadOptions:function(component, event, helper) {
        helper.SelectAreaActivity(component, event, helper);
        helper.SelectOffre(component, event, helper);
        helper.getUserInf(component,event,helper);
        helper.findOfferFamily(component,event,helper);
    }, 
    
	openModel: function(component, event, helper) {
        helper.openModel(component, event, helper);
    }, 
    
    closeModel: function(component, event, helper) {
        helper.closeModel(component, event, helper);
    },
    
 
    moveNext: function(component, event, helper) {
        helper.moveNext(component, event, helper);
    },

    
    moveBack: function(component, event, helper) {
        helper.moveBack(component, event, helper);
    },
    
    reloadPage: function(component, event, helper) {
        helper.reloadPage(component, event, helper);
    },
    
    selectFromHeaderStep1: function(component, event, helper) {
        helper.selectFromHeaderStep1(component, event, helper);
    },
    
    selectFromHeaderStep2: function(component, event, helper) {
        helper.selectFromHeaderStep2(component, event, helper);
    },
    
    selectFromHeaderStep3: function(component, event, helper) {
        helper.selectFromHeaderStep3(component, event, helper);
    },
    selectFromHeaderStep4: function(component, event, helper) {
        helper.selectFromHeaderStep4(component, event, helper);
    },
    DisplayCriteres : function (component, event, helper) {    
      helper.DisplayCriteres(component, event, helper);
      helper.DisplayCaneaux(component,event, helper);  
    },
    //Save Criteres
    saveCriteres : function (component, event, helper) { 
     helper.saveCriteres(component, event, helper); 
    },
  
    displayOffre  : function (component, event, helper) {
     helper.displayOffre(component, event, helper);
   	}, 
    
    //Add Espace Section
    addNewCanal : function (component, event, helper) {
     helper.addNewCanal(component, event, helper);
   	}, 
    
    //Add Moyen Section
    addNewMoyen :function (component, event, helper) {
     helper.addNewMoyen(component, event, helper);
   	}, 
      
    
})