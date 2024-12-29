public with sharing class CTRecentChangesController {
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges() {
        return CTPersonController.getRecentHealthChanges();
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges() {
        return CTLocationController.getRecentStatusChanges();
    }

    @AuraEnabled(cacheable=true)
    public static List<Person__c> serachPerson(String searchTerm) {
        return CTPersonController.serachPersons(searchTerm);
    }

    @AuraEnabled(cacheable=true)
    public static List<Location__c> searchLocation(String searchTerm) {
        return CTLocationController.searchLocations(searchTerm);
    }
}
