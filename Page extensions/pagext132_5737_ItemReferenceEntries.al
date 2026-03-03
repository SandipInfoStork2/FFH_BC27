pageextension 50232 ItemReferenceEntriesExt extends "Item Reference Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Unit of Measure")
        {
            field("Package Qty"; Rec."Package Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package Qty field.';
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 3 field.';
            }
            field("Category 2"; Rec."Category 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product No. field.';
            }

            field("S. Quote Description"; Rec."S. Quote Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the S. Quote Description field.';
            }
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
            field("Item Description 2 (GR)"; Rec."Item Description 2 (GR)")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description 2 (GR) field.';
            }
            field(Discontinued; Rec.Discontinued)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Discontinued field.';
            }

            field(Package; Rec.Package)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Package field.';
            }
            field(EAN; Rec.EAN)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Barcode field.';
            }
            field("Family Code"; Rec."Family Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Family Code field.';
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
                Caption = 'History';
                Image = History;
                ToolTip = 'Executes the History action.';
                trigger OnAction()
                var
                    SalesLine: Record "Sales Line";

                begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetFilter("Item Reference No.", Rec."Reference No.");
                    if SalesLine.FindSet() then;
                    Page.Run(Page::"Sales Quote Lidl Lines", SalesLine);
                end;

            }

            action(Recpount)
            {
                ApplicationArea = All;
                Caption = '';
                ToolTip = 'Executes the Recpount action.';

                trigger OnAction()
                begin
                    message('# records: ' + Format(Rec.count))
                end;
            }
        }


    }

    var
        myInt: Integer;
}