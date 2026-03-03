/*
TAL0.1 2017/11/27 VC Delete set to No, NAV allows to delete record
TAL0.2 2018/11/04 VC add export button for EDI
*/
pageextension 50130 PostedSalesCreditMemoExt extends "Posted Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here

        addafter("No. Printed")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = true;
                ToolTip = 'Specifies the value of the Reason Code field.';
            }
        }

        addafter("External Document No.")
        {
            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
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
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    cu_GeneralMgt.ExportRLIDE(Rec."No.", false, true, SalesInvHeader, SalesCrMemoHeader); //TAL0.2
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}