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
            field("Reason Code"; Rec."Reason Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reason Code field.';
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
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
            }
            field("Shelf No."; Rec."Shelf No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Shelf No. field.';
            }
            field("Document Lot No."; Rec."Document Lot No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Document Lot No. field.';
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
            field("Receipt Doc. No."; Rec."Receipt Doc. No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Receipt Doc. No. field.';
            }
            field("Producer Group"; Rec."Producer Group")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Producer Group field.';
            }
            field("Producer Group Name"; Rec."Producer Group Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Producer Group Name field.';
            }
            field("Lot Grower No."; Rec."Lot Grower No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Lot Grower No. field.';
            }
            field("Grower Name"; Rec."Grower Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Grower Name field.';
            }
            field("Grower GGN"; Rec."Grower GGN")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Grower GGN field.';
            }
            field("Lot Vendor No."; Rec."Lot Vendor No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Lot Vendor No. field.';
            }
            field("Vendor Name"; Rec."Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor Name field.';
            }
            field("Vendor GLN"; Rec."Vendor GLN")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Vendor GLN field.';
            }
            field("Vendor GGN"; Rec."Vendor GGN")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Vendor GGN field.';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Net Weight field.';
            }
            field("Total Net Weight"; Rec."Total Net Weight")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Total Net Weight field.';
            }
            field("Document Grower No."; Rec."Document Grower No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Grower No. field.';
            }
            field("Document Grower Name"; Rec."Document Grower Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Grower Name field.';
            }
            field("Document Grower GGN"; Rec."Document Grower GGN")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Grower GGN field.';
            }
            field("Document Grower Vendor No."; Rec."Document Grower Vendor No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Grower Vendor No. field.';
            }
            field("Document Grower Vendor Name"; Rec."Document Grower Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Grower Vendor Name field.';
            }
            field("Document Vendor No."; Rec."Document Vendor No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Vendor No. field.';
            }
            field("Document Vendor Name"; Rec."Document Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Vendor Name field.';
            }
            field("Document Vendor GGN"; Rec."Document Vendor GGN")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Vendor GGN field.';
            }
            field("Document Qty"; Rec."Document Qty")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Qty field.';
            }
            field("Document No. Multiple"; Rec."Document No. Multiple")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document No. Multiple field.';
            }
            field("Document Excel Line No."; Rec."Document Excel Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Document Excel Line No. field.';
            }
            field("Level 1 Document No. Filter"; Rec."Level 1 Document No. Filter")
            {
                ApplicationArea = All;
                Editable = false;
                Visible = false;
                ToolTip = 'Specifies the value of the Level 1 Document No. Filter field.';
            }

            field(RegisteredVendorNo; Grower."Grower Vendor No.")
            {
                Caption = 'Registered Vendor No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registered Vendor No. field.';
            }

            field(RegisteredVendorNname; Grower."Grower Vendor Name")
            {
                Caption = 'Registered Vendor Name';
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Registered Vendor Name field.';
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
                ToolTip = 'Specifies the value of the Gen. Bus. Posting Group field.';
            }
        }
        //TAL 1.0.0.203 <<

        addafter("Prod. Order Comp. Line No.")
        {
            field(Correction; Rec.Correction)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Correction field.';
            }
            //+1.0.0.229
            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Agent field.';
            }
            //-1.0.0.229

            field("Lot Receiving Temperature"; Rec."Lot Receiving Temperature")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Receiving Temperature field.';
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
                ApplicationArea = All;
                Image = LotInfo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Lot No. Information Card";
                RunPageLink = "Item No." = field("Item No."),
                                  "Lot No." = field("Lot No.");
                ToolTip = 'Executes the Lot Information Card action.';
            }
            action("Item Card ")
            {
                ApplicationArea = All;
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                ToolTip = 'Executes the Item Card  action.';
            }
            action("Item Tracing")
            {
                ApplicationArea = All;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the Item Tracing action.';

                trigger OnAction();
                var
                    pItemTracing: Page "Item Tracing";
                begin

                    Clear(pItemTracing);
                    pItemTracing.SetLotFilter := Rec."Lot No.";

                    //pItemTracing.FindRecords;
                    pItemTracing.Run;
                end;
            }
            action("Grower Card")
            {
                ApplicationArea = All;
                Image = ContactPerson;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = page "Grower Card";
                RunPageLink = "No." = field("Document Grower No.");
                ToolTip = 'Executes the Grower Card action.';
            }
            action("Vendor Card")
            {
                ApplicationArea = All;
                Image = Vendor;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = page "Vendor Card";
                RunPageLink = "No." = field("Document Grower Vendor No.");
                ToolTip = 'Executes the Vendor Card action.';
            }
            action("Customer Card")
            {
                ApplicationArea = All;
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                RunObject = page "Customer Card";
                RunPageLink = "No." = field("Source No.");
                ToolTip = 'Executes the Customer Card action.';
            }

            action("Count")
            {
                ApplicationArea = All;

                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                PromotedOnly = true;
                ToolTip = 'Executes the Count action.';
                trigger OnAction()
                begin
                    Message('# records: ' + Format(Rec.Count));
                end;
            }

        }

        addafter("Order &Tracking")
        {
            action("Calculate Total Weight")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Executes the Calculate Total Weight action.';

                trigger OnAction();
                var
                    rL_Item: Record Item;
                begin

                    rL_Item.GET(Rec."Item No.");
                    Rec."Net Weight" := rL_Item."Net Weight";
                    Rec."Total Net Weight" := Rec."Net Weight" * Rec.Quantity;
                    Rec.MODIFY;

                    Message('Update Completed');
                end;
            }
        }

        addafter("&Navigate")
        {

            group("Quality Control")
            {

                action("QC Purchase Receiving")
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    ToolTip = 'Executes the QC Purchase Receiving action.';

                    trigger OnAction();
                    var
                        rpt_QualityControlPurcReceiptv2: Report "Quality Control Purc. Rcpt";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        Clear(rpt_QualityControlPurcReceiptv2);

                        rL_ILE.CopyFilters(Rec);
                        rpt_QualityControlPurcReceiptv2.SetTableView(rL_ILE);
                        rpt_QualityControlPurcReceiptv2.Run;
                    end;
                }
                action("QC Production")
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'QC Production ARAD-1,5';
                    ToolTip = 'Executes the QC Production ARAD-1,5 action.';

                    trigger OnAction();
                    var
                        rpt_QualityControlProdOrder: Report "Quality Control Prod. Order";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        Clear(rpt_QualityControlProdOrder);

                        rL_ILE.CopyFilters(Rec);

                        //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                        //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                        rL_ILE.SetRange("Entry Type", Rec."Entry Type"::Sale);
                        rL_ILE.SetFilter("Location Code", 'ARAD-1|ARAD-5');
                        rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                        rL_ILE.SetFilter(Quantity, '<0');


                        rpt_QualityControlProdOrder.SetTableView(rL_ILE);
                        rpt_QualityControlProdOrder.Run;
                    end;
                }


                action("QC ProductionOther")
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'QC Production Other';
                    ToolTip = 'Executes the QC Production Other action.';

                    trigger OnAction();
                    var
                        rpt_QualityControlProdOrder: Report "Quality Control Prod. Order";
                        rL_ILE: Record "Item Ledger Entry";
                    begin
                        Clear(rpt_QualityControlProdOrder);

                        rL_ILE.CopyFilters(Rec);

                        //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                        //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                        rL_ILE.SetRange("Entry Type", Rec."Entry Type"::Sale);
                        //rL_ILE.SetFilter("Location Code", 'ARAD-1|ARAD-5');
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                        rL_ILE.SetFilter(Quantity, '<0');

                        rpt_QualityControlProdOrder.SetTableView(rL_ILE);
                        rpt_QualityControlProdOrder.Run;
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
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'Boxes Statement By Location';
                    ToolTip = 'Executes the Boxes Statement By Location action.';

                    trigger OnAction();
                    var
                        rpt_Boxestatement: Report "Boxes Statement By Location";
                        rL_ILE: Record "Item Ledger Entry";
                        rL_Location: Record Location;
                    begin
                        Clear(rpt_Boxestatement);

                        //rL_ILE.RESET;
                        //rL_ILE.SetFilter("Location Code", "Location Code");
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-PACKMAT');

                        //rL_Location.RESET;
                        //rL_Location.SetFilter(Code, "Location Code");
                        //if rL_Location.FindSet() then begin
                        //rpt_Boxestatement.SETTABLEVIEW(rL_Location);
                        rpt_Boxestatement.Run;
                        //end;

                    end;

                }

                action("Boxes Statement Summary")
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    Caption = 'Boxes Statement Summary/Detail';
                    ToolTip = 'Executes the Boxes Statement Summary/Detail action.';

                    trigger OnAction();
                    var
                        rpt_BoxestatementSum: Report "Boxes Statement Summary";
                        rL_ILE: Record "Item Ledger Entry";
                        rL_Location: Record Location;
                        SRSetup: Record "Sales & Receivables Setup";
                    begin
                        SRSetup.Get();
                        Clear(rpt_BoxestatementSum);

                        rL_ILE.Reset;
                        rL_ILE.SetFilter("Entry Type", '%1|%2', rL_ILE."Entry Type"::Sale, rL_ILE."Entry Type"::Purchase);
                        rL_ILE.SetFilter("Item Category Code", SRSetup."Box Stmt Item Category Filter");
                        //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-PACKMAT');

                        //rL_Location.RESET;
                        //rL_Location.SetFilter(Code, "Location Code");
                        //if rL_Location.FindSet() then begin
                        rpt_BoxestatementSum.SetTableView(rL_ILE);
                        rpt_BoxestatementSum.Run;
                        //end;

                    end;

                }

                action("LOT Per Item")
                {
                    ApplicationArea = All;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = false;
                    PromotedOnly = true;
                    ToolTip = 'Executes the LOT Per Item action.';

                    trigger OnAction();
                    var
                        rpt_LOTPerItem: Report "LOT Per Item";
                        rL_Item: Record Item;
                    begin
                        rL_Item.Reset;
                        rL_Item.SetFilter("No.", Rec."Item No.");
                        if rL_Item.FindSet() then;

                        Clear(rpt_LOTPerItem);

                        rpt_LOTPerItem.SetTableView(rL_Item);
                        rpt_LOTPerItem.Run;
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
        if Grower.get(Rec."Lot Grower No.") then begin
            Grower.CalcFields("Grower Vendor Name");
        end;
    end;

    var


        Grower: Record Grower;
}