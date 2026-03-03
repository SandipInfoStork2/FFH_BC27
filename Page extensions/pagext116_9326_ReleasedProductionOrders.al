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
            field("Documents Created By"; Rec."Documents Created By")
            {
                ApplicationArea = All;
                Visible = false;
                ToolTip = 'Specifies the value of the Documents Created By field.';
            }
            field("Documents Create Date"; Rec."Documents Create Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents Create Date field.';
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.';
            }
            field("Client Computer Name"; Rec."Client Computer Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Client Computer Name field.';
            }
            field("Creation Date"; Rec."Creation Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the date on which you created the production order.';
            }
        }

        modify("Location Code")
        {
            Visible = true;
        }

        //TAL 1.0.0.71 >>
        addafter("Location Code")
        {
            field("Documents Created"; Rec."Documents Created")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents Created field.';
            }
            field("Vendor No."; Rec."Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor No. field.';
            }

            //+1.0.0.229
            field("Packing Agent"; Rec."Packing Agent")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing Agent field.';
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
                RunObject = report "Prod. Order - Picking List";
                ToolTip = 'Executes the Picking List action.';
            }

            action("Raw Material Usage")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ToolTip = 'Executes the Raw Material Usage action.';
                // RunObject = Report "Prod. Order - Picking List";

                trigger OnAction();
                var
                    rpt_RawMaterialUsage: Report "Raw Material Usage";
                    rL_ILE: Record "Item Ledger Entry";
                begin
                    Clear(rpt_RawMaterialUsage);

                    //rL_ILE.COPYFILTERS(Rec);

                    //DataItemTableView = WHERE("Entry Type" = CONST(Sale), "Location Code" = FILTER('ARAD-1|ARAD-5'), 
                    //"Gen. Prod. Posting Group" = CONST('ST-FRVEG'), Quantity = FILTER(< 0));
                    rL_ILE.Reset;
                    rL_ILE.SetRange("Posting Date", WorkDate());
                    rL_ILE.SetRange("Entry Type", rL_ILE."Entry Type"::Consumption);
                    rL_ILE.SetFilter("Location Code", 'ARAD-3');
                    rL_ILE.SetFilter("Item No.", 'RFV*');
                    //rL_ILE.SetFilter("Gen. Prod. Posting Group", 'ST-FRVEG');
                    //rL_ILE.SetFilter(Quantity, '<0');


                    rpt_RawMaterialUsage.SetTableView(rL_ILE);
                    rpt_RawMaterialUsage.Run;
                end;
            }



            //+1.0.0.292
            action(ImportExcel)
            {
                Caption = 'Import Excel (Production Order)';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Import Excel (Production Order) action.';
                ApplicationArea = All;
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
                ToolTip = 'Executes the Export Excel Template action.';
                ApplicationArea = All;
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
                RunPageView = where(Status = filter('Released'));
                ApplicationArea = All;
                //, "Location Code" = filter('ARAD-4'));                                           ToolTip = 'Executes the Prod. Order Components action.';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}