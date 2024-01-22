@IsTest
private class SchedulablePositionRecordsTest {
    @IsTest
    static void tester(){
    HR_Manager__c manager = new HR_Manager__c(name='Test HRR Manager', Email__c='manager@gmail.com', Phone__c='12345325');
    
    insert manager;
    
    List<Position__c> poslist = new List<Position__c>();
   
    for (integer i = 1; i < 199; i++){
        Position__c pos1 = new Position__c(HR_Manager__c = manager.Id, Name__c='Test Position 1' , Status__c='Completed', End_Date_Time__c= DateTime.now().addMonths(-3), Start_Date_Time__c=DateTime.now().addMonths(-7));

        poslist.add(pos1);
    }
    

    Position__c pos2 = new Position__c(HR_Manager__c = manager.Id, Name__c='Test Position 2', Status__c='Canceled', End_Date_Time__c= DateTime.now().addDays(20), Start_Date_Time__c=DateTime.now().addmonths(-5));

    poslist.add(pos2);

    insert poslist;

    Test.startTest();

    SchedulablePositionRecords obj = new SchedulablePositionRecords();
    obj.execute(null);

    Test.stopTest();

    Integer poscount =[SELECT COUNT() FROM Position__c];
        System.assertEquals(1, poscount);
   }
}