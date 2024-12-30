import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HealthAdminView extends LightningElement {

    tabName = '';
    locationId;
    status;

    handleActive(event) {
        const name = event.target.value;
        this.tabName = name.charAt(0).toUpperCase() + String(name).slice(1);
        if(this.tabName == 'Location') {
            this.template.querySelector('c-health-header').getLocationStatus();
        } else {
            this.template.querySelector('c-health-header').getPersonStatus();
        }
    }


    viewDetail(event) {
        this.locationId = event.detail.recordId;
        this.status = event.detail.status;
        console.log('In admin: '+ this.status);
        //try{
            this.template.querySelector('c-location-view').locationStatus(locationId);
        //} catch(error) {
            //console.log(error);
        //}
        console.log('Okay!')
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