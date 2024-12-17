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
        Set<Id> orangeStatus = new Set<Id>();
        Set<Id> yellowStatus = new Set<Id>();
    
        for(Person__c person : newRecord) {

            //Except the 'Red' , get all other status ids.
            if(person.Health_Status__c != oldRecord.get(person.Id).Health_Status__c) {
                statusChange.add(person.Id);
            }

            //Only get redStatus person Ids
            if(person.Health_Status__c == 'Red' && oldRecord.get(person.Id).Health_Status__c != 'Red') {
                redStatus.add(person.Id);
            }
        }

        Set<Id> alreadyProcessed = new Set<Id>();
        alreadyProcessed.addAll(redStatus);
        
        
        
        // add cohabitants
        orangeStatus.addAll(CTPersonController.getCohabitants(redStatus, alreadyProcessed));
        // add primary contact
        Set<Id> primaryContact = (CTPersonController.getPrimaryContact(redStatus, alreadyProcessed));
        orangeStatus.addAll(primaryContact);

        // add neighbours
        yellowStatus.addAll(CTPersonController.getNeighbours(redStatus, alreadyProcessed));

        // add secondary contact
        yellowStatus.addAll(CTPersonController.getSecondaryContact(primaryContact, alreadyProcessed));
		
        List<Person__c> personToUpdate = new List<Person__c>();

        for(Id pid : orangeStatus) {
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c = 'Orange'));
        }
        for(Id pid : yellowStatus) {
            personToUpdate.add(new Person__c(Id=pid, Health_Status__c = 'Yellow'));
        }

        if(personToUpdate.size() > 0) {
            update personToUpdate;
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(statusChange);
        Set<Id> locationIds = new Set<Id>();
        if(locationTraces != null && locationTraces.size() > 0) {
            for(Location_Tracing__c trace : locationTraces) {
                locationIds.add(trace.Location__c);
            }
            CTLocationController.updateRedScore(locationIds);
        }
        
    }

}