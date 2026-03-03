
/*
TAL0.1 2019/01/03 VC add Deliver to vendor fields 
TAL0.2 2021/04/06 VC add PrintAppendixRecords
TAL0.3 2021/10/26 VC add fields 
                      QC Validate COC-GGN Certficate
                      QC Visual Check
                      QC Comments
                      add function SetQCComments, GetQCComments   
*/

tableextension 50123 PurchRcptHeaderExt extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here
        field(50003; "Deliver-to Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(50004; "Deliver-to Name"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate();
            var
                Vendor: Record Vendor;
            begin
            end;
        }
        field(50005; "Deliver Address Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Req. Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50102; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(50103; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }

        field(50146; "Receiving Temperature"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 2;
            Caption = 'Receiving Temperature °C';
        }

        field(50147; "Receiving Quality Control"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    procedure PrintGrowerReceiptRecords(var pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pReceiptHeader.FindSet then begin
            repeat
                rL_ILE.Reset;
                rL_ILE.SetRange("Document Type", rL_ILE."Document Type"::"Purchase Receipt");
                rL_ILE.SetFilter("Document No.", pReceiptHeader."No.");
                if rL_ILE.FindSet then begin
                    Clear(rpt_GrowerReceipt);
                    rpt_GrowerReceipt.SetTableView(rL_ILE);
                    rpt_GrowerReceipt.RunModal;
                end;


            until pReceiptHeader.Next = 0;
        end;
    end;

    procedure PrintAppendixRecords(var pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix FFH";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pReceiptHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetPurchPostReceipt("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pReceiptHeader.Next = 0;
        end;
    end;

    procedure PrintAppendixRecordsQuality(var pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix Quality";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        if pReceiptHeader.FindSet then begin
            repeat
                Clear(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetPurchPostReceipt("No.");
                rpt_ItemTrackingAppendix.RunModal;
            until pReceiptHeader.Next = 0;
        end;
    end;

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}