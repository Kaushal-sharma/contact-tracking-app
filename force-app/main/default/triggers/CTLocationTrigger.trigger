trigger CTLocationTrigger on Location__c (before insert, after insert, before update, after update) {

    switch on Trigger.operationType {
        
        when BEFORE_INSERT {
            System.debug('LocationTrigger => '+ Trigger.operationType);
            CTLocationTriggerHandler.beforeInsert(Trigger.new);
        }
        
        when BEFORE_UPDATE {
            System.debug('LocationTrigger => '+ Trigger.operationType);
            CTLocationTriggerHandler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }

        when AFTER_UPDATE {
            System.debug('LocationTrigger => '+ Trigger.operationType);
            CTLocationTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}