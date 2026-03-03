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
                field(Sales_Order_No_; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order No. field.';

                }

                field(Order_Date; Rec."Order Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Date field.';

                }
                field(Order_Time; Rec."Order Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Import DateTime field.';

                }
                field(Customer_No_; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';

                }
                field(Shelf_No_; Rec."Shelf No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shelf No. field.';

                }
                field(Item_No_; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';

                }
                field(Version_No_; Rec."Version No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Version No. field.';

                }
                field(Qty_Ordered; Rec."Qty Ordered")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty Ordered field.';

                }
                field(UOM_Base; Rec."UOM (Base)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM (Base) field.';

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
                ToolTip = 'Executes the ActionName action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}