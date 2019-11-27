import { LightningElement, track,api} from 'lwc';
//import {ShowToastEvent} from 'lightning/platformShowToastEvent'; 
//import getOffers from '@salesforce/apex/LCCTR_OfferCtr.getOffers';
//import getUserDetails from '@salesforce/apex/LCCTRL_OfferController.getUserDetails';
//import getAreaActivity from '@salesforce/apex/LCCTRL_OfferController.getActivityArea';
import Id from '@salesforce/user/Id';
import FORM_RESOURCES from '@salesforce/resourceUrl/StyleCriterionComponent';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class LWC_CriterionConfig_V0 extends LightningElement {

@track selectedOffer;
@track selectedFamilly;
@track nboffers;
@track currentStep = "1";
userId = Id;
@track user;
@track error;
@track Area;

@api recordId;

// Expose URL of assets included inside an archive file
progressurl = FORM_RESOURCES + '/img/progress.png';
recap = FORM_RESOURCES + '/img/racap.png';


@track error; // to show error message from apex controller.
@track success; // to show succes message in ui.
styleinitialized = false;


    renderedCallback() { 
        if (!this.styleinitialized){
            loadStyle(this, FORM_RESOURCES + '/StyleCriterionComponent.css')
        .then(() => { 
            this.styleinitialized=true;
         });
        }
        
    }


        get options() {
            return [
                { label: 'Valeur 1', value: 'Valeur1' },
                { label: 'Valeur 2', value: 'Valeur2' },
                { label: 'Valeur 3', value: 'Valeur3' },
            ];
        }

            selectFromHeaderStep1(){
                this.currentStep = "1";
                //window.console.log('current step'+ this.currentStep);
                this.handleProgressbar();
            }

            selectFromHeaderStep2(){
                this.currentStep = "2";
               //window.console.log('current step'+ this.currentStep);
                this.handleProgressbar();
            }

            selectFromHeaderStep3(){
                this.currentStep = "3";
                //window.console.log('current step'+ this.currentStep);
                this.handleProgressbar();
            }

            selectFromHeaderStep4(){
                this.currentStep = "4";
                //window.console.log('current step'+ this.currentStep);
                this.handleProgressbar();

            }

        get Step1() {
            // eslint-disable-next-line no-undef
            return  (this.currentStep ==="1") ? true : false;
        }

        get Step2() {
            // eslint-disable-next-line no-undef
            return  (this.currentStep ==="2") ? true : false;
        }

        get Step3() {
            // eslint-disable-next-line no-undef
            return  (this.currentStep ==="3") ? true : false;
        }

        get Step4() {
            // eslint-disable-next-line no-undef
            return  (this.currentStep ==="4") ? true : false;
        }

       
       
        handleSelectOffer(event){
            const selectedId = event.detail;
            this.selectedOffer = selectedId;
            //window.console.log('rso selected offer Parent after' + this.selectedOffer);
            this.selectFromHeaderStep3();
        } 

        handleSelectFamily(event){
           // this.selectedFamilly = event.detail;
           this.selectedFamilly=  event.detail.Id;
           this.nboffers=  event.detail.nboffers;
           if (this.nboffers===1){
            this.selectedOffer=  event.detail.selectedoffer;
            this.selectFromHeaderStep3();
           }else
           {
            this.selectFromHeaderStep2();
           }
        } 
        handlePrevious(event){
            this.currentStep=  event.detail;  
            this.handleProgressbar();
            
        }
       

        handleProgressbar(){
            this.template.querySelectorAll('li').forEach(
                element =>{ 
                //window.console.log('>>>this.currentStep : ' + this.currentStep + element.dataset.lolo);
                if(element.dataset.step ===this.currentStep){
                   //window.console.log('add class active--'+element.dataset.step+this.currentStep);
                    element.classList.add('active');
                }else{
                    element.classList.remove('active');
                    
                   //window.console.log('remove class active--'+element.dataset.step+this.currentStep);
                }
                
                    // Scroll to top
                    window.scroll(0,0);
               /* if(parseInt(element.dataset.step,10) === parseInt(this.currentStep,10)+1){
                   // window.console.log('>>>this.currentStep ramose: ' + this.currentStep);
                   // window.console.log('ajout css');
                    element.classList.remove('active');
                }*/
        })

        
        }

    

}