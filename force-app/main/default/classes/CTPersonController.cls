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
    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) total FROM Person__c GROUP BY Health_Status__c]) {
            healthCountMap.put(String.valueOf(ar.get('Health_Status__c')), Integer.valueOf(ar.get('total')));
        }
        return healthCountMap;
    }

    public static Set<Id> getCohabitants(Set<Id> personIds, Set<Id> alreadyProcessed) {
        List<String> healthStatus = new List<String>{'Green','Yellow'};

        List<People_Tracing__c> peopleTracingList = [SELECT Id, Name, Person_1__c, Person_2__c, Contact_Type__c FROM People_Tracing__c 
                                                     WHERE (Person_1__c IN :personIds OR Person_2__c IN : personIds) 
                                                     AND Contact_Type__c = 'Cohabitant' 
                                                     AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN : healthStatus)];

        Set<Id> cohabitants = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList) {
            if(!alreadyProcessed.contains(pt.Person_1__c)) {
                cohabitants.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)) {
                cohabitants.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return cohabitants;
    }
    
    public static Set<Id> getNeighbours(Set<Id> personIds, Set<Id> alreadyProcessed) {

        List<People_Tracing__c> peopleTracingList = [SELECT Id, Name, Person_1__c, Person_2__c, Contact_Type__c FROM People_Tracing__c WHERE (Person_1__c IN :personIds OR Person_2__c IN : personIds) AND Contact_Type__c = 'Neighbour' AND (Person_2__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];

        Set<Id> neighbours = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList) {
            if(!alreadyProcessed.contains(pt.Person_1__c)) {
                neighbours.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)) {
                neighbours.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return neighbours;
    }
    
    public static Set<Id> getPrimaryContact(Set<Id> personIds, Set<Id> alreadyProcessed) {
        List<String> healthStatus = new List<String>{'Green','Yellow'};

        List<People_Tracing__c> peopleTracingList = [SELECT Id, Name, Person_1__c, Person_2__c, Contact_Type__c FROM People_Tracing__c WHERE (Person_1__c IN :personIds OR Person_2__c IN : personIds) AND Contact_Type__c = 'Other' AND Contact_Date__c = LAST_N_DAYS:10 AND (Person_1__r.Health_Status__c IN :healthStatus OR Person_2__r.Health_Status__c IN :healthStatus)];

        Set<Id> primaryContact = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList) {
            if(!alreadyProcessed.contains(pt.Person_1__c)) {
                primaryContact.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)) {
                primaryContact.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return primaryContact;
    }
    
    public static Set<Id> getSecondaryContact(Set<Id> personIds, Set<Id> alreadyProcessed) {

        List<People_Tracing__c> peopleTracingList = [SELECT Id, Name, Person_1__c, Person_2__c, Contact_Type__c FROM People_Tracing__c WHERE (Person_1__c IN :personIds OR Person_2__c IN : personIds) AND Contact_Type__c = 'Other' AND Contact_Date__c = LAST_N_DAYS:10 AND (Person_1__r.Health_Status__c = 'Green' OR Person_2__r.Health_Status__c = 'Green')];

        Set<Id> secondaryContact = new Set<Id>();
        for(People_Tracing__c pt : peopleTracingList) {
            if(!alreadyProcessed.contains(pt.Person_1__c)) {
                secondaryContact.add(pt.Person_1__c);
                alreadyProcessed.add(pt.Person_1__c);
            }
            if(!alreadyProcessed.contains(pt.Person_2__c)) {
                secondaryContact.add(pt.Person_2__c);
                alreadyProcessed.add(pt.Person_2__c);
            }
        }
        return secondaryContact;
    }

    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    public static List<Person__c> searchPeople(String searchTerm){
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
            FROM Person__c 
            WHERE Name LIKE :searchTerm 
                OR Mobile__c LIKE :searchTerm 
                OR Token__c LIKE :searchTerm 
            ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }
}