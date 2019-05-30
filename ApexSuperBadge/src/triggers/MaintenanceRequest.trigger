trigger MaintenanceRequest on Case (before update, after update) {	
	
	if(trigger.isUpdate && trigger.isAfter){
		Integer i = -1;			
		Set<Id> caseId = new Set<Id>();
		for(Case c: Trigger.new){
			i++;
			if( (c.Type == 'Repair' || c.Type == 'Routine Maintenance')
				&& (c.Status == 'Closed' &&  Trigger.old[i].Status != c.Status ) ) {
				caseId.add(c.Id);
			}
		}	
		System.debug('caseId:' + caseId);
		if(!caseId.isEmpty()) MaintenanceRequestHelper.updateWorkOrders(caseId);																				
	}																					
}