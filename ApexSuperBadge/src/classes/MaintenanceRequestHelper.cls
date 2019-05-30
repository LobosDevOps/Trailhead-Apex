public class MaintenanceRequestHelper {

	public static void updateWorkOrders(Set<Id> caseId){
		//get all case and work parts
		List<Case> caseList = [select id, subject, Vehicle__c, type, Date_Reported__c,Date_Due__c,Equipment__c ,
								(select id , name, Equipment__r.Maintenance_Cycle__c from Work_Parts__r) 
								from case 
								where id in : caseId];
		List<Case> insertCaseList = new List<Case>();
		Map<Case, Case> oldCaseMap =  new Map<Case, Case>();
		for(Case c: caseList){
			Integer smallestDays = getMaintenanceCyclesmallestDays( c.Work_Parts__r);
			Date dateDue = System.today().addDays(smallestDays);
			String strSubject = c.subject != null ? c.subject : 'Routine Maintenance subject';
			Case newC = new Case(subject = strSubject, 
								 Vehicle__c = c.Vehicle__c,
								 Equipment__c = c.Equipment__c,
								 Type = 'Routine Maintenance',
								 Date_Reported__c = System.today(),
								 Date_Due__c = dateDue,
								 Old_Case__c = c.Id);
			insertCaseList.add(newC);
			oldCaseMap.put(c, newC);
		}
		//insert new Case
		if (!insertCaseList.isEmpty()) {
			insert insertCaseList;
			updateWorkParts(oldCaseMap);
		}
	}

	//return smallest Maintenance_Cycle__c
	private static Integer getMaintenanceCyclesmallestDays(List<Work_Part__c> workPartList){
		Integer smallestDays = 0;
		Integer startCnt = 0;
		for(Work_Part__c wp: workPartList){	
			if(startCnt == 0) smallestDays = Integer.valueOf(wp.Equipment__r.Maintenance_Cycle__c);
			startCnt++;
			if(wp.Equipment__r.Maintenance_Cycle__c < smallestDays){
				smallestDays = Integer.valueOf(wp.Equipment__r.Maintenance_Cycle__c) ;
			}
		}
		return smallestDays;
	}

	//update Work_Parts
	private static void updateWorkParts(Map<Case, Case> oldCaseMap){
		List<Work_Part__c> updWorkParts = new List<Work_Part__c>();
		for(Case oldC: oldCaseMap.keySet()){	
			for(Work_Part__c wp: oldC.Work_Parts__r){	
				wp.Maintenance_Request__c = oldCaseMap.get(oldC).Id;
				updWorkParts.add(wp);
			}
		}
		if (!updWorkParts.isEmpty()) update updWorkParts;
	}
}