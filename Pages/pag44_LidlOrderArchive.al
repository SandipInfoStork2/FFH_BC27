page 50044 "Lidl Order Archive"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Lidl Order Archive";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Sales_Order_No_; "Sales Order No.")
                {
                    ApplicationArea = All;

                }

                field(Order_Date; "Order Date")
                {
                    ApplicationArea = All;

                }
                field(Order_Time; "Order Time")
                {
                    ApplicationArea = All;

                }
                field(Customer_No_; "Customer No.")
                {
                    ApplicationArea = All;

                }
                field(Shelf_No_; "Shelf No.")
                {
                    ApplicationArea = All;

                }
                field(Item_No_; "Item No.")
                {
                    ApplicationArea = All;

                }
                field(Version_No_; "Version No.")
                {
                    ApplicationArea = All;

                }
                field(Qty_Ordered; "Qty Ordered")
                {
                    ApplicationArea = All;

                }
                field(UOM_Base; "UOM (Base)")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                Visible = false;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}