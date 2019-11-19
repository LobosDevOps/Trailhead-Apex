@isTest
private class OrderTests {

    @testSetup
    static void SetupTestData() {
        TestDataFactory.InsertTestData(20);
    }

    static testmethod void OrderUpdate_UnitTest() {
    	Order selectedOrder = [Select name,Status, Id from Order limit 1];
        Product2 oldProd = [Select Quantity_Ordered__c, Name, Id from Product2 limit 1];
        
        selectedOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        update selectedOrder;
        
        Product2 updatedProd = [Select Quantity_Ordered__c, Name, Id from Product2 limit 1];
        
        TestDataFactory.VerifyQuantityOrdered(oldProd,updatedProd,Constants.DEFAULT_ROWS);
    }

    @isTest
    private static void OrderExtension_UnitTest(){
       
        List<Order> orders = [SELECT Id,AccountId,EffectiveDate,Pricebook2Id,Status FROM Order];
       
        ApexPages.StandardController std = new ApexPages.StandardController(orders[0]);
       
        Test.startTest();
       
        OrderExtension extensions = new OrderExtension(std);
       
        extensions.First();
        extensions.Next();
        extensions.Previous();
        extensions.Last();
        extensions.GetFamilyOptions();
        extensions.OnFieldChange();
        extensions.SelectFamily();
       
        Boolean previous = extensions.GetHasPrevious();
        Boolean next = extensions.GetHasNext();
        Integer numberPages = extensions.GetPageNumber();
        Integer totalPages = extensions.GetTotalPages();
       
        extensions.save();
       
        Test.stopTest();
  
        System.assert(!previous);
        System.assert(!next);
        System.assertEquals(1, numberPages);
        System.assertEquals(1, totalPages);
       
    }

}