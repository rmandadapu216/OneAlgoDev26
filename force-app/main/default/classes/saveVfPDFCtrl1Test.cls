@IsTest
private class saveVfPDFCtrl1Test {
     
    static testMethod void testPdfAction1() {
        
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
 		
        //create contract materials for the purchase contract
        Contract_Material__c cm1 = new Contract_Material__c();
        cm1.Name = 'Test Material 1';
        cm1.Purchase_Contract__c = pc.Id;
        cm1.Unit_Price__c = 1000;
        cm1.Quantiy__c = 10;
        cm1.Unit_Of_Measurement__c = 'Each';
        insert cm1;
       
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.pdf'; // set a valid file path
        cv.VersionData = Blob.valueOf('Test Image Data');
        insert cv;
        
        // Associate the ContentVersion record with the Purchase_Contracts__c record to get its ContentDocumentId
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = pc.Id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        insert cdl;
        
        // Create a ContentDocumentLink record associated with the Purchase_Contracts__c record
        ContentDocumentLink[] existingCdl1 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId AND LinkedEntityId = :pc.Id];
        if (existingCdl1.size() == 0) {
            ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.LinkedEntityId = pc.Id;
            cdl1.ContentDocumentId = cdl.ContentDocumentId;
            insert cdl1;
        }
        
        Test.StartTest();
       	PageReference pageRef = Page.contractpdf2; // Add your VF page Name here
       	pageRef.getParameters().put('Id', String.valueOf(pc.Id));
       	System.Test.setCurrentPage(pageRef);
        
        //Instantiate the ImageController
     	ApexPages.StandardController sc = new ApexPages.StandardController(pc);
     	saveVfPDFCtrl1 ic = new saveVfPDFCtrl1(sc);
        ic.MstrId = pc.Id;
        // Verify that the imageURL property was set correctly
 //    	System.assertNotEquals(null, ic.imageURL); 
 
        // Call the pdfAction method and confirm that a PDF was created and linked to the record
        PageReference pdfPage = ic.pdfAction();
        Test.stopTest();

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocument.Title, ContentDocument.FileType, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :pc.Id];
        System.assertEquals(2, documentLinks.size(), 'Expected to find one document link');
        ContentDocumentLink documentLink = documentLinks[0];
        System.assertEquals('PDF', documentLink.ContentDocument.FileType, 'Expected document to be of type PDF');
        //System.assertNotNull(documentLink.ContentDocument.LatestPublishedVersionId, 'Expected document to have a published version ID');
    }
    
    static testMethod void testPdfAction2() {
        
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
 		
        //create contract materials for the purchase contract
        Contract_Material__c cm1 = new Contract_Material__c();
        cm1.Name = 'Test Material 1';
        cm1.Purchase_Contract__c = pc.Id;
        cm1.Unit_Price__c = 1000;
        cm1.Quantiy__c = 10;
        cm1.Unit_Of_Measurement__c = 'Each';
        insert cm1;

        Test.StartTest(); 
       	PageReference pageRef = Page.contractpdf2; // Add your VF page Name here
       	pageRef.getParameters().put('Id', String.valueOf(pc.Id));
       	System.Test.setCurrentPage(pageRef);
        
        //Instantiate the ImageController
     	ApexPages.StandardController sc = new ApexPages.StandardController(pc);
     	saveVfPDFCtrl1 ic = new saveVfPDFCtrl1(sc);
        ic.MstrId = pc.Id;
        // Verify that the imageURL property was set correctly
 		//System.assertNotEquals(null, ic.imageURL); 
        // Call the pdfAction method and confirm that a PDF was created and linked to the record
        PageReference pdfPage = ic.pdfAction();
        Test.stopTest();

        List<ContentDocumentLink> documentLinks = [SELECT ContentDocument.Title, ContentDocument.FileType, ContentDocument.LatestPublishedVersionId FROM ContentDocumentLink WHERE LinkedEntityId = :pc.Id];
        System.assertEquals(1, documentLinks.size(), 'Expected to find one document link');
        ContentDocumentLink documentLink = documentLinks[0];
        System.assertEquals('PDF', documentLink.ContentDocument.FileType, 'Expected document to be of type PDF');
        //System.assertNotNull(documentLink.ContentDocument.LatestPublishedVersionId, 'Expected document to have a published version ID');
    }
}