/*
TAL0.1 2019/05/17 VC add fields Extended Description,Replenishment System

*/

pageextension 50143 StandardPurchaseCodeSubformExt extends "Standard Purchase Code Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description 2 field.';
            }
            field("Extended Description"; Rec."Extended Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Extended Description field.';
            }
            field("Replenishment System"; Rec."Replenishment System")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Replenishment System field.';
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