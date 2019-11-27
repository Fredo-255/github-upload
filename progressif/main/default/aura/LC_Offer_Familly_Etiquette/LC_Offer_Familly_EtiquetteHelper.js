({
	 descriptionClick : function(component, event, helper){
        var tooltipDepartement = component.find("tooltipDepartement");
        
        // Pour eviter de declencher le onclick de l'etiquette
        event.cancelBubble = true;
        event.stopPropagation();
        var isIE = component.get("v.isIE");
        console.log("isIE " + isIE);
        
        // Retourner l'etiquette
        if(isIE !== true){
            var flip = component.find('flip');
            $A.util.toggleClass(flip, 'flip');
            
            window.setTimeout(
                $A.getCallback(function() {
                    $A.util.toggleClass(tooltipDepartement, 'slds-hide');
                }), 180
            ); 
        }else{
            component.set("v.displayToolTipIE", true);
        }
    },
    
    
    offerByFamily : function(component, event, helper){
        
        var offerFamId = event.currentTarget.id;

        var action  = component.get("c.getOffersByFamily");
         
        action.setParams({"RecordId":offerFamId});
        action.setCallback(this, 
                           function(response){
                               var state  = response.getState();
                               if(state === 'SUCCESS'){
                                   var result = response.getReturnValue();
                                
                                   component.set("v.selecFamily",result);
                                   component.set("v.currStp","2");
                               }else{
                                   console.log('Erreur getOfferFamily');
                               }
                           });
        
        $A.enqueueAction(action);  
        
    },
    
    
    
    
})