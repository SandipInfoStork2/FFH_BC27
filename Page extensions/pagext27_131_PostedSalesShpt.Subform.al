/*
18/06/17 TAL0.1 add field "Shelf No." 
TAL0.2 2018/05/24 VC design field "Quantity (Base)"
TAL0.3 2019/09/17 VC add field Unit of Measure (Base)
TAL0.4 2019/12/13 VC add ShowShortcutDimCode
TAL0.5 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.6 2021/03/22 VC add fields Total Net Weight,Net Weight

*/
pageextension 50127 PostedSalesShptSubformExt extends "Posted Sales Shpt. Subform"
{
    layout
    {
        // Add changes to page layout here


        addafter("No.")
        {
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; Rec."Packing Group Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Group Description field.';
            }
        }

        addafter(Correction)
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 3;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }

            field("Qty. Requested"; Rec."Qty. Requested")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Qty. Requested';
            }
            field("Qty. Confirmed"; Rec."Qty. Confirmed")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. Confirmed field.';
            }
        }

        modify("Net Weight")
        {
            Visible = true;
        }
        /*
        addafter("Net Weight")
        {
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
            }
        }
        */
        modify("ShortcutDimCode[5]")
        {
            Visible = true;
        }
        modify("Variant Code")
        {
            Visible = true;
        }

        //TAL 1.0.0.201 >>
        addafter("Location Code")
        {
            field("Transfer-from Code"; Rec."Transfer-from Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-from Code field.';
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transfer-to Code field.';
            }
        }
        //TAL 1.0.0.201 <<

        addafter("ShortcutDimCode[8]")
        {
            field("Shipping Temperature"; Rec."Shipping Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Temperature °C field.';
            }
            field("Shipping Quality Control"; Rec."Shipping Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping Quality Control field.';
            }

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Specifies the value of the Req. Country field.';
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = All;
                Visible = true;
                ToolTip = 'Custom: Country/Region of Origin Code';
            }


            field("Product Class"; Rec."Product Class")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Product Class (Κατηγορία)';
            }
            field("Category 9"; Rec."Category 9")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Potatoes District Region';
            }
        }



    }

    actions
    {
        // Add changes to page actions here

        addafter("&Line")
        {
            action(ItemTrackingEntries2)
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;
                ToolTip = 'Executes the Item &Tracking Entries action.';
                trigger OnAction();
                begin
                    Rec.ShowItemTrackingLines;
                end;
            }


        }


        addafter(DocumentLineTracking)
        {
            action("Update Categories")
            {
                ApplicationArea = Suite;
                Caption = 'Update Categories';
                Image = Edit;
                ToolTip = 'Custom: Update Categories';

                trigger OnAction()
                var
                    PostedSalesShipmentLineUpdate: Page "Posted Sales Line S - Update";
                begin
                    PostedSalesShipmentLineUpdate.LookupMode := true;
                    PostedSalesShipmentLineUpdate.SetRec(Rec);
                    PostedSalesShipmentLineUpdate.RunModal;
                end;
            }
        }
    }

    var
        myInt: Integer;
}