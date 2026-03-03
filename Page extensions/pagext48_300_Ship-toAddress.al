/*
TAL0.1 2018/11/14 VC add field GLN Delivery for EDI

*/

pageextension 50148 ShiptoAddressExt extends "Ship-to Address"
{
    layout
    {
        // Add changes to page layout here

        addafter("Customer No.")
        {
            field("GLN Delivery"; Rec."GLN Delivery")
            {
                ApplicationArea = All;
                ShowMandatory = true;
                ToolTip = 'Specifies the value of the GLN Delivery field.';
            }
            field("Interface Code"; Rec."Interface Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Interface Code field.';
            }

            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Blocked field.';
            }
        }

        addafter(General)
        {
            group(DD)
            {
                Caption = 'Delivery Days';
                field(Monday; Rec.Monday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Monday field.';
                }
                field(Tuesday; Rec.Tuesday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Tuesday field.';
                }
                field(Wednesday; Rec.Wednesday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Wednesday field.';
                }
                field(Thursday; Rec.Thursday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Thursday field.';
                }
                field(Friday; Rec.Friday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Friday field.';
                }
                field(Saturday; Rec.Saturday)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Saturday field.';
                }
                field(Sunday; Rec.Sunday)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Sunday field.';
                }
            }
            field("Notify Place Order"; Rec."Notify Place Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Notify Place Order field.';
            }

            field("Shop Password"; Rec."Shop Password")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shop Password field.';
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