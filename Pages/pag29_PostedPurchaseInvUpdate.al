page 50029 "Posted Purchase Line - Update"
{
    Caption = 'Posted Purchase Invoice Line - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Purch. Inv. Line";
    SourceTableTemporary = true;
    Permissions = TableData "Purch. Inv. Line" = m;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; rG_PurchInvoiceHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Buy-from Vendor Name"; rG_PurchInvoiceHeader."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor';
                    Editable = false;
                    ToolTip = 'Specifies the name of vendor at the buy-from address.';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';

                field(OldDescription; xPurchInvoiceLine.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Old Description';
                    ToolTip = 'Custom: Description';
                    Editable = false;
                }

                field(Description; rec.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Description';
                    ToolTip = 'Custom: Description';
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
        xPurchInvoiceLine := Rec;
        rG_PurchInvoiceHeader.GET(xPurchInvoiceLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_PurchInvoiceLine: Record "Purch. Inv. Line";
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged then begin
                rL_PurchInvoiceLine.GET(rec."Document No.", rec."Line No.");
                rL_PurchInvoiceLine.Description := Rec.Description;
                rL_PurchInvoiceLine.Modify();
            end;
    end;

    var
        xPurchInvoiceLine: Record "Purch. Inv. Line";
        rG_PurchInvoiceHeader: Record "Purch. Inv. Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
         (rec."Description" <> xPurchInvoiceLine."Description");


        OnAfterRecordChanged(Rec, xPurchInvoiceLine, IsChanged);
    end;

    procedure SetRec(PurchInvoiceLine: Record "Purch. Inv. Line")
    begin
        Rec := PurchInvoiceLine;
        rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var PurchInvoiceLine: Record "Purch. Inv. Line"; xPurchInvoiceLine: Record "Purch. Inv. Line"; var IsChanged: Boolean)
    begin
    end;
}