public with sharing class CTLocationTracingController {
    public CTLocationTracingController() {

    }

    @AuraEnabled
    public static List<Location_Tracing__c> getVisitors(String locVisitorId){
        try {
            List<Location_Tracing__c> locVisitorList = [SELECT Id, Person__r.Token__c, Person__r.Health_Status__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Id=:locVisitorId ORDER BY Visit_Date__c DESC];
            return locVisitorList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        try {
            List<Location_Tracing__c> locationsByPersonIdsList = [SELECT Id, Person__c, Location__c, Visit_Date__c FROM Location_Tracing__c WHERE Person__c IN :personIds AND Visit_Date__c = LAST_N_DAYS:10];
            return locationsByPersonIdsList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Location_Tracing__c> getLocationsByLocationsIds(Set<Id> locationIds){
        try {
            List<Location_Tracing__c> locationIdsList = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Location__c  IN :locationIds AND Person__r.Health_Status__c='GREEN' AND Visit_Date__c = LAST_N_DAYS:10];
            return locationIdsList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTracing) {
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c trac : newLocationTracing) {
            locationIds.add(trac.Location__c);
            personIds.add(trac.Person__c);
        }

        List<Location_Tracing__c> locationTracingList = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Person__c IN : personIds AND Location__c IN : locationIds];

        Map<Id, Set<Id>> mapForExisting = new Map<Id, Set<Id>>();

        for(Location_Tracing__c trac : locationTracingList) {
            if(locationTracingList.size() > 0){
                if(!mapForExisting.containsKey(trac.Location__c)){
                    mapForExisting.put(trac.Location__c, new Set<Id>());
                }
                mapForExisting.get(trac.Location__c).add(trac.Person__c);
            }
        }
        return null;
    }
}