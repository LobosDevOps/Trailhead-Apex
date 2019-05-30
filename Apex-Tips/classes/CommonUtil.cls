public without sharing class CommonUtil {

    /**
    * Metadata Copy
    * 1. Metadataの選択
    * 2. Metadataの更新
    */
    public static void copyMetadataIndicatorBadgeToYinTest() {
        List<Indicator_Badge__mdt> Indicator_BadgeList = [SELECT QualifiedApiName, MasterLabel,
                                                Badge_Icon_Name__c,Badge_Color__c, 
                                                Comparison_Type__c, Comparison_Value__c, 
                                                Object__c, Related_Field__c
                                                FROM Indicator_Badge__mdt ];
        System.debug(Indicator_BadgeList.size());
        System.debug(Indicator_BadgeList);
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();

        for(Indicator_Badge__mdt indicator: Indicator_BadgeList){
            Map<String, Object> mdtMap = new Map<String, Object>();
            mdtMap .put('Badge_Icon_Name__c', indicator.Badge_Icon_Name__c);
            mdtMap .put('Badge_Color__c', indicator.Badge_Color__c);
            mdtMap .put('Comparison_Type__c', indicator.Comparison_Type__c);
            mdtMap .put('Comparison_Value__c', indicator.Comparison_Value__c);
            //mdtMap .put('Object__c', indicator.Object__c);
            //mdtMap .put('Related_Field__c', indicator.Related_Field__c);

            Metadata.CustomMetadata customMetadata = geCustomMetaData('Yin_Test', indicator.QualifiedApiName
                                                    , indicator.MasterLabel, mdtMap);
            System.debug(customMetadata);
            mdContainer.addMetadata(customMetadata );
        }
        System.debug(mdContainer);
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, new MyCallback());
        System.debug(jobId);
    }

    /**
    * Metadata fieldに値のセット
    */
    private static Metadata.CustomMetadata geCustomMetaData(String metaName,String develpName,String label,
        Map<String, Object> mdtMap){
    	Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
		customMetadata.fullName = metaName+'.'+develpName;
		customMetadata.label = label;
        
        for(String field: mdtMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = field;
            customField.value = mdtMap.get(field);
            customMetadata.values.add(customField);
        }
        
		return customMetadata;
    }

    /**
    * Metadata Callback
    */
    public class MyCallback implements Metadata.DeployCallback {
        public void handleResult(Metadata.DeployResult result,
                                Metadata.DeployCallbackContext context) {
            if (result.status == Metadata.DeployStatus.Succeeded) {
                System.debug(result);
            } else {
                System.debug(result);
            }
        }
    }    

    /**
    * カスタム設定の取得を更新
    */
    public static void UpdateCustomSet(Boolean activeFlag) {
        //カスタム設定
        TriggerActive__c trgSet = TriggerActive__c.getOrgDefaults();
        //項目の取得
        trgSet.Active__c = activeFlag;
        update trgSet;
    } 
}
