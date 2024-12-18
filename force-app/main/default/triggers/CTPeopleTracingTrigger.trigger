trigger CTPeopleTracingTrigger on People_Tracing__c (before insert) {

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            System.debug('CTPeopleTracingTrigger => '+ Trigger.operationType);
            CTPeopleTracingTriggerHandler.beforeInsert(Trigger.new);
        }

        when else {
            
        }
    }
}