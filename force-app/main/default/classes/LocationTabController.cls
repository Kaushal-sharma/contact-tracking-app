public with sharing class LocationTabController {
    public class CustomException extends Exception {}

    @AuraEnabled
    public static LocationInformation getLocationDetails(String recordId){
        try {
            LocationInformation info = new LocationInformation();
            Location__c location = CTLocationController.getLocationById(recordId);
            if(location != null) {
                info.name = location.Name;
                info.redScore = Integer.valueOf(location.Red_Score__c);
                info.statusUpdateOn = location.Status_Update_Date__c;
                info.pincode = location.Pincode__c;
                info.status = location.Status__c;
            }else {
                throw new CustomException('Invalid location id!');
            }

            List<Location_Tracing__c> traces = CTLocationTracingController.getVisitors(recordId);
            System.debug(traces);
            if(traces !=null && traces.size() > 0) {
                List<CloseContact> closeContact = new List<CloseContact>();
               
                CloseContact cc = new CloseContact();
                for(Location_Tracing__c trace : traces) {
                        cc.id = trace.Person__c;
                    	cc.name = trace.Person__r.Name;
                        cc.status = trace.Person__r.Health_Status__c;
                        cc.token = trace.Person__r.Token__c;
                        cc.visitDate = trace.Visit_Date__c;
                        closeContact.add(cc);
                }
                info.contacts = closeContact;
                info.contactCount = closeContact.size();
            }
            return info;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class LocationInformation {
        @AuraEnabled public String name;
        @AuraEnabled public Integer redScore;
        @AuraEnabled public Date statusUpdateOn;
        @AuraEnabled public String pincode;
        @AuraEnabled public String status;
        @AuraEnabled public Integer contactCount=0;
        @AuraEnabled public List<CloseContact> contacts;
    }

    public class CloseContact {
        @AuraEnabled public String id;
        @AuraEnabled public String name;
        @AuraEnabled public String token;
        @AuraEnabled public Date visitDate;
        @AuraEnabled public String status;
    }
}