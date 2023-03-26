public class PDFGenerator {
   
    public static void generatePDF(Id recordId) {
        // generate the Visualforce page as a PDF
        PageReference pdf = Page.contractpdf;
        pdf.getParameters().put('id', recordId);
        pdf.setRedirect(true);
               
        blob pdfBlob;
        if (!Test.isRunningTest()) {
            pdfBlob = pdf.getContentAsPDF(); //generate the pdf blob
        } else { 
            pdfBlob = Blob.valueOf('Test');
        }

        // create a new attachment
        Attachment attachment = new Attachment();
        attachment.ParentId = recordId;
        attachment.Name = 'YourPDFName.pdf';
        attachment.Body = pdfBlob;

        // insert the attachment
        insert attachment;
    }
}