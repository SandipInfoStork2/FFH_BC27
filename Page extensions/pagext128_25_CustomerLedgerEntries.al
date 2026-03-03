pageextension 50228 CustomerLedgerEntriesExt extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Direct Debit Mandate ID")
        {
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journal Batch Name field.';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("Show Document")
        {
            action("Print Customer Receipt")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Print Receipt';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Custom: Print Receipt';
                trigger OnAction()
                begin
                    PrintPaymentReceipt(false, true);
                end;

            }

            action("Email Customer Receipt")
            {

                ApplicationArea = Basic, Suite;
                Caption = 'Email Receipt';
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Custom: Email Receipt';
                trigger OnAction()
                begin
                    PrintPaymentReceipt(true, true);
                end;

            }

        }
    }

    // procedure PrintPaymentReceipt(SendAsEmail: Boolean)
    // var
    //     ReportSelections: Record "Report Selections";
    //     CLE: Record "Cust. Ledger Entry";
    //     vL_DocNo: Text;
    //     vL_DocName: Text;

    // begin


    //     CLE.RESET;
    //     CLE.SETRANGE("Entry No.", "Entry No.");
    //     IF CLE.FINDSET THEN BEGIN
    //         CLE.TESTFIELD("Document Type", CLE."Document Type"::Payment);
    //         CLE.CALCFIELDS(Amount);
    //     end;

    //     IF CLE.Amount >= 0 THEN ERROR('You must select a credit Entry');

    //     vL_DocNo := CLE."Document No.";
    //     vL_DocName := 'Payment Receipt';

    //     ReportSelections.RESET;
    //     ReportSelections.SetRange(Usage, ReportSelections.Usage::"Payment Receipt");
    //     if ReportSelections.FindSet() then begin
    //         if SendAsEmail then
    //             ReportSelections.SendEmailToCust(
    //               ReportSelections.Usage.AsInteger(), CLE, vL_DocNo, vL_DocName, true, CLE."Sell-to Customer No.")
    //         else
    //             ReportSelections.PrintWithDialogForCust(ReportSelections.Usage, CLE, true, CLE.FieldNo("Customer No."));
    //     end;

    // end;

    //TAL 1.0.0.319 >>
    procedure PrintPaymentReceipt(SendAsEmail: Boolean; ShowDialog: Boolean)
    var
        ReportSelections: Record "Report Selections";
        CLE: Record "Cust. Ledger Entry";
        vL_DocNo: Text;
        vL_DocName: Text;
    begin
        CLE.Reset();
        CLE.SetRange("Entry No.", Rec."Entry No.");

        if CLE.FindSet() then begin
            CLE.TestField("Document Type", CLE."Document Type"::Payment);
            CLE.CalcFields(Amount);
        end;

        if CLE.Amount >= 0 then Error('You must select a credit Entry');

        vL_DocNo := CLE."Document No.";
        vL_DocName := 'Payment Receipt';

        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"Payment Receipt");
        if ReportSelections.FindSet() then begin
            if SendAsEmail then begin
                ReportSelections.SendEmailToCust(ReportSelections.Usage::"Payment Receipt".AsInteger(), CLE, vL_DocNo, vL_DocName, ShowDialog, CLE."Customer No.")
            end else begin
                ReportSelections.PrintWithDialogForCust(ReportSelections.Usage, CLE, true, CLE.FieldNo("Customer No."));
            end;
        end;
    end;
    //TAL 1.0.0.319 <<

    var
        myInt: Integer;
}