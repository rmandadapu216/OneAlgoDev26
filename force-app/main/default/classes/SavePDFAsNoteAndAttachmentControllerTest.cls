@isTest
private class SavePDFAsNoteAndAttachmentControllerTest {

    @isTest
    static void testSavePDF() {
        // Create a test Account record
        Account acct = new Account(Name = 'Test Account');
        insert acct;

        // Create a test Contract record
        Purchase_Contracts__c contract = new Purchase_Contracts__c();
        contract.Name = 'Test Contract';
        contract.Vendor_Name__c = acct.Id;
        insert contract;

        // Set up mock HTTP response with PDF file
        Test.setMock(HttpCalloutMock.class, new ContractPdfMock());

        // Create a new page reference with the contract ID parameter
        PageReference pageRef = Page.contractpdf;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', contract.Id);

        // Create a new standard controller with the test Contract record
        ApexPages.StandardController stdController = new ApexPages.StandardController(contract);

        // Create a new instance of the SavePDFAsNoteAndAttachmentController class
        SavePDFAsNoteAndAttachmentController controller = new SavePDFAsNoteAndAttachmentController(stdController);

        // Call the savePDF method
        Test.startTest();
        controller.savePDF();
		Test.stopTest();
        // Verify that an attachment and note were created
        List<Attachment> attachments = [SELECT Id FROM Attachment WHERE ParentId = :contract.Id];
        System.assertEquals(1, attachments.size(), 'An attachment should be created');
        List<Note> notes = [SELECT Id FROM Note WHERE ParentId = :contract.Id];
        System.assertEquals(1, notes.size(), 'A note should be created');
    }
    // Mock HTTP response class
    private class ContractPdfMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBodyAsBlob(Blob.valueOf('PDF content goes here'));
            res.setStatusCode(200);
            return res;
        }
    }
}