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
    Permissions = tabledata "Purch. Inv. Line" = m;
    ApplicationArea = All;

    layout
    {
        area(Content)
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
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

                field(Description; Rec.Description)
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
        rG_PurchInvoiceHeader.Get(xPurchInvoiceLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_PurchInvoiceLine: Record "Purch. Inv. Line";
    begin
        if CloseAction = Action::LookupOK then
            if RecordChanged then begin
                rL_PurchInvoiceLine.Get(Rec."Document No.", Rec."Line No.");
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
         (Rec.Description <> xPurchInvoiceLine.Description);


        OnAfterRecordChanged(Rec, xPurchInvoiceLine, IsChanged);
    end;

    procedure SetRec(PurchInvoiceLine: Record "Purch. Inv. Line")
    begin
        Rec := PurchInvoiceLine;
        Rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var PurchInvoiceLine: Record "Purch. Inv. Line"; xPurchInvoiceLine: Record "Purch. Inv. Line"; var IsChanged: Boolean)
    begin
    end;
}