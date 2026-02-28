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
    Permissions = TableData "Item Ledger Entry" = rm;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the FA Entry number. You cannot change the number because the document has already been posted.';
                }

                field("Item No."; "Item No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }


                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Open; Open)
                {
                    ApplicationArea = Basic, Suite;
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
        if CloseAction = ACTION::LookupOK then
            if RecordChanged() then begin
                ILE := Rec;
                ILE.LockTable();
                ILE.Find();

                ILE."Remaining Quantity" := "Remaining Quantity";
                ILE.Open := Open;
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
                ILE.TestField("Entry No.", "Entry No.");
                ILE.Modify();
            end;
        //CODEUNIT.Run(CODEUNIT::"Sales Invoice Hdr. - Edit", Rec);
    end;

    var
        xItemLedgerEntry: Record "Item Ledger Entry";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged := ("Remaining Quantity" <> xItemLedgerEntry."Remaining Quantity") or
        (Open <> xItemLedgerEntry.Open)

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
        Insert();
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




