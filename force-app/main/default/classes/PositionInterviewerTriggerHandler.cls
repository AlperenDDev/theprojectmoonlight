public with sharing class PositionInterviewerTriggerHandler {
    public static void PositionInterviewerTriggerHandler(List <Position_Interviewer__c> ListPI) {

        Set<Id> interviewerIds = new Set<Id>();
        Set<Id> positionIds = new Set<Id>();
    
        // Collect Interviewer and Position IDs from the new records
        for (Position_Interviewer__c pi : ListPI) {
            interviewerIds.add(pi.Interviewer__c);
            positionIds.add(pi.Position__c);
        }
    
        // Query existing records to check for duplicates
        Map<Id, Id> existingRecordsMap = new Map<Id, Id>();
        for (Position_Interviewer__c existingRecord : [SELECT Id, Interviewer__c, Position__c FROM Position_Interviewer__c
                                                      WHERE Interviewer__c IN :interviewerIds
                                                      AND Position__c IN :positionIds
                                                      ]) {
            existingRecordsMap.put(existingRecord.Interviewer__c, existingRecord.Position__c);
        }
    
        // Check for duplicates and throw an error
        for (Position_Interviewer__c pi : ListPI) {
            if (existingRecordsMap.containsKey(pi.Interviewer__c) &&
                existingRecordsMap.get(pi.Interviewer__c) == pi.Position__c) {
                pi.addError('Interviewer is already assigned to another Position.');
            }
        }

    }
}