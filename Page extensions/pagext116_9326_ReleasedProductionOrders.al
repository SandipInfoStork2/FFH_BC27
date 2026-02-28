/*
TAL0.1 2019/06/06 VC add Field Vendor No.
TAL0.2 2019/06/12 VC add Field 
      Documents Created
      Documents Created By
      Documents Create Date

TAL0.3 2022/01/10 VC add Field  
          Created By
          Client Computer Name
          Creation Date

*/
pageextension 50216 ReleasedProductionOrdersExt extends "Released Production Orders"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bin Code")
        {
            //TAL 1.0.0.71 >>
            // field("Vendor No."; "Vendor No.")
            // {
            //     ApplicationArea = All;
            // }
            // field("Documents Created"; "Documents Created")
            // {
            //     ApplicationArea = All;
            // }
            //TAL 1.0.0.71 <<
            field("Documents Created By"; "Documents Created By")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Documents Create Date"; "Documents Create Date")
            {
                ApplicationArea = All;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = All;
            }
            field("Client Computer Name"; "Client Computer Name")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; "Creation Date")
            {
                ApplicationArea = All;
            }
        }

        modify("Location Code")
        {
            Visible = true;
        }

        //TAL 1.0.0.71 >>
        addafter("Location Code")
        {
            field("Documents Created"; "Documents Created")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;
            }

            //+1.0.0.229
            field("Packing Agent"; "Packing Agent")
            {
                ApplicationArea = All;
            }
            //-1.0.0.229
        }
        //TAL 1.0.0.71 <<

    }

    actions
    {
        // Add changes to page actions here
        addafter("Production Order Statistics")
        {
            action("Picking List")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Report "Prod. Order - Picking List";
            }

            action("Raw Material Usage")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                // RunObject = Report "Prod. Order - Picking List";

                trigger OnAction();
                var
                    rpt_RawMaterialUsage: Report "Raw Material Usage";
                    rL_ILE: Record "Item Ledger Entry";
                begin
                    CLEAR(rpt_RawMaterialUsage);

                    //rL_ILE.COPYFILTERS(Rec);

                    //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                    //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                    rL_ILE.RESET;
                    rL_ILE.SetRange("Posting Date", WorkDate());
                    rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Consumption);
                    rL_ILE.SetFilter("Location Code", 'ARAD-3');
                    rL_ILE.SetFilter("Item No.", 'RFV*');
                    //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                    //rL_ILE.SetFilter(Quantity, '<0');


                    rpt_RawMaterialUsage.SETTABLEVIEW(rL_ILE);
                    rpt_RawMaterialUsage.RUN;
                end;
            }



            //+1.0.0.292
            action(ImportExcel)
            {
                Caption = 'Import Excel (Production Order)';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                //Visible = false;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin

                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ImportProductionOrderExcel();
                end;
            }

            action(ExportExcel)
            {
                Caption = 'Export Excel Template';
                Image = ExportToExcel;
                Promoted = true;
                PromotedCategory = Process;
                //Visible = false;

                trigger OnAction();
                var
                    cu_GeneralMgt: Codeunit "General Mgt.";
                begin

                    Clear(cu_GeneralMgt);
                    cu_GeneralMgt.ExportProductionOrderTemplate();
                end;
            }
            //-1.0.0.292


            action("Prod. Order Components")
            {
                Caption = 'Prod. Order Components';
                Image = Components;
                Promoted = true;
                PromotedCategory = Report;
                RunObject = page "Prod. Order Components";
                RunPageView = where(Status = filter('Released'));//, "Location Code" = filter('ARAD-4'));
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}