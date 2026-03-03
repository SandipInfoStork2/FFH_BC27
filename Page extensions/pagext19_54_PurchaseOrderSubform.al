/*
TAL0.1 2021/03/22 VC Copy item Tracking lines for quick access 
TAL0.2 2021/03/22 VC add fields Total Net Weight,Net Weight
TAL0.3 2021/04/02 VC add field Auto Tracking Attention
                     Style No. and  Auto Tracking for attention
TAL0.4 2021/04/13 VC review code for auto tracking attention 

*/
pageextension 50119 PurchaseOrderSubformExt extends "Purchase Order Subform"
{
    layout
    {
        // Add changes to page layout here
        modify("No.")
        {
            StyleExpr = StyleTxt;
        }

        modify("Description 2")
        {
            Visible = true;
        }

        addafter("Qty. Assigned")
        {
            field("Auto Tracking Attention"; Format(vG_AutoTrackingAttention))
            {
                ApplicationArea = All;
                Caption = 'Auto Tracking Attention';
                Editable = false;
                StyleExpr = StyleTxt;
                ToolTip = 'Specifies the value of the Auto Tracking Attention field.';
            }
        }

        addafter("Bin Code")
        {
            field("Quantity (Base)"; Rec."Quantity (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quantity (Base) field.';
            }
        }

        modify("Prod. Order No.")
        {
            Visible = true;
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
                ApplicationArea = All;
            }
        }
        */

        addafter("Line No.")
        {
            field("Unit of Measure (Base)"; Rec."Unit of Measure (Base)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit of Measure (Base) field.';
            }
        }

        //TAL 1.0.0.71 >>
        addafter("No.")
        {
            field("Variant Code02056"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant of the item on the line.';
            }
        }
        addafter("Net Weight")
        {
            field("VAT Prod. Posting Group16759"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
            }
        }
        //TAL 1.0.0.71 <<

        modify("Promised Receipt Date")
        {
            Visible = true;
        }
        modify("Requested Receipt Date")
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

        addafter(ShortcutDimCode8)
        {
            field("Receiving Temperature"; Rec."Receiving Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
            }
            field("Receiving Quality Control"; Rec."Receiving Quality Control")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving Quality Control field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            action("Item Tracking Lines2")
            {
                ApplicationArea = All;
                Caption = 'Item &Tracking Lines';
                Image = ItemTrackingLines;
                ShortcutKey = 'Shift+Ctrl+I';
                ToolTip = 'Executes the Item &Tracking Lines action.';

                trigger OnAction();
                begin
                    Rec.OpenItemTrackingLines;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowexRec: Boolean)
    var
        myInt: Integer;
    begin
        vG_AutoTrackingAttention := false;
    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //+TAL0.1
        vG_AutoTrackingAttention := false;
        if IsAutoLot then begin
            if not FindItemTrackingQty(Rec) then begin
                vG_AutoTrackingAttention := true;
                // CurrForm.Quantity.UPDATEFORECOLOR(255);
            end;
        end;
        //-TAL0.1
        StyleTxt := SetStyle;
    end;

    procedure IsAutoLot(): Boolean;
    var
        rL_WarehouseSetup: Record "Warehouse Setup";
        rL_Item: Record Item;
    begin
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') and (Rec.Quantity <> 0) then begin

            //+TAL0.4
            if rL_Item.GET(Rec."No.") then begin
                if rL_Item."Item Tracking Code" = '' then begin
                    exit(false);
                end;
            end;
            //-TAL0.4

            exit(true);

        end else begin
            exit(false);
        end;
    end;

    procedure FindItemTrackingQty(var pPurchaseLine: Record "Purchase Line"): Boolean;
    var
        rL_ReservationEntry: Record "Reservation Entry";
        rL_WarehouseSetup: Record "Warehouse Setup";
        rL_TrackingSpecification: Record "Tracking Specification";
    begin
        rL_WarehouseSetup.Get;

        //check unposted
        rL_ReservationEntry.Reset;
        rL_ReservationEntry.SetFilter("Item No.", pPurchaseLine."No.");
        rL_ReservationEntry.SetFilter("Location Code", pPurchaseLine."Location Code");
        rL_ReservationEntry.SetFilter("Source Type", '39');
        //rL_ReservationEntry."Source Subtype"
        rL_ReservationEntry.SetFilter("Source ID", pPurchaseLine."Document No.");
        rL_ReservationEntry.SetRange("Source Ref. No.", pPurchaseLine."Line No.");

        //rL_ReservationEntry.SETRANGE(Quantity,  pPurchaseLine.Quantity);
        if rL_ReservationEntry.FindSet then begin
            exit(true);
        end;


        //check Posted
        rL_TrackingSpecification.Reset;
        rL_TrackingSpecification.SetFilter("Item No.", pPurchaseLine."No.");
        rL_TrackingSpecification.SetFilter("Location Code", pPurchaseLine."Location Code");
        rL_TrackingSpecification.SetFilter("Source Type", '39');
        rL_TrackingSpecification.SetFilter("Source ID", pPurchaseLine."Document No.");
        rL_TrackingSpecification.SetRange("Source Ref. No.", pPurchaseLine."Line No.");
        //rL_TrackingSpecification.SETRANGE("Quantity (Base)",  pPurchaseLine.Quantity);
        if rL_TrackingSpecification.FindSet then begin
            exit(true);
        end;

        exit(false);
    end;


    procedure SetStyle(): Text;
    begin
        if vG_AutoTrackingAttention then
            exit('Attention');
        exit('');
    end;

    var
        vG_AutoTrackingAttention: Boolean;
        StyleTxt: Text;

}