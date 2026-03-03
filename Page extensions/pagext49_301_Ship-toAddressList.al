/*
TAL0.1 2018/11/14 VC add field GLN Delivery for EDI

*/
pageextension 50149 ShiptoAddressListExt extends "Ship-to Address List"
{
    layout
    {

        modify("Phone No.")
        {
            Visible = true;
        }
        addafter("Phone No.")
        {
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email field.';
            }
        }
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("GLN Delivery"; Rec."GLN Delivery")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the GLN Delivery field.';
            }
            field(Monday; Rec.Monday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Monday field.';
            }
            field(Tuesday; Rec.Tuesday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tuesday field.';
            }
            field(Wednesday; Rec.Wednesday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Wednesday field.';
            }
            field(Thursday; Rec.Thursday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Thursday field.';
            }
            field(Friday; Rec.Friday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Friday field.';
            }
            field(Saturday; Rec.Saturday)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Saturday field.';
            }
            field(Sunday; Rec.Sunday)
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Sunday field.';
            }
            field("Notify Place Order"; Rec."Notify Place Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Place Order field.';
            }

            field(vG_NoOfOrders; vG_NoOfOrders)
            {
                Caption = 'No. of Orders';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the No. of Orders field.';
            }

            field(vG_MinOrderDate; vG_MinOrderDate)
            {
                Caption = 'First Requested Delivery Date';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the First Requested Delivery Date field.';
            }

            field(vG_MaxOrderDate; vG_MaxOrderDate)
            {
                Caption = 'Last Requested Delivery Date';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Last Requested Delivery Date field.';
            }



        }
    }

    actions
    {
        // Add changes to page actions here
    }

    //+1.0.0.264
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Rec.SetSecurityFilterOnCustomer();
    end;
    //-1.0.0.264

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SalesHeader: Record "Sales Header";
    begin

        SalesHeader.Reset;
        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.", "Ship-to Code", "Requested Delivery Date");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Sell-to Customer No.", Rec."Customer No.");
        SalesHeader.SetFilter("Ship-to Code", Rec.Code);

        vG_NoOfOrders := SalesHeader.Count;
        vG_MinOrderDate := 0D;
        vG_MaxOrderDate := 0D;
        if SalesHeader.FindFirst() then begin
            vG_MinOrderDate := SalesHeader."Requested Delivery Date";
        end;

        if SalesHeader.FindLast() then begin
            vG_MaxOrderDate := SalesHeader."Requested Delivery Date";

            if vG_MinOrderDate = vG_MaxOrderDate then begin
                vG_MaxOrderDate := 0D;
            end;
        end;

    end;

    var
        myInt: Integer;

        vG_MinOrderDate: Date;

        vG_MaxOrderDate: Date;

        vG_NoOfOrders: Integer;
}