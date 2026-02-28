
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
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(50103; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
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

    procedure PrintGrowerReceiptRecords(VAR pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        IF pReceiptHeader.FINDSET THEN BEGIN
            REPEAT
                rL_ILE.RESET;
                rL_ILE.SETRANGE("Document Type", rL_ILE."Document Type"::"Purchase Receipt");
                rL_ILE.SETFILTER("Document No.", pReceiptHeader."No.");
                IF rL_ILE.FINDSET THEN BEGIN
                    CLEAR(rpt_GrowerReceipt);
                    rpt_GrowerReceipt.SETTABLEVIEW(rL_ILE);
                    rpt_GrowerReceipt.RUNMODAL;
                END;


            UNTIL pReceiptHeader.NEXT = 0;
        END;
    end;

    procedure PrintAppendixRecords(VAR pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix FFH";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        IF pReceiptHeader.FINDSET THEN BEGIN
            REPEAT
                CLEAR(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetPurchPostReceipt("No.");
                rpt_ItemTrackingAppendix.RUNMODAL;
            UNTIL pReceiptHeader.NEXT = 0;
        END;
    end;

    procedure PrintAppendixRecordsQuality(VAR pReceiptHeader: Record "Purch. Rcpt. Header")
    var

        ReportSelection: Record "Report Selections";
        rpt_ItemTrackingAppendix: Report "Item Tracking Appendix Quality";
        rpt_GrowerReceipt: Report "Grower Receipt";
        rL_ILE: Record "Item Ledger Entry";
    begin
        IF pReceiptHeader.FINDSET THEN BEGIN
            REPEAT
                CLEAR(rpt_ItemTrackingAppendix);
                rpt_ItemTrackingAppendix.SetPurchPostReceipt("No.");
                rpt_ItemTrackingAppendix.RUNMODAL;
            UNTIL pReceiptHeader.NEXT = 0;
        END;
    end;

    trigger OnDelete()
    begin
        Error('TalosCo Permissions: Delete is not allowed.');
    end;

    var
        myInt: Integer;
}