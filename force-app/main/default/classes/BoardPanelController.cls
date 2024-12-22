public with sharing class BoardPanelController {
    @AuraEnabled
    public static String addResult(String result, String mode) {
        WordShuffle__c gameResult = new WordShuffle__c(Result__c = result, Mode__c = mode);
        insert gameResult;
        return 'success';
    }
}
