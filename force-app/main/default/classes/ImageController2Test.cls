@isTest
public class ImageController2Test {

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
 		
        //create contract materials for the purchase contract
        Contract_Material__c cm1 = new Contract_Material__c();
        cm1.Name = 'Test Material 1';
        cm1.Purchase_Contract__c = pc.Id;
        cm1.Unit_Price__c = 1000;
        cm1.Quantiy__c = 10;
        cm1.Unit_Of_Measurement__c = 'Each';
        insert cm1;
        
        Contract_Material__c cm2 = new Contract_Material__c();
        cm2.Name = 'Test Material 2';
        cm2.Purchase_Contract__c = pc.Id;
        cm2.Unit_Price__c = 1000;
        cm2.Quantiy__c = 10;
        cm2.Unit_Of_Measurement__c = 'Each';
        insert cm2;
        
		//create new Amendment for the Purchase Contract
		Amendment__c amd = new Amendment__c();
        amd.Name = 'Test Amendment';
        amd.Amendment_Type__c='Rate Change'; 
        amd.Purchase_Contract__c=pc.Id;
        insert amd;
            
        // Create a test ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.jpg'; // set a valid file path
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
 	    PageReference pageRef2 = Page.Amendementpdf; // Add your VF page Name here
        pageRef2.getParameters().put('Id', String.valueOf(amd.Id));
        System.Test.setCurrentPage(pageRef2);
        
        // Initialize a new Standard Controller
        ApexPages.StandardController sc = new ApexPages.StandardController(amd);
     
        // Initialize the PurchaseContractControllerExtension
        PurchaseContractControllerExtension ext = new PurchaseContractControllerExtension(sc);
    
        // Check that the amendment record is set correctly
        System.assertEquals(amd.Id, ext.amendment.Id);
        
        //run the ImageController2 class 
		ImageController2  obj2 = new ImageController2(sc);
		Test.StopTest();
    }
}