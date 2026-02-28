pageextension 50232 ItemReferenceEntriesExt extends "Item Reference Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure")
        {
            field("Package Qty"; "Package Qty")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; "Description 3")
            {
                ApplicationArea = all;
            }
            field("Category 2"; "Category 2")
            {
                ApplicationArea = all;
            }

            field("S. Quote Description"; "S. Quote Description")
            {
                ApplicationArea = all;
            }
            field("Item Description"; "Item Description")
            {
                ApplicationArea = all;
            }
            field("Item Description 2 (GR)"; "Item Description 2 (GR)")
            {
                ApplicationArea = all;
            }
            field(Discontinued; Discontinued)
            {
                ApplicationArea = all;
            }

            field(Package; Package)
            {
                ApplicationArea = all;
            }
            field(EAN; EAN)
            {
                ApplicationArea = all;
            }
            field("Family Code"; "Family Code")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here

        addlast(Navigation)
        {
            action(History)
            {
                ApplicationArea = All;
                caption = 'History';
                Image = History;
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";

                begin
                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("Item Reference No.", "Reference No.");
                    if SalesLine.FindSet() then;
                    page.Run(page::"Sales Quote Lidl Lines", SalesLine);
                end;

            }

            action(Recpount)
            {
                ApplicationArea = All;
                Caption = '';

                trigger OnAction()
                begin
                    message('# records: ' + Format(count))
                end;
            }
        }


    }

    var
        myInt: Integer;
}