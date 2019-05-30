@isTest
private class WarehouseCalloutServiceTest {
  //private static final String RESPONSE_BODY1 = '{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100002"}';
  //  private static final String RESPONSE_BODY2 = '{"_id":"55d66226726b611100aaf743","replacement":false,"quantity":5,"name":"Generator 1000 kW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}';
    private static final Boolean expectedReplacement1 = true;
    private static final Boolean expectedReplacement2 = false;
    private static final String expectedName = 'Generator 1000 kW';
    private static final String expectedSku1 = '100002';
    private static final String expectedSku2 = '100003';
    private static final Integer expectedMaintenanceperiod = 365;
    private static final Integer expectedLifespan = 120;
    private static final Integer expectedCost = 5000;
    private static final Integer expectedQuantity = 5;

    @isTest static void testWarehouse() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> equipments = [SELECT Id, Current_Inventory__c, Replacement_Part__c, Name, Maintenance_Cycle__c, Lifespan_Months__c, Cost__c, Warehouse_SKU__c
                              FROM Product2];
        
        Integer i = 0;
        for(Product2 equipment :equipments){
          System.assertEquals(equipment.Current_Inventory__c, expectedQuantity);                
          System.assertEquals(equipment.Replacement_Part__c, (i == 0) ? expectedReplacement1 : expectedReplacement2 );
          System.assertEquals(equipment.Name, expectedName);
          System.assertEquals(equipment.Maintenance_Cycle__c, expectedMaintenanceperiod);
          System.assertEquals(equipment.Lifespan_Months__c, expectedLifespan);
          System.assertEquals(equipment.Cost__c, expectedCost);
          String expectedSku = (i == 0) ? expectedSku1 : expectedSku2;
          System.assertEquals(equipment.Warehouse_SKU__c, expectedSku);
          i++;
        }
    }
}