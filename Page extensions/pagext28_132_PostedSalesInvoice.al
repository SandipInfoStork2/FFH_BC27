
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
            field("Batch No."; "Batch No.")
            {
                ApplicationArea = all;
            }
        }

        addafter(BillToContactEmail)
        {
            field("Sell-to E-Mail"; "Sell-to E-Mail")
            {
                ApplicationArea = all;
                Caption = 'Sell-to E-Mail';
            }
        }

        addafter("Your Reference")
        {
            field("Customer Reference No."; "Customer Reference No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }

        addafter("Work Description")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
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
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    cu_GeneralMgt.ExportRLIDE("No.", true, false, SalesInvHeader, SalesCrMemoHeader); //TAL0.3
                end;
            }
        }
    }

    var
        cu_GeneralMgt: Codeunit "General Mgt.";
}