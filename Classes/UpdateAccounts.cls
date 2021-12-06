public class UpdateAccounts implements Database.Batchable<sObject>{
	//Schedulable (appel tout les nuit)
	public Set<Id> accountsToCheck = new Set<Id>();
    
	public Database.QueryLocator start(Database.BatchableContext info){ 
	    //Requeter seulement les comptes qui ont au moins une commande avec le Status 'Ordered'
    
	    if(accountsToCheck.size() > 0) return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered') AND Id IN :accountsToCheck]);
	    else return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
     
	}
	 
	public void execute(Database.BatchableContext info, List<Account> scope){
	    Map<Id, Account> mAccountToUpdate = new Map<Id, Account>();
    
	    List<Order> listOrders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :scope AND Status = 'Ordered'];
	    
	     for(Order o : listOrders){
		Account acc = mAccountToUpdate.get(o.AccountId);
    
		 if(acc == null){
		     acc = new Account( Id = o.AccountId, Chiffre_d_affaire__c = o.TotalAmount );
		 }else{
		     acc.Chiffre_d_affaire__c += o.TotalAmount;
		 }
    
		 mAccountToUpdate.put(o.AccountId, acc);
    
	     }
    
	     update mAccountToUpdate.values();
    
	}    
	 
	public void finish(Database.BatchableContext info){     
	    
	} 
     }