/*
TAL0.1 2021/04/02 VC add field Producer Group Name

*/
pageextension 50186 LotNoInformationListExt extends "Lot No. Information List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Item No.")
        {
            field("Item Description"; Rec."Item Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Description field.';
            }
        }

        addafter("Lot No.")
        {
            field("Category 1"; Rec."Category 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group field.';
            }
            field("Producer Group Name"; Rec."Producer Group Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Producer Group Name field.';
            }
            field("Grower No."; Rec."Grower No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower GGN field.';
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Vendor GLN"; Rec."Vendor GLN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GLN field.';
            }
            field("Vendor GGN"; Rec."Vendor GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GGN field.';
            }
        }

        addafter("Expired Inventory")
        {
            field("Category 4"; Rec."Category 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Product No. field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}