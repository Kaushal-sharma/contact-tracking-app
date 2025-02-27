import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HealthAdminView extends LightningElement {

    tabName = '';
    viewRecordId;
    viewStatus;

    handleActive(event) {
        const name = event.target.value;
        this.tabName = name.charAt(0).toUpperCase() + String(name).slice(1);
        if(this.tabName == 'Location')
            this.template.querySelector('c-health-header').getLocationStatus();
        else
            this.template.querySelector('c-health-header').getPersonStatus();
    }

    viewDetail(event) {
        this.viewRecordId = event.detail.recordId;
        this.viewStatus = event.detail.status;
        const viewname = event.detail.viewname;
        if(viewname=='location_view_details')
            this.template.querySelector('c-location-view').locationStatusColor(this.viewRecordId, this.viewStatus);
        else
            this.template.querySelector('c-person-view').personStatusColor(this.viewRecordId, this.viewStatus);
    }

    refreshData() {
        console.log('refresh tab: '+ this.tabName);
        if(this.tabName == 'Location')
            this.template.querySelector('c-recent-changes').recentLocationHealthStatus();
        else
            this.template.querySelector('c-recent-changes').recentPersonHealthStatus();
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