public class WarehouseSyncSchedule implements Schedulable{
  // implement scheduled code here
  public void execute(System.SchedulableContext context){
        WarehouseCalloutService.runWarehouseEquipmentSync();
        //String jobId = System.schedule('testSchedule','0 0 1 * * ?', new WarehouseSyncSchedule());
        //CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
  }

}