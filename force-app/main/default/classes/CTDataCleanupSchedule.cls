public with sharing class CTDataCleanupSchedule implements Schedulable {
    
    public static final String CRON = '0 0 2 * * ?';
    
    public void execute(SchedulableContext sc) {
        CTPeopleTracingDataCleanupBatch peopleTracingBatch = new CTPeopleTracingDataCleanupBatch();
        Database.executeBatch(peopleTracingBatch, 2000);

        CTLocationTracingDataCleanupBatch locationTracingBatch = new CTLocationTracingDataCleanupBatch();
        Database.executeBatch(locationTracingBatch, 2000);
    }

    //Execute schedule
    /*CTDataCleanupSchedule dataClean = new CTDataCleanupSchedule();
    String jobId = System.schedule('Data cleanup job', CTDataCleanupSchedule.CRON, dataClean);
    System.debug('JobId: '+ jobId);*/

    //How to test (Set data older date(before 30 day) from today);
    /*dataClean.execute(null);*/
}
