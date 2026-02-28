page 50006 "Purchase Order Subform Addon P"
{
    // version NAVW17.00

    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line Addon Posted";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Cross-Reference No."; "Cross-Reference No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IC Partner Code"; "IC Partner Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IC Partner Ref. Type"; "IC Partner Ref. Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("IC Partner Reference"; "IC Partner Reference")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Variant Code"; "Variant Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Nonstock; Nonstock)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Drop Shipment"; "Drop Shipment")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Return Reason Code"; "Return Reason Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Reserved Quantity"; "Reserved Quantity")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Job Remaining Qty."; "Job Remaining Qty.")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Direct Unit Cost"; "Direct Unit Cost")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Indirect Cost %"; "Indirect Cost %")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Unit Price (LCY)"; "Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Visible = false;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Line Discount %"; "Line Discount %")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Line Discount Amount"; "Line Discount Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prepayment %"; "Prepayment %")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prepmt. Line Amount"; "Prepmt. Line Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prepmt. Amt. Inv."; "Prepmt. Amt. Inv.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Allow Invoice Disc."; "Allow Invoice Disc.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Inv. Discount Amount"; "Inv. Discount Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. to Receive"; "Qty. to Receive")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Quantity Received"; "Quantity Received")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Qty. to Invoice"; "Qty. to Invoice")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Quantity Invoiced"; "Quantity Invoiced")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Prepmt Amt to Deduct"; "Prepmt Amt to Deduct")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prepmt Amt Deducted"; "Prepmt Amt Deducted")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Allow Item Charge Assignment"; "Allow Item Charge Assignment")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Qty. to Assign"; "Qty. to Assign")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Qty. Assigned"; "Qty. Assigned")
                {
                    ApplicationArea = All;
                    BlankZero = true;
                }
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Planning Line No."; "Job Planning Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Type"; "Job Line Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Unit Price"; "Job Unit Price")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Amount"; "Job Line Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Discount Amount"; "Job Line Discount Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Discount %"; "Job Line Discount %")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Total Price"; "Job Total Price")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Unit Price (LCY)"; "Job Unit Price (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Total Price (LCY)"; "Job Total Price (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Amount (LCY)"; "Job Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Job Line Disc. Amount (LCY)"; "Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Promised Receipt Date"; "Promised Receipt Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Planned Receipt Date"; "Planned Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = All;
                }
                field("Lead Time Calculation"; "Lead Time Calculation")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Planning Flexibility"; "Planning Flexibility")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prod. Order No."; "Prod. Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Prod. Order Line No."; "Prod. Order Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Operation No."; "Operation No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Work Center No."; "Work Center No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Finished; Finished)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)"; "Whse. Outstanding Qty. (Base)")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Inbound Whse. Handling Time"; "Inbound Whse. Handling Time")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Blanket Order No."; "Blanket Order No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Blanket Order Line No."; "Blanket Order Line No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Appl.-to Item Entry"; "Appl.-to Item Entry")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("ShortcutDimCode[3]"; ShortcutDimCode[3])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,3';
                    Visible = false;
                }
                field("ShortcutDimCode[4]"; ShortcutDimCode[4])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,4';
                    Visible = false;
                }
                field("ShortcutDimCode[5]"; ShortcutDimCode[5])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,5';
                    Visible = false;
                }
                field("ShortcutDimCode[6]"; ShortcutDimCode[6])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,6';
                    Visible = false;
                }
                field("ShortcutDimCode[7]"; ShortcutDimCode[7])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,7';
                    Visible = false;
                }
                field("ShortcutDimCode[8]"; ShortcutDimCode[8])
                {
                    ApplicationArea = All;
                    CaptionClass = '1,2,8';
                    Visible = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean;
    var
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
    begin
    end;

    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ShortcutDimCode: array[8] of Code[20];
        UpdateAllowedVar: Boolean;
        Text000: Label 'Unable to execute this function while in view only mode.';
        PurchHeader: Record "Purchase Header Addon";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
        tPurchHeader: Record "Purchase Header Addon";

    procedure ApproveCalcInvDisc();
    begin
    end;

    procedure CalcInvDisc();
    begin
    end;

    procedure ExplodeBOM();
    begin
    end;

    procedure OpenSalesOrderForm();
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
    end;

    procedure InsertExtendedText(Unconditionally: Boolean);
    begin
    end;

    procedure ShowTracking();
    var
        TrackingForm: Page "Order Tracking";
    begin
    end;

    procedure OpenSpecOrderSalesOrderForm();
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
    begin
    end;

    procedure UpdateForm(SetSaveRecord: Boolean);
    begin
    end;

    procedure SetUpdateAllowed(UpdateAllowed: Boolean);
    begin
    end;

    procedure UpdateAllowed(): Boolean;
    begin
    end;

    procedure ShowPrices();
    begin
    end;

    procedure ShowLineDisc();
    begin
    end;

    local procedure NoOnAfterValidate();
    begin
    end;

    local procedure CrossReferenceNoOnAfterValidat();
    begin
    end;
}

