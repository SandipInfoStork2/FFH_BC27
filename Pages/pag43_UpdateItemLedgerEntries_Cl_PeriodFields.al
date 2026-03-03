page 50043 "Item Ledger Entry - Update"
{
    Caption = 'Item Ledger Entry - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    Permissions = tabledata "Item Ledger Entry" = rm;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the FA Entry number. You cannot change the number because the document has already been posted.';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the item in the entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies a description of the entry.';
                }


                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the entry''s posting date.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the quantity in the Quantity field that remains to be processed.';
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies whether the entry has been fully applied to.';
                }

                /*
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = Basic, Suite;
                }

                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Shpt. Method Code"; "Shpt. Method Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Country/Region of Origin Code"; "Country/Region of Origin Code")
                {
                    ApplicationArea = Basic, Suite;
                }


                field("Entry/Exit Point"; "Entry/Exit Point")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Area"; "Area")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                */

            }

        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        xItemLedgerEntry := Rec;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ILE: Record "Item Ledger Entry";
    begin
        if CloseAction = Action::LookupOK then
            if RecordChanged() then begin
                ILE := Rec;
                ILE.LockTable();
                ILE.Find();

                ILE."Remaining Quantity" := Rec."Remaining Quantity";
                ILE.Open := Rec.Open;
                /*
                ILE."Country/Region Code" := "Country/Region Code";
                ILE."Transaction Type" := "Transaction Type";
                ILE."Transport Method" := "Transport Method";
                ILE."Entry/Exit Point" := "Entry/Exit Point";
                ILE."Area" := "Area";
                ILE."Transaction Specification" := "Transaction Specification";
                ILE."Shpt. Method Code" := "Shpt. Method Code";
                ILE."Country/Region of Origin Code" := "Country/Region of Origin Code";
                */
                ILE.TestField("Entry No.", Rec."Entry No.");
                ILE.Modify();
            end;
        //CODEUNIT.Run(CODEUNIT::"Sales Invoice Hdr. - Edit", Rec);
    end;

    var
        xItemLedgerEntry: Record "Item Ledger Entry";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged := (Rec."Remaining Quantity" <> xItemLedgerEntry."Remaining Quantity") or
        (Rec.Open <> xItemLedgerEntry.Open)

        /*
        IsChanged :=
           ("Country/Region Code" <> xItemLedgerEntry."Country/Region Code") or
             ("Transaction Type" <> xItemLedgerEntry."Transaction Type") or
               ("Transport Method" <> xItemLedgerEntry."Transport Method") or
                 ("Entry/Exit Point" <> xItemLedgerEntry."Entry/Exit Point") or
                   ("Area" <> xItemLedgerEntry."Area") or
                     ("Transaction Specification" <> xItemLedgerEntry."Transaction Specification") or
                       ("Shpt. Method Code" <> xItemLedgerEntry."Shpt. Method Code") or
                        ("Country/Region of Origin Code" <> xItemLedgerEntry."Country/Region of Origin Code");
                        */
    end;


    procedure SetRec(ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        Rec := ItemLedgerEntry;
        Rec.Insert();
    end;

}

//"Country/Region Code"; Code[10]
//"Transaction Type"; Code[10]
//"Transport Method"; Code[10]
//"Entry/Exit Point"; Code[10]
//"Area"
//"Transaction Specification"
//"Shpt. Method Code"
//"Transaction Quantity"




