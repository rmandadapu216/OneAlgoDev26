@isTest
private class ImageControllerTest {
    static testMethod void testImageController() {
        
        // Create a test Account record
        Account acc = new Account();
        acc.Record_Type__c = 'Vendor';
        acc.name = 'Test Vendor';
        insert acc;
        
        // Create a test Purchase_contracts__c record
        Purchase_contracts__c pc = new Purchase_contracts__c();
        pc.Name = 'Test Contract';
        pc.Vendor_Name__c = acc.id;
        insert pc;

        // Create a test ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.jpg'; // set a valid file path
        cv.VersionData = Blob.valueOf('Test Image Data');
        insert cv;

        // Get the related ContentDocument record
       	List<ContentDocument> cd = [SELECT Id, Title FROM ContentDocument];
       
        // Create a test ContentDocumentLink record
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd[0].Id;
        cdl.LinkedEntityId = pc.Id;
        cdl.ShareType = 'V';
        insert cdl;
		
        Test.StartTest(); 
       	PageReference pageRef = Page.contractpdf; // Add your VF page Name here
       	pageRef.getParameters().put('Id', String.valueOf(pc.Id));
       	System.Test.setCurrentPage(pageRef);
        
        //Instantiate the ImageController
     	ApexPages.StandardController sc = new ApexPages.StandardController(pc);
     	ImageController ic = new ImageController(sc);

        // Verify that the imageURL property was set correctly
     	System.assertNotEquals(null, ic.imageURL); 
     	Test.StopTest();
    }
}