/*
TAL0.1 2021/10/25 VC visible True,
                  "Document No.","Posting Date","Source No.","Source Name"
TAL0.2 2021/10/25 VC add action SetLotFilter

*/

pageextension 50189 ItemTracingExt extends "Item Tracing"
{
    layout
    {
        // Add changes to page layout here
        modify("Serial No.")
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = true;
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Source No.")
        {
            Visible = true;
        }
        modify("Source Name")
        {
            Visible = true;
        }

        addafter("Source Name")
        {
            field("Lot Grower No."; Rec."Lot Grower No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Grower GGN field.';
            }
            field("Lot Vendor No."; Rec."Lot Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Vendor GLN"; Rec."Vendor GLN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GLN field.';
            }
            field("Vendor GGN"; Rec."Vendor GGN")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor GGN field.';
            }
        }

        addafter("Location Code")
        {
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
            }
        }

        addbefore("Lot No.")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Line No. field.';
            }
        }

        addafter("Lot No.")
        {
            field("Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expiration Date field.';
            }
        }
    }

    actions
    {
        // Add changes to page actions here

        modify(Print)
        {
            Visible = false;
        }


        addafter(Print)
        {
            action(TAL_Print)
            {
                ApplicationArea = ItemTracking;
                Caption = '&Print';
                Ellipsis = true;
                Enabled = true; //PrintEnable;
                Image = Print;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    xItemTracingBuffer: Record "Item Tracing Buffer";
                    PrintTracking: Report "TAL:Item Tracing Specification";
                begin
                    Clear(PrintTracking);
                    xItemTracingBuffer.Copy(Rec);
                    PrintTracking.TransferEntries(Rec);
                    Rec.Copy(xItemTracingBuffer);
                    PrintTracking.Run();
                end;
            }
        }




    }



    procedure SetLotFilter(pFilter: Text)
    var
        myInt: Integer;
    begin
        LotNoFilter := pFilter;
    end;



    var
        PrintEnable: Boolean;
}