public class ErrorLogHelper {

    public static void createErrorLogs(string processName, string logDetails, Datetime errorTime, string apexClassName ){

        Error_Log__c err = new Error_Log__c();
        err.Process_Name__c = processName;
        err.Apex_Class_Name__c = apexClassName;
        err.Log_Details__c = logDetails;
        err.Log_Date_Time__c = errorTime;
        insert err;
    }
    
}