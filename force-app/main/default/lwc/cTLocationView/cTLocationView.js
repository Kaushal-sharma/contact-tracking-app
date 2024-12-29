import { LightningElement, api} from 'lwc';

export default class CTLocationView extends LightningElement {

    @api recordId;
    @api recordStatus;
    backgroundColor;

    fields = ['Name','Status__c','Red_Score__c','Pincode__c','Address__c','Status_Update_Date__c'];

    @api
    locationStatus() {
        consoles.log('status: '+ this.recordStatus)
        this.backgroundColor = `background-${this.recordStatus}`;
    }
        
}