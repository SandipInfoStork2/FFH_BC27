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

            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Batch No. field.';
            }

            field("Export DateTime"; Rec."Export DateTime")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Export DateTime field.';
            }
            field("Total Qty"; Rec."Total Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty field.';
            }
            field("Total Qty (Base)"; Rec."Total Qty (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Qty (Base) field.';
            }
            field("Total Weight"; Rec."Total Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Weight field.';
            }

            field("Customer Reference No."; Rec."Customer Reference No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Customer Reference No. field.';
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
                    cu_GeneralMgt.ExportRLIDE(Rec."No.", true, false, SalesInvHeader, SalesCrMemoHeader); //TAL0.2
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}