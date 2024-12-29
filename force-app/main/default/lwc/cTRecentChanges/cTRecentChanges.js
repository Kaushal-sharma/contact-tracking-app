import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecentPersonHealthChanges from '@salesforce/apex/CTRecentChangesController.getRecentPersonHealthChanges';
import getRecentLocationHealthChanges from '@salesforce/apex/CTRecentChangesController.getRecentLocationHealthChanges';

export default class CTRecentChanges extends LightningElement {

    columns = [
        { label: "Name", fieldName: "Name", type: "text" },
        { label: "Phone", fieldName: "Mobile__c", type: "text" },
        { label: "Token", fieldName: "Token__c", type: "text" },
        { label: "Health Status", fieldName: "Health_Status__c", type: "text" },
        { label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date" },
        { label: "View", type: "button", initialWidth: 135, typeAttributes: { label: "View/Update", name: "view_details", title: "Click to View Details" } }
    ]

    data = [];

    connectedCallback() {
        this.recentPersonHealthStatus();
    }

    recentPersonHealthStatus() {
        getRecentPersonHealthChanges()
        .then((response) => {
            this.data = response;
        })
        .catch((error) => {
            this.showMessage(error.statusText, error, 'error');
        })
    }

    recentLocationHealthStatus() {
        getRecentLocationHealthChanges()
        .then((response) => {
            this.data = response;
        })
        .catch((error) => {
            this.showMessage(error.statusText, error, 'error');
        })
    }

    handleKeyUp(event) {
     
    }

    handleRowAction(event) {

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