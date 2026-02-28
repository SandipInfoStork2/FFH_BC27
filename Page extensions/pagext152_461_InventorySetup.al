pageextension 50252 InventorySetupExt extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Use Item References")
        {
            field("Allow Change Tracking Code"; "Allow Change Tracking Code")
            {
                ApplicationArea = all;
            }
            field("Notify Expired Items Email 1"; "Notify Expired Items Email 1")
            {
                ApplicationArea = all;
            }
            field("Notify Expired Items Email 2"; "Notify Expired Items Email 2")
            {
                ApplicationArea = all;
            }
            field("Notify Expired Items Email 3"; "Notify Expired Items Email 3")
            {
                ApplicationArea = all;

            }
            field("Notify Expired Items Email 4"; "Notify Expired Items Email 4")
            {
                ApplicationArea = all;
            }
            field("Notify Expired Items Email 5"; "Notify Expired Items Email 5")
            {
                ApplicationArea = all;
            }
            field("Notify Expired Items Email 6"; "Notify Expired Items Email 6")
            {
                ApplicationArea = all;
            }

        }

        addafter(Numbering)
        {
            group(Other)
            {

                field("Allow Item Trac. Code Change"; Rec."Allow Item Trac. Code Change")
                {
                    ApplicationArea = All;
                    Tooltip = 'Custom: Allow Item Tracking Code Change on Item Card.';
                }
            }

            group("Item Categories Caption")
            {

                field("Item Cat. 10 Caption"; Rec."Item Cat. 10 Caption")
                {
                    ApplicationArea = all;
                }

                field("Item Cat. 11 Caption"; Rec."Item Cat. 11 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 12 Caption"; Rec."Item Cat. 12 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 13 Caption"; Rec."Item Cat. 13 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 14 Caption"; Rec."Item Cat. 14 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 15 Caption"; Rec."Item Cat. 15 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 16 Caption"; Rec."Item Cat. 16 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 17 Caption"; Rec."Item Cat. 17 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 18 Caption"; Rec."Item Cat. 18 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 19 Caption"; Rec."Item Cat. 19 Caption")
                {
                    ApplicationArea = all;
                }
                field("Item Cat. 20 Caption"; Rec."Item Cat. 20 Caption")
                {
                    ApplicationArea = all;
                }
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