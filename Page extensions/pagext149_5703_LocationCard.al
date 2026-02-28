

pageextension 50249 LocationCardExt extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Name 2"; "Name 2")
            {
                ApplicationArea = all;
            }

        }
        //TAL 1.0.0.95 >>
        addafter("E-Mail")
        {
            field("Email CC"; "Email CC")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Email CC';
            }

            field("Work Order Email"; "Work Order Email")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email';
            }

            field("Work Order Email 2"; "Work Order Email 2")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email 2';
            }

            field("Work Order Email 3"; "Work Order Email 3")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email 3';
            }
            field("Work Order Email CC"; "Work Order Email CC")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC';
            }

            field("Work Order Email CC 2"; "Work Order Email CC 2")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC 3';
            }

            field("Work Order Email CC 3"; "Work Order Email CC 3")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Work Order Email CC 3';
            }
        }
        //TAL 1.0.0.95 <<

        addafter("Use As In-Transit")
        {
            field("Default Reason Code"; "Default Reason Code")
            {
                ApplicationArea = All;
            }

            //+1.0.0.293
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
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