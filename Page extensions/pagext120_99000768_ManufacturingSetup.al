/*
TAL0.1 2022/01/11 VC add field Zero Date Component Formula

*/
pageextension 50220 ManufacturingSetupExt extends "Manufacturing Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(Planning)
        {
            group(Other)
            {
                field("Zero Date Component Formula"; Rec."Zero Date Component Formula")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Zero Date Component Formula';
                }
                field("Mandatory Output Posting"; Rec."Mandatory Output Posting")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Mandatory Output Posting';
                }
                //+1.0.0.229
                field("Mandatory Packing Agent"; Rec."Mandatory Packing Agent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: Mandatory Packing Agent';
                }
                //-1.0.0.229

                //+1.0.0.237
                field("skip MatrOrCapConsumpExists"; Rec."skip MatrOrCapConsumpExists")
                {
                    ApplicationArea = All;
                    ToolTip = 'Custom: skip MatrOrCapConsumpExists. When Output journal is posted and reversed, allow to change status to finish.';
                }
                //-1.0.0.237
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