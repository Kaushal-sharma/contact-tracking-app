@isTest
public class ContactTriggerHandlerTest {

    @TestSetup
    public static void makeData() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test 1'));
        accounts.add(new Account(Name = 'Test 2'));

        insert accounts;

        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(LastName = 'Test Contact 1', AccountId = accounts[0].Id, Active__c = true));
        contacts.add(new Contact(LastName = 'Test Contact 2', AccountId = accounts[0].Id, Active__c = true));
        contacts.add(new Contact(LastName = 'Test Contact 3', AccountId = accounts[0].Id));
        contacts.add(new Contact(LastName = 'Test Contact 4', AccountId = accounts[0].Id));
        contacts.add(new Contact(LastName = 'Test Contact 5', AccountId = accounts[1].Id));

        insert contacts;
    }
    
    @isTest
    public static void afterInsertTest1() {
        
        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
       	System.debug(accList);
        List<Contact> contList = [SELECT Id, LastName, AccountId, Active__c FROM Contact];
        System.debug(contList);
        
        System.assertEquals(2, accList.size());
        for(Account ac : accList) {
            if(ac.Name == 'Test 1') {
                System.assertEquals(2, ac.Number_of_Active_Contact__c);
            }
            if(ac.Name == 'Test 2') {
                System.assertEquals(null, ac.Number_of_Active_Contact__c);
            }
        }
        
        System.assertEquals(5, contList.size());   
    }

    @isTest
    public static void afterInsertTestBulk() {
        Account acct = [SELECT Id FROM Account WHERE Name = 'Test 1'];
   
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 1000; i++) {
            contacts.add(new Contact(LastName = 'Test Contact ' + i, AccountId = acct.Id, Active__c = true));
        }
        insert contacts;

        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
        System.assertEquals(2, accList.size());
        
        for (Account acc : accList) {
            if (acc.Name == 'Test 1') {
                System.assertEquals(1002, acc.Number_of_Active_Contact__c);
            }
            if (acc.Name == 'Test 2') {
                System.assertEquals(null, acc.Number_of_Active_Contact__c);
            }
        }

        List<Contact> contList = [SELECT Id FROM Contact];
        System.assertEquals(1005, contList.size());
    }

    /* This test method failed but Why, Ask someone? */
    @isTest
    public static void afterUpdateTest1() {
		Account acct = [SELECT Id FROM Account WHERE Name = 'Test 2'];
        List<Contact> contList = [SELECT Id, LastName, AccountId, Active__c FROM Contact];
        for (Contact con : contList) {
            if (con.LastName == 'Test Contact 3' || con.LastName == 'Test Contact 4') {
                con.Active__c = true;
                con.AccountId = acct.Id;
            }
        }

        // allocate new set of governor limits
        Test.startTest();
        update contList;
        Test.stopTest();

        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
        System.assertEquals(2, accList.size());
        for (Account acc : accList) {
            if (acc.Name == 'Test 1') {
                System.assertEquals(4, acc.Number_of_Active_Contact__c);
            }
            if (acc.Name == 'Test 2') {
                System.assertEquals(null, acc.Number_of_Active_Contact__c);
            }
        }

        System.assertEquals(5, contList.size());
    }
	

    @isTest
    public static void afterUpdateTest2() {
        Account acct = [SELECT Id FROM Account WHERE Name = 'Test 2'];

        List<Contact> contList = [SELECT Id, LastName, AccountId, Active__c FROM Contact];
        for (Contact con : contList) {
            if (con.LastName == 'Test Contact 1') {
                con.Active__c = true;
                con.AccountId = acct.Id;
            }
        }

        // allocate new set of governor limits
        Test.startTest();
        update contList;
        Test.stopTest();

        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
        System.assertEquals(2, accList.size());
        for (Account acc : accList) {
            if (acc.Name == 'Test 1') {
                System.assertEquals(1, acc.Number_of_Active_Contact__c);
            }
            if (acc.Name == 'Test 2') {
                System.assertEquals(null, acc.Number_of_Active_Contact__c);
            }
        }

        System.assertEquals(5, contList.size());
    }

    @isTest
    public static void afterDeleteTest() {
        List<Contact> contList = [SELECT Id, LastName FROM Contact WHERE Name IN ('Test Contact 1', 'Test Contact 5')];

        Test.startTest();
        delete contList;
        Test.stopTest();

        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
        System.assertEquals(2, accList.size());
        for (Account acc : accList) {
            if (acc.Name == 'Test 1') {
                System.assertEquals(1, acc.Number_of_Active_Contact__c);
            }
            if (acc.Name == 'Test 2') {
                System.assertEquals(null, acc.Number_of_Active_Contact__c);
            }
        }

        contList = [SELECT Id, LastName, Active__c FROM Contact];
        System.assertEquals(2, accList.size());
    }

    @isTest
    public static void afterUnDeleteTest() {
        List<Contact> contactsToDelete = [SELECT Id, LastName FROM Contact WHERE Name IN ('Test Contact 1', 'Test Contact 5')];
        delete contactsToDelete;

        Test.startTest();
        undelete contactsToDelete;
        Test.stopTest();

        List<Account> accList = [SELECT Id, Name, Number_of_Active_Contact__c FROM Account];
        System.assertEquals(2, accList.size());
        for (Account acc : accList) {
            if (acc.Name == 'Test 1') {
                System.assertEquals(2, acc.Number_of_Active_Contact__c);
            }
            if (acc.Name == 'Test 2') {
                System.assertEquals(null, acc.Number_of_Active_Contact__c);
            }
        }

        List<Contact> contList = [SELECT Id, LastName FROM Contact];
        System.assertEquals(5, contList.size());
    }
}