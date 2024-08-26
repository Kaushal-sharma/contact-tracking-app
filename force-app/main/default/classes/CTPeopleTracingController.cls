public with sharing class CTPeopleTracingController {
    public CTPeopleTracingController() {

    }

    @AuraEnabled
    public static List<People_Tracing__c> getTraces(String personId)  {
        try {
            List<People_Tracing__c> peopleList = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, Person_1__c, Person_1__r.Health_Status__c, Person_1__r.Token__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c=: personId AND Person_2__c =: personId ORDER BY Contact_Date__c DESC];
            return peopleList;
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 

   
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces) {
        try {
            Set<Id> personIds = new Set<Id>();
			List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
            Map<Id, Set<Id>> mapOfExistingRecords = new Map<Id, Set<Id>>();
            
            for(People_Tracing__c traces : newPeopleTraces) {
                personIds.add(traces.Person_1__c);
                personIds.add(traces.Person_2__c);
            }

            
            List<People_Tracing__c> existingRecords = [SELECT Id, Person_1__c, Person_2__c FROM People_Tracing__c WHERE Person_1__c IN : personIds OR Person_2__c IN : personIds];

            if(existingRecords.size() > 0 && existingRecords != null) {
                for(People_Tracing__c trace : existingRecords) {
                    if(!mapOfExistingRecords.containsKey(trace.Person_1__c)) {
                        mapOfExistingRecords.put(trace.Person_1__c, new Set<Id>());
                    }
                    mapOfExistingRecords.get(trace.Person_1__c).add(trace.Person_2__c);

                    if(!mapOfExistingRecords.containsKey(trace.Person_2__c)) {
                        mapOfExistingRecords.put(trace.Person_2__c, new Set<Id>());
                    }
                    mapOfExistingRecords.get(trace.Person_2__c).add(trace.Person_1__c);
                }
                
                for(People_Tracing__c traces : newPeopleTraces) {
                    if((mapOfExistingRecords.containsKey(traces.Person_1__c) && mapOfExistingRecords.get(traces.Person_1__c).contains(traces.Person_2__c)) || (mapOfExistingRecords.containsKey(traces.Person_2__c) && mapOfExistingRecords.get(traces.Person_2__c).contains(traces.Person_1__c))) {
                        duplicates.add(traces);
                    }
                }
            }
            return duplicates;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}