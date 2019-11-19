public class Product2Extension {

    // private final Product2 prd;
    public List<ProductWrapper> productsToInsert {get;set;}

    //PriceBookEntry Product2 Wrapper
    public class ProductWrapper {
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper() {
            this.productRecord = new Product2(Initial_Inventory__c =0);
            this.pricebookEntryRecord = new PricebookEntry(Unitprice=0.0);
        }
    }

    public Product2Extension(ApexPages.StandardController stdController) {
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> productFamilyList = new List<SelectOption>();
        productFamilyList.add(new SelectOption('', Constants.SELECT_ONE));
        for(Schema.PicklistEntry pe: Constants.PRODUCT_FAMILY){
            productFamilyList.add(new SelectOption(pe.value, pe.label));
        }
        return productFamilyList;
    }

    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference save(){
System.debug('Save ');  
        Savepoint sp = Database.setSavepoint();

        try {
            //Product2 List
            Map<Integer, Product2> products = new Map<Integer, Product2>();

            //PriceBookEntry List
            Map<Integer, PriceBookEntry> priceBookEntries = new Map<Integer, PriceBookEntry>(); 

            Integer index = 0;
System.debug('productsToInsert ' + productsToInsert);  
            for(ProductWrapper pw :productsToInsert){
                if (String.isNotBlank(pw.productRecord.Name) 
                    && String.isNotBlank(pw.productRecord.Family) 
                    && pw.productRecord.isActive
                    && pw.pricebookEntryRecord.UnitPrice != null
                    && pw.pricebookEntryRecord.UnitPrice != 0
                    && pw.productRecord.Initial_Inventory__c!=null
                    && pw.productRecord.Initial_Inventory__c!=0){
                        products.put(index, pw.productRecord);
                        priceBookEntries.put(index, pw.pricebookEntryRecord);
                        index++;
                    }
            }

System.debug('products : ' + products.size());    
System.debug('priceBookEntries : ' + priceBookEntries.size());   
            insert products.values();
            // Database.SaveResult[] productSaveResults = Database.insert(products.values(), false);
            //TODO
            // for (Database.SaveResult sr : productSaveResults) {
            //     if (sr.isSuccess()) {
            //         // Operation was successful, so get the ID of the record that was processed
            //         System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            //     }
            //     else {
            //         // Operation failed, so get all errors                
            //         for(Database.Error err : sr.getErrors()) {
            //             System.debug('The following error has occurred.');                    
            //             System.debug(err.getStatusCode() + ': ' + err.getMessage());
            //             System.debug('Account fields that affected this error: ' + err.getFields());
            //         }
            //     }
            // }

            List<PriceBookEntry> istPbeList = new List<PriceBookEntry>();
            for(Integer mapIndex : products.keySet()) {
            	PriceBookEntry currentPBEntry = priceBookEntries.get(mapIndex);
                if(products.get(mapIndex).Id!=null) {
System.debug('product id : ' + products.get(mapIndex).Id);
                    currentPBEntry.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                	currentPBEntry.Product2Id = products.get(mapIndex).Id;
                	currentPBEntry.IsActive = true;
                    istPbeList.add(currentPBEntry);
                }
            }

System.debug('istPbeList : ' + istPbeList.size());  
            insert istPbeList;
            // Database.SaveResult[] pbeSaveResults = Database.insert(istPbeList, false);
            //TODO error handing

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
System.debug('Exception : ' + e);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,Constants.ERROR_MESSAGE));
            Database.rollback(sp);
        }
        return null;
    }

}