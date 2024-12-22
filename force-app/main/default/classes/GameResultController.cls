public with sharing class GameResultController {
    @AuraEnabled
    public static List<WordShuffle__c> getResults() {
        // get current user's id
        String userId = UserInfo.getUserId();
        List<WordShuffle__c> results = [
            SELECT Id, Name, Result__c, Mode__c, CreatedDate
            FROM WordShuffle__c
            WHERE CreatedById = :userId
            ORDER BY CreatedDate DESC
        ];
        return results;
    }
}
