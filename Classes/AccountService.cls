public with sharing class AccountService {
    
    public static void updateChiffreAffaire(Set<Id> accountIds){
        
        List<Account> accounts = [SELECT Id, Name, Chiffre_d_affaire__c, (SELECT TotalAmount FROM Orders WHERE Status = 'Ordered') FROM Account WHERE Id IN :accountIds];
        
        for (Account a : accounts){
            
            a.Chiffre_d_affaire__c = 0;
            
            for(Order order : a.Orders){
                
                a.Chiffre_d_affaire__c += order.TotalAmount;
                
            }
        }
        System.debug('Comptes: ' + accounts);
        update accounts;    
    }
}