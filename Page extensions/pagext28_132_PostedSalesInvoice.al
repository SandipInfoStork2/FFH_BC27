
/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
TAL0.2 2018/07/22 VC add field Batch No. 
TAL0.3 2018/11/04 VC add export button for EDI

*/
pageextension 50128 PostedSalesInvoiceExt extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here

        addafter("External Document No.")
        {
            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }
        }

        addafter(BillToContactEmail)
        {
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                ApplicationArea = All;
                Caption = 'Sell-to E-Mail';
                ToolTip = 'Specifies the value of the Sell-to E-Mail field.';
            }
        }

        addafter("Your Reference")
        {
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
            }
        }

        addafter("Work Description")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter(ActivityLog)
        {
            action("Export EDI")
            {
                ApplicationArea = All;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the Export EDI action.';

                trigger OnAction();
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    Clear(cu_GeneralMgt);
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    cu_GeneralMgt.ExportRLIDE(Rec."No.", true, false, SalesInvHeader, SalesCrMemoHeader); //TAL0.3
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}