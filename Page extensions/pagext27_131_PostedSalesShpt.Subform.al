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
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Packing Group Description"; "Packing Group Description")
            {
                ApplicationArea = all;
            }
        }

        addafter(Correction)
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = all;
                DecimalPlaces = 0 : 3;
            }
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = all;
            }

            field("Qty. Requested"; "Qty. Requested")
            {
                ApplicationArea = all;
            }
            field("Qty. Confirmed"; "Qty. Confirmed")
            {
                ApplicationArea = all;
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
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.201 <<

        addafter("ShortcutDimCode[8]")
        {
            field("Shipping Temperature"; "Shipping Temperature")
            {
                ApplicationArea = all;
            }
            field("Shipping Quality Control"; "Shipping Quality Control")
            {
                ApplicationArea = all;
            }

            field("Req. Country"; Rec."Req. Country")
            {
                ApplicationArea = all;
                Visible = true;
            }

            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ApplicationArea = all;
                Visible = true;
            }


            field("Product Class"; "Product Class")
            {
                ApplicationArea = all;
            }
            field("Category 9"; "Category 9")
            {
                ApplicationArea = all;
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
                ApplicationArea = all;
                Caption = 'Item &Tracking Entries';
                Image = ItemTrackingLedger;
                trigger OnAction();
                begin
                    ShowItemTrackingLines;
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