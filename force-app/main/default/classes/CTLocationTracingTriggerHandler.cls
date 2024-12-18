public with sharing class CTLocationTracingTriggerHandler {
    
    public static void beforeInsert(List<Location_Tracing__c> newRecord) {
        List<Location_Tracing__c> duplicates = CTLocationTracingController.checkDuplicates(newRecord);

        for(Location_Tracing__c locationTrace : duplicates) {
            locationTrace.addError('Duplicate record found. Person :'+locationTrace.Person__c);
        }
    }
}