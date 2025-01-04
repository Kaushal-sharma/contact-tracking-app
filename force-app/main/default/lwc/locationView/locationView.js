import { LightningElement, api} from 'lwc';

export default class LocationView extends LightningElement {
    
    fields = ['Name', 'Status__c', 'Red_Score__c', 'Pincode__c', 'Address__c', 'Status_Update_Date__c'];
    locationId;
    backgroundColor;

    @api
    locationStatusColor(id, status) {
        this.locationId = id;
        this.backgroundColor = `background-${status}`;
        console.log(this.backgroundColor);
    }
        
}