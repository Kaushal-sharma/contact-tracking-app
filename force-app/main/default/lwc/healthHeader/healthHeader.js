import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPersonHealthStatus from '@salesforce/apex/CTHealthHeaderController.getPersonHealthStatuscount';
import getLocationHealthStatus from '@salesforce/apex/CTHealthHeaderController.getLocationHealthStatuscount';

export default class HealthHeader extends NavigationMixin(LightningElement) {

    @api tabName;
    statusInfo={};


    @api
    getPersonStatus() {
        getPersonHealthStatus()
        .then((response) => {
            this.statusInfo = response;
        })
        .catch((error) => {
            this.showMessage(error.statusText, error, 'error');
        })
    }

    @api
    getLocationStatus() {
        getLocationHealthStatus()
        .then((response) => {
            this.statusInfo = response;
            console.log(this.statusInfo);
        })
        .catch((error) => {
            this.showMessage(error.statusText, error, 'error');
        })
    }

    createNewRecord(event) {
        console.log(`Create ${this.tabName} record.`);
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.tabName+'__c',
                actionName: 'new'
            },
        });
    }

    refreshAllData() {
        
    }

    showMessage(title, msg, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: msg,
                variant: variant
            })
        )
    }
}