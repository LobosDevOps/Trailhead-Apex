trigger ProjectTrigger on Project__c (after update) {
    private static final String STATUS_BILLABLE = 'Billable';

    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            //Status was changed to 'Billable' BillingCalloutServiceをコール
            filterStatusChanged(Trigger.oldMap, Trigger.new);
        }
    }
    
    //Status was changed to 'Billable' BillingCalloutServiceをコール
    private static void filterStatusChanged(Map<Id, Project__c> oldMap, List<Project__c> newList) {
        for (Project__c newProject : newList) {
            if (newProject.Status__c == STATUS_BILLABLE && oldMap.get(newProject.Id).Status__c != STATUS_BILLABLE)
                BillingCalloutService.callBillingService(newProject.Id);
        }
    }
}