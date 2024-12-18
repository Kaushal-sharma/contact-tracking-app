trigger CTLocationTracingTrigger on Location_Tracing__c (before insert) {
    
    switch on Trigger.operationType {

        when BEFORE_INSERT {
            System.debug('CTLocationTracingTrigger => '+ Trigger.operationType);
            CTLocationTracingTriggerHandler.beforeInsert(Trigger.new);
        }

        when else {
            
        }
    }
}