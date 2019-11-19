@isTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    static TestMethod void Product2Extension_UnitTest(){
        Test.setCurrentPage(Page.Product2New);

        List<Product2> productInits = TestDataFactory.ConstructProducts(1);
        Product2 prod = productInits[0]; //new Product2(Name='test', isActive= true);
        ApexPages.StandardController controller = new ApexPages.StandardController(prod);

        //Test for save
        List<Product2> productSaves = TestDataFactory.ConstructProducts(Constants.DEFAULT_ROWS);
        List<PriceBookEntry> entrieSaves = TestDataFactory.ConstructPricebookEntries(productSaves);

        Test.startTest();
        
        Product2Extension ext = new Product2Extension(controller);
        //Test Constructor
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());

        //Test add button
        ext.addRows();
        System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size());

        //Test for save
        Integer index = 0;
        for(Product2 prd: productSaves) {
            
            // Product2 newProduct = new Product2(Name='Product'+i, Initial_Inventory__c = 10, isActive=true, family= Constants.PRODUCT_FAMILY.get(math.mod(i,4)).getValue());
            ext.productsToInsert.get(index).productRecord = prd;
            ext.productsToInsert.get(index).pricebookEntryRecord = entrieSaves[index];
            index++;
        }
        ext.save();
        //test for GetFamilyOptions
        ext.GetFamilyOptions();
        //test for GetInventory
        ext.GetInventory();
        Test.stopTest();

        List<Product2> selectedProd = [Select id from Product2];
System.debug('selectedProd : ' + selectedProd.size() );
        System.assertEquals(Constants.DEFAULT_ROWS, selectedProd.size());
    }

}