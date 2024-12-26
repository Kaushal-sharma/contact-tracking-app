public with sharing class CTPeopleTracingTriggerHandler {
    
    public static void beforeInsert(List<People_Tracing__c> newRecord) {

        //This logic implement by me. Check the when select same person with same id.
        for(People_Tracing__c people : newRecord) {
            if(people.Person_1__c.equals(people.Person_2__c)) {
                people.addError('Can not meet Person 1: '+people.Person_1__c+' Person 2: '+people.Person_2__c + ' cause of same.');
            }
        }
        
        //Check with existing reocrd
        List<People_Tracing__c> duplicates = CTPeopleTracingController.checkDuplicates(newRecord);
        System.debug('duplicates: '+ duplicates);
        for(People_Tracing__c peopleTrace : duplicates) {
            peopleTrace.addError('Duplicate record found. Person 1:'+peopleTrace.Person_1__c+' Person 2:'+peopleTrace.Person_2__c);
        }
    }

}