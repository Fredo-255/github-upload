import { LightningElement ,track , api } from 'lwc';

import getCriteres from '@salesforce/apex/LCCTR_OfferCtr.getCriteres';
import saveAutorisation from '@salesforce/apex/LCCTR_OfferCtr.saveAutorisation';

export default class LwcCriterionList extends LightningElement {

		@track criteres;
		@track error;
		@track Crits = []; 
		@track Crito;
		@track i=0;
		@track item;
		@api selectedOffer;
		@api inputListCrit= [];
		@api nboffers;
		@track previousstep=1;
		@track Sectioncriteres;
		@track mapData= [];

 
	connectedCallback() {
		this.LoadCriteres();
	}

	// Click Previous
	// Si 1 seule offre dans la famille sélectionné --> revenir Etape 1
	// Si plusieurs offres dans la famille sélectionné --> revenir Etape 2
	previous(event){
		event.preventDefault();
		if ( this.nboffers>1){
			this.previousstep="2";
		}else{
			this.previousstep="1";
		}
		
        const previousclick = new CustomEvent('clickprevious', {
            detail: this.previousstep
        });
		this.dispatchEvent(previousclick);
		
	}
	// Enregistrer les critères
	SaveCrit(){
		

		// Get List Critères From childs Add Criterion
		this.inputListCrit= [];
		this.template
		.querySelectorAll("c-lwc-add-criterion")
		.forEach(element => { 
			const childComponentsDataList = element.getCritObject();
			this.inputListCrit.push(childComponentsDataList);
		});
		//window.console.log('test after save--'+JSON.stringify(this.inputListCrit));

		
		// Get Espaces + Moyens

		//Create Autorisation - Critères Autorisation
       
		this.CreateAutorisation();
		


	}
	
	// Load Criterion List From OfferId
	LoadCriteres() {
		//window.console.log('rso load crit : offer Id'+this.selectedOffer);
		getCriteres({RecordId: this.selectedOffer})
		.then(result => {
			
		
			//window.console.log('rso log crit All 2 '+JSON.stringify(result));
			this.Sectioncriteres=result;
			this.criteres=result;
			//indow.console.log('rso log crit All 2');

			

		
			/*if(result) {
				for(let key in result) {
					// Preventing unexcepted data
					if (result.hasOwnProperty(key)) { // Filtering the data in the loop
						this.mapData.push({value:result[key], key:key});
					}
				}
			}	*/
			
			
		})
		.catch(error => {
			this.error = error;
		});
	}

	
	CreateAutorisation() {
		//window.console.log('Entree Save autorisation');
		saveAutorisation({
			RecordId:'a0a5E0000043EgEQAU', 
            Offer:this.selectedOffer,
			Criteres: JSON.stringify(this.inputListCrit),
			Espaces:'[]'
		
		})
		.then(result => {
			
			window.console.log('rso log crit'+JSON.stringify(result));
			/*result.forEach((item, index) => {
				window.console.log('rso log crit'+index+'---'+item);
			});*/
		})
		.catch(error => {
			this.error = error;
			//window.console.log('Error save autotisation'+error);
		});
	}

}