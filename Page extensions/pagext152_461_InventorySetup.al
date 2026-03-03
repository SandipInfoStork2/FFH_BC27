pageextension 50252 InventorySetupExt extends "Inventory Setup"
{
    layout
    {
        // Add changes to page layout here
        //addafter("Use Item References")
        addafter("Prevent Negative Inventory")
        {
            field("Allow Change Tracking Code"; Rec."Allow Change Tracking Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Allow Change Tracking Code field.';
            }
            field("Notify Expired Items Email 1"; Rec."Notify Expired Items Email 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 1 field.';
            }
            field("Notify Expired Items Email 2"; Rec."Notify Expired Items Email 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 2 field.';
            }
            field("Notify Expired Items Email 3"; Rec."Notify Expired Items Email 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 3 field.';

            }
            field("Notify Expired Items Email 4"; Rec."Notify Expired Items Email 4")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 4 field.';
            }
            field("Notify Expired Items Email 5"; Rec."Notify Expired Items Email 5")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 5 field.';
            }
            field("Notify Expired Items Email 6"; Rec."Notify Expired Items Email 6")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Expired Items Email 6 field.';
            }

        }

        addafter(Numbering)
        {
            group(Other)
            {

                field("Allow Item Trac. Code Change"; Rec."Allow Item Trac. Code Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Allow Item Tracking Code Change on Item Card.';
                }
            }

            group("Item Categories Caption")
            {

                field("Item Cat. 10 Caption"; Rec."Item Cat. 10 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 10 Caption field.';
                }

                field("Item Cat. 11 Caption"; Rec."Item Cat. 11 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 11 Caption field.';
                }
                field("Item Cat. 12 Caption"; Rec."Item Cat. 12 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 12 Caption field.';
                }
                field("Item Cat. 13 Caption"; Rec."Item Cat. 13 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 13 Caption field.';
                }
                field("Item Cat. 14 Caption"; Rec."Item Cat. 14 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 14 Caption field.';
                }
                field("Item Cat. 15 Caption"; Rec."Item Cat. 15 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 15 Caption field.';
                }
                field("Item Cat. 16 Caption"; Rec."Item Cat. 16 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 16 Caption field.';
                }
                field("Item Cat. 17 Caption"; Rec."Item Cat. 17 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 17 Caption field.';
                }
                field("Item Cat. 18 Caption"; Rec."Item Cat. 18 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 18 Caption field.';
                }
                field("Item Cat. 19 Caption"; Rec."Item Cat. 19 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 19 Caption field.';
                }
                field("Item Cat. 20 Caption"; Rec."Item Cat. 20 Caption")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Cat. 20 Caption field.';
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