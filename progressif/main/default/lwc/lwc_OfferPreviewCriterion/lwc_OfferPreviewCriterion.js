import { LightningElement, api } from 'lwc';
import FORM_RESOURCES from '@salesforce/resourceUrl/StyleCriterionComponent';
import { loadStyle } from 'lightning/platformResourceLoader';


export default class Lwc_OfferPreviewCriterion extends LightningElement {

    @api recordId;
        

    // Expose URL of assets included inside an archive file
    progressurl = FORM_RESOURCES + '/img/progress.png';
    styleinitialized = false;


        renderedCallback() { 
            if (!this.styleinitialized){
                loadStyle(this, FORM_RESOURCES + '/StyleCriterionComponent.css')
            .then(() => { 
                this.styleinitialized=true;
            });
            }
            
        }
}