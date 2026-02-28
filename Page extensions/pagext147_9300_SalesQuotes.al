pageextension 50247 SalesQuotesExt extends "Sales Quotes"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; "Week No.")
            {
                ApplicationArea = all;
            }

        }

        modify("Document Date")
        {
            Visible = true;
        }

        modify("Requested Delivery Date")
        {
            Visible = true;
        }

        moveafter("Posting Date"; "Document Date")
        addafter("Document Date")
        {
            field(DocumentDay; vG_DocumentDay)
            {
                caption = 'Document Day';
                ApplicationArea = all;
            }
            /*
            field("Requested Delivery Date"; "Requested Delivery Date")
            {
                ApplicationArea = all;
            }
            */

            /*
            field("Order Date"; "Order Date")
            {
                Visible = false;
                ApplicationArea = all;
            }
            field(RequestedDeliveryDay; vG_RequestedDeliveryDay)
            {
                caption = 'Requested Delivery Day';
                ApplicationArea = all;
            }
            */
        }

        addafter("Requested Delivery Date")
        {
            field(RequestedDeliveryDay; vG_RequestedDeliveryDay)
            {
                caption = 'Requested Delivery Day';
                ApplicationArea = all;
            }
        }
        modify("Posting Date")
        {
            Visible = false;
        }
        modify("Due Date")
        {
            Visible = false;
        }

        addafter(Amount)
        {

            field("No. of Lines"; "No. of Lines")
            {
                ApplicationArea = all;
                DrillDownPageId = "Sales Quote Lidl Subform";
            }

            field("No. of Costing Lines"; "No. of Lines")
            {
                caption = 'No. of Costing Lines';
                ApplicationArea = all;
                DrillDownPageId = "S.Q. Lidl Costing Subform";
            }
            field("No. of New Lines"; "No. of New Lines")
            {
                ApplicationArea = all;
                DrillDownPageId = "Sales Quote Lidl Subform";
            }
        }

        addafter("Quote Valid Until Date")
        {
            field("Price Start Date"; "Price Start Date")
            {
                ApplicationArea = all;
            }
            field("Price End Date"; "Price End Date")
            {
                ApplicationArea = all;
            }
            field("Price Update Start Date"; "Price Update Start Date")
            {
                ApplicationArea = all;
            }
            field("Price Update End Date"; "Price Update End Date")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(Dimensions)
        {
            action(pLidldLines)
            {
                ApplicationArea = All;
                caption = 'Sales Quote Lidl Lines';

                trigger OnAction()
                Var
                    rL_SalesLine: Record "Sales Line";
                    pLidlLine: Page "Sales Quote Lidl Lines";
                begin
                    rL_SalesLine.RESET;
                    rL_SalesLine.SetRange("Document Type", "Document Type");
                    rL_SalesLine.SetFilter("Document No.", "No.");
                    if rL_SalesLine.FindSet() then begin
                        clear(pLidlLine);
                        pLidlLine.SetTableView(rL_SalesLine);
                        pLidlLine.Run();
                    end;
                end;
            }
        }


    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        DateforWeek1: Record Date;
    begin
        if DateforWeek1.GET(DateforWeek1."Period Type"::Date, "Document Date") then begin
            vG_DocumentDay := DateforWeek1."Period Name";
        end;

        if DateforWeek1.GET(DateforWeek1."Period Type"::Date, "Requested Delivery Date") then begin
            vG_RequestedDeliveryDay := DateforWeek1."Period Name";
        end;
    end;

    var

        vG_DocumentDay: Text;
        vG_RequestedDeliveryDay: Text;
}