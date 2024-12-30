import { LightningElement, api} from 'lwc';

export default class CTLocationView extends LightningElement {
    
    fields = ['Name', 'Status__c', 'Red_Score__c', 'Pincode__c', 'Address__c', 'Status_Update_Date__c'];
    locationId;
    recordStatus;
    backgroundColor='background-Red';

    @api
    locationStatus(locationId) {
        consoles.log('locationID: '+ locationId)
        this.locationId = locationId;
        // this.backgroundColor = `background-${this.recordStatus}`;
    }
        
}