page 50023 "Grower Item Catalog"
{
    // version NAVW110.0

    CaptionML = ELL = 'Vendor Grower Item Catalog',
                ENU = 'Vendor Grower Item Catalog';
    DataCaptionFields = "Grower No.";
    PageType = List;
    SourceTable = "Item Grower Vendor";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("Grower No."; Rec."Grower No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the vendor who offers the alternate direct unit cost.';
                    Visible = false;
                }
                field("Category 1"; Rec."Category 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 1 field.';
                }
                field("Product Name"; Rec."Product Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product Name field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item that the alternate direct unit cost is valid for.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a variant code for the item.';
                    Visible = false;
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number that the vendor uses for this item.';
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a date formula for the amount of time that it takes to replenish the item.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group("Ve&ndor Item")
            {
                Caption = 'Ve&ndor Item';
                Image = Item;
                action("Purch. Prices")
                {
                    ApplicationArea = Suite;
                    Caption = 'Purch. Prices';
                    Image = Price;
                    RunObject = page "Purchase Prices";
                    RunPageLink = "Item No." = field("Item No."),
                                  "Vendor No." = field("Grower No.");
                    RunPageView = sorting("Item No.", "Vendor No.");
                    ToolTip = 'Define purchase price agreements with vendors for specific items.';
                }
                action("P&urch. Line Discounts")
                {
                    ApplicationArea = Suite;
                    Caption = 'P&urch. Line Discounts';
                    Image = LineDiscount;
                    RunObject = page "Purchase Line Discounts";
                    RunPageLink = "Item No." = field("Item No."),
                                  "Vendor No." = field("Grower No.");
                    ToolTip = 'Define purchase line discounts with vendors. For example, you may get for a line discount if you buy items from a vendor in large quantities.';
                }
            }
        }
    }
}

