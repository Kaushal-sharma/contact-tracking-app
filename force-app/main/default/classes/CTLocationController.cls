public with sharing class CTLocationController {
    public CTLocationController() {

    }

    @AuraEnabled
    public static List<Location__c> getRececntStatusChanges(){
        try {
            List<Location__c> recentStatusChangeList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
            return recentStatusChangeList;  

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Location__c> searchLocations(String searchTerm){
        try {
            searchTerm = searchTerm + '%';
            List<Location__c> searchLocationsList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm ORDER BY Status_Update_Date__c DESC NULLS LAST];
            return searchLocationsList;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /*
        why I'm storing the result in a list first and then returning it this way?
        Because since we are matching it by the id, we'll always get one record in return. The reason is, sometimes the id could be invalid. And in that case, you may hit an exception here that there is no record found and it cannot assign it to a location record. So, if you are using a list of location record, even if the query returns 0 record, you will not hit the exceptions.
        But if you will do something like this, like, only location object, then you may hit the exception some time. So, it's better that we get list of location and then from there, we can pass the zeroth element.
    */
    @AuraEnabled
    public static Location__c getLocationById(String locationId){
        try {
            List<Location__c> locationList = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE Id=:locationId];
            
            if(locationList != null && locationList.size() > 0) {
                return locationList[0];
            }
            return null;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}