import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HealthAdminView extends LightningElement {

    tabName = '';
    viewRecordId;
    viewStatus;

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
        this.viewRecordId = event.detail.recordId;
        this.viewStatus = event.detail.status;
        const viewname = event.detail.viewname;
        console.log('In admin: '+this.viewRecordId +' '+ this.viewStatus);
        try{
            if(viewname=='location_view_details') {
                this.template.querySelector('c-location-view').locationStatusColor();
            } else {
                this.template.querySelector('c-person-view').personStatusColor();
            }
        } catch(error) {
            this.showMessage('Error', 'Something went wrong!', 'error');
        }
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