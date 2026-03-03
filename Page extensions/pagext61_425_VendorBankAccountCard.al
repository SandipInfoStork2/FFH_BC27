pageextension 50161 VendorBankAccountCardExt extends "Vendor Bank Account Card"
{
    layout
    {
        // Add changes to page layout here

        addafter(Code)
        {
            field("Reference Code"; Rec."Reference Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reference Code field.';
            }
        }

        addafter("Bank Clearing Code")
        {
            group(Other)
            {
                Caption = 'Other';
                field("Sorting Code"; Rec."Sorting Code")
                {
                    ApplicationArea = All;
                    Caption = 'Sorting Code';
                    ToolTip = 'Specifies the value of the Sorting Code field.';
                }
                field("Intermediary Bank Swift Code"; Rec."Intermediary Bank Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Intermediary Bank Swift Code';
                    ToolTip = 'Specifies the value of the Intermediary Bank Swift Code field.';
                }
            }
        }
        addafter(Transfer)
        {
            group("Receiver's Correspondent")
            {
                Caption = 'Receiver''s Correspondent';
                field("R Correspondent Swift Code"; Rec."R Correspondent Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Swift Code';
                    ToolTip = 'Specifies the value of the Receiver''s Correspondent Swift Code field.';
                }
                field("R Correspondent Bank Name"; Rec."R Correspondent Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Bank Name';
                    ToolTip = 'Specifies the value of the Receiver''s Correspondent Bank Name field.';
                }
                field("R Correspondent Address 1"; Rec."R Correspondent Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 1';
                    ToolTip = 'Specifies the value of the Receiver''s Correspondent Address 1 field.';
                }
                field("R Correspondent Address 2"; Rec."R Correspondent Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 2';
                    ToolTip = 'Specifies the value of the Receiver''s Correspondent Address 2 field.';
                }
                field("R Correspondent Address 3"; Rec."R Correspondent Address 3")
                {
                    ApplicationArea = All;
                    Caption = 'Receiver''s Correspondent Address 3';
                    ToolTip = 'Specifies the value of the Receiver''s Correspondent Address 3 field.';
                }
            }
            group("Third Reimbursement Institution")
            {
                Caption = 'Third Reimbursement Institution';
                field("Thrd R Institution Swift Code"; Rec."Thrd R Institution Swift Code")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Swift Code';
                    ToolTip = 'Specifies the value of the Third Reimbursement Institution Swift Code field.';
                }
                field("Thrd R Institution Bank Name"; Rec."Thrd R Institution Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Bank Name';
                    ToolTip = 'Specifies the value of the Third Reimbursement Institution Bank Name field.';
                }
                field("Thr R Institution RC Address 1"; Rec."Thr R Institution RC Address 1")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 1';
                    ToolTip = 'Specifies the value of the Third Reimbursement Institution Address 1 field.';
                }
                field("Thr R Institution RC Address 2"; Rec."Thr R Institution RC Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 2';
                    ToolTip = 'Specifies the value of the Third Reimbursement Institution Address 2 field.';
                }
                field("Thr R Institution RC Address 3"; Rec."Thr R Institution RC Address 3")
                {
                    ApplicationArea = All;
                    Caption = 'Third Reimbursement Institution Address 3';
                    ToolTip = 'Specifies the value of the Third Reimbursement Institution Address 3 field.';
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