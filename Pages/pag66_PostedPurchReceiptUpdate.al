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

    layout
    {
        area(content)
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
                field("Receiving Temperature"; "Receiving Temperature")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Receiving Quality Control"; "Receiving Quality Control")
                {
                    ApplicationArea = all;
                    Editable = true;
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
        if CloseAction = ACTION::LookupOK then
            if RecordChanged() then
                CODEUNIT.Run(CODEUNIT::"Purch. Rcpt. Header - Edit", Rec);
    end;

    var
        xPurchRcptHeader: Record "Purch. Rcpt. Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
            ("Receiving Temperature" <> xPurchRcptHeader."Receiving Temperature") or
            ("Receiving Quality Control" <> xPurchRcptHeader."Receiving Quality Control");

        OnAfterRecordChanged(Rec, xRec, IsChanged, xPurchRcptHeader);
    end;

    [Scope('OnPrem')]
    procedure SetRec(PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        Rec := PurchRcptHeader;
        Insert();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var PurchRcptHeader: Record "Purch. Rcpt. Header"; xPurchRcptHeader: Record "Purch. Rcpt. Header"; var IsChanged: Boolean; xPurchRcptHeaderGlobal: Record "Purch. Rcpt. Header")
    begin
    end;
}
