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
		Map<Id, Set<Id>> mapForExisting = new Map<Id, Set<Id>>();
        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        
        AggregateResult[] results  = [SELECT COUNT(Id) Total, Person__c, Location__c FROM Location_Tracing__c GROUP BY Person__c, Location__c HAVING COUNT(Id) > 1];
        System.debug('findDuplicates: '+ results);
        
        for(AggregateResult trace : results) {
            locationIds.add(String.valueOf(trace.get('Location__c')));
            personIds.add(String.valueOf(trace.get('Person__c')));
        }
        SYstem.debug('locationIds: '+ locationIds);
        System.debug('PersonIds: '+ personIds);
        
        List<Location_Tracing__c> locationTracingList = [SELECT Id, Name, Person__c, Location__c FROM Location_Tracing__c WHERE Person__c IN : personIds AND Location__c IN : locationIds ORDER BY CreatedDate DESC];
        
        for(Location_Tracing__c trace : locationTracingList) {
        	duplicates.add(trace);
        }        

        /*for(Location_Tracing__c trace : newLocationTracing) {
            locationIds.add(trace.Location__c);
            personIds.add(trace.Person__c);
        }
        
        List<Location_Tracing__c> locationTracingList = [SELECT Id, Person__c, Location__c FROM Location_Tracing__c WHERE Person__c IN : personIds AND Location__c IN : locationIds ORDER BY CreatedDate DESC];

        System.debug('locationTracingList: '+ locationTracingList);
        
        
        for(Location_Tracing__c trace : locationTracingList) {
            if(locationTracingList.size() > 0){
                if(!mapForExisting.containsKey(trace.Location__c)){
                    mapForExisting.put(trace.Location__c, new Set<Id>());
                }
                mapForExisting.get(trace.Location__c).add(trace.Person__c);
            }
        }

        for(Location_Tracing__c trace : newLocationTracing) {
            System.debug('=> Location__c: '+trace.Location__c+ ' Person__c: '+mapForExisting.get(trace.Location__c));
            if(mapForExisting.containsKey(trace.Location__c)) {
               if(mapForExisting.containsKey(trace.Location__c) && mapForExisting.get(trace.Location__c).contains(trace.Person__c)) {
                	duplicates.add(trace);
            	}
            }
        }*/
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