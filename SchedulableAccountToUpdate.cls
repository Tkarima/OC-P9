global class SchedulableAccountToUpdate implements Schedulable { 
    set<Id> setAccountIds = new set<Id>();
    public static String sch = '0 0 1 ? * SUN';//Tout les dimanche à 1h00

    global static String scheduleMe() {
        SchedulableAccountToUpdate SC = new SchedulableAccountToUpdate();
        return System.schedule('SchedulableAccountToUpdate', sch, SC);
   }

    global void execute(SchedulableContext sc) {
        batchUpdateAccounts ba = new batchUpdateAccounts();
        ba.accountsToCheck = setAccountIds;
        Database.executeBatch(ba, 20);
    }
 }