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
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
            field("Extended Description"; "Extended Description")
            {
                ApplicationArea = All;
            }
            field("Replenishment System"; "Replenishment System")
            {
                ApplicationArea = All;
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