public with sharing class PersonTabController {
    public class CustomException extends Exception {} 

    @AuraEnabled
    public static UserInformation getPersonDetails(String recordId){
        try {
            UserInformation info = new UserInformation();
            Person__c person = CTPersonController.getPersonById(recordId);
            if(person != null) {
                info.name = person.Name;
                info.token = person.Token__c;
                info.statusUpdateOn = person.Status_Update_Date__c;
                info.phone = person.Mobile__c;
                info.status = person.Health_Status__c;
            } else {
                throw new CustomException('Invalid person id!');
            }

            List<People_Tracing__c> traces = CTPeopleTracingController.getTraces(recordId);
            if(traces !=null && traces.size() > 0) {
                List<CloseContact> closeContact = new List<CloseContact>();
                Set<Id> ids = new Set<Id>();
                ids.add(recordId);

                CloseContact cc = new CloseContact();
                for(People_Tracing__c trace : traces) {
                    if(!ids.contains(trace.Person_1__c)) {
                        cc.id = trace.Person_1__c;
                        cc.name = trace.Name;
                        cc.status = trace.Person_1__r.Health_Status__c;
                        cc.token = trace.Person_1__r.Token__c;
                        cc.contactDate = trace.Contact_Date__c;
                    }

                    if(!ids.contains(trace.Person_2__c)) {
                        cc.id = trace.Person_1__c;
                        cc.name = trace.Name;
                        cc.status = trace.Person_2__r.Health_Status__c;
                        cc.token = trace.Person_2__r.Token__c;
                        cc.contactDate = trace.Contact_Date__c;
                    }
                    closeContact.add(cc);
                }
                info.contacts = closeContact;
                info.contactCount = closeContact.size();
            }
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class UserInformation {
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date statusUpdateOn;
        @AuraEnabled public String phone;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactCount=0;
        @AuraEnabled public List<CloseContact> contacts;
    }

    public class CloseContact {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date contactDate;
        @AuraEnabled public String status;
    }
}