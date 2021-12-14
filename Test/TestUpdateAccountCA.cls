@isTest
private class testUpdateAccountCA {
    @isTest static void test() {
        //create Account
        Account acc1 = new Account(Name = 'Test Account 1');
        insert acc1;
		//create product
        Product2 pd1 = new Product2(Name = 'D', Family = 'Chemise');
        Insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
            
        );
        Insert pbe;
        

        Order o1 = new Order(AccountId = acc1.Id,EffectiveDate = Date.today(),
            Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId());
        insert o1;

        OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = 150);
        insert oi1;
        OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = 1000);
        insert oi2;        
        
        o1.Status = 'Ordered'; 
        update o1;

        //Retrieve the Order and the Account
        o1 = [SELECT Name, TotalAmount, Status FROM Order WHERE Id =:o1.Id LIMIT 1];
        acc1 = [SELECT Name, Chiffre_d_affaire__c FROM Account WHERE Id =:acc1.Id LIMIT 1];
        
        // Test that the trigger correctly updated the CA of the Account
        System.debug('CA du compte: ' + acc1.Chiffre_d_affaire__c);
        System.assertEquals(10*150 + 20*1000, acc1.Chiffre_d_affaire__c, 'CA du compte incorrect');
    }
    
}