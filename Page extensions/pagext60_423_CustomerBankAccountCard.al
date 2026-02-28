pageextension 50160 CustomerBankAccountCardExt extends "Customer Bank Account Card"
{
    layout
    {
        // Add changes to page layout here

        addafter(Code)
        {
            field("Reference Code"; "Reference Code")
            {
                ApplicationArea = All;
            }
        }

        addafter("Bank Clearing Code")
        {
            group(Other)
            {
                Caption = 'Other';
                field("Sorting Code"; "Sorting Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sorting Code';
                }
                field("Intermediary Bank Swift Code"; "Intermediary Bank Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Intermediary Bank Swift Code';
                }
            }
        }

        addafter(Transfer)
        {
            group("Receiver's Correspondent")
            {
                Caption = 'Receiver''s Correspondent';
                field("R Correspondent Swift Code"; "R Correspondent Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Swift Code';
                }
                field("R Correspondent Bank Name"; "R Correspondent Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Bank Name';
                }
                field("R Correspondent Address 1"; "R Correspondent Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 1';
                }
                field("R Correspondent Address 2"; "R Correspondent Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 2';
                }
                field("R Correspondent Address 3"; "R Correspondent Address 3")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 3';
                }
            }
            group("Third Reimbursement Institution")
            {
                Caption = 'Third Reimbursement Institution';
                field("Thrd R Institution Swift Code"; "Thrd R Institution Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Swift Code';
                }
                field("Thrd R Institution Bank Name"; "Thrd R Institution Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Bank Name';
                }
                field("Thr R Institution RC Address 1"; "Thr R Institution RC Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 1';
                }
                field("Thr R Institution RC Address 2"; "Thr R Institution RC Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 2';
                }
                field("Thr R Institution RC Address 3"; "Thr R Institution RC Address 3")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 3';
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}