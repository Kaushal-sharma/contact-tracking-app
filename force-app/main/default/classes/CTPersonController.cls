public with sharing class CTPersonController {
    public CTPersonController() {

    }

    public static string getToken(String mobile){
        try {
            Blob blobValue = Blob.valueOf(mobile);
            Blob hash = Crypto.generateDigest('md5', blobValue);
            String token = EncodingUtil.base64Encode(hash);            
            return token;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Person__c> getRecentHealthChange(){
        try {
            List<Person__c> recentHealthChangeList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
            return recentHealthChangeList;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public static List<Person__c> serachPerson(String searchTerm){
        try {
            searchTerm = searchTerm+'%';
            List<Person__c> searchPersonList = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
            return searchPersonList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    // Search only one person thatswhy here is method type Person__c
    public static Person__c getPersonById(String personId){
        try {
            List<Person__c> person = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c WHERE Id =:personId ];
            
            if(person != null && person.size() > 0) {
                return person[0];
            }
            return null;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Integer> getHealthStatusCount(){
        try {
            Map<String, Integer> healthStatusCount = new Map<String, Integer>();
            for(AggregateResult result : [SELECT Health_Status__c, COUNT(Id) Total FROM Person__c GROUP BY Health_Status__c]) {
                //statusCount.put((String)result.get('Health_Status__c'), (Integer)result.get('Total'));
                healthStatusCount.put(String.valueOf(result.get('Health_Status__c')), Integer.valueOf(result.get('Total')));
            }
            return healthStatusCount;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}