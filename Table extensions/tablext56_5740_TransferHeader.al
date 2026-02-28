/*
TAL 0.1 29/1/18

*/

tableextension 50156 TransferHeaderExt extends "Transfer Header"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Salesperson Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'TAL ANP';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate();
            var
                vl_salesperson: Record "Salesperson/Purchaser";
            begin
                //TAL 0.1 ANP
                IF vl_salesperson.GET("Salesperson Code") THEN BEGIN
                    "Salesperson Name" := vl_salesperson.Name;
                END
                ELSE
                    "Salesperson Name" := '';
                BEGIN
                END;
                //TAL 0.1 ANP
            end;
        }
        field(50001; "Salesperson Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'TAL ANP';
        }
        field(50002; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50003; "Shipment/Delivery Time"; Time)
        {
            DataClassification = ToBeClassified;
        }

    }

    procedure PrintTransferOrder(SendAsEmail: Boolean)
    var
        ReportSelections: Record "Report Selections";
        TransferHeader: Record "Transfer Header";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Location: Record Location;
        LocationTo: Record Location;
        vBody: Text;
        AttachementTempBlob: Codeunit "Temp Blob";
        AttachementInstream: InStream;
        AttachementOutStream: OutStream;
        recRef: RecordRef;
        //TAL 1.0.0.95 >>
        ToRecipient: List of [Text];
        CCRecipient: List of [Text];
        BCCRecipient: List of [Text];
    //TAL 1.0.0.95 <<
    begin
        Location.Get("Transfer-from Code");
        LocationTo.Get("Transfer-to Code");

        TestField("Shipment/Delivery Time");

        vBody := 'Dear Colleague,<br><br> Please send the attached Items to ' + LocationTo."Name 2" + '. Shipment/Delivery Date time: <b>' + Format("Shipment Date") + ' ' + FORMAT("Shipment/Delivery Time", 0, '<Hours24,2>:<Minutes,2>') + '</b></br></br> Regards, ' + LocationTo.Contact;

        // EmailMessage.Create(Location."E-Mail", 'Transfer To ' + "Transfer-to Code" + ' ' + "No.", vBody, true);//before
        //TAL 1.0.0.95 >>
        ToRecipient.Add(Location."E-Mail");
        CCRecipient.Add(Location."Email CC");
        CCRecipient.Add(LocationTo."Email CC");
        EmailMessage.Create(ToRecipient, 'Transfer To ' + LocationTo."Name 2" + ' ' + "No.", vBody, true, CCRecipient, BCCRecipient);
        //TAL 1.0.0.95 <<

        TransferHeader.RESET;
        TransferHeader.SetFilter("No.", "No.");
        if TransferHeader.FindSet() then;

        recRef.GetTable(TransferHeader);
        recRef.SetView(TransferHeader.GetView());


        AttachementTempBlob.CreateOutStream(AttachementOutStream);

        /*
        Clear(rpt_50048);
        rpt_50048.UseRequestPage(false);
        rpt_50048.SkipDefaultFilters();
        rpt_50048.SetTableView(TransferHeader);
        rpt_50048.SaveAs('', REPORTFORMAT::Pdf, AttachementOutStream, recRef);
        */

        ReportSelections.RESET;
        ReportSelections.SetRange(Usage, ReportSelections.Usage::Inv1);
        if ReportSelections.FindSet() then begin
            Report.SaveAs(ReportSelections."Report ID", '', REPORTFORMAT::Pdf, AttachementOutStream, recRef);
        END;


        AttachementTempBlob.CreateInStream(AttachementInstream);

        EmailMessage.AddAttachment('TransferOrder' + FORMAT(TransferHeader."No.") + '.pdf', 'PDF', AttachementInstream);

        //if SendAsEmail then begin
        //    Email.Send(EmailMessage);
        //end else begin
        Email.OpenInEditor(EmailMessage);
        //end;


    end;

    var
        myInt: Integer;
}