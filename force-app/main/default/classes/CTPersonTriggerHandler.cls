public with sharing class CTPersonTriggerHandler {
    
    public static void beforeInsert(List<Person__c> newRecord) {
        for(Person__c person : newRecord) {
            person.Health_Status__c = 'Green';
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }
    }

    public static void beforeUpdate(List<Person__c> newRecord, Map<Id, Person__c> oldRecord) {
        for(Person__c person : newRecord) {
            if(person.Health_Status__c != oldRecord.get(person.Id).Health_Status__c) {
                person.Status_Update_Date__c = Date.Today();
            }
        }
    }

    public static void afterUpdate(List<Person__c> newRecord, Map<Id, Person__c> oldRecord) {
        Set<Id> statusChange = new Set<Id>();
        Set<Id> redStatus = new Set<Id>();
        Set<Id> orangeStatus = new <Id>();
        Set<Id> yellowStatus = new <Id>();
    
        for(Person__c person : newRecord) {

            //Except the 'Red' , get all other status ids.
            if(person.Health_Status__c != oldRecord.get(person.Id).Health_Status__c) {
                statusChange.add(person.Id);
            }

            //Only get redStatus person Ids
            if(person.Health_Status__c != oldRecord.get(person.Id).Health_Status__c && person.Health_Status__c == 'Red' oldRecord.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }
        
        People_Tracing__c peopleTracingObj = new People_Tracing__c();
        
    }

}