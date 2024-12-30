import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import HEALTH_STATUS from "@salesforce/schema/Person__c.Health_Status__c";
import getPersonHealthStatus from '@salesforce/apex/CTHealthHeaderController.getPersonHealthStatuscount';
import getLocationHealthStatus from '@salesforce/apex/CTHealthHeaderController.getLocationHealthStatuscount';

export default class HealthHeader extends NavigationMixin(LightningElement) {

    @api tabName;
    @track healthStatus = [];
    picklist=[];

    @wire(getPicklistValues, { recordTypeId: "012000000000000AAA", fieldApiName: HEALTH_STATUS })
    picklistResults({ error, data }) {
        if (data) {
          this.picklist = data.values;
          this.error = undefined;
        } else if (error) {
          this.error = error;
          this.ratings = undefined;
        }
    }

    @api
    getPersonStatus() {
        this.healthStatus=[];
        getPersonHealthStatus()
        .then((response) => {
            this.picklist.forEach((item, index) => {
                for(let [key, value] of Object.entries(response)) {
                    if(item.label == key) {
                        item = {...item, count:value, color:`text-${item.label}`}
                    } 
                }
                if(!Object.hasOwn(item, 'count')) {
                    item = {...item, count:0, color:`text-${item.label}`}
                }
                this.healthStatus.push(item);
            });
        })
        .catch((error) => {
            this.showMessage(error.statusText, error, 'error');
        })
    }

    @api
    getLocationStatus() {
        this.healthStatus = [];
        getLocationHealthStatus()
        .then((response) => {
            this.picklist.forEach((item, index) => {
                for(let [key, value] of Object.entries(response)) {
                    if(item.label == key) {
                        item = {...item, count:value, color:`text-${item.label}`}
                    } 
                }
                if(!Object.hasOwn(item, 'count')) {
                    item = {...item, count:0, color:`text-${item.label}`}
                }
                this.healthStatus.push(item);
            });
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