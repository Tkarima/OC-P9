trigger UpdateAccountCATrigger on Order (after update) {

	System.debug('trigger lancé');
    if(Trigger.isAfter) {
        set<Id> setAccountIds = new set<Id>();

        for(Order newOrder : Trigger.new){
            setAccountIds.add(newOrder.AccountId);
        }
		System.debug(setAccountIds);
       AccountService.updateChiffreAffaire(setAccountIds);
        
    }

}
