/*
TAL0.1 2018/11/04 VC add export button for EDI
TAL0.2 2020/03/26 VC add field Total Qty,Total Weight,Total Qty (Base)

*/
pageextension 50140 PostedSalesCreditMemosExt extends "Posted Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document Exchange Status")
        {
            field("Export DateTime"; "Export DateTime")
            {
                ApplicationArea = All;
            }
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = All;
            }
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = All;
            }
            field("Total Qty (Base)"; "Total Qty (Base)")
            {
                ApplicationArea = All;
            }
            field("Total Weight"; "Total Weight")
            {
                ApplicationArea = All;
            }

            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Posting Date")
        {
            Visible = true;
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

                trigger OnAction();
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                begin
                    CLEAR(cu_GeneralMgt);
                    SalesCrMemoHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                    cu_GeneralMgt.ExportRLIDE("No.", false, true, SalesInvHeader, SalesCrMemoHeader); //TAL0.1
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}