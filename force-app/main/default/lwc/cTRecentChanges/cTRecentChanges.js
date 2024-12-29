import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecentPersonHealthChanges from '@salesforce/apex/CTRecentChangesController.getRecentPersonHealthChanges';
import getRecentLocationHealthChanges from '@salesforce/apex/CTRecentChangesController.getRecentLocationHealthChanges';
import serachPerson from '@salesforce/apex/CTRecentChangesController.serachPerson';
import searchLocation from '@salesforce/apex/CTRecentChangesController.searchLocation';


const personColumns = [
    { label: "Name", fieldName: "Name", type: "text" },
    { label: "Phone", fieldName: "Mobile__c", type: "text" },
    { label: "Token", fieldName: "Token__c", type: "text" },
    { label: "Health Status", fieldName: "Health_Status__c", type: "text" },
    { label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date" },
    { label: "View", type: "button", initialWidth: 135, typeAttributes: { label: "View/Update", name: "view_details", title: "Click to View Details" } }
]

const locationColumns = [
    { label: "Name", fieldName: "Name", type: "text" },
    { label: "Status", fieldName: "Status__c", type: "text" },
    { label: "Red Score", fieldName: "Red_Score__c", type: "number" },
    { label: "Pincode", fieldName: "Pincode__c", type: "text" },
    { label: "Address", fieldName: "Address__c", type: "text" },
    { label: "Status Update Date", fieldName: "Status_Update_Date__c", type: "date" },
    { label: "View", type: "button", initialWidth: 135, typeAttributes: { label: "View/Update", name: "view_details", title: "Click to View Details" } }
]

export default class CTRecentChanges extends LightningElement {

    @api scope;
    columns =[];
    data = [];

    connectedCallback() {
        if(this.scope == 'Location') {
            this.columns = locationColumns;
            this.recentLocationHealthStatus();
        } else {
            this.columns = personColumns;
            this.recentPersonHealthStatus();
        }
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
        const isEnterKey = event.keyCode === 13;
        const query = event.target.value;
        if(!query) {
            this.connectedCallback();
        }
        if(isEnterKey) {
            console.log('keyCode: '+ isEnterKey);
            if(this.scope=='Location') {
                console.log('Location: search');
                searchLocation({searchTerm:query})
                .then((response) => {
                    this.data = response;
                    console.log(this.data);
                })
                .catch((error) => {
                    this.showMessage(error.statusText, error, 'error');
                })
            } 
            else {
                console.log('Person: search');
                serachPerson({searchTerm:query})
                .then((response) => {
                    this.data = response;
                    console.log(this.data);
                })
                .catch((error) => {
                    this.showMessage(error.statusText, error, 'error');
                })
            }
        } 
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