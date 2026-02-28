/*
TAL0.1 2019/05/17 VC add fields Inbound Req. Wksh,Outbound Req. Wksh

*/

pageextension 50101 LocationListExt extends "Location List"
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
            field("Inbound Req. Wksh"; "Inbound Req. Wksh")
            {
                ApplicationArea = all;
            }
            field("Outbound Req. Wksh"; "Outbound Req. Wksh")
            {
                ApplicationArea = all;
            }
            field("Last Posting Date"; "Last Posting Date")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        addafter("&Bins")
        {
            action("Ledger E&ntries")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Ledger E&ntries';
                Image = ItemLedger;
                Promoted = true;
                PromotedCategory = Category4;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category5;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Location Code" = FIELD("Code");
                RunPageView = SORTING("Item No.")
                                      ORDER(Descending);
                ShortCutKey = 'Ctrl+F7';
                ToolTip = 'View the history of transactions that have been posted for the selected record.';
            }

            action(UpdateLastPostingDate)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                caption = 'Update Last Posting Date';

                trigger OnAction()
                var
                    rL_ILE: Record "Item Ledger Entry";
                    rL_Location: Record Location;
                begin
                    rL_Location.RESET;
                    if rL_Location.FindSet() then begin
                        repeat
                            rL_ILE.RESET;
                            rL_ILE.SetFilter("Location Code", rL_Location.Code);
                            if rL_ILE.FindLast() then begin

                                rL_Location."Last Posting Date" := rL_ILE."Posting Date";

                            end else begin
                                rL_Location."Last Posting Date" := 0D;
                            end;

                            rL_Location.Modify();


                        until rL_Location.Next() = 0;
                    end;



                end;
            }
        }


    }

    var
        myInt: Integer;
}