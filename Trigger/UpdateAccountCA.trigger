trigger UpdateAccountCATrigger on Order (after update) {


    if(Trigger.isAfter) {
        set<Id> setAccountIds = new set<Id>();

        for(Order newOrder : Trigger.new){
            setAccountIds.add(newOrder.AccountId);
        }

        UpdateAccounts acc = new UpdateAccounts();
        acc.accountsToCheck = setAccountIds;

        Database.executeBatch(acc, 100);
    }

}