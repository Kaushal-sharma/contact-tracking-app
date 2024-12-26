import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import HEALTH_STATUS from "@salesforce/schema/Person__c.Health_Status__c";

import getHealthStatus from '@salesforce/apex/CTPersonController.getHealthStatusCount';

export default class CTHealthAdminView extends LightningElement {

    tabName = '';
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

    connectedCallback() {
        this.retrieveHealthStatus();
    }

    retrieveHealthStatus() {
        getHealthStatus()
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
    }

    handleActive(event) {
        const name = event.target.value;
        this.tabName = name.charAt(0).toUpperCase() + String(name).slice(1);
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