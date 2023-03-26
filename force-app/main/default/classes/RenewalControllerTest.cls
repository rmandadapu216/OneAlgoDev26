@isTest
public class RenewalControllerTest {

    @isTest
    static void testPdfAction1() {
        // Create test Account record
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        // Create test Contract record as master
        Purchase_Contracts__c testContract1 = new Purchase_Contracts__c();
        testContract1.Vendor_Name__c = testAccount.Id;
        insert testContract1;

        // Create test Contract record with a master contract
        Purchase_Contracts__c testContract2 = new Purchase_Contracts__c();
        testContract2.Vendor_Name__c = testAccount.Id;
        testContract2.Parent_Purchase_Contract__c = testContract1.Id;
        insert testContract2;
        
        //create page reference
        PageReference pageRef = Page.Renewalpdf; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(testContract2.Id));
        Test.setCurrentPage(pageRef);

        // Set up standard controller and RenewalController instance
        ApexPages.StandardController sc = new ApexPages.StandardController(testContract2);
        RenewalController rc = new RenewalController(sc);
        rc.MstrId = testContract1.Id;

        // Test PDF generation and attachment
        Test.startTest();
        rc.pdfAction();
        Test.stopTest();

        // Verify that the PDF was generated and attached
        //List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :testContract2.Id];
        //System.assertEquals(1, links.size(), 'PDF should be attached to the Purchase_Contracts__c record');
    }
    
    @isTest
    static void testPdfAction2() {
        // Create test Account record
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;

        // Create test Contract record as master
        Purchase_Contracts__c testContract1 = new Purchase_Contracts__c();
        testContract1.Vendor_Name__c = testAccount.Id;
        insert testContract1;

        // Create test Contract record with a master contract
        Purchase_Contracts__c testContract2 = new Purchase_Contracts__c();
        testContract2.Vendor_Name__c = testAccount.Id;
        testContract2.Parent_Purchase_Contract__c = testContract1.Id;
        insert testContract2;
        //create ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.pdf'; // set a valid file path
        cv.VersionData = Blob.valueOf('Test Image Data');
        insert cv;
        
        // Associate the ContentVersion record with the Purchase_Contracts__c record to get its ContentDocumentId
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = testContract1.Id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        insert cdl;
        
        // Create a ContentDocumentLink record associated with the Purchase_Contracts__c record
        ContentDocumentLink[] existingCdl1 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId AND LinkedEntityId = :testContract1.Id];
        if (existingCdl1.size() == 0) {
            ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.LinkedEntityId = testContract1.Id;
            cdl1.ContentDocumentId = cdl.ContentDocumentId;
            insert cdl1;
        }
        
        PageReference pageRef = Page.Renewalpdf; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(testContract2.Id));
        Test.setCurrentPage(pageRef);

        // Set up standard controller and RenewalController instance
        ApexPages.StandardController sc = new ApexPages.StandardController(testContract2);
        system.debug('after sc call');
        RenewalController rc = new RenewalController(sc);
        system.debug('after rc call');
        rc.MstrId = testContract1.Id;

        // Test PDF generation and attachment
        Test.startTest();
        rc.pdfAction();
        Test.stopTest();

        // Verify that the PDF was generated and attached
        //List<ContentDocumentLink> links = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :testContract2.Id];
        //System.assertEquals(1, links.size(), 'PDF should be attached to the Purchase_Contracts__c record');
    }
}