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
            field("Export DateTime"; Rec."Export DateTime")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Export DateTime field.';
            }
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
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
                    cu_GeneralMgt.ExportRLIDE(Rec."No.", false, true, SalesInvHeader, SalesCrMemoHeader); //TAL0.1
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}