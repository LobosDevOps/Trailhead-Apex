/* 
 * This class can be safely deleted from your org. 
 * It was only used to ensure 100% test coverage
 * for the managed package installation.
 */

@IsTest
private class InstallationTests {
    
    //test WarehouseSyncSchedule
    public static String CRON_EXP = '0 0 1 * * ?';

    //test MaintenanceRequestHelper
    public static final String Vehic1 = 'Vehic1';

    //test WarehouseSyncSchedule
    static testmethod void testWarehouseSync() {

        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        String jobId = System.schedule('WarehouseSyncSchedule',
                                       CRON_EXP, 
                                       new WarehouseSyncSchedule());   
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE id = :jobId];

        Test.stopTest();
 
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
    }   

    //test MaintenanceRequestHelper
    private static List<Vehicle__c> getVehicleList(){
        List<Vehicle__c> vehicleList = new List<Vehicle__c>();			
        Vehicle__c veh1 = new Vehicle__c(Model__c=Vehic1);			
        vehicleList.add(veh1);			
        return vehicleList;
    }	

    private static List<Product2> getProduct2List(){
        List<Product2> product2List = new List<Product2>();			
        Product2 prod = new Product2(Name='Product1');			
        prod.Maintenance_Cycle__c = 10;	
        prod.Replacement_Part__c = true;	
		product2List.add(prod);	

        Product2 prod2 = new Product2(Name='Product2');			
        prod2.Maintenance_Cycle__c = 8;	
        prod2.Replacement_Part__c = true;	
		product2List.add(prod2);	

        return product2List;
    }

    private static List<Case> getCaseList(Integer caseCnt, String status, String type, Vehicle__c veh){
        List<Case> caseList = new List<Case>();	
        for (Integer i=0; i<caseCnt; i++){			
            Case c = new Case(			
                            Status = status,			
                            Type = type,			
                            Vehicle__c =veh.Id,
                            Date_Due__c = System.today());			
            caseList.add(c);			
        }			
        return caseList;
    }

    private static List<Work_Part__c> getWorkPartList(List<Case> caseList, List<Product2> p2List){
        List<Work_Part__c> partsList = new List<Work_Part__c>();	
        for (Case c: caseList){			
            Work_Part__c part1 = new Work_Part__c();	
            part1.Equipment__c = p2List[0].Id;	
            part1.Maintenance_Request__c = c.Id;
            partsList.add(part1);

            Work_Part__c part2 = new Work_Part__c();
            part2.Equipment__c = p2List[1].Id;	
            part2.Maintenance_Request__c = c.Id;			
            partsList.add(part2);
        }			
        return partsList;
    }

    //@testSetup static void setupData(){	
    static List<case> getUpdateCaseList(Integer caseCnt, String type){			
        List<Vehicle__c> vehicleList = getVehicleList();			
        insert vehicleList;		

        List<Product2> Product2List = getProduct2List();			
		insert Product2List;

        List<case> caseList = getCaseList(caseCnt, 'Open', type, vehicleList[0]);			
        insert caseList;	
        List<Work_Part__c> partsList = getWorkPartList(caseList, Product2List);
        insert partsList; 

        return caseList;
    }	

    static void compareResult(Integer caseCnt, String status, String type, Date dateDue, Integer wpCnt){			
        List<Case> caseList	= [Select id, Status, Type, Date_Due__c,
                                (select id , name, Equipment__r.Maintenance_Cycle__c from Work_Parts__r) 
                                from Case where Status = :status and Type = :type];
        System.assert(caseList.size() == caseCnt);
        Integer wpRstCnt = 0;
        for(Case c : caseList){
            System.assert(c.Date_Due__c == dateDue);
            wpRstCnt += c.Work_Parts__r.size();
        }
        System.assert(wpRstCnt == wpCnt);
    }

    @isTest			
    static void testMaintenanceRequestPositive(){	
		List<Case> caseList = getUpdateCaseList(1, 'Repair');  
        for(Case c :caseList){
            c.Status = 'Closed';
        }      	
        Test.startTest();				
        update caseList;
        Test.stopTest();

        compareResult(1, 'Closed', 'Repair', System.today(), 0);
        compareResult(1, 'New', 'Routine Maintenance', System.today().addDays(8), 2);
    }

    static testmethod void testMaintenanceRequestNegative() {       	
		List<Case> caseList = getUpdateCaseList(1, 'Repair');  
        for(Case c :caseList){
            c.Status = 'Working';
        }      	
        Test.startTest();				
        update caseList;
        Test.stopTest();			

        compareResult(1, 'Working', 'Repair', System.today(), 2);
        compareResult(0, 'New', 'Routine Maintenance', System.today(), 0);
    }

    static testmethod void testMaintenanceRequestBulk() {
		List<Case> caseList = getUpdateCaseList(300, 'Routine Maintenance');  
        for(Case c :caseList){
            c.Status = 'Closed';
        }      	
        Test.startTest();				
        update caseList;
        Test.stopTest();			

        compareResult(300, 'Closed', 'Routine Maintenance', System.today(), 0);
        compareResult(300, 'New', 'Routine Maintenance', System.today().addDays(8), 600);
    }
}