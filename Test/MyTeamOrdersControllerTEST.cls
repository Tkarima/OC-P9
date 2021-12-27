@istest
private class MyTeamOrdersControllerTEST {
    @istest static void MyTeamOrdersControllerTEST() {

        //create 10 User test
        List<User> listUser = new List<User>();
     
        for(Integer i=0; i<10; i++) {
            String uniqueName = 'fUserTest' + i;
            User tempUser = new User(FirstName = 'fUserTest' + i,
                                    LastName = 'lUserTest' + i,
                                    email = uniqueName + '@test' + i + '.org',
                                    Username = uniqueName + '@test' + i + '.org',
                                    EmailEncodingKey = 'ISO-8859-1',
                                    TimeZoneSidKey = 'America/Los_Angeles',
                                    LocaleSidKey = 'en_US',
                                    LanguageLocaleKey = 'en_US',
                                    Alias = uniqueName.abbreviate(8),
                                    ProfileId = '00e20000001iNcr'
                                    );
            listUser.add(tempUser);
        }

        insert listUser;

        //create team for each usertest
        List<Account> listAccount = new List<Account>();
        List<AccountTeamMember> listAccountTeamMember = new List<AccountTeamMember>();
        Integer j = 0;
        for(User u : listUser) {
            Account acc1 = new Account(Name = 'Test Account' + j);
            insert acc1;
            AccountTeamMember acctTM = new AccountTeamMember(AccountId = acc1.Id, userId = u.Id,TeamMemberRole = 'Sales Rep');
            listAccount.add(acc1);
            listAccountTeamMember.add(acctTM);
            j += 1;
            insert acctTM;
        }

        //create 1 Pruduct
        Product2 pd1 = new Product2(Name = 'Chemise Verte longue XYX', Family = 'Chemise');
        insert pd1;
 
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = System.Test.getStandardPricebookId(),
            Product2Id = pd1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        insert pbe;

        //creat contract
        date myDate = date.today();
        List<Contract> listContract = new List<Contract>();
        for(Account a : listAccount) {
            Contract ctt1 = new Contract(AccountId = a.Id, StartDate = myDate, ContractTerm = 1, Status='Draft');
            listContract.add(ctt1);
        }
        insert listContract;

        //ativated contracte and create orderItem and order for each contract
        Integer UnitPrice1 = 100;
        Integer UnitPrice2 = 1000;
        for(Contract c: listContract) {
            
            Contract ctt2 = new Contract(Id = c.Id, Status='Activated');
            update ctt2;

            Order o1 = new Order(AccountId = c.AccountId, ContractId = ctt2.Id,Status = 'Draft', EffectiveDate = date.today(), Pricebook2Id = System.Test.getStandardPricebookId(), ShipmentCost__c = 0);
            insert o1;
    
            OrderItem oi1 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=10, UnitPrice = UnitPrice1);
            insert oi1;
            OrderItem oi2 = new OrderItem (OrderId = o1.Id, PricebookEntryId = pbe.Id, Quantity=20, UnitPrice = UnitPrice2);
            insert oi2;

            UnitPrice1 += 100;
            UnitPrice2 += 1000;
        }

        //Test if SumOrder is good for each team
        Test.startTest();
        Decimal u = 0;
        for(User user : listUser) {
            System.runAs(user) {
                MyTeamOrdersController Mtoc = new MyTeamOrdersController();
                Decimal result = Mtoc.SumOders;
                System.assertEquals((10*100)+(20*1000)+(10*100)+(20*1000), result);
            }
            
        }
        Test.stopTest();
    }
}