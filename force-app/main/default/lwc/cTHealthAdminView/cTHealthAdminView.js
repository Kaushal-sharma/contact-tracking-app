import { LightningElement } from 'lwc';

export default class CTHealthAdminView extends LightningElement {

    tabContent = '';

    handleActive(event) {
        const tab = event.target;
        this.tabContent = event.target.value;
        console.log(this.tabContent);
    }
}