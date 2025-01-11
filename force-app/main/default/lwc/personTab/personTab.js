import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPersonDetails from '@salesforce/apex/PersonTabController.getPersonDetails';

const COLUMNS = [
    { label: "Name", fieldName: "name", type: "text" },
    { label: "Token", fieldName: "token", type: "text" },
    { label: "Contact Status", fieldName: "status", type: "text" },
    { label: "Contact Date", fieldName: "contactDate", type: "date" },
]

export default class PersonTab extends LightningElement {
    
    columns = COLUMNS;
    recordId;
    userFound=false;
    userInfo=[];

    connectedCallback() {
        //this.getUserInfo();
    }
    
    searchChangeHandler(event){
        this.recordId = event.target.value;
    }

    get styleDynamic() {
        return `border-radius:15px 15px 0px 0px; background-color:${this.userInfo.status}`;
    }

    getUserInfo() {
        if(this.recordId) {
            getPersonDetails({recordId:this.recordId})
            .then((response) => {
                console.log(response);
                this.userInfo = response;
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