report 50006 "Work Order Lidl"
{
    // version NAVW110.0

    // TAL0.1 2018/06/21 VC show Qty Requested instead of Qty
    // TAL0.2 2018/06/27 VC design blank column palette
    // TAL0.3 2018/07/22 VC add field Batch No.
    // TAL0.4 2019/07/08 VC request from Koullis to show Shipment Date
    // TAL0.5 2021/04/06 VC add Lot No.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep06_50006_WorkOrderLidl.rdlc';

    Caption = 'Work Order';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.";
            RequestFilterHeading = 'Sales Order';

            dataitem(PageLoop; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(No1_SalesHeader; "Sales Header"."No.")
                {
                }
                column(ShipmentDate_SalesHeader; Format("Sales Header"."Shipment Date"))
                {
                }
                column(CompanyName; CompanyName)
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                {
                }
                column(SalesOrderNoCaption; SalesOrderNoCaptionLbl)
                {
                }
                column(PageNoCaption; PageNoCaptionLbl)
                {
                }
                column(WorkOrderCaption; WorkOrderCaptionLbl)
                {
                }
                column(vG_DateDesc; vG_DateDesc)
                {
                }
                column(OrderDate_SalesHeader; Format("Sales Header"."Order Date"))
                {
                }
                column(BatchNo_SalesHeader; "Sales Header"."Batch No.")
                {
                }
                column(LotNo_SalesHeader; "Sales Header"."Lot No.")
                {
                }

                //ship

                column(HdrShipToAddr1; ShipToAddr[1])
                {
                }
                column(HdrShipToAddr2; ShipToAddr[2])
                {
                }
                column(HdrShipToAddr3; ShipToAddr[3])
                {
                }
                column(HdrShipToAddr4; ShipToAddr[4])
                {
                }
                column(HdrShipToAddr5; ShipToAddr[5])
                {
                }
                column(HdrShipToAddr6; ShipToAddr[6])
                {
                }
                column(HdrShipToAddr7; ShipToAddr[7])
                {
                }
                column(HdrShipToAddr8; ShipToAddr[8])
                {
                }

                column(HdrShowShippingAddr; Format(ShowShippingAddr))
                {
                }


                column(HdrShipToCaption; vG_ShiptoAddrCaptionLbl)
                {
                }

                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                    RequestFilterFields = "Location Code", "Shortcut Dimension 2 Code";
                    column(No_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ShelfNo_SalesLine; "Shelf No.")
                    {
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(Description2_SalesLine; vG_Description2)
                    {
                    }
                    column(PackingGroupDescription_SalesLine; "Packing Group Description")
                    {
                    }
                    column(Quantity_SalesLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitofMeasure_SalesLine; "Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(Type_SalesLine; Type)
                    {
                        IncludeCaption = true;
                    }
                    column(QtyworkPostSalesOrderCptn; QtyworkPostSalesOrderCptnLbl)
                    {
                    }
                    column(QuantityUsedCaption; QuantityUsedCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaption; UnitofMeasureCaptionLbl)
                    {
                    }
                    column(PackageQty_SalesLine; "Package Qty")
                    {
                    }
                    column(QtyRequested_SalesLine; "Qty. Requested")
                    {
                    }

                    column(PreviousQtyRequested_SalesLine; vG_PreviousQtyRequested)
                    {
                        DecimalPlaces = 0 : 5;
                    }


                    column(QtySalesUOM; "Sales Line"."Unit of Measure")
                    {
                    }
                    column(QtyBase_SalesLine; "Sales Line"."Quantity (Base)")
                    {
                    }
                    column(NewOrderQty; "Sales Line"."New Order Qty")
                    {

                    }

                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                        OrderQty: Record "Order Qty";
                    begin
                        vG_Description2 := '';

                        vG_Description2 := "Description 2";
                        if vG_Description2 = '' then begin
                            vG_Description2 := Description;
                        end;

                        vG_PreviousQtyRequested := 0;
                        //find the Qty. Requested change
                        if "Sales Line"."Shelf No." <> '' then begin
                            OrderQty.Reset;
                            OrderQty.SetCurrentKey("Customer No.", "Order Date", "Shelf No.", "Max Version No.");
                            OrderQty.SetFilter("Customer No.", "Sales Header"."Sell-to Customer No.");
                            OrderQty.SetRange("Order Date", "Sales Header"."Order Date");
                            OrderQty.SetFilter("Shelf No.", "Sales Line"."Shelf No.");
                            //OrderQty.SetFilter("Version No.", '<>%1', 1);
                            OrderQty.SetRange("Stat. Qty. Requested Change", true);
                            if OrderQty.FindLast() then begin
                                vG_PreviousQtyRequested := OrderQty."Previous Qty. Requested";
                            end;
                        end;


                    end;
                }
                dataitem("Order Qty"; "Order Qty")
                {
                    DataItemLink = "Customer No." = field("Sell-to Customer No."), "Order Date" = field("Order Date");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = sorting("Shelf No.") where(Deleted = filter(true));

                    column(ShelfNo_OrderQty; "Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    //Item No.
                    column(ItemNo_OrderQty; "Item No.")
                    {
                        IncludeCaption = true;
                    }

                    //Item Description 2
                    column(ItemDesc_OrderQty; vG_ItemDesc_OrderQty)
                    {

                    }

                    //Sales UOM

                    column(UOMBase_OrderQty; "Sales Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }

                    column(SalesLineQuantity_OrderQty; "Sales Line Quantity")
                    {
                        IncludeCaption = true;
                    }

                    //Qty Requested Cartons
                    column(QtyRequested_OrderQty; "Qty. Requested")
                    {
                        IncludeCaption = true;
                    }

                    column(QtyConfirmed_OrderQty; "Qty. Confirmed")
                    {
                        IncludeCaption = true;
                    }

                    column(PackingGroupDescription_OrderQty; vG_PackingGroupDescription_OrderQty)
                    {

                    }

                    column(PackageQty_OrderQty; vG_PackageQty_OrderQty)
                    {
                        DecimalPlaces = 0 : 1;
                    }

                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                        rL_Item: Record Item;
                    begin
                        vG_ItemDesc_OrderQty := '';
                        if rL_Item.Get("Order Qty"."Item No.") then begin
                            vG_ItemDesc_OrderQty := rL_Item."Description 2";

                            rL_Item.CalcFields("Packing Group Description");
                            vG_PackingGroupDescription_OrderQty := rL_Item."Packing Group Description";
                            vG_PackageQty_OrderQty := rL_Item."Package Qty";

                        end;
                    end;
                }
                dataitem("Sales Comment Line"; "Sales Comment Line")
                {
                    DataItemLink = "Document Type" = field("Document Type"), "No." = field("No.");
                    DataItemLinkReference = "Sales Header";
                    DataItemTableView = where("Document Line No." = const(0));
                    column(Date_SalesCommentLine; Format(Date))
                    {
                    }
                    column(Code_SalesCommentLine; Code)
                    {
                        IncludeCaption = true;
                    }
                    column(Comment_SalesCommentLine; Comment)
                    {
                        IncludeCaption = true;
                    }
                    column(CommentsCaption; CommentsCaptionLbl)
                    {
                    }
                    column(SalesCommentLineDtCptn; SalesCommentLineDtCptnLbl)
                    {
                    }
                }
                dataitem("Extra Lines"; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(NoCaption; NoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption; DescriptionCaptionLbl)
                    {
                    }
                    column(QuantityCaption; QuantityCaptionLbl)
                    {
                    }
                    column(UnitofMeasureCaptionControl33; UnitofMeasureCaptionControl33Lbl)
                    {
                    }
                    column(DateCaption; DateCaptionLbl)
                    {
                    }
                    column(workPostdItemorResJnlCptn; workPostdItemorResJnlCptnLbl)
                    {
                    }
                    column(TypeCaption; TypeCaptionLbl)
                    {
                    }
                }
            }

            trigger OnAfterGetRecord();
            var
                i: Integer;
            begin
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");



                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, "Sales Header");
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                vG_ShiptoAddrCaptionLbl := ShiptoAddrCaptionLbl;
                if not ShowShippingAddr then begin
                    ShipToAddr[1] := '';
                    ShipToAddr[2] := '';
                    ShipToAddr[3] := '';
                    ShipToAddr[4] := '';
                    ShipToAddr[5] := '';
                    ShipToAddr[6] := '';
                    ShipToAddr[7] := '';
                    ShipToAddr[8] := '';
                    vG_ShiptoAddrCaptionLbl := '';
                end;

                //Order Date
                //Get day of the week

                zday := Date2DWY("Shipment Date", 1); //GET THE DAY OF THE WEEK //TAL0.4

                case zday of
                    1:
                        vG_DateDesc := 'ΔΕΥΤΕΡΑ';
                    2:
                        vG_DateDesc := 'ΤΡΙΤΗ';
                    3:
                        vG_DateDesc := 'ΤΕΤΑΡΤΗ';
                    4:
                        vG_DateDesc := 'ΠΕΜΠΤΗ';
                    5:
                        vG_DateDesc := 'ΠΑΡΑΣΚΕΥΗ';
                    6:
                        vG_DateDesc := 'ΣΑΒΒΑΤΟ';
                    7:
                        vG_DateDesc := 'ΚΥΡΙΑΚΗ';

                end;

                vG_DateDesc += ' ' + Format("Shipment Date"); //TAL0.4
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        FormatAddr: Codeunit "Format Address";
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        ShipmentDateCaptionLbl: Label 'Shipment Date';
        SalesOrderNoCaptionLbl: Label 'Sales Order No.';
        PageNoCaptionLbl: Label 'Page';
        WorkOrderCaptionLbl: Label 'Work Order';
        QtyworkPostSalesOrderCptnLbl: Label 'Quantity used during work (Posted with the Sales Order)';
        QuantityUsedCaptionLbl: Label 'Quantity Used';
        UnitofMeasureCaptionLbl: Label 'Unit of Measure';
        CommentsCaptionLbl: Label 'Comments';
        SalesCommentLineDtCptnLbl: Label 'Date';
        NoCaptionLbl: Label 'No.';
        DescriptionCaptionLbl: Label 'Description';
        QuantityCaptionLbl: Label 'Quantity';
        UnitofMeasureCaptionControl33Lbl: Label 'Unit of Measure';
        DateCaptionLbl: Label 'Date';
        workPostdItemorResJnlCptnLbl: Label 'Extra Item/Resource used during work (Posted with Item or Resource Journals)';
        TypeCaptionLbl: Label 'Type';
        zday: Integer;
        vG_DateDesc: Text;

        vG_ShiptoAddrCaptionLbl: Text;
        ShiptoAddrCaptionLbl: Label 'Ship-to Address';

        ShowShippingAddr: Boolean;

        vG_Description2: Text;


        vG_PreviousQtyRequested: Decimal;

        vG_ItemDesc_OrderQty: Text;
        vG_PackingGroupDescription_OrderQty: Text;
        vG_PackageQty_OrderQty: Decimal;
}

