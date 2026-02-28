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
            field("E-Mail"; "E-Mail")
            {
                ApplicationArea = All;
            }
        }
        // Add changes to page layout here
        addafter("Location Code")
        {
            field("GLN Delivery"; "GLN Delivery")
            {
                ApplicationArea = All;
            }
            field(Monday; Monday)
            {
                ApplicationArea = All;
            }
            field(Tuesday; Tuesday)
            {
                ApplicationArea = All;
            }
            field(Wednesday; Wednesday)
            {
                ApplicationArea = All;
            }
            field(Thursday; Thursday)
            {
                ApplicationArea = All;
            }
            field(Friday; Friday)
            {
                ApplicationArea = All;
            }
            field(Saturday; Saturday)
            {
                ApplicationArea = All;
            }
            field(Sunday; Sunday)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Notify Place Order"; "Notify Place Order")
            {
                ApplicationArea = All;
            }

            field(vG_NoOfOrders; vG_NoOfOrders)
            {
                Caption = 'No. of Orders';
                ApplicationArea = All;
                Editable = false;
            }

            field(vG_MinOrderDate; vG_MinOrderDate)
            {
                Caption = 'First Requested Delivery Date';
                ApplicationArea = All;
                Editable = false;
            }

            field(vG_MaxOrderDate; vG_MaxOrderDate)
            {
                Caption = 'Last Requested Delivery Date';
                ApplicationArea = All;
                Editable = false;
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

        SalesHeader.RESET;
        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.", "Ship-to Code", "Requested Delivery Date");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Sell-to Customer No.", "Customer No.");
        SalesHeader.SetFilter("Ship-to Code", rec.Code);

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