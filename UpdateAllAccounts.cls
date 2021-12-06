global class UpdateAllAccounts implements Schedulable { 
    set<Id> setAccountIds = new set<Id>();
    public static String sch = '0 0 6 ? * MON';//Tous les Lundi à 6h00

    global static String scheduleMe() {
        UpdateAllAccounts SC = new UpdateAllAccounts();
        return System.schedule('UpdateAllAccounts', sch, SC);
    }

    global void execute(SchedulableContext sc) {
        UpdateAccounts ba = new UpdateAccounts();
        ba.accountsToCheck = setAccountIds;
        Database.executeBatch(ba, 100);
    }
 }