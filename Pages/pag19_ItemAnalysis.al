page 50019 "Item Analysis"
{
    // TAL0.1 2021/04/08 VC REquest from koulis for coc
    // TAL0.2 2021/04/09 VC add Balance BF/ CF
    // TAL0.3 2021/04/09 VC Balance BF -1D
    // TAL0.4 2021/04/28 VC add location filter
    // TAL0.5 2021/10/25 VC Review Start Date Filter, after COC meeting to start from 01/09
    // TAL0.6 2021/10/25 VC Item Analysis add Set Ascending when showing Production BOM RFV-00045 to appear first
    // TAL0.7 2021/10/25 VC add Related Information Item Card
    // TAL0.8 2021/10/26 VC add column Transfer (Qty.) ILE

    CardPageId = "Item Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Item;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the item.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Base Unit of Measure';
                }
                field(vG_Balance_BF; vG_Qty_BF)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + vG_BalanceCaption_BF;
                    Caption = 'vG_Balance_BF';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the vG_Balance_BF field.';

                    trigger OnDrillDown();
                    begin
                        Page.Run(Page::"Item Ledger Entries", rG_ILE_BF);
                    end;
                }
                field("Purchases (Qty.) ILE"; Rec."Purchases (Qty.) ILE")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'Purchases (Qty.)',
                                ENU = 'Purchases (Qty.)';
                    ToolTip = 'Specifies the value of the Purchases (Qty.) ILE field.';
                }
                field("Sales (Qty.) ILE"; Rec."Sales (Qty.) ILE")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'Sales (Qty.)',
                                ENU = 'Sales (Qty.)';
                    ToolTip = 'Specifies the value of the Sales (Qty.) ILE field.';
                }
                field("Consumption (Qty.)"; Rec."Consumption (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Consumption (Qty.) field.';
                }
                field("Output (Qty.)"; Rec."Output (Qty.)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Output (Qty.) field.';
                }
                field("Positive Adjmt. (Qty.) ILE"; Rec."Positive Adjmt. (Qty.) ILE")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'Positive Adjmt. (Qty.)',
                                ENU = 'Positive Adjmt. (Qty.)';
                    ToolTip = 'Specifies the value of the Positive Adjmt. (Qty.) ILE field.';
                }
                field("Negative Adjmt. (Qty.) ILE"; Rec."Negative Adjmt. (Qty.) ILE")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'Negative Adjmt. (Qty.)',
                                ENU = 'Negative Adjmt. (Qty.)';
                    ToolTip = 'Specifies the value of the Negative Adjmt. (Qty.) ILE field.';
                }
                field("Transfer (Qty.) ILE"; Rec."Transfer (Qty.) ILE")
                {
                    ApplicationArea = All;
                    CaptionML = ELL = 'Transfer (Qty.)',
                                ENU = 'Transfer (Qty.)';
                    ToolTip = 'Specifies the value of the Transfer (Qty.) ILE field.';
                }
                field(vG_Balance_CF; vG_Qty_CF)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + vG_BalanceCaption_CF;
                    Caption = 'vG_Balance_CF';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the vG_Balance_CF field.';

                    trigger OnDrillDown();
                    begin
                        Page.Run(Page::"Item Ledger Entries", rG_ILE_CF);
                    end;
                }
                field(vG_Qty_NetChange; vG_Qty_NetChange)
                {
                    ApplicationArea = All;
                    CaptionClass = '3,' + vG_BalanceCaption_NetChange;
                    Caption = 'vG_Qty_NetChange';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Ambiguous;
                    StyleExpr = true;
                    ToolTip = 'Specifies the value of the vG_Qty_NetChange field.';

                    trigger OnDrillDown();
                    begin
                        Page.Run(Page::"Item Ledger Entries", rG_ILE_NetChange);
                    end;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example an item that is placed in quarantine.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Item)
            {
                Caption = 'Item';
                action("Item Card ")
                {
                    ApplicationArea = All;
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Item Card";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the Item Card  action.';
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        rG_LocationFilter := Rec.GETFILTER("Location Filter"); //TAL0.4


        vG_Date_BF := Rec.GETRANGEMIN("Date Filter");
        vG_Date_BF_Previous := CalcDate('-1D', vG_Date_BF); //TAL0.3
        vG_Date_CF := Rec.GETRANGEMAX("Date Filter");

        vG_BalanceCaption_BF := 'Balance B/F ' + Format(vG_Date_BF_Previous); //TAL0.3
        vG_BalanceCaption_CF := 'Balance C/F ' + Format(vG_Date_CF);

        vG_BalanceCaption_NetChange := 'Net Change ' + Format(vG_Date_BF) + '..' + Format(vG_Date_CF);

        vG_Qty_BF := 0;
        rG_ILE_BF.Reset;
        rG_ILE_BF.SETFILTER("Item No.", Rec."No.");
        rG_ILE_BF.SetFilter("Posting Date", '..' + Format(vG_Date_BF_Previous)); //TAL0.3
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_BF.SetFilter("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_BF.FindSet then begin
            rG_ILE_BF.CalcSums(Quantity);
            vG_Qty_BF := rG_ILE_BF.Quantity;
        end;


        vG_Qty_CF := 0;
        rG_ILE_CF.Reset;
        rG_ILE_CF.SETFILTER("Item No.", Rec."No.");
        rG_ILE_CF.SetFilter("Posting Date", '..' + Format(vG_Date_CF));
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_CF.SetFilter("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_CF.FindSet then begin
            rG_ILE_CF.CalcSums(Quantity);
            vG_Qty_CF := rG_ILE_CF.Quantity;
        end;


        vG_Qty_NetChange := 0;
        rG_ILE_NetChange.Reset;
        rG_ILE_NetChange.SETFILTER("Item No.", Rec."No.");
        rG_ILE_NetChange.SetRange("Posting Date", vG_Date_BF, vG_Date_CF);
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_NetChange.SetFilter("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_NetChange.FindSet then begin
            rG_ILE_NetChange.CalcSums(Quantity);
            vG_Qty_NetChange := rG_ILE_NetChange.Quantity;
        end;
    end;

    trigger OnOpenPage();
    var
        vL_StartYear: Date;
        vL_EndYear: Date;
        vL_CurrentYear: Integer;
    begin
        vL_CurrentYear := Date2DMY(WorkDate, 3);

        //+TAL0.5
        //vL_StartYear:=DMY2DATE(1,1,vL_CurrentYear);
        //vL_EndYear:=DMY2DATE(31,12,vL_CurrentYear);

        vL_StartYear := CalcDate('<-CM>-1M', WorkDate); //MY2DATE(1,9,vL_CurrentYear);
        vL_EndYear := WorkDate;
        //-TAL0.5


        Rec.SETFILTER("Date Filter", Format(vL_StartYear) + '..' + Format(vL_EndYear));
    end;

    var
        vG_Date_BF_Previous: Date;
        vG_Date_BF: Date;
        vG_Date_CF: Date;
        vG_BalanceCaption_BF: Text;
        vG_BalanceCaption_CF: Text;
        vG_BalanceCaption_NetChange: Text;
        rG_ILE_BF: Record "Item Ledger Entry";
        rG_ILE_CF: Record "Item Ledger Entry";
        rG_ILE_NetChange: Record "Item Ledger Entry";
        vG_Qty_BF: Decimal;
        vG_Qty_CF: Decimal;
        vG_Qty_NetChange: Decimal;
        rG_LocationFilter: Text;

    procedure SetAscending();
    begin
        Rec.ASCENDING(false); //TAL0.6
    end;
}

