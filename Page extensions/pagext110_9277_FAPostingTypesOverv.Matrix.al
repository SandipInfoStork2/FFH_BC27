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
            field("Depreciation Starting Date"; Rec."Depreciation Starting Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which depreciation of the fixed asset starts.';
            }
            field("Depreciation Ending Date"; Rec."Depreciation Ending Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which depreciation of the fixed asset ends.';
            }
            field("Depreciation Method"; Rec."Depreciation Method")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how depreciation is calculated for the depreciation book.';
            }
            field("No. of Depreciation Years"; Rec."No. of Depreciation Years")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the length of the depreciation period, expressed in years.';
            }
            field("No. of Depreciation Months"; Rec."No. of Depreciation Months")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the length of the depreciation period, expressed in months.';
            }
            field("No. FA Acquisitions"; Rec."No. FA Acquisitions")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. FA Acquisitions field.';
            }
            field("No. FA Depreciations"; Rec."No. FA Depreciations")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. FA Depreciations field.';
            }
            field("No. FA Disposals"; Rec."No. FA Disposals")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the No. FA Disposals field.';
            }
            field("Straight-Line %"; Rec."Straight-Line %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the percentage to depreciate the fixed asset by the straight-line principle, but with a fixed yearly percentage.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addfirst(Processing)
        {
            action("Count")
            {
                ApplicationArea = All;
                ToolTip = 'Executes the Count action.';

                trigger OnAction();
                begin
                    MESSAGE('# Record: ' + FORMAT(Rec.COUNT));
                end;
            }
        }
    }

    var
        myInt: Integer;
}