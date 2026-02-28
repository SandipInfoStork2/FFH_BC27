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

    CardPageID = "Item Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = all;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field(vG_Balance_BF; vG_Qty_BF)
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + vG_BalanceCaption_BF;
                    Caption = 'vG_Balance_BF';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnDrillDown();
                    begin
                        PAGE.RUN(PAGE::"Item Ledger Entries", rG_ILE_BF);
                    end;
                }
                field("Purchases (Qty.) ILE"; "Purchases (Qty.) ILE")
                {
                    ApplicationArea = all;
                    CaptionML = ELL = 'Purchases (Qty.)',
                                ENU = 'Purchases (Qty.)';
                }
                field("Sales (Qty.) ILE"; "Sales (Qty.) ILE")
                {
                    ApplicationArea = all;
                    CaptionML = ELL = 'Sales (Qty.)',
                                ENU = 'Sales (Qty.)';
                }
                field("Consumption (Qty.)"; "Consumption (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Output (Qty.)"; "Output (Qty.)")
                {
                    ApplicationArea = all;
                }
                field("Positive Adjmt. (Qty.) ILE"; "Positive Adjmt. (Qty.) ILE")
                {
                    ApplicationArea = all;
                    CaptionML = ELL = 'Positive Adjmt. (Qty.)',
                                ENU = 'Positive Adjmt. (Qty.)';
                }
                field("Negative Adjmt. (Qty.) ILE"; "Negative Adjmt. (Qty.) ILE")
                {
                    ApplicationArea = all;
                    CaptionML = ELL = 'Negative Adjmt. (Qty.)',
                                ENU = 'Negative Adjmt. (Qty.)';
                }
                field("Transfer (Qty.) ILE"; "Transfer (Qty.) ILE")
                {
                    ApplicationArea = all;
                    CaptionML = ELL = 'Transfer (Qty.)',
                                ENU = 'Transfer (Qty.)';
                }
                field(vG_Balance_CF; vG_Qty_CF)
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + vG_BalanceCaption_CF;
                    Caption = 'vG_Balance_CF';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnDrillDown();
                    begin
                        PAGE.RUN(PAGE::"Item Ledger Entries", rG_ILE_CF);
                    end;
                }
                field(vG_Qty_NetChange; vG_Qty_NetChange)
                {
                    ApplicationArea = all;
                    CaptionClass = '3,' + vG_BalanceCaption_NetChange;
                    Caption = 'vG_Qty_NetChange';
                    DecimalPlaces = 0 : 0;
                    Editable = false;
                    Style = Ambiguous;
                    StyleExpr = TRUE;

                    trigger OnDrillDown();
                    begin
                        PAGE.RUN(PAGE::"Item Ledger Entries", rG_ILE_NetChange);
                    end;
                }
                field(Inventory; Inventory)
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("Inventory Posting Group"; "Inventory Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Item)
            {
                Caption = 'Item';
                action("Item Card ")
                {
                    ApplicationArea = all;
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Item Card";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        rG_LocationFilter := GETFILTER("Location Filter"); //TAL0.4


        vG_Date_BF := GETRANGEMIN("Date Filter");
        vG_Date_BF_Previous := CALCDATE('-1D', vG_Date_BF); //TAL0.3
        vG_Date_CF := GETRANGEMAX("Date Filter");

        vG_BalanceCaption_BF := 'Balance B/F ' + FORMAT(vG_Date_BF_Previous); //TAL0.3
        vG_BalanceCaption_CF := 'Balance C/F ' + FORMAT(vG_Date_CF);

        vG_BalanceCaption_NetChange := 'Net Change ' + FORMAT(vG_Date_BF) + '..' + FORMAT(vG_Date_CF);

        vG_Qty_BF := 0;
        rG_ILE_BF.RESET;
        rG_ILE_BF.SETFILTER("Item No.", "No.");
        rG_ILE_BF.SETFILTER("Posting Date", '..' + FORMAT(vG_Date_BF_Previous)); //TAL0.3
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_BF.SETFILTER("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_BF.FINDSET then begin
            rG_ILE_BF.CALCSUMS(Quantity);
            vG_Qty_BF := rG_ILE_BF.Quantity;
        end;


        vG_Qty_CF := 0;
        rG_ILE_CF.RESET;
        rG_ILE_CF.SETFILTER("Item No.", "No.");
        rG_ILE_CF.SETFILTER("Posting Date", '..' + FORMAT(vG_Date_CF));
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_CF.SETFILTER("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_CF.FINDSET then begin
            rG_ILE_CF.CALCSUMS(Quantity);
            vG_Qty_CF := rG_ILE_CF.Quantity;
        end;


        vG_Qty_NetChange := 0;
        rG_ILE_NetChange.RESET;
        rG_ILE_NetChange.SETFILTER("Item No.", "No.");
        rG_ILE_NetChange.SETRANGE("Posting Date", vG_Date_BF, vG_Date_CF);
        //+TAL0.4
        if rG_LocationFilter <> '' then begin
            rG_ILE_NetChange.SETFILTER("Location Code", rG_LocationFilter);
        end;
        //-TAL0.4
        if rG_ILE_NetChange.FINDSET then begin
            rG_ILE_NetChange.CALCSUMS(Quantity);
            vG_Qty_NetChange := rG_ILE_NetChange.Quantity;
        end;
    end;

    trigger OnOpenPage();
    var
        vL_StartYear: Date;
        vL_EndYear: Date;
        vL_CurrentYear: Integer;
    begin
        vL_CurrentYear := DATE2DMY(WORKDATE, 3);

        //+TAL0.5
        //vL_StartYear:=DMY2DATE(1,1,vL_CurrentYear);
        //vL_EndYear:=DMY2DATE(31,12,vL_CurrentYear);

        vL_StartYear := CALCDATE('<-CM>-1M', WORKDATE); //MY2DATE(1,9,vL_CurrentYear);
        vL_EndYear := WORKDATE;
        //-TAL0.5


        SETFILTER("Date Filter", FORMAT(vL_StartYear) + '..' + FORMAT(vL_EndYear));
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
        ASCENDING(false); //TAL0.6
    end;
}

