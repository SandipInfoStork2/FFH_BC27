/*
TAl0.1 ANP Added Action Update Descreption from Payee
TAl0.2 VC 2020/02/24 Check Counter
*/
pageextension 50144 PaymentJournalExt extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Check Printed")
        {
            Visible = true;
        }

        addafter("Check Printed")
        {
            field(LineNoCheques; LineNoCheques)
            {
                ApplicationArea = All;
                Caption = 'No. Cheques to Print';
                ToolTip = 'Specifies the value of the No. Cheques to Print field.';
            }
        }

        addafter(Description)
        {
            field("Payee Name (GL Cheque)"; Rec."Payee Name (GL Cheque)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payee Name field.';
            }
        }

        addafter(Control24)
        {
            group(lblTotalChequesforPrinting)
            {

                Caption = 'Total Cheques for Printing';
                Visible = ViewTotalCheques;
                field(TotalCheques; TotalCheques)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the TotalCheques field.';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(PositivePayExport)
        {
            action(UpdateDescreptionwithPayeeName)
            {
                ApplicationArea = All;
                Caption = 'Update Descr. from Payee';
                ToolTip = 'Executes the Update Descr. from Payee action.';

                trigger OnAction();
                begin
                    //TAL0.1
                    //CLEAR(rG_JournalLine);
                    rG_JournalLine.Reset;
                    rG_JournalLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    rG_JournalLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    if rG_JournalLine.FindFirst then begin
                        repeat
                            rG_JournalLine.Description := rG_JournalLine."Payee Name (GL Cheque)";
                            rG_JournalLine.Modify;
                        until rG_JournalLine.Next = 0;
                    end;
                    Message('Completed');
                    //TAL0.1
                end;
            }

        }


        modify(SuggestVendorPayments)
        {
            Visible = false;
        }
        addafter(SuggestVendorPayments)
        {
            action(SuggestVendorPayments_2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Suggest Vendor Payments';
                Ellipsis = true;
                Image = SuggestVendorPayments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                ToolTip = 'Create payment suggestions as lines in the payment journal.';

                trigger OnAction()
                var
                    SuggestVendorPayments: Report "Suggest Vendor Payments FFH"; //has the Date Type Option
                begin
                    Clear(SuggestVendorPayments);
                    SuggestVendorPayments.SetGenJnlLine(Rec);
                    SuggestVendorPayments.RunModal;
                end;
            }
        }

        addbefore(Preview)
        {
            // action(PostAndEmail)
            // {
            //     ApplicationArea = All;
            //     Image = PostMail;
            //     Promoted = true;
            //     PromotedCategory = Category8;
            //     Caption = 'Post and Email';
            //     Tooltip = 'Custom: Post and Email';
            //     trigger OnAction()
            //     var
            //         CurrentJnlBatchName: Code[10];
            //     begin
            //         CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Email", Rec);
            //         CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
            //         CurrPage.UPDATE(FALSE);
            //     end;
            // }
        }

    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //+TAl0.2
        ViewTotalCheques := true;
        if rG_GeneralLedgerSetup.Get then;
        //-TAl0.2

        //+TAl0.2
        UpdateAllPrintChequeNo;
        //-TAl0.2
    end;

    trigger OnAfterGetRecord();
    begin

        //+TAl0.2
        LineNoCheques := 0;
        if Rec."Journal Template Name" = rG_GeneralLedgerSetup."Cheque Template Name" then begin
            ViewTotalCheques := true;
            LineNoCheques := UpdatePrintChequeNo(Rec);
        end else begin
            ViewTotalCheques := false;
        end;
        //-TAl0.2
    end;

    trigger OnAfterGetCurrRecord();
    begin

        //+TAl0.2
        UpdateAllPrintChequeNo;
        //-TAl0.2
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin

        LineNoCheques := 0;
    end;




    procedure UpdatePrintChequeNo(pGenJournalLine: Record "Gen. Journal Line") CounterCheques: Integer;
    begin


        if ViewTotalCheques = false then
            exit;

        rG_GeneralLedgerSetup.Get();
        PageSplit := rG_GeneralLedgerSetup."Cheque Page Line No";
        if PageSplit = 0 then
            Error(Text50000);

        RowCounter := 0;
        PageCounter := 0;

        GenJnlLine.Reset;
        if pGenJournalLine."Journal Template Name" <> '' then begin
            GenJnlLine.SetRange("Journal Template Name", pGenJournalLine."Journal Template Name");
        end;

        GenJnlLine.SetRange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
        GenJnlLine.SetRange("Check Printed", false);
        GenJnlLine.SetRange("Line No.", pGenJournalLine."Line No.");

        if GenJnlLine.FindSet then begin
            repeat

                if GenJnlLine."Account Type" = pGenJournalLine."Account Type"::Vendor then begin
                    if Vendor.Get(GenJnlLine."Account No.") then begin


                        VendLedgEntry.Reset;
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                        VendLedgEntry.SetRange(Open, true);

                        if GenJnlLine."Document No." = '' then begin
                            VendLedgEntry.SetFilter("Applies-to ID", '<>%1', '');
                        end else begin
                            VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
                        end;

                        RowCounter := VendLedgEntry.Count;
                        if RowCounter <= (PageSplit - 1) then begin
                            PageCounter := 1;
                        end else begin
                            PageCounter := 1 + Round(((RowCounter - (PageSplit - 1)) / PageSplit), 1, '>');
                        end;


                    end;
                end else
                    if GenJnlLine."Account Type" = pGenJournalLine."Account Type"::Customer then begin
                        if Customer.Get(GenJnlLine."Account No.") then begin


                            CustLedgEntry.Reset;
                            CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                            CustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
                            CustLedgEntry.SetRange(Open, true);

                            if GenJnlLine."Document No." = '' then begin
                                CustLedgEntry.SetFilter("Applies-to ID", '<>%1', '');
                            end else begin
                                CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
                            end;

                            RowCounter := CustLedgEntry.Count;
                            if RowCounter <= (PageSplit - 1) then begin
                                PageCounter := 1;
                            end else begin
                                PageCounter := 1 + Round(((RowCounter - (PageSplit - 1)) / PageSplit), 1, '>');
                            end;


                        end;
                    end;

            until GenJnlLine.Next = 0;

        end;

        CounterCheques := PageCounter;
        exit(CounterCheques);
    end;

    procedure UpdateAllPrintChequeNo();
    begin

        if ViewTotalCheques = false then
            exit;

        rG_GeneralLedgerSetup.Get();
        PageSplit := rG_GeneralLedgerSetup."Cheque Page Line No";
        if PageSplit = 0 then
            Error(Text50000);

        TotalCheques := 0;
        RowCounter := 0;
        PageCounter := 0;

        GenJnlLine.Reset;
        if Rec."Journal Template Name" <> '' then begin
            GenJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
        end;

        GenJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
        GenJnlLine.SetRange("Check Printed", false);

        if GenJnlLine.FindSet then begin
            repeat

                if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then begin
                    if Vendor.Get(GenJnlLine."Account No.") then begin


                        VendLedgEntry.Reset;
                        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive);
                        VendLedgEntry.SetRange("Vendor No.", GenJnlLine."Account No.");
                        VendLedgEntry.SetRange(Open, true);

                        if GenJnlLine."Document No." = '' then begin
                            VendLedgEntry.SetFilter("Applies-to ID", '<>%1', '');
                        end else begin
                            VendLedgEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
                        end;

                        RowCounter := VendLedgEntry.Count;
                        if RowCounter <= (PageSplit - 1) then begin
                            PageCounter := 1;
                        end else begin
                            PageCounter := 1 + Round(((RowCounter - (PageSplit - 1)) / PageSplit), 1, '>');  //NOD0.9 //NOD.10
                        end;


                        if RowCounter > (PageSplit) then begin
                            PageCounter := 1;
                        end;



                    end;
                end else
                    if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer then begin
                        if Customer.Get(GenJnlLine."Account No.") then begin


                            CustLedgEntry.Reset;
                            CustLedgEntry.SetCurrentKey("Customer No.", Open, Positive);
                            CustLedgEntry.SetRange("Customer No.", GenJnlLine."Account No.");
                            CustLedgEntry.SetRange(Open, true);

                            if GenJnlLine."Document No." = '' then begin
                                CustLedgEntry.SetFilter("Applies-to ID", '<>%1', '');
                            end else begin
                                CustLedgEntry.SetRange("Applies-to ID", GenJnlLine."Document No.");
                            end;

                            RowCounter := CustLedgEntry.Count;
                            if RowCounter <= (PageSplit - 1) then begin
                                PageCounter := 1;
                            end else begin
                                PageCounter := 1 + Round(((RowCounter - (PageSplit - 1)) / PageSplit), 1, '>');
                            end;


                            if RowCounter > (PageSplit) then begin
                                PageCounter := 1;
                            end;



                        end;
                    end;

                TotalCheques := TotalCheques + PageCounter;
            until GenJnlLine.Next = 0;

        end;
    end;

    var
        rG_JournalLine: Record "Gen. Journal Line";
        GenJnlLine: Record "Gen. Journal Line";
        linecounter: Integer;
        rG_GeneralLedgerSetup: Record "General Ledger Setup";
        [InDataSet]
        ViewTotalCheques: Boolean;
        PageSplit: Integer;
        TotalCheques: Integer;
        RowCounter: Integer;
        PageCounter: Integer;
        Vendor: Record Vendor;
        Customer: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        LineNoCheques: Integer;
        Text50000: Label '"Page split not set "';
        Text50001: Label 'Please set the document type on line %1';
        Text50002: Label 'PLEASE SPECIFY REASON CODE ON LINE %1';
}