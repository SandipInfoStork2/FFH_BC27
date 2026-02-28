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
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = true;
            }
        }

        addafter("External Document No.")
        {
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
                Editable = false;
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
                ApplicationArea = all;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    CLEAR(cu_GeneralMgt);
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    cu_GeneralMgt.ExportRLIDE("No.", false, true, SalesInvHeader, SalesCrMemoHeader); //TAL0.2
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}