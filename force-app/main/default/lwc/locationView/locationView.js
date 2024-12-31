import { LightningElement, api} from 'lwc';

export default class LocationView extends LightningElement {
    
    fields = ['Name', 'Status__c', 'Red_Score__c', 'Pincode__c', 'Address__c', 'Status_Update_Date__c'];
    @api locationId;
    @api locationStatus;
    backgroundColor;

    @api
    locationStatusColor() {
        consoles.log('locationID: '+ this.backgroundColor);
        this.backgroundColor = `background-${this.locationStatus}`;
    }
        
}