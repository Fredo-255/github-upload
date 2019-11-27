import { LightningElement, track, api} from 'lwc';
import getCriteressecondaires from '@salesforce/apex/LCCTR_OfferCtr.getCriteressecondaires';
export default class LwcAddCriterion extends LightningElement {

   
    @api crit;
    @track critupdated;
    @track
    IsText;
    IsNumber;
    IsPicklist;
    IsRequired;
    Required='';
    IsDate;
    IsRadio;
    IsToogle;
    IsCurrency;
    IsUrl;
    IsTextArea;
    IsEmail;
    IsPhone;
    IsPercent;
    IsAdresse;
    IsSection;
    HasHelptext;
    @track HasSecondCrit;
    options=[];
    @track
    _ChildSecondaryCriterion;
    get ChildSecondaryCriterion() {
        return this._ChildSecondaryCriterion;
    }
    set ChildSecondaryCriterion(value) {
        this._ChildSecondaryCriterion = value;
    }
    @track IsResponse= false;
    @track
    _selectedvalue;
    
    @track critValue;

    @track value = '';

    

   /* get options() {
        return [
            { label: 'Oui', value: '1' },
            { label: 'Non', value: '2' },
        ];

        // Options Picklist
		
        
    }*/

    get selectedvalue() {
        return this._selectedvalue;
    }
    set selectedvalue(value) {
        this._selectedvalue = value;
    }

    connectedCallback(){
        if (this.crit.criterion__r.TypeCriterion__c ==='7') {
            this.IsPicklist = true;  
        }
        if (this.crit.criterion__r.TypeCriterion__c ==='1') {
            this.IsText = true;  
        }
        if (this.crit.criterion__r.TypeCriterion__c ==='5') {
            this.IsNumber = true;  
        }
        if (this.crit.Mandatory__c) {
            this.IsRequired = true;  
            this.Required='Required';
        }
        if (this.crit.criterion__r.TypeCriterion__c==='3') {
            this.IsToogle = true;  
        }
        if (this.crit.criterion__r.TypeCriterion__c==='4') {
            this.IsDate = true;  
           
        }
        if (this.crit.criterion__r.TypeCriterion__c==='6') {
            this.IsCurrency = true;  
        }
     
        if (this.crit.criterion__r.TypeCriterion__c==='9') {
            this.IsUrl = true;  
        }

        if (this.crit.criterion__r.TypeCriterion__c==='2') {
            this.IsRadio = true;  
        }
        if (this.crit.criterion__r.TypeCriterion__c==='10') {
            this.IsPercent = true;  
        }
        
        if (this.crit.criterion__r.TypeCriterion__c==='11') {
            this.IsTextArea = true;  
        }

        if (this.crit.criterion__r.TypeCriterion__c==='13') {
            this.IsEmail = true;  
        }

        if (this.crit.criterion__r.TypeCriterion__c==='14') {
            this.IsPhone = true;  
        }

        if (this.crit.criterion__r.TypeCriterion__c==='12') {
            this.IsSection = true;  
        }
        
        if (this.crit.helpText__c) {
            this.HasHelptext = true;  
        }

        if ( this.crit.criterion__r.ListValues__c != null){

            const optionvalue =  this.crit.criterion__r.ListValues__c.split(",");
			optionvalue.forEach(element => {
				this.options.push({ label: element.trim(), value: element.trim() })
			});
		}
       
        /*if (this.crit.ChildSecondaryCriterionOfferCriterion__r) {
            this.HasSecondCrit = true;  
        }*/

        if(this.crit.criterion__r.DefaultValue__c){
            this.selectedvalue=this.crit.criterion__r.DefaultValue__c;
            this.critValue=this.crit.criterion__r.DefaultValue__c;
            //load critères secondaires if picklist or radio
            if (this.IsRadio || this.IsPicklist ){
                this.loadCritsecondaires();
            }
            this.checkValidity();
        }
        //window.console.log('default value--'+this.crit.TECH_LabelToDisplay__c+'--'+this.crit.criterion__r.DefaultValue__c);
    }
    


    handleChangeSelect(event) {

        this.selectedvalue = event.detail.value;
        this.critvalue = event.detail.value;
        this.checkValidity();

        //getCriteressecondaires

        this.loadCritsecondaires();
        
        
    } 

    loadCritsecondaires(){
        getCriteressecondaires({RecordId: this.crit.Id ,
                                Response:this.selectedvalue})
		.then(result => {
			
		
			//window.console.log('rso log crit secondaire '+JSON.stringify(result));
            if (result.length>0){
                this.ChildSecondaryCriterion=result;
                this.HasSecondCrit=true;
            }else
            {
                this.ChildSecondaryCriterion=result;
                this.HasSecondCrit=false;   
            }
            
			//window.console.log('rso  HasSecondCrit '+this.HasSecondCrit+JSON.stringify(this.ChildSecondaryCriterion));
		})
		.catch(error => {
			this.error = error;
		});
    }
    @api  
    SaveCritOne(event){
        window.console.log('rso --clickchild'+this.crit.Name+event.detail.value);
    }

    @api 
    getCritObject() {
     
    const critObjectInput = {};
    critObjectInput.Id = this.crit.Id;
    critObjectInput.Value = this.critvalue;
   

     return critObjectInput;
    }
 
    handleChangeValue(event) {
        //window.console.log('handle change');
        this.critvalue = event.target.value;
        this.checkValidity();
    }  

    checkSiretValidity(siret){
        let somme = 0;
        let tmp;
        let isValid= false;
        for (let cpt = 0; cpt<siret.length; cpt++) 
        {
            if ((cpt / 2) === 0) 
            { // Les positions impaires : 1er, 3è, 5è, etc...     
                  tmp = siret.charAt(cpt) * 2; // On le multiplie par 2
                 if (tmp > 9)
                     tmp -= 9; // Si le résultat est supérieur à 9, on lui soustrait 9
            }
         else
            tmp = siret.charAt(cpt);
         somme += parseInt(tmp,10);
        }
          if ((somme / 10) === 0){
            isValid= true;
          }
          else{
            isValid= false; 
          } 
          return isValid; 

    }

    resetValidity(){
        //window.console.log('All form entries look Not valid. remove');
            
        this.template.querySelectorAll('.validityinput').forEach(element=>  {element.classList.remove('validitycheck'); })   
    }    
    checkValidity(){
        
        //window.console.log('check validity');
        const allValid = [...this.template.querySelectorAll('lightning-input, lightning-textarea, lightning-combobox')]

        .reduce((validSoFar, inputCmp) => {

        inputCmp.reportValidity();

       // window.console.log('rso  inputCmp'+inputCmp.value);


        return validSoFar && inputCmp.checkValidity() && inputCmp.value.length !== 0;

        }, true);
        //window.console.log('check validity all valid--'+allValid);

        if (allValid) {


            
            this.template.querySelectorAll('.validityinput').forEach( element=>  {element.classList.add('validitycheck');})
            
            } else {

                
            //window.console.log('All form entries look Not valid. remove');
            
                this.template.querySelectorAll('.validityinput').forEach(element=>  {element.classList.remove('validitycheck'); })   
            }
    }
}