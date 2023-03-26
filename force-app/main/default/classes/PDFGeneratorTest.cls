@isTest
private class PDFGeneratorTest {

    @isTest
    static void testGeneratePDF() {
        
        // Create a test Account record
        Account acc = new Account();
        acc.Record_Type__c = 'Vendor';
        acc.name = 'Test Vendor';
        insert acc;
        
		// Create a test Contract record
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
          
        Attachment attach=new Attachment();   	
    	attach.Name='YourPDFName.pdf';
    	Blob bodyBlob=Blob.valueOf('Testing Body of Attachment');
    	attach.body=bodyBlob;
        attach.parentId=pc.id;
      	insert attach;
         
       	List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :pc.Id];
        System.assertEquals(1, attachments.size());
                       
       	Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(pc);
        ImageController  imgc = new ImageController(sc);
        PageReference pageRef = Page.contractpdf;
        pageRef.getParameters().put('id', String.valueOf(pc.Id));
        Test.setCurrentPage(pageRef);
        pageRef.setRedirect(true);
        
        blob pdfBlob;
        if (!Test.isRunningTest()) {
			pdfBlob = pageRef.getContent(); //generate the pdf blob
		} else {
			pdfBlob = Blob.valueOf('Test');
		}  
        
       	PDFGenerator.generatePDF(pc.Id);
        Test.stopTest();

        // Verify that an Attachment record was created
        List<Attachment> attachments_1 = [SELECT Id FROM Attachment WHERE ParentId = :pc.Id];
        System.assertEquals(1, attachments_1.size()-1);
        //Attachment attachment = attachments_1[0];
		//Verify that the attachment contains the expected PDF file
        //System.assertNotEquals(null, attachment.Body);
       // System.assertEquals('YourPDFName.pdf', attachment.Name);  
    }
}