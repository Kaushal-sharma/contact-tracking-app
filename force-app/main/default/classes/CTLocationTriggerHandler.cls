public with sharing class CTLocationTriggerHandler {
   
    public static void beforeInsert(List<Location__c> newRecord) {
        for(Location__c location : newRecord) {
            location.Status__c = 'Green';
        }
    }

    public static void beforeUpdate(List<Location__c> newRecord, Map<Id, Location__c> oldRecord) {
        for(Location__c location : newRecord) {
            if(location.Status__c != oldRecord.get(location.Id).Status__c) {
                location.Status_Update_Date__c = Date.Today();
            }
        }
    }

    public static void afterUpdate(List<Location__c> newRecord, Map<Id, Location__c> oldRecord) {
        Set<Id> locationIds = new Set<Id>();

        for(Location__c location : newRecord) {
            if(location.Status__c == 'Red' && oldRecord.get(location.Id).Status__c != 'Red') {
                locationIds.add(location.Id);   
            }
        }

        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByPersonIds(locationIds);
        Set<Id> personIds = new Set<Id>();
        for(Location_Tracing__c trace : locationTraces) {
            personIds.add(trace.Person__c);
        }

        List<Person__c> personToUpdate = new List<Person__c>();
        for(Id pid : personIds) {
            personToUpdate.add(new Person__c(Id=pid,  Health_Status__c='Yellow'));
        }

        if(personToUpdate.size() > 0 ) {
            update personToUpdate;
        }
    }
}