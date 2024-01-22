trigger PositionInterviewerTrigger on Position_Interviewer__c (before insert, before update, after insert, after update) {

    if (trigger.isBefore && trigger.isUpdate || trigger.isBefore && trigger.isInsert) {

        PositionInterviewerTriggerHandler.PositionInterviewerTriggerHandler(Trigger.new);
        
    }
    
}