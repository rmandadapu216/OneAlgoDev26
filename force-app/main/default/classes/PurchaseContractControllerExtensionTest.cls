@isTest
private class PurchaseContractControllerExtensionTest {
    
    static testMethod void testPurchaseContractControllerExtension() {
        
        // Create a test Account record
        Account acc = new Account();
        acc.Record_Type__c = 'Vendor';
        acc.name = 'Test Vendor';
        insert acc;
        
        // Create test Purchase Contract and Contract Material records
        Purchase_Contracts__c pc = new Purchase_Contracts__c();
        pc.Name = 'Test Purchase Contract';
        pc.Vendor_Name__c = acc.id;
        insert pc;
        
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
        
        // Create test Amendment record related to the Purchase Contract record created above
        Amendment__c a = new Amendment__c();
        a.Name = 'Test Amendment';
        a.Purchase_Contract__c = pc.Id;
        a.Amendment_Type__c='Rate Change';
        insert a;
        
        // Initialize a new Standard Controller with the test Amendment record
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        
        // Initialize the PurchaseContractControllerExtension with the Standard Controller
        PurchaseContractControllerExtension ext = new PurchaseContractControllerExtension(sc);
        
        // Check that the amendment record is set correctly
        System.assertEquals(a.Id, ext.amendment.Id);
        
        // Check that the contractMaterials list is set correctly
        System.assertEquals(2, ext.contractMaterials.size());
        System.assertEquals(cm1.Id, ext.contractMaterials[0].Id);
        System.assertEquals(cm2.Id, ext.contractMaterials[1].Id);
    }
}