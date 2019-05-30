public with sharing class WarehouseCalloutService {
    //https://github.com/Konstryktor/Superbadge-Apex-Specialist/tree/master/classes
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future (callout = true)
    public static void runWarehouseEquipmentSync(){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        if(response.getStatusCode() == 200){
            updateEquipment( (List<Object>) JSON.deserializeUntyped(response.getBody()));
        }else{
            System.debug('response err: ' + response.getStatusCode());
        }
    }

    private static void updateEquipment(List<Object> results){
        System.debug('results:'+ results);
        List<Product2> equipmentlist = new List<Product2>();
        for(Object resultObject : results){
            Map<String, Object> itemMap = (Map<String, Object>)resultObject;
            Product2 quipment = new Product2();
            //"_id":"55d66226726b611100aaf740",
            quipment.Replacement_Part__c = (Boolean)itemMap.get('replacement');   //"replacement":true,
            quipment.Current_Inventory__c = (Integer)itemMap.get('quantity');   //"quantity":194,
            quipment.Name = (String)itemMap.get('name');   //"name":"Fuse 8A",
            quipment.Maintenance_Cycle__c = (Integer)itemMap.get('maintenanceperiod');   //"maintenanceperiod":0,
            quipment.Lifespan_Months__c = (Integer)itemMap.get('lifespan');   //"lifespan":0,
            quipment.Cost__c = (Integer)itemMap.get('cost');   //"cost":5,
            quipment.Warehouse_SKU__c = (String)itemMap.get('sku');   //"sku":"100002"
            equipmentlist.add(quipment);
        }

        System.debug('equipmentlist size:'+ equipmentlist.size());
        System.debug('equipmentlist:'+ equipmentlist);
        upsert equipmentlist Warehouse_SKU__c;
        //insert equipmentlist;
    }
}