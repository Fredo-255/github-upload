import { LightningElement,track,api } from 'lwc';
import findOfferFamily from '@salesforce/apex/LCCTR_OfferCtr.findOfferFamily'
import FORM_RESOURCES from '@salesforce/resourceUrl/StyleCriterionComponent';



export default class LwcOfferFamilly extends LightningElement {
  @api  appResources;
  @api recordId;
  
  @track offersFamilly;
  @track noData;

// bearSilhouette: FORM_RESOURCES +'/progress.png',

appResources = {
    bearSilhouette: FORM_RESOURCES +'/progress.png',
};

//@wire(findOfferFamily) offersFamilly;

connectedCallback(){
    this.loadOfferFamilly();
}


loadOfferFamilly() {
    //window.console.log('rso beginload');
    
    //window.console.log(this.recordId);
    
    

    findOfferFamily({Recordid : this.recordId})
        .then(result => {
           // window.console.log('rso nb family'+result.length);
            this.offersFamilly = result;
            if (result.length<1){
                
                this.noData=true;
            }
        })
        .catch(error => {
            this.error = error;
            //window.console.log('Error'+  this.error);
        });
}



ListIsNotEmpty(){
    return this.offersFamilly.data && this.offersFamilly.datalenght >0;
}

/*
get noData() {
    return !this.offersFamilly.data;
}*/

handleclickFamily(event){
    event.preventDefault();
    const selectedFamily = event.currentTarget.dataset.familyid;  
    let nboffers;
    let selectedoffer;



    if(this.offersFamilly) {
        for(let key in this.offersFamilly) {
            // Preventing unexcepted data
            if (this.offersFamilly.hasOwnProperty(key) && selectedFamily===this.offersFamilly[key].Id) { // Filtering the data in the loop
                nboffers=this.offersFamilly[key].ChildOffer__r.length;
                selectedoffer=this.offersFamilly[key].ChildOffer__r[0].Id;
               /* window.console.log('rsi id each '+JSON.stringify(this.offersFamilly[key].ChildOffer__r[0].Id));
                window.console.log('rsi id each '+JSON.stringify(this.offersFamilly[key].Id));
                window.console.log('rsi id each '+JSON.stringify(this.offersFamilly[key].ChildOffer__r.length));*/
                
            }
        }
    }	

   
    const selectFamily = new CustomEvent('clickfamily', {
        detail: { Id: selectedFamily, nboffers:nboffers ,selectedoffer:selectedoffer }
    });
    this.dispatchEvent(selectFamily);
    
}

handleclickLink(event){
    
    event.stopImmediatePropagation();
                

}


}