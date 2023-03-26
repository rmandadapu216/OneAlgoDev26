@istest
public class Testclass_for_Amendment_comments {

    static testmethod void amendmentwithoutcommentsmethod1(){
        //create a record 
     
        account ac=new account ();
        ac.Name='amnd Test Method 1';
        ac.Vendor_Status2__c='Active';
         insert ac;
        
        Purchase_Contracts__c pcs = new Purchase_Contracts__c();
                pcs.name = 'ContractTest1';
                pcs.Vendor_Name__c = ac.id;
                pcs.Stages__c = 'Initiation';
                pcs.Contract_type__c='Software';
                pcs.Contract_Term__c = 5;
                pcs.Approval_Date__c=system.today();
                pcs.Execution_Date__c=system.today()+5;
                pcs.Signature__c=true;
                insert pcs;
        
        Contract_Material__c  cm1=new Contract_Material__c ();
        cm1.Purchase_Contract__c=pcs.ID;
        cm1.Name='Contractmat1';
        cm1.Quantiy__c=20;
        cm1.Unit_Price__c=100;
        cm1.Unit_Of_Measurement__c='Each';
        insert cm1;
        
        pcs.Stages__c='Negotiation';
        update pcs;
        pcs.Delivery_Schedule__c='Weekly';
        pcs.Stages__c='Generation';
        update pcs;
      pcs.Stages__c='Pending Approval';
        user usr1 =[select id from user where alias='Nr'];
        
         // Create an approval request for the account
      approval.ProcessSubmitRequest appsub =new approval.ProcessSubmitRequest();
        appsub.setComments('Submitting request for approval');
        appsub.setObjectId(pcs.Id);
        
         // Submit on behalf of a specific submitter
         appsub.setSubmitterId(usr1.Id);
        
         // Submit the record to specific process and skip the criteria evaluation
         appsub.setProcessDefinitionNameOrId('Approval_for_Purchase_Contract4');
        appsub.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        approval.ProcessResult result =approval.Process(appsub);
        
          // Verify the result
         system.Assert(result.isSuccess());
        system.assertEquals('Pending',result.getInstanceStatus(),'Instance Status'+result.getInstanceStatus());
     
        // Approve the submitted request
        // First, get the ID of the newly created item

        Approval.ProcessWorkItemRequest req1;
         	List<Id> newWorkItemIds = result.getNewWorkItemIds(); 
         for(integer i=0;i<4; i++){
             //Approve the submitted request.  
             //First, get the ID of the newly created item
              newWorkItemIds = result.getNewWorkItemIds();    	
             //Instantiate the new ProcessWorkItemRequest object and populate it
             req1 = new Approval.ProcessWorkItemRequest();
             req1.setComments('Approving request.');
             req1.setAction('Approve');
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
             //Use the ID from the newly created item to specify the item to be worked
             req1.setWorkItemId(newWorkItemIds.get(0));
             result = Approval.process(req1);
            
         }
        
              System.assert(result.isSuccess(), 'Result Status:'+result.isSuccess());
        
        System.assertEquals(
            'Approved', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
         pcs =[select id, name ,Stages__c from Purchase_Contracts__c where name='ContractTest1' ];
        system.debug('Latest stage = ' + pcs.stages__c);
       pcs.Stages__c = 'Execution';
     update pcs;
     system.debug(pcs.Stages__c);
        Amendment__c amd =new Amendment__c ();
        amd.Amendment_Type__c='Rate Change';
        amd.Name='Purchase Contract1 Amendment1';
        amd.Purchase_Contract__c=pcs.Id;
        insert amd;
        amd.Stage__c = 'Pending Approval';
        
        List<User> User = [select Id from User where IsActive = True limit 1];
     
        User = [select Id from User where IsActive = True limit 1];
     
     //Create an approval request for the change
     Approval.ProcessSubmitRequest req10 = new Approval.ProcessSubmitRequest();
     req10.setComments('Submitting request for approval.');
     req10.setObjectId(amd.Id);
     req10.setNextApproverIds(new Id[] {UserInfo.getUserId()});
     
     //Submit the approval request for the change
     result = Approval.process(req10);
     
     //Verify the result
     System.assert(result.isSuccess());
     
     System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
     system.debug(amd.Stage__c);	
     amd = [select id, Stage__c from Amendment__c where name = 'Purchase Contract1 Amendment1'];
     system.debug('Amend Pending Approval stage - ' + amd.Stage__c);
     
    Approval.ProcessWorkItemRequest req11;
     
     for(integer i=0;i<1; i++){
         //Approve the submitted request.  
         //First, get the ID of the newly created item
         List<Id> newWorkItemIds1 = result.getNewWorkItemIds();    	
         //Instantiate the new ProcessWorkItemRequest object and populate it
         req11 = new Approval.ProcessWorkItemRequest();
         req11.setComments(null);
         req11.setAction('Reject');
         req11.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
         //Use the ID from the newly created item to specify the item to be worked
         req11.setWorkItemId(newWorkItemIds1.get(0));
         result = Approval.process(req11);
         
     }
 //    amd = [select id, Stage__c from Amendment__c where name = 'Purchase Contract1 Amendment1'];
 //    system.debug('Amend Approval stage - ' + amd.Stage__c);
      amd = [select id, Signature__c,Reason_for_rejection__c  from Amendment__c where name = 'Purchase Contract1 Amendment1'];
     system.debug('Amend Approval stage - ' + amd.Signature__c);
	test.startTest();
        database.SaveResult result1 = database.update(amd,false);
         system.assertEquals('Please mention comments for Rejection',result1.getErrors()[0].getmessage());
    }
    static testmethod void amendmentwithcommentsmethod2(){
        //create a record 
     
        account ac=new account ();
        ac.Name='amnd Test Method 2';
        ac.Vendor_Status2__c='Active';
         insert ac;
        
        Purchase_Contracts__c pcs = new Purchase_Contracts__c();
                pcs.name = 'ContractTest2';
                pcs.Vendor_Name__c = ac.id;
                pcs.Stages__c = 'Initiation';
                pcs.Contract_type__c='Software';
                pcs.Contract_Term__c = 5;
                pcs.Approval_Date__c=system.today();
                pcs.Execution_Date__c=system.today()+5;
                pcs.Signature__c=true;
                insert pcs;
        
        Contract_Material__c  cm1=new Contract_Material__c ();
        cm1.Purchase_Contract__c=pcs.ID;
        cm1.Name='Contractmat2';
        cm1.Quantiy__c=20;
        cm1.Unit_Price__c=100;
        cm1.Unit_Of_Measurement__c='Each';
        insert cm1;
        
        pcs.Stages__c='Negotiation';
        update pcs;
        pcs.Delivery_Schedule__c='Weekly';
        pcs.Stages__c='Generation';
        update pcs;
      pcs.Stages__c='Pending Approval';
        user usr1 =[select id from user where alias='Nr'];
        
         // Create an approval request for the account
      approval.ProcessSubmitRequest appsub =new approval.ProcessSubmitRequest();
        appsub.setComments('Submitting request for approval');
        appsub.setObjectId(pcs.Id);
        
         // Submit on behalf of a specific submitter
         appsub.setSubmitterId(usr1.Id);
        
         // Submit the record to specific process and skip the criteria evaluation
         appsub.setProcessDefinitionNameOrId('Approval_for_Purchase_Contract4');
        appsub.setSkipEntryCriteria(true);
        
        // Submit the approval request for the account
        approval.ProcessResult result =approval.Process(appsub);
        
          // Verify the result
         system.Assert(result.isSuccess());
        system.assertEquals('Pending',result.getInstanceStatus(),'Instance Status'+result.getInstanceStatus());
     
        // Approve the submitted request
        // First, get the ID of the newly created item

        Approval.ProcessWorkItemRequest req1;
         	List<Id> newWorkItemIds = result.getNewWorkItemIds(); 
         for(integer i=0;i<4; i++){
             //Approve the submitted request.  
             //First, get the ID of the newly created item
              newWorkItemIds = result.getNewWorkItemIds();    	
             //Instantiate the new ProcessWorkItemRequest object and populate it
             req1 = new Approval.ProcessWorkItemRequest();
             req1.setComments('Approving request.');
             req1.setAction('Approve');
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
             //Use the ID from the newly created item to specify the item to be worked
             req1.setWorkItemId(newWorkItemIds.get(0));
             result = Approval.process(req1);
            
         }
        
              System.assert(result.isSuccess(), 'Result Status:'+result.isSuccess());
        
        System.assertEquals(
            'Approved', result.getInstanceStatus(), 
            'Instance Status'+result.getInstanceStatus());
         pcs =[select id, name ,Stages__c from Purchase_Contracts__c where name='ContractTest2' ];
        system.debug('Latest stage = ' + pcs.stages__c);
       pcs.Stages__c = 'Execution';
     update pcs;
     system.debug(pcs.Stages__c);
        Amendment__c amd =new Amendment__c ();
        amd.Amendment_Type__c='Rate Change';
        amd.Name='Purchase Contract1 Amendment2';
        amd.Purchase_Contract__c=pcs.Id;
        insert amd;
        amd.Stage__c = 'Pending Approval';
        
        List<User> User = [select Id from User where IsActive = True limit 1];
     
        User = [select Id from User where IsActive = True limit 1];
     
     //Create an approval request for the change
     Approval.ProcessSubmitRequest req10 = new Approval.ProcessSubmitRequest();
     req10.setComments('Submitting request for approval.');
     req10.setObjectId(amd.Id);
     req10.setNextApproverIds(new Id[] {UserInfo.getUserId()});
     
     //Submit the approval request for the change
     result = Approval.process(req10);
     
     //Verify the result
     System.assert(result.isSuccess());
     
     System.assertEquals('Pending', result.getInstanceStatus(), 'Instance Status'+result.getInstanceStatus());
     system.debug(amd.Stage__c);	
     amd = [select id, Stage__c from Amendment__c where name = 'Purchase Contract1 Amendment2'];
     system.debug('Amend Pending Approval stage - ' + amd.Stage__c);
     
    Approval.ProcessWorkItemRequest req11;
     
     for(integer i=0;i<1; i++){
         //Approve the submitted request.  
         //First, get the ID of the newly created item
         List<Id> newWorkItemIds1 = result.getNewWorkItemIds();    	
         //Instantiate the new ProcessWorkItemRequest object and populate it
         req11 = new Approval.ProcessWorkItemRequest();
         req11.setComments('Rejected');
         req11.setAction('Reject');
         req11.setNextApproverIds(new Id[] {UserInfo.getUserId()});    	
         //Use the ID from the newly created item to specify the item to be worked
         req11.setWorkItemId(newWorkItemIds1.get(0));
         result = Approval.process(req11);
         
     }
 //    amd = [select id, Stage__c from Amendment__c where name = 'Purchase Contract1 Amendment2'];
 //    system.debug('Amend Approval stage - ' + amd.Stage__c);
      amd = [select id, Signature__c,Reason_for_rejection__c  from Amendment__c where name = 'Purchase Contract1 Amendment2'];
     system.debug('Amend Approval stage - ' + amd.Signature__c);
	test.startTest();
        database.SaveResult result1 = database.update(amd,false);
        test.stopTest();
        amd.Reason_for_rejection__c=req11.getComments();
        system.debug(amd.Reason_for_rejection__c);
         system.assertEquals('Rejected',amd.Reason_for_rejection__c);
    }
}