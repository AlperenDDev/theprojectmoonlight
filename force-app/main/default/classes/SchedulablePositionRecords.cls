public class SchedulablePositionRecords implements Database.Batchable<SObject>, Schedulable{
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new SchedulablePositionRecords());
    }

    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator([
            SELECT Id 
            FROM Position__c
            WHERE End_Date_Time__c <=: Datetime.now().addMonths(-2)
            AND Status__c = 'Completed'
        ]);
}
    public void execute(Database.BatchableContext bc, List<Position__c> positions){
        try {
            delete positions;
        } catch (Exception exc) {
            ErrorLogHelper.createErrorLogs('Delete ended positions', exc.getMessage() , Datetime.now(), 'execute');
        }   
    }

    public void finish(Database.BatchableContext bc){
        Set<Id> userIds = new Set<Id>();
        for(GroupMember pm :[SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = 'DailyJob']){
            userIds.add(pm.UserOrGroupId);
        }
    
    set<String> emailAddresses = new Set<String>();
    for(User us: [SELECT Email FROM User WHERE Id IN: userIds AND IsActive = true]){
        emailAddresses.add(us.Email);
    }

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setSubject('Positions are deleted');
    mail.setSenderDisplayName('SI Salesforce Robot ');
    mail.setPlainTextBody('Daily Purge Position Job Completed. You can check Setup --> Apex Jobs');
    mail.setHtmlBody('<p>Job is completed. You can check Setup --> Apex Jobs</p>');
    mail.setToAddresses(new List<String>(emailAddresses));

    try {
        Messaging.sendEmail(new list<Messaging.SingleEmailMessage> {mail});
    } catch (Exception e) {
        ErrorLogHelper.createErrorLogs('Delete ended positions', e.getMessage() , Datetime.now(), 'send email');
    }
    }
}