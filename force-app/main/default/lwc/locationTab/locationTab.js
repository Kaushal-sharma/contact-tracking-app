import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLocationDetails from '@salesforce/apex/LocationTabController.getLocationDetails';

const COLUMNS = [
    { label: "Name", fieldName: "name", type: "text" },
    { label: "Status", fieldName: "status", type: "text" },
    { label: "Token", fieldName: "token", type: "text" },
    { label: "Visit Date", fieldName: "visitDate", type: "date" },
]

export default class LocationTab extends LightningElement {
    
    columns = COLUMNS;
    recordId;
    userFound=false;
    locationInfo=[];

    connectedCallback() {
        //this.getUserInfo();
    }
    
    searchChangeHandler(event){
        this.recordId = event.target.value;
    }

    get styleDynamic() {
        return `border-radius:15px 15px 0px 0px; background-color:${this.locationInfo.status}`;
    }

    getUserInfo() {
        if(this.recordId) {
            getLocationDetails({recordId:this.recordId})
            .then((response) => {
                console.log(response);
                this.locationInfo = response;
                this.userFound=true;
            })
            .catch((error) => {
                this.userFound=false;
                this.showMessage('Error', error.body.message, 'error');
            })
        } else {
            this.showMessage('Error', 'Enter valid id', 'error');
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