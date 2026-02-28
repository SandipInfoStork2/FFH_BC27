report 50056 "Sales Order Production"
{
    // TAL0.1 Anp add ship to name
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep56_50056_SalesOrderProduction.rdlc';

    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            RequestFilterFields = "No.", "Shortcut Dimension 2 Code", "Shipment Date", "Ship-to Code";
            column(DocumentType_SalesLine; "Sales Line"."Document Type")
            {
            }
            column(DocumentNo_SalesLine; "Sales Line"."Document No.")
            {
            }
            column(No_SalesLine; "Sales Line"."No.")
            {
            }
            column(Description_SalesLine; vG_LineDescription) //1.0.0.198
            {
            }
            column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureBase_SalesLine; "Sales Line"."Unit of Measure (Base)")
            {
            }
            column(Quantity_SalesLine; "Sales Line".Quantity)
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
            {
            }
            column(ShipmentDate_SalesLine; FORMAT("Sales Line"."Shipment Date"))
            {
            }
            column(ShiptoCode_SalesLine; "Sales Line"."Ship-to Code")
            {
            }
            column(vG_ShowDetails; FORMAT(vG_ShowDetails))
            {
            }
            column(ItemWithRouting; ItemWithRouting)
            {
            }
            column(DisplayName; DisplayName)
            {
            }
            column(ShiptoCity; rG_ShiptoAddress.City)
            {
            }
            column(ShiptoName; rG_ShiptoAddress.Name)
            {
            }
            column(ShiptoAddress; rG_ShiptoAddress.Address)
            {
            }
            column(vG_ShiptoName; vG_ShiptoName)
            {
            }

            column(CaptionShipToCode; vG_CaptionShipToCode)
            {
            }

            column(CaptionShipToName; vG_CaptionShipToName)
            {
            }


            trigger OnPreDataItem();
            begin
                "Sales Line".SETRANGE("Document Type", "Sales Line"."Document Type"::Order);
                "Sales Line".SETRANGE(Type, "Sales Line".Type::Item);
                "Sales Line".SETFILTER(Quantity, '<>%1', 0);

                rG_CompanyInformation.GET;
                DisplayName := rG_CompanyInformation.Name;


                if vG_ShowSellToDetails then begin
                    vG_CaptionShipToCode := '';
                    vG_CaptionShipToName := 'Name';
                end else begin
                    vG_CaptionShipToCode := 'Ship-to Code';
                    vG_CaptionShipToName := 'Ship-To Name';
                end;

            end;

            trigger OnAfterGetRecord();

            var
                SalesHeader: Record "Sales Header";
            begin

                rG_Item.GET("No.");
                ItemWithRouting := rG_Item."Routing No." <> '';

                rG_SalesHeader.GET("Sales Line"."Document Type", "Sales Line"."Document No.");
                //rG_ShiptoAddress.GET(rG_SalesHeader."Bill-to Customer No.",rG_SalesHeader."Ship-to Code");

                //+TAL0.1
                vG_ShiptoName := '';
                rG_ShiptoAddress.RESET;
                rG_ShiptoAddress.SETFILTER("Customer No.", rG_SalesHeader."Bill-to Customer No.");
                rG_ShiptoAddress.SETRANGE(Code, "Sales Line"."Ship-to Code");
                if rG_ShiptoAddress.FINDSET then begin
                    vG_ShiptoName := rG_ShiptoAddress.Name;
                end;

                //-TAL0.1

                //+1.0.0.198
                vG_LineDescription := "Sales Line".Description;
                if vG_ShowDescription2 then begin
                    vG_LineDescription := rG_Item."Description 2";// "Sales Line"."Description 2";
                end;
                //-1.0.0.198

                if vG_ShowSellToDetails then begin
                    SalesHeader.RESET;
                    SalesHeader.get("Document Type", "Document No.");
                    vG_ShiptoName := SalesHeader."Sell-to Customer Name";
                    "Sales Line"."Ship-to Code" := '';
                end;

            end;


        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(ShowDetails; vG_ShowDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Details';
                    }
                    field(ShowSellToDetails; vG_ShowSellToDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Sell-to Details';
                        ToolTip = 'Default in details shows Ship-to. When checked shows Sell-to.';

                        trigger OnValidate()
                        var

                            Text50000: Label 'Show Details must be true.';
                        begin
                            if vG_ShowDetails = false then begin
                                Error(Text50000);
                            end;
                        end;
                    }



                    field(ShowDescription2; vG_ShowDescription2)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Description 2';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        vG_ShowDetails: Boolean;
        vG_ShowSellToDetails: Boolean;

        vG_ShowDescription2: Boolean;
        rG_Item: Record Item;
        ItemWithRouting: Boolean;
        DisplayName: Text;
        rG_CompanyInformation: Record "Company Information";
        rG_ShiptoAddress: Record "Ship-to Address";
        rG_SalesHeader: Record "Sales Header";
        vG_ShiptoName: Text;

        vG_LineDescription: Text;

        vG_CaptionShipToCode: Text;
        vG_CaptionShipToName: Text;
}

