import { LightningElement, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateToRedStatus from '@salesforce/apex/PersonViewController.updateHealthStatus';

export default class PersonView extends LightningElement {
    
    fields = ['Name', 'Mobile__c', 'Token__c', 'Health_Status__c', 'Status_Update_Date__c'];
    personId;
    backgroundColor;
    status

    get statusIsRed() {
        return this.status!='Red' ? true : false;
    }

    @api
    personStatusColor(id, status) {
        this.personId = id;
        this.status = status;
        this.backgroundColor = `background-${status}`;
    }

    updateToRedStatus() {
        updateToRedStatus({personId:this.personId})
        .then((res)=>{
            this.showMessage('Success', 'Update to Red status', 'success');
        })
        .catch((error) => {
            this.showMessage('Error', error.body.message, 'error');
        })
    }

    successHandler() {
        const refreshEvent = new CustomEvent('personupdate');
        this.dispatchEvent(refreshEvent);
        this.showMessage('Success', 'Person Updated', 'success');
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