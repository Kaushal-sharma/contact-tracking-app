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

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
        // store unique location ids
        Set<Id> locationIds = new Set<Id>();
        // store unique person Ids
        Set<Id> personIds = new Set<Id>();
        for (Location_Tracing__c trace : newLocationTraces) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }

        // map of location id, set of person ids
        Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
        // location1, [person1, person2]
        // query existing location tracing records
        List<Location_Tracing__c> existingRecords = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Location__c IN :locationIds AND Person__c IN :personIds];

        // list of duplicate records
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();


        if(existingRecords != null && existingRecords.size() > 0){
            for (Location_Tracing__c trace : existingRecords) {
                if(! mapOfExistingRecords.containsKey(trace.Location__c)){
                    mapOfExistingRecords.put(trace.Location__c, new Set<Id>());
                }
                // add person ids to map set
                mapOfExistingRecords.get(trace.Location__c).add(trace.Person__c);
            }
            
            // loop over new location tracing records
            for (Location_Tracing__c trace : newLocationTraces) {
                // first check for location id
                // if item found in map, then check for person in set
                if(mapOfExistingRecords.containsKey(trace.Location__c) 
                    && mapOfExistingRecords.get(trace.Location__c).contains(trace.Person__c)){
                        duplicates.add(trace);
                }
            }
        }

        return duplicates;
    }
 
    @AuraEnabled
    public static Map<String, Integer> getStatusCount(){
        try {
            Map<String, Integer> statusCount = new Map<String, Integer>();
            for(AggregateResult result : [SELECT Status__c, COUNT(Id) Total FROM Location__c GROUP BY Status__c]) {
                //statusCount.put((String)result.get('Health_Status__c'), (Integer)result.get('Total'));
                statusCount.put(String.valueOf(result.get('Status__c')), Integer.valueOf(result.get('Total')));
            }
            return statusCount;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}