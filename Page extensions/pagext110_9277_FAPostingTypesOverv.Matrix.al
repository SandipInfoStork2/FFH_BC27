/*
TAL0.1 2022/01/05 VC add No. of Aquisitions

*/
pageextension 50210 FAPostingTypesOvervMatrixExt extends "FA Posting Types Overv. Matrix"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Depreciation Starting Date"; "Depreciation Starting Date")
            {
                ApplicationArea = all;
            }
            field("Depreciation Ending Date"; "Depreciation Ending Date")
            {
                ApplicationArea = all;
            }
            field("Depreciation Method"; "Depreciation Method")
            {
                ApplicationArea = all;
            }
            field("No. of Depreciation Years"; "No. of Depreciation Years")
            {
                ApplicationArea = all;
            }
            field("No. of Depreciation Months"; "No. of Depreciation Months")
            {
                ApplicationArea = all;
            }
            field("No. FA Acquisitions"; "No. FA Acquisitions")
            {
                ApplicationArea = all;
            }
            field("No. FA Depreciations"; "No. FA Depreciations")
            {
                ApplicationArea = all;
            }
            field("No. FA Disposals"; "No. FA Disposals")
            {
                ApplicationArea = all;
            }
            field("Straight-Line %"; "Straight-Line %")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(processing)
        {
            action("Count")
            {
                ApplicationArea = all;

                trigger OnAction();
                begin
                    MESSAGE('# Record: ' + FORMAT(COUNT));
                end;
            }
        }
    }

    var
        myInt: Integer;
}