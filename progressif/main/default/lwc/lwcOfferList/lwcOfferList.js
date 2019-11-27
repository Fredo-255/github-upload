import { LightningElement,track ,api} from 'lwc';


import getOffersList from '@salesforce/apex/LCCTR_OfferCtr.getOffersList';

export default class LwcOfferList extends LightningElement {

	@api selectedFamilly;
    @track offers;
	@track error;
	@api recordId;
    
	connectedCallback() {
		this.loadOffers();
	}
	
	loadOffers() {
		getOffersList(
			{
				FamillyId:this.selectedFamilly,
				Recordid : this.recordId
			}
		)
			.then(result => {
				this.offers = result;
			})
			.catch(error => {
				this.error = error;
			});
	}
	handleclickoffer(event){

		
		event.preventDefault();
		const selectedoffer = event.currentTarget.dataset.offerid;
		//const selectedoffer='a0L6E000003fgQQUAY';
        const selectOffer = new CustomEvent('clickoffer', {
            detail: selectedoffer
        });
		this.dispatchEvent(selectOffer);
		
		//window.console.log ( 'rso click offer child'+selectedoffer);
	}

	handleclickprevious(event){

		
		event.preventDefault();
        const previousclick = new CustomEvent('previous', {
            detail: "1"
        });
		this.dispatchEvent(previousclick);
		
	}
	



}