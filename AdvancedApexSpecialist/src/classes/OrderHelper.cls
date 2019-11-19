public class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap = new Map<Id, Product2>();

        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        List<OrderItem> orderItemList = [SELECT Id, Product2Id
                                        FROM OrderItem
                                        WHERE OrderId in :activatedOrderIds];

        //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
        Set<Id> proIds = new Set<Id>();
        for(OrderItem oi : orderItemList){
            proIds.add(oi.Product2Id);
        }      
        productMap = new Map<Id, Product2>([Select id, Name, Quantity_Ordered__c 
                                       From Product2
                                       Where id in :proIds]);
        for(Product2 prd: productMap.values()){
System.debug('Product2 Name : ' + prd.Name + ' Quantity_Ordered__c : ' + prd.Quantity_Ordered__c);
        }

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        AggregateResult[] groupedResults = [SELECT Product2Id, sum(Quantity) sumQuantity 
                                            From OrderItem
                                            WHERE Product2Id in :productMap.keySet()
                                            Group By Product2Id];

        for (AggregateResult ar : groupedResults) { 
            productMap.get((String) ar.get('Product2Id')).Quantity_Ordered__c += Integer.valueOf(ar.get('sumQuantity')); 
        } 

        for(Product2 prd: productMap.values()){
System.debug('Product2 Name : ' + prd.Name + ' Quantity_Ordered__c : ' + prd.Quantity_Ordered__c);
        }
        
        //ToDo: Perform an update on the records in the productMap
        if(productMap!=null && productMap.size()>0){ 
            update productMap.values(); 
        } 

    }
}