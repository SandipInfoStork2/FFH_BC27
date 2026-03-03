/*
TAL0.1 2018/07/22 VC add field Batch No. 
TAL0.2 2018/11/04 VC add export button for EDI
TAL0.3 2020/03/26 VC add field Total Qty,Total Weight,Total Qty (Base)

*/
pageextension 50139 PostedSalesInvoicesExt extends "Posted Sales Invoices"
{

    layout
    {
        // Add changes to page layout here
        modify("External Document No.")
        {
            Visible = true;
        }
        modify("Order No.")
        {
            Visible = true;
        }
        addafter("Document Exchange Status")
        {

            field("Batch No."; "Batch No.")
            {
                ApplicationArea = all;
            }

            field("Export DateTime"; "Export DateTime")
            {
                ApplicationArea = all;
            }
            field("Total Qty"; "Total Qty")
            {
                ApplicationArea = all;
            }
            field("Total Qty (Base)"; "Total Qty (Base)")
            {
                ApplicationArea = all;
            }
            field("Total Weight"; "Total Weight")
            {
                ApplicationArea = all;
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

        modify("Ship-to Code")
        {
            Visible = true;
        }

        //TAL 1.0.0.71 >>
        moveafter("No."; "Posting Date")
        //TAL 1.0.0.71 <<
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
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    cu_GeneralMgt.ExportRLIDE("No.", true, false, SalesInvHeader, SalesCrMemoHeader); //TAL0.2
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}