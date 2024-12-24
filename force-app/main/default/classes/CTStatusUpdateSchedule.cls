
public with sharing class CTStatusUpdateSchedule implements Schedulable {

    public static final String CRON = '0 0 3 * * ?';

    public void execute(SchedulableContext sc) {
        CTUpdatePersonStatusBatch updatePersonStatusBatch = new CTUpdatePersonStatusBatch();
        Database.executeBatch(updatePersonStatusBatch, 2000);

        CTLocationStatusUpdateBatch updateLocationStatusBatch = new CTLocationStatusUpdateBatch();
        Database.executeBatch(updateLocationStatusBatch, 2000);
    }

    //Execute schedule(means only define batch when you want to execute)
    /*CTStatusUpdateSchedule updateSchedule = new CTStatusUpdateSchedule();
    String jobId = System.schedule('Status update job', CTStatusUpdateSchedule.CRON, dataClean);
    System.debug('JobId: '+ jobId);*/


    //How to test (Set data older date(14 day ago) from today);
    //updateSchedule.execute(null);
}
