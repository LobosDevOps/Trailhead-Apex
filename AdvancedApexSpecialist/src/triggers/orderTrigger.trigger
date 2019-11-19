/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (
    before insert, after insert
    ,before update, after update
    ,before delete, after delete
    ,after undelete
) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            OrderHelper.AfterUpdate(Trigger.New , Trigger.Old);
        }
    }
}