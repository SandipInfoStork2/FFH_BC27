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
            field("Job Queue Email"; Rec."Job Queue Email")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Job Queue Email field.';
            }
            field("User Department"; Rec."User Department")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the User Department field.';
            }
            field("Close Inventory Period"; Rec."Close Inventory Period")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Close Inventory Period field.';
            }
        }
        //TAL 1.0.0.69 >>
        addafter(Email)
        {
            field(Name; Rec.Name)
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Name';
            }
            //+1.0.0.228
            field("Unit Cost Editable"; Rec."Unit Cost Editable")
            {
                ApplicationArea = All;
                ToolTip = 'Custom: Unit Cost Editable/Visible';
            }
            //-1.0.0.228

            field("HORECA Customer No."; Rec."HORECA Customer No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Customer No. field.';
            }
            field("HORECA Ship-to Filter"; Rec."HORECA Ship-to Filter")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Ship-to Filter field.';

                trigger OnLookup(var Text: Text): Boolean

                var
                    ShiptoAddress: Record "Ship-to Address";
                begin

                    ShiptoAddress.Reset;
                    ShiptoAddress.SetFilter("Customer No.", Rec."HORECA Customer No.");
                    ShiptoAddress.SetFilter(Code, '%1', Rec."HORECA Ship-to Filter");
                    ShiptoAddress.SetRange(Blocked, false);
                    if ShiptoAddress.FindSet() then begin
                        Page.Run(Page::"Ship-to Address List", ShiptoAddress);
                    end;

                end;
            }
            field("HORECA Items"; Rec."HORECA Items")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Items field.';

            }

            field("HORECA Min. Order Period"; Rec."HORECA Min. Order Period")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Min. Order Period field.';
            }

            field("HORECA Manager Email 1"; Rec."HORECA Manager Email 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Manager Email 1 field.';
            }

            field("HORECA Manager Email 2"; Rec."HORECA Manager Email 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Manager Email 2 field.';
            }

            field("HORECA Manager Email 3"; Rec."HORECA Manager Email 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Manager Email 3 field.';
            }

            //+1.0.0.292
            field("HORECA Package Item No."; Rec."HORECA Package Item No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the HORECA Package Item No. field.';
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
                ToolTip = 'Executes the User Setup Card action.';

            }
        }
        //TAL 1.0.0.69 <<
    }

    var
        myInt: Integer;
}