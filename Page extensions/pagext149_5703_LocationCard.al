

pageextension 50249 LocationCardExt extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name 2"; Rec."Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name 2 field.';
            }

        }
        //TAL 1.0.0.95 >>
        addafter("E-Mail")
        {
            field("Email CC"; Rec."Email CC")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Email CC';
            }

            field("Work Order Email"; Rec."Work Order Email")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email';
            }

            field("Work Order Email 2"; Rec."Work Order Email 2")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email 2';
            }

            field("Work Order Email 3"; Rec."Work Order Email 3")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email 3';
            }
            field("Work Order Email CC"; Rec."Work Order Email CC")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC';
            }

            field("Work Order Email CC 2"; Rec."Work Order Email CC 2")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC 3';
            }

            field("Work Order Email CC 3"; Rec."Work Order Email CC 3")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC 3';
            }
        }
        //TAL 1.0.0.95 <<

        addafter("Use As In-Transit")
        {
            field("Default Reason Code"; Rec."Default Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Default Reason Code field.';
            }

            //+1.0.0.293
            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Agent field.';
            }
            //-1.0.0.293
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter(Dimensions)
        {
            action(UpdateBin)
            {
                ApplicationArea = All;
                ToolTip = 'Executes the UpdateBin action.';


                trigger OnAction()

                var
                    ILE: Record "Item Ledger Entry";
                begin


                end;
            }
        }




    }

    var
        myInt: Integer;
}