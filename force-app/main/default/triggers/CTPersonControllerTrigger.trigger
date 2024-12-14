trigger CTPersonControllerTrigger on Person__c (after insert) {
   
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            System.debug('isAfter:'); 
            String x = Trigger.new[0].Id;
            List<Person__c> pl  = [SELECT Id, Mobile__c, Token__c FROM Person__c WHERE Id =: x];
        	pl[0].Token__c = CTPersonController.getToken(pl[0].Mobile__c);
            update pl;
            
            for(Person__c t : Trigger.new) {
            	//t.Token__c = CTPersonController.getToken(t.Mobile__c);  
        	}
        }
    	//update Trigger.new; 
    }
     
}