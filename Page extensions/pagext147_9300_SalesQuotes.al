pageextension 50247 SalesQuotesExt extends "Sales Quotes"
{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Week No."; Rec."Week No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Week No. field.';
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
                Caption = 'Document Day';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Day field.';
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
                Caption = 'Requested Delivery Day';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Requested Delivery Day field.';
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

            field("No. of Lines"; Rec."No. of Lines")
            {
                ApplicationArea = All;
                DrillDownPageId = "Sales Quote Lidl Subform";
                ToolTip = 'Specifies the value of the No. of Lines field.';
            }

            field("No. of Costing Lines"; Rec."No. of Lines")
            {
                Caption = 'No. of Costing Lines';
                ApplicationArea = All;
                DrillDownPageId = "S.Q. Lidl Costing Subform";
                ToolTip = 'Specifies the value of the No. of Costing Lines field.';
            }
            field("No. of New Lines"; Rec."No. of New Lines")
            {
                ApplicationArea = All;
                DrillDownPageId = "Sales Quote Lidl Subform";
                ToolTip = 'Specifies the value of the No. of New Lines field.';
            }
        }

        addafter("Quote Valid Until Date")
        {
            field("Price Start Date"; Rec."Price Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Get Costing Price Previous Week - Start Date';
            }
            field("Price End Date"; Rec."Price End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Get Costing Price Previous Week - End Date';
            }
            field("Price Update Start Date"; Rec."Price Update Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Update Prices Previous Week - Start Date';
            }
            field("Price Update End Date"; Rec."Price Update End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Update Prices Previous Week - End Date';
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
                Caption = 'Sales Quote Lidl Lines';
                ToolTip = 'Executes the Sales Quote Lidl Lines action.';

                trigger OnAction()
                var
                    rL_SalesLine: Record "Sales Line";
                    pLidlLine: Page "Sales Quote Lidl Lines";
                begin
                    rL_SalesLine.Reset;
                    rL_SalesLine.SetRange("Document Type", Rec."Document Type");
                    rL_SalesLine.SetFilter("Document No.", Rec."No.");
                    if rL_SalesLine.FindSet() then begin
                        Clear(pLidlLine);
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
        if DateforWeek1.GET(DateforWeek1."Period Type"::Date, Rec."Document Date") then begin
            vG_DocumentDay := DateforWeek1."Period Name";
        end;

        if DateforWeek1.GET(DateforWeek1."Period Type"::Date, Rec."Requested Delivery Date") then begin
            vG_RequestedDeliveryDay := DateforWeek1."Period Name";
        end;
    end;

    var

        vG_DocumentDay: Text;
        vG_RequestedDeliveryDay: Text;
}