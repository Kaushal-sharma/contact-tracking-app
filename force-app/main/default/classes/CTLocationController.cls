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
    
    
    public static void updateRedScore(Set<Id> locationIds) {
        List<Location__c> locationToUpdate = new List<Location__c>();
        List<AggregateResult> redPeoplePerLocation = [SELECT Location__c, COUNT(Id) total FROM Location_Tracing__c WHERE Visit_Date__c = LAST_N_DAYS: 10 AND Location__c IN : locationIds GROUP BY Location__c];

        for(AggregateResult ar : redPeoplePerLocation) {
            String locationId = String.valueOf(ar.get('Location__c'));
            Integer redScore = Integer.valueOf(ar.get('total'));
            String status = getStatus(redScore);
            locationToUpdate.add(new Location__c(Id=locationId, Red_Score__c = redScore, Status__c = status));
        }

        if(locationToUpdate != null && locationToUpdate.size() > 0 ) {
            update locationToUpdate;
        }
    }

    public static String getStatus(Integer redScore) {
        if(redScore == 0) {
            return 'Green';
        } else if(redScore <= 5) {
            return 'Yellow';
        } else if(redScore <= 10) {
            return 'Orange';
        } else {
            return 'Red';
        }
    }

    @AuraEnabled
    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Status__c, COUNT(Id) total FROM Location__c GROUP BY Status__c]) {
            healthCountMap.put(String.valueOf(ar.get('Status__c')), Integer.valueOf(ar.get('total')));
        }
        return healthCountMap;
    }

    public static List<Location__c> getRecentStatusChanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

}