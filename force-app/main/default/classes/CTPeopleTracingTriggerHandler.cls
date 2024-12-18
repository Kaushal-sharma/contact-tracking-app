public with sharing class CTPeopleTracingTriggerHandler {
    
    public static void beforeInsert(List<People_Tracing__c> newRecord) {

        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecord);
        for(People_Tracing__c peopleTrace : duplicates) {
            peopleTrace.addError('Duplicate record found. Person 1:'+peopleTrace.Person_1__c+' Person 2:'+peopleTrace.Person_2__c);
        }
    }

}