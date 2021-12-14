//Cette classe comporte la syntaxe Apex par lot
 // Cette méthode comporte trois parties "Start" , "execute" et "finish"

public class BatchUpdateAccounts implements Database.Batchable<sObject>{
    
    public Set<Id> accountsToCheck = new Set<Id>();

    // START
    public Database.QueryLocator start(Database.BatchableContext info){ 
       

       
        //Comptes avec au moins une commande (Order) dont le status est 'Ordered'
        //Database.getQeryLocator est utilisé pour renvoyer un localisateur de requêtes qui exécute notre liste de renvois de requêtes SOQL
        if(accountsToCheck.size() > 0) return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered') AND Id IN :accountsToCheck]);
        else return Database.getQueryLocator([SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = 'Ordered')]);
 
    }
     //EXECUTE
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
     //FINISH
    public void finish(Database.BatchableContext info){     
        if(!Test.isRunningTest())
            Database.executeBatch(new batchUpdateAccounts());
        }
}