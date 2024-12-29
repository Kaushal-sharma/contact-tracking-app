import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CTHealthAdminView extends LightningElement {

    tabName = '';
    dataId;
    status;

    handleActive(event) {
        const name = event.target.value;
        this.tabName = name.charAt(0).toUpperCase() + String(name).slice(1);
        if(this.tabName == 'Location') {
            this.template.querySelector('c-c-t-health-header').getLocationStatus();
        } else {
            this.template.querySelector('c-c-t-health-header').getPersonStatus();
        }
    }


    viewDetail(event) {
        this.dataId = event.detail.recordId;
        this.status = event.detail.status;
        console.log('In admin: '+ this.status);
        this.template.querySelector('c-c-t-location-view').locationStatus();
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