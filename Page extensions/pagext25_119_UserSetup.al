/*
TAL.JQEMail 2017/11/20 VC add field Job Queue Email
TAL0.1 2018/01/10 VC add fields User Department
TAL0.2 2019/12/06 VC add field Close Inventory Period

*/
pageextension 50125 UserSetupExt extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        modify(Email)
        {
            Visible = true;
        }

        addafter("Time Sheet Admin.")
        {
            field("Job Queue Email"; "Job Queue Email")
            {
                ApplicationArea = All;
            }
            field("User Department"; "User Department")
            {
                ApplicationArea = All;
            }
            field("Close Inventory Period"; "Close Inventory Period")
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.69 >>
        addafter(Email)
        {
            field(Name; Name)
            {
                ApplicationArea = All;
                Tooltip = 'Custom: Name';
            }
            //+1.0.0.228
            field("Unit Cost Editable"; "Unit Cost Editable")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Unit Cost Editable/Visible';
            }
            //-1.0.0.228

            field("HORECA Customer No."; "HORECA Customer No.")
            {
                ApplicationArea = All;
            }
            field("HORECA Ship-to Filter"; "HORECA Ship-to Filter")
            {
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean

                var
                    ShiptoAddress: Record "Ship-to Address";
                begin

                    ShiptoAddress.RESET;
                    ShiptoAddress.SetFilter("Customer No.", Rec."HORECA Customer No.");
                    ShiptoAddress.SetFilter(Code, '%1', Rec."HORECA Ship-to Filter");
                    ShiptoAddress.SetRange(Blocked, false);
                    if ShiptoAddress.FindSet() then begin
                        PAGE.RUN(PAGE::"Ship-to Address List", ShiptoAddress);
                    end;

                end;
            }
            field("HORECA Items"; "HORECA Items")
            {
                ApplicationArea = All;

            }

            field("HORECA Min. Order Period"; "HORECA Min. Order Period")
            {
                ApplicationArea = All;
            }

            field("HORECA Manager Email 1"; "HORECA Manager Email 1")
            {
                ApplicationArea = All;
            }

            field("HORECA Manager Email 2"; "HORECA Manager Email 2")
            {
                ApplicationArea = All;
            }

            field("HORECA Manager Email 3"; "HORECA Manager Email 3")
            {
                ApplicationArea = All;
            }

            //+1.0.0.292
            field("HORECA Package Item No."; "HORECA Package Item No.")
            {
                ApplicationArea = All;
            }
            //-1.0.0.292
        }
        //TAL 1.0.0.69 <<
    }

    actions
    {
        // Add changes to page actions here
        //TAL 1.0.0.69 >>
        addlast(Navigation)
        {
            action(UserSetupCard)
            {
                ApplicationArea = All;
                Caption = 'User Setup Card';
                RunObject = page "User Setup Card";
                RunPageLink = "User ID" = field("User ID");
                Promoted = true;
                PromotedCategory = Process;

            }
        }
        //TAL 1.0.0.69 <<
    }

    var
        myInt: Integer;
}