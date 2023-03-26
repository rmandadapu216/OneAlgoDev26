@isTest
public class saveVfPDFCtrl2Amen_Test {
    
    static testMethod void test1() {
        
        // Create a test Account record
        Account acc = new Account();
        acc.Record_Type__c = 'Vendor';
        acc.name = 'Test Vendor';
        insert acc;
        
        Purchase_Contracts__c pur = new Purchase_Contracts__c();
        pur.Name = 'Test Purchase Contract';
        pur.Vendor_Name__c = acc.id;
        insert pur;

        // Test data setup
        Amendment__c accObj = new Amendment__c();
        accObj.Name = 'Test Amendment';
        accObj.Amendment_Type__c = 'Rate Change';
        accObj.Purchase_Contract__c = pur.Id;
        accObj.Name = 'Test Amendment';
        insert accObj;
            
        //create page reference
        PageReference pageRef = Page.Amendementpdf; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(accObj.Id));
        Test.setCurrentPage(pageRef);    
        
        // Test the constructor of the saveVfPDFCtrl2Amen class
        ApexPages.StandardController sc = new ApexPages.StandardController(accObj);
        saveVfPDFCtrl2Amen savePDF = new saveVfPDFCtrl2Amen(sc);
        
        // Test PDF generation and attachment
        Test.startTest();
        savePDF.pdfAction();
        Test.stopTest();
        
        System.assertEquals(accObj.Id, savePDF.MstrId);
        System.assertEquals(accObj.Id, savePDF.accObj.Id);
    }
    
    static testMethod void test2() {
        
        // Create a test Account record
        Account acc = new Account();
        acc.Record_Type__c = 'Vendor';
        acc.name = 'Test Vendor';
        insert acc;
        
        Purchase_Contracts__c pc = new Purchase_Contracts__c();
        pc.Name = 'Test Purchase Contract';
        pc.Vendor_Name__c = acc.id;
        insert pc;

        // Test data setup
        Amendment__c accObj = new Amendment__c();
        accObj.Name = 'Test Amendment';
        accObj.Amendment_Type__c = 'Rate Change';
        accObj.Purchase_Contract__c = pc.Id;
        accObj.Name = 'Test Amendment';
        insert accObj;
        
        //create ContentVersion record
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Image';
        cv.PathOnClient = 'test.pdf'; // set a valid file path
        cv.VersionData = Blob.valueOf('Test Image Data');
        insert cv;
        
        // Associate the ContentVersion record with the Purchase_Contracts__c record to get its ContentDocumentId
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = accObj.Id;
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        insert cdl;
        
        // Create a ContentDocumentLink record associated with the Purchase_Contracts__c record
        ContentDocumentLink[] existingCdl1 = [SELECT Id FROM ContentDocumentLink WHERE ContentDocumentId = :cdl.ContentDocumentId AND LinkedEntityId = :accObj.Id];
        if (existingCdl1.size() == 0) {
            ContentDocumentLink cdl1 = new ContentDocumentLink();
            cdl1.LinkedEntityId = accObj.Id;
            cdl1.ContentDocumentId = cdl.ContentDocumentId;
            insert cdl1;
        }
        
        //create page reference
        PageReference pageRef = Page.Amendementpdf; // Add your VF page Name here
        pageRef.getParameters().put('id', String.valueOf(accObj.Id));
        Test.setCurrentPage(pageRef);    
        
        // Test the constructor of the saveVfPDFCtrl2Amen class
        ApexPages.StandardController sc = new ApexPages.StandardController(accObj);
        saveVfPDFCtrl2Amen savePDF = new saveVfPDFCtrl2Amen(sc);
        
        // Test PDF generation and attachment
        Test.startTest();
        savePDF.pdfAction();
        Test.stopTest();
        
        System.assertEquals(accObj.Id, savePDF.MstrId);
        System.assertEquals(accObj.Id, savePDF.accObj.Id);
    }
}