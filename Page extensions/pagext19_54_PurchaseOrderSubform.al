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
            field("Auto Tracking Attention"; FORMAT(vG_AutoTrackingAttention))
            {
                ApplicationArea = All;
                Caption = 'Auto Tracking Attention';
                Editable = false;
                StyleExpr = StyleTxt;
            }
        }

        addafter("Bin Code")
        {
            field("Quantity (Base)"; "Quantity (Base)")
            {
                ApplicationArea = All;
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
            field("Unit of Measure (Base)"; "Unit of Measure (Base)")
            {
                ApplicationArea = All;
            }
        }

        //TAL 1.0.0.71 >>
        addafter("No.")
        {
            field("Variant Code02056"; Rec."Variant Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Net Weight")
        {
            field("VAT Prod. Posting Group16759"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
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
            }
            field("Transfer-to Code"; Rec."Transfer-to Code")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.201 <<

        addafter(ShortcutDimCode8)
        {
            field("Receiving Temperature"; "Receiving Temperature")
            {
                ApplicationArea = all;
            }
            field("Receiving Quality Control"; "Receiving Quality Control")
            {
                ApplicationArea = all;
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
                ShortCutKey = 'Shift+Ctrl+I';

                trigger OnAction();
                begin
                    OpenItemTrackingLines;
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
        if (Type = Type::Item) and ("No." <> '') and (Quantity <> 0) then begin

            //+TAL0.4
            if rL_Item.GET("No.") then begin
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
        rL_WarehouseSetup.GET;

        //check unposted
        rL_ReservationEntry.RESET;
        rL_ReservationEntry.SETFILTER("Item No.", pPurchaseLine."No.");
        rL_ReservationEntry.SETFILTER("Location Code", pPurchaseLine."Location Code");
        rL_ReservationEntry.SETFILTER("Source Type", '39');
        //rL_ReservationEntry."Source Subtype"
        rL_ReservationEntry.SETFILTER("Source ID", pPurchaseLine."Document No.");
        rL_ReservationEntry.SETRANGE("Source Ref. No.", pPurchaseLine."Line No.");

        //rL_ReservationEntry.SETRANGE(Quantity,  pPurchaseLine.Quantity);
        if rL_ReservationEntry.FINDSET then begin
            exit(true);
        end;


        //check Posted
        rL_TrackingSpecification.RESET;
        rL_TrackingSpecification.SETFILTER("Item No.", pPurchaseLine."No.");
        rL_TrackingSpecification.SETFILTER("Location Code", pPurchaseLine."Location Code");
        rL_TrackingSpecification.SETFILTER("Source Type", '39');
        rL_TrackingSpecification.SETFILTER("Source ID", pPurchaseLine."Document No.");
        rL_TrackingSpecification.SETRANGE("Source Ref. No.", pPurchaseLine."Line No.");
        //rL_TrackingSpecification.SETRANGE("Quantity (Base)",  pPurchaseLine.Quantity);
        if rL_TrackingSpecification.FINDSET then begin
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