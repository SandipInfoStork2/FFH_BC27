pageextension 50235 VendorLedgerEntriesExt extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shortcut Dimension 8 Code")
        {
            field("Journal Batch Name"; "Journal Batch Name")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Show Document")
        {
            action("Print Vendor Receipt")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Print Receipt';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Custom: Print Receipt';
                trigger onAction()
                begin
                    PrintVendorReceipt(false, true);
                end;

            }

            action("Email Vendor Receipt")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Email Receipt';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Custom: Email Receipt';
                trigger onAction()
                begin
                    PrintVendorReceipt(true, true);
                end;

            }

        }
    }

    // procedure PrintVendorReceipt(SendAsEmail: Boolean)
    // var
    //     ReportSelections: Record "Report Selections";
    //     VLE: Record "Vendor Ledger Entry";
    //     vL_DocNo: Text;
    //     vL_DocName: Text;

    // begin
    //     VLE.RESET;
    //     VLE.SETRANGE("Entry No.", "Entry No.");
    //     IF VLE.FINDSET THEN BEGIN
    //         VLE.TESTFIELD("Document Type", VLE."Document Type"::Payment);
    //         VLE.CALCFIELDS(Amount);
    //     end;

    //     IF VLE.Amount <= 0 THEN ERROR('You must select a debit Entry');

    //     vL_DocNo := VLE."Document No.";
    //     vL_DocName := 'Vendor Receipt';

    //     ReportSelections.RESET;
    //     ReportSelections.SetRange(Usage, ReportSelections.Usage::"Vendor Receipt");
    //     if ReportSelections.FindSet() then begin
    //         if SendAsEmail then
    //             ReportSelections.SendEmailToCust(
    //               ReportSelections.Usage.AsInteger(), VLE, vL_DocNo, vL_DocName, true, VLE."Buy-from Vendor No.")
    //         else
    //             ReportSelections.PrintWithDialogForCust(ReportSelections.Usage, VLE, true, VLE.FieldNo("Vendor No."));
    //     end;

    // end;

    //TAL 1.0.0.319 >>
    procedure PrintVendorReceipt(SendAsEmail: Boolean; ShowDialog: Boolean)
    var
        ReportSelections: Record "Report Selections";
        VLE: Record "Vendor Ledger Entry";
        vL_DocNo: Text;
        vL_DocName: Text;
    begin
        VLE.Reset();
        VLE.SetRange("Entry No.", "Entry No.");

        IF VLE.FindSet() THEN BEGIN
            VLE.TestField("Document Type", VLE."Document Type"::Payment);
            VLE.CalcFields(Amount);
        end;

        IF VLE.Amount <= 0 THEN ERROR('You must select a debit Entry');

        vL_DocNo := VLE."Document No.";
        vL_DocName := 'Vendor Receipt';

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"Vendor Receipt");
        if ReportSelections.FindSet() then begin
            if SendAsEmail then begin
                ReportSelections.SendEmailToVendor(ReportSelections.Usage::"Vendor Receipt".AsInteger(), VLE, vL_DocNo, vL_DocName, ShowDialog, VLE."Buy-from Vendor No.")
            end else begin
                ReportSelections.PrintWithDialogForVend(ReportSelections.Usage, VLE, true, VLE.FieldNo("Vendor No."));
            end;
        end;
    end;
    //TAL 1.0.0.319 <<

    var
        myInt: Integer;
}