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
            field("Lot Grower No."; "Lot Grower No.")
            {
                ApplicationArea = All;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = All;
            }
            field("Grower GGN"; "Grower GGN")
            {
                ApplicationArea = All;
            }
            field("Lot Vendor No."; "Lot Vendor No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
            }
            field("Vendor GLN"; "Vendor GLN")
            {
                ApplicationArea = All;
            }
            field("Vendor GGN"; "Vendor GGN")
            {
                ApplicationArea = All;
            }
        }

        addafter("Location Code")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = All;
            }
        }

        addbefore("Lot No.")
        {
            field("Line No."; "Line No.")
            {
                ApplicationArea = All;
            }
        }

        addafter("Lot No.")
        {
            field("Expiration Date"; "Expiration Date")
            {
                ApplicationArea = All;
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