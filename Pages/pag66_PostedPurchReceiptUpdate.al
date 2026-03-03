page 50066 "Posted Purch. Receipt - Update"
{
    Caption = 'Posted Purch. Receipt - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Purch. Rcpt. Header";
    SourceTableTemporary = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor';
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor who shipped the items.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
            }

            group(QC)
            {
                Caption = 'Quality Control';
                field("Receiving Temperature"; Rec."Receiving Temperature")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Receiving Temperature °C field.';
                }
                field("Receiving Quality Control"; Rec."Receiving Quality Control")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Receiving Quality Control field.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        xPurchRcptHeader := Rec;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::LookupOK then
            if RecordChanged() then
                Codeunit.Run(Codeunit::"Purch. Rcpt. Header - Edit", Rec);
    end;

    var
        xPurchRcptHeader: Record "Purch. Rcpt. Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
            (Rec."Receiving Temperature" <> xPurchRcptHeader."Receiving Temperature") or
            (Rec."Receiving Quality Control" <> xPurchRcptHeader."Receiving Quality Control");

        OnAfterRecordChanged(Rec, xRec, IsChanged, xPurchRcptHeader);
    end;

    procedure SetRec(PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        Rec := PurchRcptHeader;
        Rec.Insert();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var PurchRcptHeader: Record "Purch. Rcpt. Header"; xPurchRcptHeader: Record "Purch. Rcpt. Header"; var IsChanged: Boolean; xPurchRcptHeaderGlobal: Record "Purch. Rcpt. Header")
    begin
    end;
}
