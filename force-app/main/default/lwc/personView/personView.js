import { LightningElement, api} from 'lwc';

export default class PersonView extends LightningElement {
    
    fields = ['Name', 'Mobile__c', 'Token__c', 'Health_Status__c', 'Status_Update_Date__c'];
    @api personId;
    @api personStatus;
    backgroundColor;

    @api
    personStatusColor() {
        consoles.log('PersonId: '+ this.backgroundColor);
        this.backgroundColor = `background-${this.personStatus}`;
    }
        
}