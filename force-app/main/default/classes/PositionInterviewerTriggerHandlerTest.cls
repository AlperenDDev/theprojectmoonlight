@isTest
private class PositionInterviewerTriggerHandlerTest {
    @TestSetup
    static void prepareDate(){
       HR_Manager__c manager = new HR_Manager__c(name= 'Test Manager', Email__c = 'manager@gmail.com', Phone__c = '123654789');
        insert manager;

        Interviewer__c interviewer = new Interviewer__c(name= 'Test interviewer', Email__c = 'interviewer@gmail.com', Phone__c = '234567891');
        insert interviewer;
        
        Position__c position = new Position__c(HR_Manager__c = manager.Id, Name__c = 'Test position', Start_Date_Time__c = datetime.now().addDays(1));
        insert position;

        Position_Interviewer__c positionInterviewer = new Position_Interviewer__c(Interviewer__c = interviewer.Id, Position__c = position.Id);
        insert positionInterviewer;
    }
    @IsTest
    static void testPozitive() {
        Position_Interviewer__c systemRecord = [SELECT Interviewer__c, Position__c FROM Position_Interviewer__c LIMIT 1];
        Test.startTest();
        try{
        insert new Position_Interviewer__c(Interviewer__c = systemRecord.Interviewer__c, Position__c = systemRecord.Position__c);
        
        }catch(Exception exc){
        }
        Test.stopTest();
        Integer systemCount = [SELECT COUNT()FROM Position_Interviewer__c];
        Assert.areEqual(1, systemCount, 'Success');
        
    }

    @IsTest
    static void testNegative() {
        delete[SELECT Id FROM Position_Interviewer__c];

        Interviewer__c interviewer = [SELECT Id FROM Interviewer__c LIMIT 1];
        Position__c position = [SELECT Id FROM Position__c LIMIT 1];

        Test.startTest();
        insert new Position_Interviewer__c(Interviewer__c = interviewer.Id, Position__c = position.Id);
            
        Test.stopTest();
        Integer systemCount = [SELECT COUNT()FROM Position_Interviewer__c];
        Assert.areEqual(1, systemCount, 'Success');
        
        
    }
    

}