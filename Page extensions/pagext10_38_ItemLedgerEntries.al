/*
TAL0.1 2018/07/25 VC add UOM
TAL0.2 2019/12/06 VC Editable false, add logic for close inventory periods
TAL0.3 2020/03/03 VC add Source No. Source Name
TAL0.4 2021/03/27 VC add fields Document Grower Vendor No.,Document Grower Vendor Name
TAL0.5 2021/03/27 VC add actions Grower Card, Vendor Card 
TAL0.6 2021/04/02 VC add field Producer Group Name
TAL0.7 2021/04/03 VC add action Lot Information Card 
TAL0.8 2021/10/25 VC add action Item Tracing and Customer Card
 
*/
pageextension 50110 ItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        // Add changes to page layout here

        addafter("Location Code")
        {
            field("Reason Code"; "Reason Code")
            {
                ApplicationArea = all;
            }
        }

        addafter("Item No.")
        {
            /* field("Item Description"; "Item Description")
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the variant code for the items.';
                Visible = false;
            } */
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = all;
            }
            field("Item Category Code"; "Item Category Code")
            {
                ApplicationArea = all;
            }
            field("Shelf No."; "Shelf No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Document Lot No."; "Document Lot No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }


        modify("Unit of Measure Code")
        {
            Visible = true;
        }

        modify("Lot No.")
        {
            Visible = true;
        }
        modify("Source Type") { Editable = false; Visible = true; }
        modify("Source No.") { Editable = false; Visible = true; }
        addafter("Job Task No.")
        {
            /* field("Source Type"; "Source Type")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Source No."; "Source No.")
            {
                ApplicationArea = all;
                Editable = false;
            } */
            field("Receipt Doc. No."; "Receipt Doc. No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Producer Group"; "Producer Group")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Producer Group Name"; "Producer Group Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Lot Grower No."; "Lot Grower No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Grower Name"; "Grower Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Grower GGN"; "Grower GGN")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Lot Vendor No."; "Lot Vendor No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Vendor GLN"; "Vendor GLN")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Vendor GGN"; "Vendor GGN")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Net Weight"; "Net Weight")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Total Net Weight"; "Total Net Weight")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Document Grower No."; "Document Grower No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Grower Name"; "Document Grower Name")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Grower GGN"; "Document Grower GGN")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Grower Vendor No."; "Document Grower Vendor No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Grower Vendor Name"; "Document Grower Vendor Name")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Vendor No."; "Document Vendor No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Vendor Name"; "Document Vendor Name")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Vendor GGN"; "Document Vendor GGN")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Qty"; "Document Qty")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document No. Multiple"; "Document No. Multiple")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Document Excel Line No."; "Document Excel Line No.")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }
            field("Level 1 Document No. Filter"; "Level 1 Document No. Filter")
            {
                ApplicationArea = all;
                Editable = false;
                Visible = false;
            }

            field(RegisteredVendorNo; Grower."Grower Vendor No.")
            {
                caption = 'Registered Vendor No.';
                ApplicationArea = all;
            }

            field(RegisteredVendorNname; Grower."Grower Vendor Name")
            {
                caption = 'Registered Vendor Name';
                ApplicationArea = all;
            }
        }

        modify("Prod. Order Comp. Line No.")
        {
            Visible = true;
        }

        moveafter("Shortcut Dimension 8 Code"; "Prod. Order Comp. Line No.")

        modify("Expiration Date")
        {
            Visible = true;
        }
        //TAL 1.0.0.203 >>
        addafter("Gen. Prod. Posting Group")
        {
            field(GenBusPostingGroup; Rec.GenBusPostingGroup)
            {
                ApplicationArea = All;
            }
        }
        //TAL 1.0.0.203 <<

        addafter("Prod. Order Comp. Line No.")
        {
            field(Correction; Correction)
            {
                ApplicationArea = All;
            }
            //+1.0.0.229
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
            }
            //-1.0.0.229

            field("Lot Receiving Temperature"; "Lot Receiving Temperature")
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        // Add changes to page actions here
        addbefore(Dimensions)
        {
            action("Lot Information Card")
            {
                ApplicationArea = all;
                Image = LotInfo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Lot No. Information Card";
                RunPageLink = "Item No." = FIELD("Item No."),
                                  "Lot No." = FIELD("Lot No.");
            }
            action("Item Card ")
            {
                ApplicationArea = all;
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Item Card";
                RunPageLink = "No." = FIELD("Item No.");
            }
            action("Item Tracing")
            {
                ApplicationArea = all;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    pItemTracing: Page "Item Tracing";
                begin

                    CLEAR(pItemTracing);
                    pItemTracing.SetLotFilter := "Lot No.";

                    //pItemTracing.FindRecords;
                    pItemTracing.RUN;
                end;
            }
            action("Grower Card")
            {
                ApplicationArea = all;
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Grower Card";
                RunPageLink = "No." = FIELD("Document Grower No.");
            }
            action("Vendor Card")
            {
                ApplicationArea = all;
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = Page "Vendor Card";
                RunPageLink = "No." = FIELD("Document Grower Vendor No.");
            }
            action("Customer Card")
            {
                ApplicationArea = all;
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = FIELD("Source No.");
            }

            action("Count")
            {
                ApplicationArea = all;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Message('# records: ' + Format(Count));
                end;
            }

        }

        addafter("Order &Tracking")
        {
            action("Calculate Total Weight")
            {
                ApplicationArea = all;
                Visible = false;

                trigger OnAction();
                var
                    rL_Item: Record Item;
                begin

                    rL_Item.GET("Item No.");
                    "Net Weight" := rL_Item."Net Weight";
                    "Total Net Weight" := "Net Weight" * Quantity;
                    MODIFY;

                    MESSAGE('Update Completed');
                end;
            }
        }

        addafter("&Navigate")
        {

            group("Quality Control")
            {

                action("QC Purchase Receiving")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        rpt_QualityControlPurcReceiptv2: Report "Quality Control Purc. Rcpt";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        CLEAR(rpt_QualityControlPurcReceiptv2);

                        rL_ILE.COPYFILTERS(Rec);
                        rpt_QualityControlPurcReceiptv2.SETTABLEVIEW(rL_ILE);
                        rpt_QualityControlPurcReceiptv2.RUN;
                    end;
                }
                action("QC Production")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'QC Production ARAD-1,5';

                    trigger OnAction();
                    var
                        rpt_QualityControlProdOrder: Report "Quality Control Prod. Order";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        CLEAR(rpt_QualityControlProdOrder);

                        rL_ILE.COPYFILTERS(Rec);

                        //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                        //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                        rL_ILE.SetRange("Entry Type", "Entry Type"::Sale);
                        rL_ILE.SetFilter("Location Code", 'ARAD-1|ARAD-5');
                        rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                        rL_ILE.SetFilter(Quantity, '<0');


                        rpt_QualityControlProdOrder.SETTABLEVIEW(rL_ILE);
                        rpt_QualityControlProdOrder.RUN;
                    end;
                }


                action("QC ProductionOther")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'QC Production Other';

                    trigger OnAction();
                    var
                        rpt_QualityControlProdOrder: Report "Quality Control Prod. Order";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        CLEAR(rpt_QualityControlProdOrder);

                        rL_ILE.COPYFILTERS(Rec);

                        //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                        //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                        rL_ILE.SetRange("Entry Type", "Entry Type"::Sale);
                        //rL_ILE.SetFilter("Location Code", 'ARAD-1|ARAD-5');
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                        rL_ILE.SetFilter(Quantity, '<0');

                        rpt_QualityControlProdOrder.SETTABLEVIEW(rL_ILE);
                        rpt_QualityControlProdOrder.RUN;
                    end;
                }
                /*
                action("Item Statement By Source")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'Item Statement By Source';

                    trigger OnAction();
                    var
                        rpt_ItemStatementBySource: Report "Item Statement by Source";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        CLEAR(rpt_ItemStatementBySource);

                        rL_ILE.RESET;
                        rL_ILE.SetRange("Source Type", "Source Type");
                        rL_ILE.SetFilter("Source No.", "Source No.");
                        rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-PACKMAT');
                        if rL_ILE.FindSet() then begin
                            rpt_ItemStatementBySource.SETTABLEVIEW(rL_ILE);
                            rpt_ItemStatementBySource.RUN;
                        end;

                    end;

                }
                */

                action("Boxes Statement By Location")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'Boxes Statement By Location';

                    trigger OnAction();
                    var
                        rpt_Boxestatement: Report "Boxes Statement By Location";
                        rL_ILE: Record "Item Ledger Entry";
                        rL_Location: Record Location;
                    begin
                        CLEAR(rpt_Boxestatement);

                        //rL_ILE.RESET;
                        //rL_ILE.SetFilter("Location Code", "Location Code");
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-PACKMAT');

                        //rL_Location.RESET;
                        //rL_Location.SetFilter(Code, "Location Code");
                        //if rL_Location.FindSet() then begin
                        //rpt_Boxestatement.SETTABLEVIEW(rL_Location);
                        rpt_Boxestatement.RUN;
                        //end;

                    end;

                }

                action("Boxes Statement Summary")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'Boxes Statement Summary/Detail';

                    trigger OnAction();
                    var
                        rpt_BoxestatementSum: Report "Boxes Statement Summary";
                        rL_ILE: Record "Item Ledger Entry";
                        rL_Location: Record Location;
                        SRSetup: Record "Sales & Receivables Setup";
                    begin
                        SRSetup.GET();
                        CLEAR(rpt_BoxestatementSum);

                        rL_ILE.RESET;
                        rL_ILE.SetFilter("Entry Type", '%1|%2', rL_ILE."Entry Type"::Sale, rL_ILE."Entry Type"::Purchase);
                        rL_ILE.SetFilter("Item Category Code", SRSetup."Box Stmt Item Category Filter");
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-PACKMAT');

                        //rL_Location.RESET;
                        //rL_Location.SetFilter(Code, "Location Code");
                        //if rL_Location.FindSet() then begin
                        rpt_BoxestatementSum.SETTABLEVIEW(rL_ILE);
                        rpt_BoxestatementSum.RUN;
                        //end;

                    end;

                }

                action("LOT Per Item")
                {
                    ApplicationArea = all;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;

                    trigger OnAction();
                    var
                        rpt_LOTPerItem: Report "LOT Per Item";
                        rL_Item: Record "Item";
                    begin
                        rL_Item.RESET;
                        rL_Item.SetFilter("No.", Rec."Item No.");
                        if rL_Item.FindSet() then;

                        CLEAR(rpt_LOTPerItem);

                        rpt_LOTPerItem.SETTABLEVIEW(rL_Item);
                        rpt_LOTPerItem.RUN;
                    end;
                }

                action("Update Entry")
                {
                    ApplicationArea = Suite;
                    Caption = 'Update Closing Period Fields';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Add new information that is relevant to the entry.You can only edit a few fields because the document has already been posted.';

                    trigger OnAction()
                    var
                        UpdateItemLedgerEntry: Page "Item Ledger Entry - Update";
                    begin
                        UpdateItemLedgerEntry.LookupMode := true;
                        UpdateItemLedgerEntry.SetRec(Rec);
                        UpdateItemLedgerEntry.RunModal();
                    end;
                }

            }
        }

    }

    views
    {
        addfirst
        {
            view(vRawMaterialUsage)
            {
                Caption = 'Raw Material Usage';
                Filters = where("Location Code" = filter('ARAD-3'), "Item No." = filter('RFV*'),
                "Entry Type" = filter(Consumption), "Posting Date" = filter('t')
                );

            }


        }
    }

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        //CalcFields("Lot Grower No.");
        if Grower.get("Lot Grower No.") then begin
            Grower.CalcFields("Grower Vendor Name");
        end;
    end;

    var


        Grower: Record Grower;
}