dotnet
{
    // assembly(System)
    // {
    //     Version = '4.0.0.0';
    //     Culture = neutral;
    //     PublicKeyToken = 'b77a5c561934e089';

    //     type(System.Text.RegularExpressions.Regex; MyRegEx) { }
    //     type(System.Text.RegularExpressions.RegexOptions; MyRegExOptions) { }



    //     //RegEx: DotNet "'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.Regex";
    //     //RegExOptions: DotNet "'System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.RegularExpressions.RegexOptions";
    //     //System.Environment.'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'

    // }
    // assembly(mscorlib)
    // {
    //     type(System.ArgumentNullException; MyRegEx1) { }
    //     type(System.ArgumentNullException; MyRegExOptions1) { }

    //     type(System.IO.StreamWriter; streamWriter_DT) { }

    //     type(System.Text.UnicodeEncoding; encoding_DT) { }

    //     type(System.IO.Directory; Folder_DT) { }
    //     type("System.Collections.Generic.List`1"; Lst_DT) { }
    //     type(System.Object; Obj_DT) { }

    //     type(System.Environment; MyENV) { }

    //     //streamWriter: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamWriter";
    //     //encoding: DotNet "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.UnicodeEncoding";

    // }



}



codeunit 50000 "General Mgt."
{
    // version COC

    // TAL0.2 2018/06/21 VC add column qty
    // TAL0.3 2018/07/22 VC add field Batch No.
    // TAL0.4 2018/08/09 VC add ConvertDelim Scenario
    // TAL0.5 2018/08/09 VC add logic for Sunday
    // TAL0.6 2018/10/04 VC review logic for LotNo generation vL_DayLot
    // TAL0.7 2019/01/04 VC review logic for Week Number. Lidl Week starts from sunday to saturday
    // TAL0.8 2019/01/22 VC replace logic from test page 50014
    // TAL0.9 2019/01/29 VC add codeunit permissions
    // TAL0.10 2019/06/12 VC update Released Production order documents created.
    // TAL0.11 2020/03/03 VC add Lot No for Chain of Custody
    // TAL0.12 2021/03/10 VC replace SalesShipment Line with Item Ledger Entries
    // TAL0.13 2021/03/30 VC add action GrowerReceiptNos
    // TAL0.14 2021/04/03 VC add Lot information card
    // TAL0.15 2021/10/18 VC add action ImportPHCOrders
    // TAL0.16 2021/11/23 VC ImportPHCOrders add version
    //TAL0.17 2022/01/20 VC add action POCreateLot, to create lot based on grower
    //TAL0.18 2022/01/21 VC look up producer group growers


    Permissions = TableData "Item Ledger Entry" = rm,
                  TableData "Value Entry" = rm,
                  TableData "Sales Shipment Header" = rm,
                  TableData "Sales Shipment Line" = rm,
                  TableData "Sales Invoice Header" = rm,
                  TableData "Sales Invoice Line" = rm,
                  TableData "Sales Cr.Memo Header" = rm,
                  TableData "Sales Cr.Memo Line" = rm,
                  TableData "Return Receipt Header" = rm,
                  TableData "Return Receipt Line" = rm,
                  TableData "Sales & Receivables Setup" = rm;

    trigger OnRun();
    begin
    end;

    var
        cu_FileMgt: Codeunit "File Management";
        Text50000: TextConst ELL = 'Εισαγωγή Αρχείου Excel.', ENU = 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        CurrentLine: Text;
        TargetText: BigText;
        Text1000013: TextConst ENU = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ./- ', NLD = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ./- ';
        Text1000014: TextConst ENU = 'Invalid sign used in Fillingcharacter', NLD = 'Ongeldig teken gebruikt in vulteken';
        Text1000015: TextConst ENU = '<Integer>', NLD = '<Integer>';
        Text1000010: TextConst ENU = '<Year4><Month,2><Day,2>', NLD = '<Year,2><Month,2><Day,2>';
        Text1000008: TextConst ENU = '<standard format,2>', NLD = '<standard format,2>';
        Text1000009: TextConst ENU = 'X', NLD = 'X';
        vG_UseDotNet: Boolean;
        TargetFile: File;
        TargetStream: OutStream;
        ExportFileName: Text[1024];
        rG_SRSetup: Record "Sales & Receivables Setup";
        // streamWriter: DotNet streamWriter_DT; //"'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.StreamWriter";
        // encoding: DotNet encoding_DT; //"'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Text.UnicodeEncoding";

        // vG_Environment: DotNet MyENV;

        Text1000016: Label '<Precision,2:2><Sign><Integer><Decimals><Comma,.>';
        Text1000017: Label '<Precision,3:3><Sign><Integer><Decimals><Comma,.>';
        Text1000018: Label '<Precision,0:2><Sign><Integer><Decimals><Comma,.>';
        Text50001: Label 'inv_header';
        Text50002: Label 'inv_lines';
        Text50003: Label 'cr_memo_header';
        Text50004: Label 'cr_memo_lines';
        HeaderPrefix: Text;
        LinesPrefix: Text;
        rG_SalesInvoiceHeader: Record "Sales Invoice Header";
        rG_SalesInvoiceLine: Record "Sales Invoice Line";
        rG_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        rG_SalesCrMemoLine: Record "Sales Cr.Memo Line";
        rG_CompanyInfo: Record "Company Information";
        rG_GLSetup: Record "General Ledger Setup";
        rG_PaymentTerms: Record "Payment Terms";
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        currency: Record Currency;
        TotalAdjCostLCY: Decimal;
        CustAmount: Decimal;
        AmountInclVAT: Decimal;
        InvDiscAmount: Decimal;
        VATAmount: Decimal;
        CostLCY: Decimal;
        ProfitLCY: Decimal;
        ProfitPct: Decimal;
        AdjProfitLCY: Decimal;
        AdjProfitPct: Decimal;
        LineQty: Decimal;
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        TotalVolume: Decimal;
        TotalParcels: Decimal;
        AmountLCY: Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        VATPercentage: Decimal;
        VATAmountText: Text[30];
        CustLedgEntry: Record "Cust. Ledger Entry";
        CostCalcMgt: Codeunit "Cost Calculation Management";
        Text000: Label 'VAT Amount';
        Text001: Label '%1% VAT';
        Amountstr: Text[30];
        VATArrayColumn1: array[3] of Text;
        VATArrayColumn2: array[3] of Text;
        VATArrayColumn3: array[3] of Text;
        VATArrayColumn4: array[3] of Text;
        VATArrayColumn5: array[3] of Text;
        I: Integer;
        //rG_CrossReference: Record "Item Cross Reference";
        rG_CrossReference: Record "Item Reference";
        rG_ReasonCode: Record "Reason Code";
        sLineNo: Integer;
        rG_ValueEntry: Record "Value Entry";
        rG_TempILENo: Integer;
        rG_SalesShipment: Record "Sales Shipment Header";
        vG_GLNDelivery: Code[13];
        rG_ShipToAddress: Record "Ship-to Address";
        vG_ShelfNo: Code[20];
        rG_Item: Record Item;
        Text50005: Label 'Are you sure to start the document generation?';
        Text50006: Label 'Are you sure to delete the Growers(vendors) %1 records?';
        TmpDate: Date;
        TmpDecimal: Decimal;
        Text50007: Label 'Are you sure to Transfer the vendors to Growers YES %1 records?';
        Text50008: Label 'Are you sure to Update Grower Vendor No.?';
        Text50009: Label 'Are you sure to Update Shipment Lot No. %1 records?';
        Text50010: Label 'Are you sure to Update Return Receipt Lot No. %1 records?';
        Text50011: Label 'Are you sure to Update ILE %1 records?';
        Text50012: Label 'Shelf No. %1 does not exist';
        Text50013: Label 'Lot  No. %1 does not exist';
        Text50014: Label 'Lot  No. %1 and Shelf No. %2 found more than once';
        Text50015: Label 'Lot  No. %1 and Shelf No. %2 not found';
        Text50016: Label 'Are you sure to Update ILE GGN?';
        Text50017: Label 'Are you sure to Update Sales Shipment Line Net Weight %1 records?';
        Text50018: Label 'Are you sure to Update Sales Invoice Line Net Weight %1 records?';
        Text50019: Label 'Are you sure to Update Sales Cr. Memo Line Net Weight %1 records?';
        Text50020: Label 'Are you sure to Update ILE Grower Vendor No %1 records?';
        Text50021: Label 'Are you sure to Update Return Receipt Line Net Weight %1 records?';
        Text50022: Label 'Are you sure to Update ILE Level Zero %1 records?';
        Text50023: Label 'Are you sure to Update ILE Lot Grower No. %1 records?';

        vG_TempBlob: Codeunit "Temp Blob";
        vG_OutS: OutStream;
        vG_InS: InStream;

    procedure ImportLidlOrder(var pSalesOrder: Record "Sales Header");
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        Colmn1_DeliveryID: Text;
        Colmn4_ItemNo: Code[20];
        Colmn9_CountryCode: Code[10];
        Colmn10_ProductClassCat: Code[20];
        Colmn11_PackageQty: Decimal;
        Colmn24_QtyRequested: Decimal;
        vL_Year: Integer;
        p_Date: Page "Date-Time Dialog";
        vL_TariffDate: Date;
        rL_Item: Record Item;
        vl_OrderDate: Date;
        vL_BatchNo: Text;
        vl_ExtDocNo: Text;
        vl_LotNo: Text;
        vL_Day: Text;
        vL_DayLot: Text;
        vL_Week: Text;
        vL_WeekDayText: Text;
        vInsert: Boolean;
        SalesLine: Record "Sales Line";
        tmpLineNo: Integer;
        MyDecimalPoint: Text;
        tmp_int: Integer;
        vL_DayTemp: Text;
        vL_WeekLot: Text;
        vL_DayWeekTemp: Text;
        rL_CrossReference: Record "Item Reference";
        rL_ReservationEntry: Record "Reservation Entry";
        vL_ItemTrackingLotNo: Code[20];
        rL_LotNoInformation: Record "Lot No. Information";
        rL_LidlOrderArchive: Record "Lidl Order Archive";
        vL_RowVersion: Integer;
        OrderQty: Record "Order Qty";
        OrderQtyExists: Boolean;
        OrderQtyHeaderExists: Boolean;

    begin
        //MESSAGE(FORMAT(pSalesOrder.COUNT));
        vInsert := false;
        pSalesOrder.TESTFIELD("Sell-to Customer No.", 'CUST00032');
        if pSalesOrder."External Document No." = '' then begin
            //insert mode
            vInsert := true;
        end else begin
            //modify mode
            pSalesOrder.TESTFIELD("External Document No.", '');
        end;

        /*
        //request from user to enter year
        vL_Year:=0;
        p_Date.RUNMODAL;
        vL_TariffDate:=DT2DATE(p_Date.GetDateTime);
        IF vL_TariffDate=0D THEN BEGIN
          ERROR('Import Tariff date cannot be blank. Import again.');
        END;
        vL_Year:= DATE2DMY(vL_TariffDate,3);
        */

        //MyDecimalPoint:= GetDecimalsPoint;

        rG_SRSetup.GET;
        rG_SRSetup.TESTFIELD("Lidl Import Sundry Grower"); //TAL0.14

        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 28; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;

        //Get the order Date
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 1);
        ExcelBuffer.SETRANGE("Column No.", 2);
        if ExcelBuffer.FINDSET then begin
            //MESSAGE(Trim(ExcelBuffer."Cell Value as Text"));
            EVALUATE(vl_OrderDate, Trim(ExcelBuffer."Cell Value as Text"));
        end;


        //Get the Batch No.
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 2);
        ExcelBuffer.SETRANGE("Column No.", 2);
        if ExcelBuffer.FINDSET then begin
            //MESSAGE(Trim(ExcelBuffer."Cell Value as Text"));
            EVALUATE(vL_BatchNo, Trim(ExcelBuffer."Cell Value as Text"));

            //48 - 03 TUE 607428111701 - 29389
            //Lot No 4802

            vL_Day := FORMAT(DATE2DWY(vl_OrderDate, 1) + 1);
            vL_DayTemp := vL_Day; //TAL0.7

            //+TAL0.5
            //Sunday =1
            //Monday =2
            //Tuesday = 3
            //Wednesday = 4
            //Thursday = 5
            //Friday = 6
            //Saturday = 7

            if vL_DayTemp = '8' then begin //sunday placed
                vL_Day := '1';
            end;
            //-TAL0.5

            vL_Day := PADSTR('', 2 - STRLEN(vL_Day), '0') + vL_Day;


            vL_Week := FORMAT(DATE2DWY(vl_OrderDate, 2));
            vL_DayWeekTemp := FORMAT(DATE2DWY(vl_OrderDate, 1));
            //+TAL0.7
            if vL_DayWeekTemp = '7' then begin //sunday placed
                EVALUATE(tmp_int, vL_Week);
                tmp_int += 1;
                vL_Week := FORMAT(tmp_int);
            end;
            //-TAL0.7

            //check greater than 52
            EVALUATE(tmp_int, vL_Week);
            if tmp_int > 52 then begin
                tmp_int := 1;
                vL_Week := FORMAT(tmp_int);
            end;

            vL_WeekDayText := COPYSTR(FORMAT(vl_OrderDate, 0, '<Weekday Text>'), 1, 3);
            vL_WeekDayText := UPPERCASE(vL_WeekDayText);
            vL_Week := PADSTR('', 2 - STRLEN(vL_Week), '0') + vL_Week;
            vl_ExtDocNo := vL_Week + ' - ' + vL_Day + ' ' + vL_WeekDayText + ' 7019' + FORMAT(vl_OrderDate, 0, '<Day,2><Month,2><Year,2>') + '01';

            //+TAL0.6
            //DATE2DWY Monday =1
            //vL_DayLot := FORMAT(DATE2DWY(vl_OrderDate,1));
            //vL_DayLot:= PADSTR('',2 - STRLEN(vL_DayLot),'0') + vL_DayLot;
            //MESSAGE(vL_DayLot);
            //vl_LotNo:='Lot No: '+vL_Week+''+vL_DayLot;

            //**************
            //Lots
            //***************
            //DATE2DWY Monday =1
            vL_DayLot := FORMAT(DATE2DWY(vl_OrderDate, 1));
            vL_DayTemp := vL_DayLot;
            if vL_DayTemp = '8' then begin
                vL_DayLot := '1';
            end;
            vL_DayLot := PADSTR('', 2 - STRLEN(vL_DayLot), '0') + vL_DayLot;
            vL_WeekLot := FORMAT(DATE2DWY(vl_OrderDate, 2));
            vL_WeekLot := PADSTR('', 2 - STRLEN(vL_WeekLot), '0') + vL_WeekLot;
            vl_LotNo := 'Lot No: ' + vL_WeekLot + '-' + vL_DayLot;
            //+TAL0.6
        end;

        //MESSAGE(vl_ExtDocNo);
        //MESSAGE(vl_LotNo);

        pSalesOrder.VALIDATE("Posting Date", vl_OrderDate);
        pSalesOrder.VALIDATE("Document Date", vl_OrderDate);
        pSalesOrder.VALIDATE("Order Date", vl_OrderDate); //1.0.0.113
        pSalesOrder.VALIDATE("Requested Delivery Date", vl_OrderDate);
        pSalesOrder.VALIDATE("External Document No.", vl_ExtDocNo);
        pSalesOrder.VALIDATE("Batch No.", vL_BatchNo);
        pSalesOrder.VALIDATE("Lot No.", 'L' + vL_WeekLot + '-' + vL_DayLot); //TAL0.11
        pSalesOrder.MODIFY;

        vL_ItemTrackingLotNo := 'L' + COPYSTR(FORMAT(DATE2DWY(vl_OrderDate, 3)), 3, 2) + '-' + vL_WeekLot + '-' + vL_DayLot;


        tmpLineNo := 0;
        //insert the first 3 lines
        if vInsert then begin
            tmpLineNo := 10000;
            CLEAR(SalesLine);
            SalesLine."Document Type" := pSalesOrder."Document Type";
            SalesLine."Document No." := pSalesOrder."No.";
            SalesLine."Line No." := tmpLineNo;
            SalesLine.Description := vl_ExtDocNo;
            SalesLine.INSERT(true);

            tmpLineNo += 10000;
            CLEAR(SalesLine);
            SalesLine."Document Type" := pSalesOrder."Document Type";
            SalesLine."Document No." := pSalesOrder."No.";
            SalesLine."Line No." := tmpLineNo;
            SalesLine.Description := vl_LotNo;
            SalesLine.INSERT(true);

            tmpLineNo += 10000;
            CLEAR(SalesLine);
            SalesLine."Document Type" := pSalesOrder."Document Type";
            SalesLine."Document No." := pSalesOrder."No.";
            SalesLine."Line No." := tmpLineNo;
            SalesLine.Description := '=========================';
            SalesLine.INSERT(true);
        end;


        OrderQtyHeaderExists := false;
        OrderQty.RESET;
        OrderQty.SetRange("Customer No.", pSalesOrder."Sell-to Customer No.");
        OrderQty.SetRange("Order Date", pSalesOrder."Order Date");
        if OrderQty.FindSet() then begin
            OrderQtyHeaderExists := true;
        end;


        ExcelBuffer.RESET;
        for RowNo := 8 to RowNoMax do begin //STARTING LINE
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_DeliveryID := '';
            Colmn4_ItemNo := '';
            Colmn11_PackageQty := 0;
            Colmn24_QtyRequested := 0;
            Colmn10_ProductClassCat := '';


            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin

                    case ColumnNo of

                        1:
                            begin
                                EVALUATE(Colmn1_DeliveryID, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_ItemNo, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        9:
                            begin
                                EVALUATE(Colmn9_CountryCode, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        10:
                            begin
                                EVALUATE(Colmn10_ProductClassCat, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        11:
                            begin
                                EVALUATE(Colmn11_PackageQty, ConvertDelim(Trim(ExcelBuffer."Cell Value as Text"))); //TAL0.4

                            end;


                        28:
                            begin
                                EVALUATE(Colmn24_QtyRequested, Trim(ExcelBuffer."Cell Value as Text"));



                                //MESSAGE('Colmn1_DeliveryID: '+ Colmn1_DeliveryID + 'Colmn4_ItemNo: '+ Colmn4_ItemNo +' Colmn11_PackageQty: '+FORMAT(Colmn11_PackageQty));
                                //EXIT;
                                if Colmn24_QtyRequested <> 0 then begin

                                    //get navision item No
                                    if rG_SRSetup."Enable Lidl Cross-Ref Search" then begin
                                        rL_CrossReference.RESET;
                                        /* rL_CrossReference.SETRANGE("Cross-Reference Type", rL_CrossReference."Cross-Reference Type"::Customer);
                                        rL_CrossReference.SETFILTER("Cross-Reference Type No.", pSalesOrder."Sell-to Customer No.");
                                        rL_CrossReference.SETFILTER("Cross-Reference No.", Colmn4_ItemNo);
                                        rL_CrossReference.SETRANGE("Discontinue Bar Code", false); */
                                        rL_CrossReference.SETRANGE("Reference Type", rL_CrossReference."Reference Type"::Customer);
                                        rL_CrossReference.SETFILTER("Reference Type No.", pSalesOrder."Sell-to Customer No.");
                                        rL_CrossReference.SETFILTER("Reference No.", Colmn4_ItemNo);
                                        //rL_CrossReference.SETRANGE("Discontinue Bar Code", false); //field remove from table due to not used
                                        if rL_CrossReference.FINDSET then begin
                                            rL_Item.GET(rL_CrossReference."Item No.");
                                            rL_Item.TESTFIELD("Package Qty", Colmn11_PackageQty);

                                        end else begin
                                            ERROR('Item not found in Item Card-> Cross References: Cross-Reference No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                        end;

                                    end else begin
                                        rL_Item.RESET;
                                        rL_Item.SETFILTER("Shelf No.", Colmn4_ItemNo);
                                        rL_Item.SETRANGE("Package Qty", Colmn11_PackageQty);
                                        if not rL_Item.FINDSET then begin
                                            ERROR('Item not found: Shelf No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                        end;

                                    end;



                                    //insert line
                                    if vInsert then begin


                                        tmpLineNo += 10000;
                                        CLEAR(SalesLine);
                                        SalesLine.SetHideValidationDialog(false); //1.0.0.221
                                        SalesLine."Document Type" := pSalesOrder."Document Type";
                                        SalesLine."Document No." := pSalesOrder."No.";
                                        SalesLine."Line No." := tmpLineNo;
                                        SalesLine.INSERT(true);
                                        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                                        SalesLine.VALIDATE("No.", rL_Item."No.");
                                        SalesLine.VALIDATE("Qty. Requested", Colmn24_QtyRequested);
                                        SalesLine.VALIDATE(Quantity, Colmn24_QtyRequested * Colmn11_PackageQty); //TAL0.2
                                        SalesLine.VALIDATE("Req. Country", Colmn9_CountryCode);

                                        //SalesLine.VALIDATE("Product Class", Colmn10_ProductClassCat);
                                        //+1.0.0.303
                                        if Colmn10_ProductClassCat = '-' then begin
                                            Colmn10_ProductClassCat := rG_SRSetup."Default Product Class";
                                        end;
                                        //-1.0.0.303

                                        SalesLine."Product Class" := Colmn10_ProductClassCat;
                                        SalesLine.MODIFY;

                                        //case when excel 1 was zero and then excel 3 has value
                                        OrderQtyExists := false;
                                        if (SalesLine."Shelf No." <> '') and (OrderQtyHeaderExists) then begin
                                            OrderQty.RESET;
                                            OrderQty.SetRange("Customer No.", pSalesOrder."Sell-to Customer No.");
                                            OrderQty.SetRange("Order Date", pSalesOrder."Order Date");
                                            OrderQty.SetFilter("Shelf No.", SalesLine."Shelf No.");
                                            //OrderQty.SetFilter("Version No.", '<>%1', 1);
                                            if OrderQty.FindSet() then begin
                                                repeat
                                                    if OrderQty."Version No." > 1 then begin
                                                        OrderQtyExists := true;
                                                    end;
                                                until OrderQty.Next() = 0;

                                                if (OrderQtyExists = false) then begin
                                                    SalesLine."New Order Qty" := true;
                                                    SalesLine.MODIFY;

                                                    OrderQty.RESET;
                                                    OrderQty.SetRange("Customer No.", pSalesOrder."Sell-to Customer No.");
                                                    OrderQty.SetRange("Order Date", pSalesOrder."Order Date");
                                                    OrderQty.SetFilter("Shelf No.", SalesLine."Shelf No.");
                                                    OrderQty.SetFilter("Version No.", '%1', 1);
                                                    if OrderQty.FindSet() then begin
                                                        OrderQty."New Order Qty" := true;
                                                        OrderQty.Modify();
                                                    end;
                                                end;
                                            end;


                                        end;


                                        rL_Item.TESTFIELD("Item Tracking Code");
                                        if rL_Item."Item Tracking Code" <> '' then begin
                                            CLEAR(rL_ReservationEntry);
                                            rL_ReservationEntry.INIT;
                                            rL_ReservationEntry."Entry No." := 0;
                                            rL_ReservationEntry.VALIDATE("Item No.", SalesLine."No.");
                                            rL_ReservationEntry.VALIDATE("Location Code", SalesLine."Location Code");
                                            rL_ReservationEntry.VALIDATE("Quantity (Base)", -1 * SalesLine."Quantity (Base)");
                                            rL_ReservationEntry.VALIDATE("Reservation Status", rL_ReservationEntry."Reservation Status"::Surplus);
                                            rL_ReservationEntry.VALIDATE("Creation Date", TODAY);
                                            rL_ReservationEntry.VALIDATE("Source Type", 37);
                                            rL_ReservationEntry.VALIDATE("Source Subtype", 1);
                                            rL_ReservationEntry.VALIDATE("Source ID", SalesLine."Document No.");

                                            rL_ReservationEntry.VALIDATE("Source Ref. No.", SalesLine."Line No.");
                                            rL_ReservationEntry.VALIDATE(Quantity, -1 * SalesLine.Quantity);
                                            rL_ReservationEntry.VALIDATE("Qty. per Unit of Measure", SalesLine."Qty. per Unit of Measure");
                                            rL_ReservationEntry.VALIDATE("Qty. to Handle (Base)", -1 * SalesLine."Quantity (Base)");
                                            rL_ReservationEntry.VALIDATE("Qty. to Invoice (Base)", -1 * SalesLine."Quantity (Base)");

                                            rL_ReservationEntry.VALIDATE("Shipment Date", SalesLine."Shipment Date");
                                            rL_ReservationEntry.VALIDATE("Created By", USERID);


                                            rL_ReservationEntry.VALIDATE("Lot No.", vL_ItemTrackingLotNo);
                                            rL_ReservationEntry.VALIDATE("Item Tracking", rL_ReservationEntry."Item Tracking"::"Lot No.");
                                            rL_ReservationEntry.INSERT(true);

                                            //+TAL0.14
                                            //insert lot information card
                                            CLEAR(rL_LotNoInformation);
                                            rL_LotNoInformation.INIT;
                                            rL_LotNoInformation.VALIDATE("Item No.", SalesLine."No.");
                                            rL_LotNoInformation.VALIDATE("Lot No.", vL_ItemTrackingLotNo);
                                            rL_LotNoInformation.VALIDATE("Grower No.", rG_SRSetup."Lidl Import Sundry Grower");
                                            if rL_LotNoInformation.INSERT(true) then;
                                            //-TAL0.14



                                        end;




                                        //insert to archive
                                        if rG_SRSetup."Lidl Archive Orders" then begin
                                            //"Sales Order No.", "Order Date", "Order Time","Item No.", "Version No."


                                            vL_RowVersion := 1;
                                            clear(rL_LidlOrderArchive);
                                            rL_LidlOrderArchive.Reset();

                                            rL_LidlOrderArchive.SetCurrentKey("Sales Order No.", "Order Date", "Order Time", "Item No.", "Version No.");

                                            rL_LidlOrderArchive.SetFilter("Sales Order No.", SalesLine."Document No.");
                                            rL_LidlOrderArchive.SetRange("Order Date", pSalesOrder."Order Date");
                                            rL_LidlOrderArchive.SetFilter("Item No.", SalesLine."No.");
                                            if rL_LidlOrderArchive.FindLast() then begin
                                                vL_RowVersion := rL_LidlOrderArchive."Version No." + 1;
                                            end;

                                            clear(rL_LidlOrderArchive);
                                            rL_LidlOrderArchive.Validate("Sales Order No.", SalesLine."Document No.");
                                            rL_LidlOrderArchive.Validate("Order Date", pSalesOrder."Order Date");
                                            rL_LidlOrderArchive.Validate("Order Time", CreateDateTime(workdate, Time)); //pSalesOrder."Order Date"
                                            rL_LidlOrderArchive.Validate("Customer No.", pSalesOrder."Sell-to Customer No.");
                                            rL_LidlOrderArchive.Validate("Shelf No.", SalesLine."Shelf No.");
                                            rL_LidlOrderArchive.Validate("Item No.", SalesLine."No.");
                                            rL_LidlOrderArchive.Validate("Version No.", vL_RowVersion);
                                            rL_LidlOrderArchive.Validate("Qty Ordered", SalesLine."Qty. Requested");

                                            SalesLine.CalcFields("Unit of Measure (Base)");
                                            rL_LidlOrderArchive.Validate("UOM (Base)", SalesLine."Unit of Measure (Base)");
                                            rL_LidlOrderArchive.Insert(true)

                                        end;

                                        //becuase excel cannot be editted to delete the lines, commit after each transaction
                                        if rG_SRSetup."Lidl Import Dev Mode" then begin
                                            COMMIT;
                                        end;

                                    end;
                                end;

                            end;


                    end; //end case
                end;//end if
            end; //end for 2

        end; //end for 1
        Window.CLOSE;

    end;


    procedure ImportLidlOrderConfirmation(var pSalesOrder: Record "Sales Header");
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        vl_OrderDate: Date;
        Colmn3_Truck: Text;
        Colmn4_ItemNo: Code[20];
        Colmn9_CountryOrigin: Text;
        Colmn11_PackageQty: Decimal;
        Colmn31_QtyConfirmed: Decimal;
        rL_CrossReference: Record "Item Reference";
        rL_Item: Record Item;
        SalesLine: Record "Sales Line";
    begin


        SalesLine.RESET;
        SalesLine.SetRange("Document Type", pSalesOrder."Document Type");
        SalesLine.setFilter("Document No.", pSalesOrder."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then begin
            repeat
                SalesLine."Excel Confirm Write" := false;
                SalesLine.Modify();
            until SalesLine.Next() = 0;
        end;
        commit;


        rG_SRSetup.GET;

        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 31; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;

        //Get the order Date
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 1);
        ExcelBuffer.SETRANGE("Column No.", 2);
        if ExcelBuffer.FINDSET then begin
            //MESSAGE(Trim(ExcelBuffer."Cell Value as Text"));
            EVALUATE(vl_OrderDate, Trim(ExcelBuffer."Cell Value as Text"));
        end;

        ExcelBuffer.RESET;
        for RowNo := 8 to RowNoMax do begin //STARTING LINE
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn3_Truck := '';
            Colmn4_ItemNo := '';
            Colmn9_CountryOrigin := '';
            Colmn31_QtyConfirmed := 0;
            Colmn11_PackageQty := 0;


            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin

                    case ColumnNo of
                        1:
                            begin
                                // EVALUATE(Colmn1_DeliveryID, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        3:
                            begin
                                EVALUATE(Colmn3_Truck, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_ItemNo, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        9:
                            begin
                                EVALUATE(Colmn9_CountryOrigin, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        11:
                            begin
                                EVALUATE(Colmn11_PackageQty, ConvertDelim(Trim(ExcelBuffer."Cell Value as Text"))); //TAL0.4
                            end;

                        31:
                            begin
                                EVALUATE(Colmn31_QtyConfirmed, Trim(ExcelBuffer."Cell Value as Text"));

                                //MESSAGE('Colmn1_DeliveryID: '+ Colmn1_DeliveryID + 'Colmn4_ItemNo: '+ Colmn4_ItemNo +' Colmn11_PackageQty: '+FORMAT(Colmn11_PackageQty));
                                //EXIT;
                                if (Colmn4_ItemNo <> '') and (Colmn3_Truck = '1') then begin
                                    Clear(rL_Item);
                                    //get navision item No
                                    if rG_SRSetup."Enable Lidl Cross-Ref Search" then begin
                                        rL_CrossReference.RESET;
                                        /* rL_CrossReference.SETRANGE("Cross-Reference Type", rL_CrossReference."Cross-Reference Type"::Customer);
                                        rL_CrossReference.SETFILTER("Cross-Reference Type No.", pSalesOrder."Sell-to Customer No.");
                                        rL_CrossReference.SETFILTER("Cross-Reference No.", Colmn4_ItemNo);
                                        rL_CrossReference.SETRANGE("Discontinue Bar Code", false); */
                                        rL_CrossReference.SETRANGE("Reference Type", rL_CrossReference."Reference Type"::Customer);
                                        rL_CrossReference.SETFILTER("Reference Type No.", pSalesOrder."Sell-to Customer No.");
                                        rL_CrossReference.SETFILTER("Reference No.", Colmn4_ItemNo);
                                        //rL_CrossReference.SETRANGE("Discontinue Bar Code", false); //Field remove from table due to not is use
                                        if rL_CrossReference.FINDSET then begin
                                            rL_Item.GET(rL_CrossReference."Item No.");
                                            rL_Item.TESTFIELD("Package Qty", Colmn11_PackageQty);

                                        end else begin
                                            //if not rG_SRSetup."Lidl Import Dev Mode" then begin
                                            //ERROR('Item not found in Item Card-> Cross References: Cross-Reference No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                            message('Item not found in Item Card-> Cross References: Cross-Reference No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                            // end;


                                        end;

                                    end else begin
                                        rL_Item.RESET;
                                        rL_Item.SETFILTER("Shelf No.", Colmn4_ItemNo);
                                        rL_Item.SETRANGE("Package Qty", Colmn11_PackageQty);
                                        if not rL_Item.FINDSET then begin
                                            //if not rG_SRSetup."Lidl Import Dev Mode" then begin
                                            //ERROR('Item not found: Shelf No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                            message('Item not found: Shelf No.: ' + Colmn4_ItemNo + ' Package Qty: ' + FORMAT(Colmn11_PackageQty));
                                            //end;
                                        end;
                                    end;

                                    //
                                    if rL_Item."No." <> '' then begin
                                        SalesLine.RESET;
                                        SalesLine.SetRange("Document Type", pSalesOrder."Document Type");
                                        SalesLine.setFilter("Document No.", pSalesOrder."No.");
                                        SalesLine.SetRange(Type, SalesLine.Type::Item);
                                        SalesLine.SetFilter("Shelf No.", Colmn4_ItemNo); //filter based on shelf no
                                        //SalesLine.setFilter("No.", rL_Item."No.");
                                        SalesLine.SetRange("Excel Confirm Write", false); //handle unique excel value, if same item exists on the excel not to process
                                        SalesLine.SetFilter("Req. Country", Colmn9_CountryOrigin); //1.0.0.221
                                        if SalesLine.FindSet() then begin
                                            SalesLine.VALIDATE("Qty. Confirmed", Colmn31_QtyConfirmed); //1.0.0.207
                                            SalesLine."Excel Confirm Write" := true;
                                            SalesLine.Modify();
                                        end;

                                    end;


                                    //becuase excel cannot be editted to delete the lines, commit after each transaction
                                    if rG_SRSetup."Lidl Import Dev Mode" then begin
                                        COMMIT;
                                    end;

                                end;
                            end; //end 28

                    end; //end case
                end;//end if

            end; //for column=1
        end; //end for 1
        Window.CLOSE;
    end;

    local procedure Trim(pInput: Text) Trimmed: Text;
    begin

        Trimmed := DELCHR(pInput, '<', ' ');
        Trimmed := DELCHR(Trimmed, '>', ' ');
    end;

    local procedure RemoveDash(pInput: Text) Trimmed: Text;
    begin

        Trimmed := DELCHR(pInput, '=', '-');

    end;

    local procedure GetDecimalsPoint() DecimalPoint: Text;
    var
        TempStr: Text;
    begin

        TempStr := FORMAT(1.23, 0);
        DecimalPoint := COPYSTR(TempStr, 2, 1);
        exit(DecimalPoint);
    end;

    local procedure ConvertDelim(lExpression: Text): Text;
    var
        lText: Text;
        delim: Text;
    begin
        lText := FORMAT(1.1);
        delim := COPYSTR(lText, 2, 1);
        lExpression := CONVERTSTR(lExpression, ',', FORMAT(delim));
        lExpression := CONVERTSTR(lExpression, '.', FORMAT(delim));
        exit(lExpression);
    end;

    procedure ExportRLIDE(pDocumentNo: Code[20]; pInvoice: Boolean; pCrMemo: Boolean; var pSalesInvHeader: Record "Sales Invoice Header"; var pSalesCrMemoHeader: Record "Sales Cr.Memo Header");
    var
        FileNameHeader: Text;
        FileNameLines: Text;
        vL_extension: Text;
        DataCompression: Codeunit "Data Compression";
        ZipFileName: Text[50];

    begin
        rG_CompanyInfo.GET;
        rG_CompanyInfo.TESTFIELD("VAT Registration No.");
        rG_CompanyInfo.TESTFIELD(GLN);


        //https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/file/file-downloadfromstream-method

        if pInvoice then begin

            ZipFileName := 'SalesInvoices_' + Format(CurrentDateTime) + '.zip';
            DataCompression.CreateZipArchive();
            if pSalesInvHeader.FindSet() then begin
                repeat


                    pDocumentNo := pSalesInvHeader."No.";
                    //new
                    //set the counter
                    rG_SRSetup.GET;
                    if rG_SRSetup."EDI Last Date" = TODAY then begin
                        rG_SRSetup."EDI Counter" += 1;
                        rG_SRSetup.MODIFY;
                    end else begin
                        rG_SRSetup."EDI Last Date" := TODAY;
                        rG_SRSetup."EDI Counter" := 1;
                        rG_SRSetup.MODIFY;
                    end;
                    vG_UseDotNet := rG_SRSetup."EDI Export Dot Net";

                    if pInvoice then begin
                        HeaderPrefix := Text50001;
                        LinesPrefix := Text50002;
                    end;
                    vL_extension := '.txt';
                    FileNameHeader := HeaderPrefix + '_' +
                               FORMAT(TODAY, 0, '<YEAR4><MONTH,2><Day,2>') + '_' +
                               FORMAT(rG_SRSetup."EDI Counter") +
                               vL_extension;

                    FileNameLines := LinesPrefix + '_' +
                                FORMAT(TODAY, 0, '<YEAR4><MONTH,2><Day,2>') + '_' +
                                FORMAT(rG_SRSetup."EDI Counter") +
                                vL_extension;



                    rG_SalesInvoiceHeader.GET(pDocumentNo);
                    CheckEDIInvoice(rG_SalesInvoiceHeader);
                    //prepare Header
                    CreateFile(FileNameHeader);
                    HeaderInfoSInvoice;
                    CloseFile;




                    //add to zip
                    //cu_FileMgt.DownloadToFile(rG_SRSetup."EDI Export Path Server" + FileNameHeader, rG_SRSetup."EDI Export Path Client" + FileNameHeader);
                    vG_TempBlob.CreateInStream(vG_InS, TEXTENCODING::UTF8);
                    DataCompression.AddEntry(vG_InS, FileNameHeader);

                    rG_SalesInvoiceLine.RESET;
                    rG_SalesInvoiceLine.SETFILTER("Document No.", rG_SalesInvoiceHeader."No.");
                    rG_SalesInvoiceLine.SETRANGE(Type, rG_SalesInvoiceLine.Type::Item);
                    rG_SalesInvoiceLine.SETFILTER("No.", '<>%1', '');
                    if rG_SalesInvoiceLine.FINDSET then begin
                        //Create the lines file
                        CreateFile(FileNameLines);
                        sLineNo := 0;
                        repeat
                            //prepare Lines
                            sLineNo += 1;
                            BodyInfoSInvoiceLines;
                        until rG_SalesInvoiceLine.NEXT = 0;
                        CloseFile;

                        //add to zip
                        //cu_FileMgt.DownloadToFile(rG_SRSetup."EDI Export Path Server" + FileNameLines, rG_SRSetup."EDI Export Path Client" + FileNameLines);
                        vG_TempBlob.CreateInStream(vG_InS, TEXTENCODING::UTF8);
                        DataCompression.AddEntry(vG_InS, FileNameLines);
                    end;
                until pSalesInvHeader.Next() = 0;
            end;

        end;

        if pCrMemo then begin
            ZipFileName := 'SalesCrMemos_' + Format(CurrentDateTime) + '.zip';
            DataCompression.CreateZipArchive();
            if pSalesCrMemoHeader.FindSet() then begin
                repeat


                    pDocumentNo := pSalesCrMemoHeader."No.";
                    //new
                    //set the counter
                    rG_SRSetup.GET;
                    if rG_SRSetup."EDI Last Date" = TODAY then begin
                        rG_SRSetup."EDI Counter" += 1;
                        rG_SRSetup.MODIFY;
                    end else begin
                        rG_SRSetup."EDI Last Date" := TODAY;
                        rG_SRSetup."EDI Counter" := 1;
                        rG_SRSetup.MODIFY;
                    end;
                    vG_UseDotNet := rG_SRSetup."EDI Export Dot Net";

                    if pCrMemo then begin
                        HeaderPrefix := Text50001;//Text50003;
                        LinesPrefix := Text50002; //Text50004;
                    end;

                    vL_extension := '.txt';
                    FileNameHeader := HeaderPrefix + '_' +
                               FORMAT(TODAY, 0, '<YEAR4><MONTH,2><Day,2>') + '_' +
                               FORMAT(rG_SRSetup."EDI Counter") +
                               vL_extension;

                    FileNameLines := LinesPrefix + '_' +
                                FORMAT(TODAY, 0, '<YEAR4><MONTH,2><Day,2>') + '_' +
                                FORMAT(rG_SRSetup."EDI Counter") +
                                vL_extension;


                    rG_SalesCrMemoHeader.GET(pDocumentNo);

                    CheckEDICrMemo(rG_SalesCrMemoHeader);
                    //prepare Header
                    CreateFile(FileNameHeader);
                    HeaderInfoSCrMemo;
                    CloseFile;

                    //add to zip
                    //cu_FileMgt.DownloadToFile(rG_SRSetup."EDI Export Path Server" + FileNameHeader, rG_SRSetup."EDI Export Path Client" + FileNameHeader);
                    vG_TempBlob.CreateInStream(vG_InS, TEXTENCODING::UTF8);
                    DataCompression.AddEntry(vG_InS, FileNameHeader);

                    rG_SalesCrMemoLine.RESET;
                    rG_SalesCrMemoLine.SETFILTER("Document No.", rG_SalesCrMemoHeader."No.");
                    rG_SalesCrMemoLine.SETRANGE(Type, rG_SalesCrMemoLine.Type::Item);
                    rG_SalesCrMemoLine.SETFILTER("No.", '<>%1', '');
                    if rG_SalesCrMemoLine.FINDSET then begin
                        CreateFile(FileNameLines);
                        sLineNo := 0;
                        repeat
                            sLineNo += 1;
                            BodyInfoSCrMemoLines
                        until rG_SalesCrMemoLine.NEXT = 0;
                        CloseFile;

                        //add to zip
                        //cu_FileMgt.DownloadToFile(rG_SRSetup."EDI Export Path Server" + FileNameLines, rG_SRSetup."EDI Export Path Client" + FileNameLines);
                        vG_TempBlob.CreateInStream(vG_InS, TEXTENCODING::UTF8);
                        DataCompression.AddEntry(vG_InS, FileNameLines);
                    end;
                until pSalesCrMemoHeader.Next() = 0;
            end;
        end;

        if rG_SRSetup."EDI Export Dot Net" = false then begin
            Clear(vG_TempBlob);
            vG_TempBlob.CreateOutStream(vG_OutS); ///OutS
            DataCompression.SaveZipArchive(vG_OutS); //OutS
            vG_TempBlob.CreateInStream(vG_InS);
            DownloadFromStream(vG_InS, '', '', '', ZipFileName);
        end;


        MESSAGE(FORMAT(FileNameHeader) + ' File Generated');
        MESSAGE(FORMAT(FileNameLines) + ' File Generated');

        //CLEAR(auOpenFolder);
        //CREATE(auOpenFolder);
        //auOpenFolder.Run(rG_CustomSetup."SEPA Path");
        //auOpenFolder.Exec('%windir%\explorer.exe ' +rG_CustomSetup."SEPA Path");
    end;

    procedure CheckEDISH(var SalesHeader: Record "Sales Header");
    var
        rL_Customer: Record Customer;
        rL_SalesHeader: Record "Sales Header";
        VE: Record "Value Entry";
        ILE: Record "Item Ledger Entry";
        ReasonCode: Record "Reason Code";
    begin

        rL_SalesHeader.RESET;
        rL_SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type");
        rL_SalesHeader.SETFILTER("No.", SalesHeader."No.");
        rL_SalesHeader.FINDFIRST;

        //MESSAGE(FORMAT(SalesHeader.COUNT));
        if rL_SalesHeader."Document Type" <> rL_SalesHeader."Document Type"::"Credit Memo" then begin
            exit;
        end;

        rL_Customer.GET(rL_SalesHeader."Bill-to Customer No.");
        if rL_Customer.GLN = '' then begin
            exit;
        end;

        SalesHeader.TESTFIELD("Reason Code");

        if SalesHeader."Reason Code" <> '' then begin
            if SalesHeader."Applies-to Doc. Type" = SalesHeader."Applies-to Doc. Type"::Invoice then begin
                if SalesHeader."Applies-to Doc. No." <> '' then begin
                    //popup user to select Reason Code
                    //cu //update item ledger entries reason code
                    //
                    VE.RESET;
                    VE.SetRange("Document Type", VE."Document Type"::"Sales Invoice");
                    VE.SetFilter("Document No.", SalesHeader."Applies-to Doc. No.");
                    VE.SetFilter("Reason Code", '');
                    if VE.FindSet() then begin
                        repeat
                            //if reason code is CR103 these will mark the invoice entries with CR103
                            ReasonCode.GET(SalesHeader."Reason Code");
                            if ReasonCode."Mark Invoice Entries" then begin
                                VE."Reason Code" := SalesHeader."Reason Code";
                                VE.Modify();
                            end;

                        //ILE.RESET;
                        //ILE.SetRange("Entry No.", VE."Item Ledger Entry No.");
                        //ILE.SetFilter("Reason Code", '');
                        //if ILE.FindSet() then begin
                        //    repeat
                        //        ILE."Reason Code" := SalesHeader."Reason Code";
                        //        ILE.Modify();
                        //    until ILE.Next() = 0;
                        //end;
                        until VE.Next() = 0;
                    end;
                end;
            end;
        end;
    end;

    procedure CheckEDIInvoice(var pSalesInvoiceHeader: Record "Sales Invoice Header");
    var
        rL_Customer: Record Customer;
        rL_SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        rL_SalesInvoiceHeader.RESET;
        rL_SalesInvoiceHeader.SETFILTER("No.", pSalesInvoiceHeader."No.");
        rL_SalesInvoiceHeader.FINDFIRST;
        //MESSAGE(FORMAT(rL_SalesInvoiceHeader.COUNT));

        rL_Customer.GET(rL_SalesInvoiceHeader."Bill-to Customer No.");
        rL_Customer.TESTFIELD(GLN);
    end;

    procedure CheckEDICrMemo(var pSalesCrMemoHeader: Record "Sales Cr.Memo Header");
    var
        rL_Customer: Record Customer;
        rL_SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        rL_SalesCrMemoHeader.RESET;
        rL_SalesCrMemoHeader.SETFILTER("No.", pSalesCrMemoHeader."No.");
        rL_SalesCrMemoHeader.FINDFIRST;

        //MESSAGE(FORMAT(rL_SalesCrMemoHeader.COUNT));


        rL_Customer.GET(rL_SalesCrMemoHeader."Bill-to Customer No.");
        rL_Customer.TESTFIELD(GLN);

        rL_SalesCrMemoHeader.TESTFIELD("Reason Code");
    end;

    procedure WriteText(Text: Text[250]; Numberpos: Integer; Align: Code[1]; "Filling character": Text[1]; LineTransition: Boolean) LineText: Text[1024];
    var
        NewLine: Char;
        NewLine2: Char;
        CharTab: Char;
    begin
        /*
        Text:= CONVERTSTR(Text,
                          'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδζικλμνƒ„…‹”•΅£¤i¦¨©£¤―ωάέήϊίόώΆΈΉΊ',
                          'CueaaaaceeeiiiAAEaAooouuyOUoOaiounAAAcyaAoDEEEiIIIEEIOBOOoOuUUUyY');
        
        
        Text:= UPPERCASE(Text);
        Text:=DELCHR(Text,'=',(DELCHR(Text,'=',Text1000013)));
        */

        FillOut(Text, Numberpos, Align, "Filling character");
        LineText := Text;

        //CFile.WRITE(Text);
        //IF NOT LineTransition THEN
        //  CFile.SEEK(CFile.POS()-2);

        NewLine := 13;
        NewLine2 := 10;
        CharTab := 9;


        if vG_UseDotNet = true then begin

        end else begin
            if LineTransition then begin
                LineText += FORMAT(NewLine) + FORMAT(NewLine2);
            end;
        end;

    end;

    procedure FillOut(var Text: Text[250]; Numberpos: Integer; Align: Code[1]; "Filling character": Text[1]);
    begin
        if Numberpos > STRLEN(Text) then begin
            if "Filling character" = '' then
                "Filling character" := ' ';
            case Align of
                '', '<':
                    Text := PADSTR(Text, Numberpos, "Filling character");
                '>':
                    Text := PADSTR('', Numberpos - STRLEN(Text), "Filling character") + Text;
                else
                    ERROR(Text1000014);
            end;
        end else
            if (Numberpos < STRLEN(Text)) then begin
                case Align of
                    '', '<':
                        Text := COPYSTR(Text, 1, Numberpos);
                    '>':
                        Text := DELSTR(Text, 1, STRLEN(Text) - Numberpos);
                    else
                        ERROR(Text1000014);
                end;
            end;
    end;

    // local procedure CreateFile(pFileName: Text);
    // begin
    //     CLEAR(TargetFile);
    //     CLEAR(TargetStream);
    //     CLEAR(TargetText);

    //     ExportFileName := rG_SRSetup."EDI Export Path Server" + pFileName;

    //     if rG_SRSetup."EDI Create Server File" then begin
    //         TargetFile.CREATE(ExportFileName);
    //         TargetFile.TEXTMODE(false);
    //         TargetFile.CREATEOUTSTREAM(TargetStream);
    //     end;

    //     CLEAR(vG_TempBlob);
    //     vG_TempBlob.CreateOutStream(vG_OutS, TEXTENCODING::UTF8);

    //     if (vG_UseDotNet = true) and (rG_SRSetup."EDI Create Server File") then begin
    //         /*
    //         0: //DOS-PC8
    //           streamReader := streamReader.StreamReader(InStr, encoding.GetEncoding(850));
    //         1: //ANSI
    //           streamReader := streamReader.StreamReader(InStr, encoding.GetEncoding(1252));
    //         2: //UTF8
    //           streamReader := streamReader.StreamReader(InStr, encoding.UTF8);
    //         */

    //         case rG_SRSetup."EDI Encoding Export" of
    //             rG_SRSetup."EDI Encoding Export"::ANSI:
    //                 begin
    //                     streamWriter := streamWriter.StreamWriter(TargetStream, encoding.GetEncoding(1252));
    //                 end;
    //             rG_SRSetup."EDI Encoding Export"::"DOS-PC8":
    //                 begin
    //                     streamWriter := streamWriter.StreamWriter(TargetStream, encoding.GetEncoding(850));
    //                 end;
    //             rG_SRSetup."EDI Encoding Export"::Unicode:
    //                 begin
    //                     streamWriter := streamWriter.StreamWriter(TargetStream, encoding.Unicode);
    //                 end;
    //             rG_SRSetup."EDI Encoding Export"::UTF8:
    //                 begin
    //                     streamWriter := streamWriter.StreamWriter(TargetStream, encoding.UTF8);
    //                 end;
    //         end;

    //     end;

    // end;

    local procedure CreateFile(pFileName: Text);
    var
        Encoding: TextEncoding;
    begin
        CLEAR(TargetFile);
        CLEAR(TargetStream);
        CLEAR(TargetText);

        /* ExportFileName := rG_SRSetup."EDI Export Path Server" + pFileName;

        if rG_SRSetup."EDI Create Server File" then begin
            TargetFile.CREATE(ExportFileName);
            TargetFile.TEXTMODE(false);
            TargetFile.CREATEOUTSTREAM(TargetStream);
        end;

        CLEAR(vG_TempBlob);
        vG_TempBlob.CreateOutStream(vG_OutS, TEXTENCODING::UTF8);

        if (vG_UseDotNet = true) and (rG_SRSetup."EDI Create Server File") then begin
            case rG_SRSetup."EDI Encoding Export" of
                rG_SRSetup."EDI Encoding Export"::ANSI:
                    Encoding := TextEncoding::Windows;
                rG_SRSetup."EDI Encoding Export"::"DOS-PC8":
                    Encoding := TextEncoding::MSDos;
                rG_SRSetup."EDI Encoding Export"::Unicode:
                    Encoding := TextEncoding::UTF16;
                rG_SRSetup."EDI Encoding Export"::UTF8:
                    Encoding := TextEncoding::UTF8;
            end;
        end; */

        ExportFileName := rG_SRSetup."EDI Export Path Server" + pFileName;

        if rG_SRSetup."EDI Create Server File" then begin
            // Create file
            TargetFile.Create(ExportFileName);

            // Choose encoding from setup
            case rG_SRSetup."EDI Encoding Export" of
                rG_SRSetup."EDI Encoding Export"::ANSI:
                    Encoding := TextEncoding::Windows;
                rG_SRSetup."EDI Encoding Export"::"DOS-PC8":
                    Encoding := TextEncoding::MSDos;
                rG_SRSetup."EDI Encoding Export"::Unicode:
                    Encoding := TextEncoding::UTF16;
                rG_SRSetup."EDI Encoding Export"::UTF8:
                    Encoding := TextEncoding::UTF8;
            end;

            // Create stream with selected encoding
            TargetFile.CreateOutStream(TargetStream);
        end;
    end;

    local procedure CloseFile();
    begin

        //TargetFile.SEEK(TargetFile.POS()-2);

        if vG_UseDotNet = true then begin
            //streamWriter.Close();
            TargetFile.CLOSE;
        end else begin
            if rG_SRSetup."EDI Create Server File" then begin
                TargetText.WRITE(TargetStream); //encoding
            end;

            TargetText.Write(vG_OutS);


        end;

        if rG_SRSetup."EDI Create Server File" then begin
            TargetFile.CLOSE;
        end;
    end;

    local procedure FormatDecimal(pDecimal: Text): Text;
    begin

        exit(DELCHR(pDecimal, '=', ',.'));
    end;

    procedure HeaderInfoSInvoice();
    var
        rL_Customer: Record Customer;
        SalesInvLine: Record "Sales Invoice Line";
    begin
        CustAmount := 0;
        AmountInclVAT := 0;
        CostLCY := 0;
        InvDiscAmount := 0;
        LineQty := 0;
        TotalNetWeight := 0;
        TotalGrossWeight := 0;
        TotalVolume := 0;
        TotalParcels := 0;
        VATPercentage := 0;
        VATAmount := 0;
        InvDiscAmount := 0;
        AmountLCY := 0;

        for I := 1 to 3 do begin
            VATArrayColumn1[I] := '';
            VATArrayColumn2[I] := '';
            VATArrayColumn3[I] := '';
            VATArrayColumn4[I] := '';
            VATArrayColumn5[I] := '';
        end;

        rL_Customer.GET(rG_SalesInvoiceHeader."Bill-to Customer No.");


        if rG_SalesInvoiceHeader."Currency Code" = '' then
            currency.InitRoundingPrecision
        else
            currency.GET(rG_SalesInvoiceHeader."Currency Code");

        SalesInvLine.SETRANGE("Document No.", rG_SalesInvoiceHeader."No.");
        if SalesInvLine.FIND('-') then
            repeat
                CustAmount := CustAmount + SalesInvLine.Amount;
                AmountInclVAT := AmountInclVAT + SalesInvLine."Amount Including VAT";
                if rG_SalesInvoiceHeader."Prices Including VAT" then
                    InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount" / (1 + SalesInvLine."VAT %" / 100)
                else
                    InvDiscAmount := InvDiscAmount + SalesInvLine."Inv. Discount Amount";
                CostLCY := CostLCY + (SalesInvLine.Quantity * SalesInvLine."Unit Cost (LCY)");
                LineQty := LineQty + SalesInvLine.Quantity;
                TotalNetWeight := TotalNetWeight + (SalesInvLine.Quantity * SalesInvLine."Net Weight");
                TotalGrossWeight := TotalGrossWeight + (SalesInvLine.Quantity * SalesInvLine."Gross Weight");
                TotalVolume := TotalVolume + (SalesInvLine.Quantity * SalesInvLine."Unit Volume");
                if SalesInvLine."Units per Parcel" > 0 then
                    TotalParcels := TotalParcels + ROUND(SalesInvLine.Quantity / SalesInvLine."Units per Parcel", 1, '>');
                if SalesInvLine."VAT %" <> VATPercentage then
                    if VATPercentage = 0 then
                        VATPercentage := SalesInvLine."VAT %"
                    else
                        VATPercentage := -1;
                TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesInvLineCostLCY(SalesInvLine);
            until SalesInvLine.NEXT = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount, currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
            VATAmountText := Text000
        else
            VATAmountText := STRSUBSTNO(Text001, VATPercentage);

        if rG_SalesInvoiceHeader."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WORKDATE, rG_SalesInvoiceHeader."Currency Code", CustAmount, rG_SalesInvoiceHeader."Currency Factor");

        SalesInvLine.CalcVATAmountLines(rG_SalesInvoiceHeader, TempVATAmountLine);

        CLEAR(rG_SalesShipment);
        rG_ValueEntry.RESET;
        rG_ValueEntry.SETFILTER("Document No.", rG_SalesInvoiceHeader."No.");
        rG_ValueEntry.SETRANGE("Document Type", rG_ValueEntry."Document Type"::"Sales Invoice");
        if rG_ValueEntry.FINDSET then begin
            rG_TempILENo := rG_ValueEntry."Item Ledger Entry No.";
            rG_ValueEntry.RESET;
            rG_ValueEntry.SETRANGE("Item Ledger Entry No.", rG_TempILENo);
            rG_ValueEntry.SETRANGE("Document Type", rG_ValueEntry."Document Type"::"Sales Shipment");
            if rG_ValueEntry.FINDSET then begin
                rG_SalesShipment.RESET;
                rG_SalesShipment.SETFILTER("No.", rG_ValueEntry."Document No.");
                if rG_SalesShipment.FINDSET then;
            end;

        end;


        //MESSAGE(FORMAT(TempVATAmountLine.COUNT));
        //----------------------------------------------------------------------------------------------------------

        CurrentLine := '';
        CurrentLine += WriteText(rG_SalesInvoiceHeader."No.", 14, '<', '', false); //1 Αριθμός εγγραφής [ref_number]
        CurrentLine += WriteText('CY' + rG_CompanyInfo."VAT Registration No.", 13, '<', '', false); //2 ΑΦΜ Προμηθευτή [afm_supplier]
        CurrentLine += WriteText(rG_CompanyInfo.GLN, 13, '<', '', false); //3 GLN Προμηθευτή [GLN_supplier]

        if rL_Customer."No." = 'CUST00032' then begin
            rL_Customer."VAT Registration No." := 'CY' + rL_Customer."VAT Registration No.";
        end;

        CurrentLine += WriteText(rL_Customer."VAT Registration No.", 13, '<', '', false); //4 ΑΦΜ Λιανέμπορου [afm_retailer]
        CurrentLine += WriteText(rL_Customer.GLN, 13, '<', '', false); //5 GLN Λιανέμπορου [GLN_retailer]

        //if header has ship to read delivery from ship to
        vG_GLNDelivery := '';
        if rG_SalesInvoiceHeader."Ship-to Code" = '' then begin
            vG_GLNDelivery := rL_Customer."GLN Delivery";
        end else begin
            rG_ShipToAddress.RESET;
            rG_ShipToAddress.SETFILTER("Customer No.", rG_SalesInvoiceHeader."Sell-to Customer No.");
            rG_ShipToAddress.SETFILTER(Code, rG_SalesInvoiceHeader."Ship-to Code");
            if rG_ShipToAddress.FINDSET then begin
                vG_GLNDelivery := rG_ShipToAddress."GLN Delivery";
            end;
        end;
        if vG_GLNDelivery = '' then begin
            ERROR('GLN Delivery cannot be blank for Document ' + rG_SalesInvoiceHeader."No.");
        end;

        CurrentLine += WriteText(vG_GLNDelivery, 13, '<', '', false); //6 GLN Τόπου παράδοσης [GLN_delivery]
        CurrentLine += WriteText('', 13, '<', '', false); //7 ΑΦΜ αντιπροσώπου [afm_distrib]
        CurrentLine += WriteText('', 13, '<', '', false); //8 ΑΦΜ εντολέα[afm_issuer]
        CurrentLine += WriteText('2', 2, '<', '', false); //9 Τύπος παραστατικού [inv_type]
        CurrentLine += WriteText(COPYSTR(rG_SalesInvoiceHeader."No. Series", 1, 3), 3, '<', '', false); //10 Σειρά Παραστατικού  [inv_sec]

        CurrentLine += WriteText(rG_SalesInvoiceHeader."No.", 20, '<', '', false); //11 Αριθμός Παραστατικού [inv_number]
        CurrentLine += WriteText(FORMAT(rG_SalesInvoiceHeader."Posting Date", 0, Text1000010), 8, '<', '', false); //12 Ημ/νία έκδοσης παραστατικού [inv_date]
        CurrentLine += WriteText('', 2, '<', '', false); //13 Τύπος Αντίστοιχου Παραστατικού [ref_inv_type]
        CurrentLine += WriteText('', 3, '<', '', false); //14 Σειρά Αντίστοιχου Παραστατικού [ref_inv_seq]
        CurrentLine += WriteText(rG_SalesShipment."No.", 20, '<', '', false); //15 Αριθμός Αντίστοιχου Παραστατικού [ref_inv_number]
        CurrentLine += WriteText(FORMAT(rG_SalesShipment."Posting Date", 0, Text1000010), 8, '<', '', false); //16 Ημερομηνία Αντίστοιχου Παραστατικού [ref_inv_date]
        CurrentLine += WriteText(rG_SalesShipment."External Document No.", 20, '<', '', false); //17 Αριθμός Αντίστοιχης Παραγγελίας [order_seq]
        CurrentLine += WriteText('', 3, '<', '', false); //18 Σειρά Αντίστοιχης Παραγγελίας[order_seq]
        CurrentLine += WriteText(FORMAT(rG_SalesShipment."Order Date", 0, Text1000010), 8, '<', '', false); //19 Ημερομηνία Παραγγελίας [order_date]
        CurrentLine += WriteText(FORMAT(rG_SalesInvoiceHeader."Shipment Date", 0, Text1000010), 8, '<', '', false); //20 Ημερομηνία παράδοσης [arrival_date]

        CurrentLine += WriteText(FORMAT(rG_SalesInvoiceHeader."Shipment Date", 0, Text1000010), 8, '<', '', false); //21 Ημερομηνία αποστολής [departure_date]
        CurrentLine += WriteText('30', 2, '<', '', false); //22 Τρόπος πληρωμής [payment_type]
        CurrentLine += WriteText('', 100, '<', '', false); //23 Περιγραφή Όρων πληρωμής  [payment_terms]

        if rG_SalesInvoiceHeader."Currency Code" = '' then begin
            rG_GLSetup.GET;
            CurrentLine += WriteText(rG_GLSetup."LCY Code", 3, '<', '', false); //24 Νόμισμα  [currency]
        end else begin
            CurrentLine += WriteText(rG_SalesInvoiceHeader."Currency Code", 3, '<', '', false); //24 Νόμισμα  [currency]
        end;

        rG_PaymentTerms.GET(rG_SalesInvoiceHeader."Payment Terms Code");


        CurrentLine += WriteText(DELCHR(FORMAT(rG_PaymentTerms."Due Date Calculation"), '=', 'D'), 3, '<', '', false); //25 Αριθμός Ημερών για Πληρωμή  [payment_days]
        CurrentLine += WriteText('', 1, '<', '', false); //26 Καθεστώς ΦΠΑ Προμηθευτή [supplier_vat]
        CurrentLine += WriteText('', 1, '<', '', false); //27 Κωδικός Κίνησης [move_code]

        Amountstr := FORMAT(CustAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //28 Καθαρή Αξία προ εκπτώσεων [net_amount]

        Amountstr := FORMAT(InvDiscAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //29 Αξία Εκπτώσεων [allow_amount] 14,2
        CurrentLine += WriteText('', 5, '<', '', false); //30 Ποσοστό άλλων εκπτώσεων  [oth_allow_percent]

        CurrentLine += WriteText('', 14, '<', '', false); //31 Αξία άλλων εκπτώσεων  [oth_allow_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //32 Συνολικές Εκπτώσεις [total_allows]
        CurrentLine += WriteText('', 14, '<', '', false); //33 Αξία Επιβαρύνσεων [charges_amount]
        CurrentLine += WriteText('', 5, '<', '', false); //34 Ποσοστό άλλων Επιβαρύνσεων [oth_charges_percent]
        CurrentLine += WriteText('', 14, '<', '', false); //35 Αξία άλλων επιβαρύνσεων [oth_charges_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //36 Συνολική Αξία Επιβαρύνσεων [total_charges]

        if TempVATAmountLine.FINDSET then begin
            I := 0;
            repeat
                I += 1;

                VATArrayColumn1[I] := FORMAT(TempVATAmountLine."VAT %");

                Amountstr := FORMAT(TempVATAmountLine."VAT Amount", 0, Text1000016);
                VATArrayColumn2[I] := Amountstr;
                VATArrayColumn3[I] := '';

                Amountstr := FORMAT(TempVATAmountLine."VAT Base", 0, Text1000016);
                VATArrayColumn4[I] := Amountstr;

                Amountstr := FORMAT(TempVATAmountLine."Amount Including VAT", 0, Text1000016);
                VATArrayColumn5[I] := Amountstr;

            until TempVATAmountLine.NEXT = 0;
        end;

        if I > 3 then begin
            ERROR('Only up to 3 VAT Rates are supported');
        end;

        CurrentLine += WriteText(VATArrayColumn1[1], 2, '<', '', false); //37 Ποσοστό ΦΠΑ 1 [vat_rate1]
        CurrentLine += WriteText(VATArrayColumn2[1], 14, '<', '', false); //38 Υποκείμενη Αξία 1 [vat_amount1]
        CurrentLine += WriteText(VATArrayColumn3[1], 14, '<', '', false); //39 Αξία Επιβαρύνσεων 1[vat_charges1]
        CurrentLine += WriteText(VATArrayColumn4[1], 14, '<', '', false); //40 Φορολογούμενο Ποσό 1 [taxable_amount1]
        CurrentLine += WriteText(VATArrayColumn5[1], 14, '<', '', false); //41 Αξία ΦΠΑ 1[amount_per_vat1]

        CurrentLine += WriteText(VATArrayColumn1[2], 2, '<', '', false); //42 Ποσοστό ΦΠΑ 2 [vat_rate2]
        CurrentLine += WriteText(VATArrayColumn2[2], 14, '<', '', false); //43 Υποκείμενη Αξία 2 [vat_amount2]
        CurrentLine += WriteText(VATArrayColumn3[2], 14, '<', '', false); //44 Αξία Επιβαρύνσεων 2 [vat_charges2]
        CurrentLine += WriteText(VATArrayColumn4[2], 14, '<', '', false); //45 Φορολογούμενο Ποσό 2 [taxable_amount2]
        CurrentLine += WriteText(VATArrayColumn5[2], 14, '<', '', false); //46 Αξία ΦΠΑ 2 [amount_per_vat2]

        CurrentLine += WriteText(VATArrayColumn1[3], 2, '<', '', false); //47 Ποσοστό ΦΠΑ 3 [vat_rate3]
        CurrentLine += WriteText(VATArrayColumn2[3], 14, '<', '', false); //48 Υποκείμενη Αξία 3 [vat_amount3]
        CurrentLine += WriteText(VATArrayColumn3[3], 14, '<', '', false); //49 Αξία Επιβαρύνσεων 3 [vat_charges3]
        CurrentLine += WriteText(VATArrayColumn4[3], 50, '<', '', false); //50 Φορολογούμενο Ποσό 3 [taxable_amount3]
        CurrentLine += WriteText(VATArrayColumn5[3], 14, '<', '', false); //51 Αξία ΦΠΑ 3 [amount_per_vat3]


        CurrentLine += WriteText('', 2, '<', '', false); //52 Είδος φόρου 1[Other_tax_tax_type]
        CurrentLine += WriteText('', 5, '<', '', false); //53 Ποσοστό φόρου 1 [Other_tax_tax_rate]
        CurrentLine += WriteText('', 14, '<', '', false); //54 Αξία φόρου  1 [Other_tax_taxamount]
        CurrentLine += WriteText('', 15, '<', '', false); //55 Περιγραφή φόρου 1 [Other_tax_tax_description]
        CurrentLine += WriteText('', 2, '<', '', false); //56 Είδος φόρου 2 [Other_tax_tax_type]
        CurrentLine += WriteText('', 5, '<', '', false); //57 Ποσοστό φόρου 2  [Other_tax_tax_rate]
        CurrentLine += WriteText('', 14, '<', '', false); //58 Αξία φόρου  2 [Other_tax_taxamount]
        CurrentLine += WriteText('', 15, '<', '', false); //59 Περιγραφή φόρου 2 [Other_tax_tax_description]
        CurrentLine += WriteText('', 14, '<', '', false); //60 Συνολική Υποκείμενη Αξία [total_sub_amount]

        CurrentLine += WriteText('', 14, '<', '', false); //61 Συνολικό Φορολογούμενο Ποσό [total_taxable_amount]#

        Amountstr := FORMAT(VATAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //62 Συνολικό ΦΠΑ [total_vat_amount]


        Amountstr := FORMAT(CustAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //63 Μεικτή Αξία [gross_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //64 Αξία μεταφορικών [transport_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //65 ΦΠΑ μεταφορικών[transport_vat]

        Amountstr := FORMAT(AmountInclVAT, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //66 Συνολικό Ποσό Πληρωμής [total_pay_amount]
        CurrentLine += WriteText(FORMAT(LineQty, 0, Text1000017), 11, '<', '', false); //67 Σύνολο τεμαχίων [total_cu] 11,3
        CurrentLine += WriteText('', 100, '<', '', true); //68  Σχόλια  [comments] //last line

        if vG_UseDotNet = true then begin
            //streamWriter.WriteLine(CurrentLine);
            TargetFile.Write(CurrentLine);
        end else begin
            TargetText.ADDTEXT(CurrentLine);  //NOD0.7
        end;

        rG_SalesInvoiceHeader."Export DateTime" := CURRENTDATETIME;
        rG_SalesInvoiceHeader.MODIFY;
    end;

    procedure BodyInfoSInvoiceLines();
    var
        BankAcc: Record "Bank Account";
        CommentLine: Text;
        Country: Record "Country/Region";
        GenCat: Record "General Categories";
        Customer: Record Customer;

        CountryofOriginName: Text;
        PotatoesDesc: Text;
        ProductClass: Text;
    begin


        CurrentLine := '';
        CurrentLine += WriteText(rG_SalesInvoiceLine."Document No.", 14, '<', '', false); //1 Αριθμός εγγραφής [ref_number]
        CurrentLine += WriteText(FORMAT(sLineNo), 14, '<', '', false); //2 Αύξων αριθμός γραμμής [line_number]

        vG_ShelfNo := '';
        rG_Item.GET(rG_SalesInvoiceLine."No.");
        if rG_SalesInvoiceLine."Shelf No." = '' then begin
            vG_ShelfNo := rG_Item."Shelf No.";
        end else begin
            vG_ShelfNo := rG_SalesInvoiceLine."Shelf No.";
        end;
        if vG_ShelfNo = '' then begin
            ERROR('Shelf No. cannot be blank. Item No.' + rG_SalesInvoiceLine."No.");
        end;

        CurrentLine += WriteText(vG_ShelfNo, 20, '<', '', false); //3 Κωδικός προϊόντος προμηθευτή [SKU]

        //find the cross reference
        rG_CrossReference.RESET;
        rG_CrossReference.SETFILTER("Item No.", rG_SalesInvoiceLine."No.");
        //rG_CrossReference.SETRANGE("Cross-Reference Type", rG_CrossReference."Cross-Reference Type"::"Bar Code");
        rG_CrossReference.SETRANGE("Reference Type", rG_CrossReference."Reference Type"::"Bar Code");
        if rG_CrossReference.FINDSET then begin
            //CurrentLine += WriteText(rG_CrossReference."Cross-Reference No.", 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
            CurrentLine += WriteText(rG_CrossReference."Reference No.", 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
        end else begin
            CurrentLine += WriteText('', 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
        end;


        CurrentLine += WriteText(rG_SalesInvoiceLine.Description, 70, '<', '', false); //5 Περιγραφή Προϊόντος [prod_description]
        CurrentLine += WriteText(rG_SalesInvoiceLine."Unit of Measure Code", 9, '<', '', false); //6 Μονάδα μέτρησης της ποσότητας παράδοσης [delivery_mu]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Qty. per Unit of Measure", 0, Text1000017);
        CurrentLine += WriteText(Amountstr, 11, '<', '', false); //7 Συντελεστής Κιβωτιοποίησης [delivery_capacity] 11,3

        Amountstr := FORMAT(rG_SalesInvoiceLine.Quantity, 0, Text1000017);
        CurrentLine += WriteText(Amountstr, 11, '<', '', false); //8 Ποσότητα παράδοσης  [delivery_qty]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Unit Price", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //9  Τιμή μονάδος [price]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Line Discount %", 0, Text1000018);
        CurrentLine += WriteText(Amountstr, 5, '<', '', false); //10  Ποσοστό έκπτωσης 1[allow_percent1]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Line Discount Amount", 0, Text1000018);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //11 Ποσό έκπτωσης  1 [allow_amount1]
        CurrentLine += WriteText('', 5, '<', '', false); //12 Ποσοστό έκπτωσης 2[allow_percent2]
        CurrentLine += WriteText('', 14, '<', '', false); //13  Ποσό έκπτωσης  2 [allow_amount2]
        CurrentLine += WriteText('', 5, '<', '', false); //14  Ποσοστό έκπτωσης 3[allow_percent3]
        CurrentLine += WriteText('', 14, '<', '', false); //15  Ποσό έκπτωσης  3 [allow_amount3]
        CurrentLine += WriteText('', 5, '<', '', false); //16 Ποσοστό έκπτωσης 4[allow_percent4]
        CurrentLine += WriteText('', 14, '<', '', false); //17 Ποσό έκπτωσης  4 [allow_amount4]
        CurrentLine += WriteText('', 14, '<', '', false); //18 Συνολική αξία εκπτώσεων [total_allows]
        CurrentLine += WriteText('', 5, '<', '', false); //19 Ποσοστό επιβάρυνσης 1 [charge_percent1]
        CurrentLine += WriteText('', 14, '<', '', false); //20 Ποσό επιβάρυνσης 1 [charge_amount1]


        CurrentLine += WriteText('', 5, '<', '', false); //21 Ποσοστό επιβάρυνσης 2 [charge_percent2]
        CurrentLine += WriteText('', 14, '<', '', false); //22 Ποσό επιβάρυνσης 2 [charge_amount2]
        CurrentLine += WriteText('', 14, '<', '', false); //23 Συνολική αξία επιβαρύνσεων [total_charges]
        CurrentLine += WriteText(FORMAT(rG_SalesInvoiceLine."VAT %"), 3, '<', '', false); //24 Ποσοστό ΦΠΑ [vat_percent]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Amount Including VAT" - rG_SalesInvoiceLine.Amount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //25 Αξία ΦΠΑ [vat_amount]
        CurrentLine += WriteText('', 5, '<', '', false); //26 Ποσοστό άλλων φόρων  [tax_percent]
        CurrentLine += WriteText('', 14, '<', '', false); //27 Αξία άλλων φόρων [tax_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //28 Καθαρή αξία προ έκπτωσεων [net_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //29 Υποκείμενη αξία [sub_amount]
        Amountstr := FORMAT(rG_SalesInvoiceLine."VAT Base Amount", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //30 Φορολογούμενο ποσό [taxable_amount]

        Amountstr := FORMAT(rG_SalesInvoiceLine.Quantity * rG_SalesInvoiceLine."Unit Price", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //31 Μεικτή αξία [gross_amount]


        CurrentLine += WriteText('', 14, '<', '', false); //32 Τελική τιμή μονάδος [net_price]

        Amountstr := FORMAT(rG_SalesInvoiceLine."Line Amount", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //33 Συνολική τελική αξία προϊόντος [final_amount]

        CurrentLine += WriteText(rG_SalesInvoiceLine."Shipment No.", 20, '<', '', false); //34 Αριθμός αντίστοιχου παραστατικού – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_number]4

        if rG_SalesInvoiceLine."Shipment No." = '' then begin
            CurrentLine += WriteText('', 20, '<', '', false); //35  Τύπος αντίστοιχου παραστατικού – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_type]
        end else begin
            CurrentLine += WriteText('1', 20, '<', '', false); //35  Τύπος αντίστοιχου παραστατικού – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_type]
        end;

        CurrentLine += WriteText(FORMAT(rG_SalesInvoiceLine."Shipment Date", 0, Text1000010), 8, '<', '', false); //36 Ημερομηνία αντίστοιχου παραστατικού– σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_date]
        CurrentLine += WriteText('', 20, '<', '', false); //37 Αριθμός αντίστοιχης παραγγελίας πελάτη – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλές παραγγελίες πελάτη [order_number]
        CurrentLine += WriteText('', 8, '<', '', false); //38 Ημερομηνία αντίστοιχης παραγγελίας πελάτη – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλές παραγγελίες πελάτη [order_date]
        CurrentLine += WriteText('', 8, '<', '', false); //39 Ημερομηνία λήξης [expire_date]
        CurrentLine += WriteText('', 20, '<', '', false); //40 Αριθμός παρτίδας [lot_number]


        //+1.0.0.303
        CommentLine := '';
        Customer.GET(rG_SalesInvoiceHeader."Sell-to Customer No.");
        if Customer."Mandatory CY Fields" then begin
            ProductClass := rG_SalesInvoiceLine."Product Class";

            if Country.get(rG_SalesInvoiceLine."Country/Region of Origin Code") then begin
                CountryofOriginName := Country.Name;
                CommentLine := CountryofOriginName;
            end;

            if ProductClass <> '' then begin
                CommentLine += ',' + ProductClass;
            end;


            if GenCat.GET(27, GenCat.Type::Category9, rG_SalesInvoiceLine."Category 9") then begin
                PotatoesDesc := GenCat.Description;
                CommentLine += ',' + PotatoesDesc;
            end;
        end;
        //-1.0.0.303

        CurrentLine += WriteText(CommentLine, 50, '<', '', true); //41 Σχόλια [comments]

        if vG_UseDotNet = true then begin
            //streamWriter.WriteLine(CurrentLine);
            TargetFile.Write(CurrentLine);
        end else begin
            TargetText.ADDTEXT(CurrentLine);  //NOD0.7
        end;
    end;

    procedure HeaderInfoSCrMemo();
    var
        rL_Customer: Record Customer;
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        CustAmount := 0;
        AmountInclVAT := 0;
        CostLCY := 0;
        InvDiscAmount := 0;
        LineQty := 0;
        TotalNetWeight := 0;
        TotalGrossWeight := 0;
        TotalVolume := 0;
        TotalParcels := 0;
        VATPercentage := 0;
        VATAmount := 0;
        InvDiscAmount := 0;
        AmountLCY := 0;

        for I := 1 to 3 do begin
            VATArrayColumn1[I] := '';
            VATArrayColumn2[I] := '';
            VATArrayColumn3[I] := '';
            VATArrayColumn4[I] := '';
            VATArrayColumn5[I] := '';
        end;

        rL_Customer.GET(rG_SalesCrMemoHeader."Bill-to Customer No.");


        if rG_SalesCrMemoHeader."Currency Code" = '' then
            currency.InitRoundingPrecision
        else
            currency.GET(rG_SalesCrMemoHeader."Currency Code");

        SalesCrMemoLine.SETRANGE("Document No.", rG_SalesCrMemoHeader."No.");
        if SalesCrMemoLine.FIND('-') then
            repeat
                CustAmount := CustAmount + SalesCrMemoLine.Amount;
                AmountInclVAT := AmountInclVAT + SalesCrMemoLine."Amount Including VAT";
                if rG_SalesInvoiceHeader."Prices Including VAT" then
                    InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount" / (1 + SalesCrMemoLine."VAT %" / 100)
                else
                    InvDiscAmount := InvDiscAmount + SalesCrMemoLine."Inv. Discount Amount";
                CostLCY := CostLCY + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Cost (LCY)");
                LineQty := LineQty + SalesCrMemoLine.Quantity;
                TotalNetWeight := TotalNetWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Net Weight");
                TotalGrossWeight := TotalGrossWeight + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Gross Weight");
                TotalVolume := TotalVolume + (SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Volume");
                if SalesCrMemoLine."Units per Parcel" > 0 then
                    TotalParcels := TotalParcels + ROUND(SalesCrMemoLine.Quantity / SalesCrMemoLine."Units per Parcel", 1, '>');
                if SalesCrMemoLine."VAT %" <> VATPercentage then
                    if VATPercentage = 0 then
                        VATPercentage := SalesCrMemoLine."VAT %"
                    else
                        VATPercentage := -1;
                TotalAdjCostLCY := TotalAdjCostLCY + CostCalcMgt.CalcSalesCrMemoLineCostLCY(SalesCrMemoLine);
            until SalesCrMemoLine.NEXT = 0;
        VATAmount := AmountInclVAT - CustAmount;
        InvDiscAmount := ROUND(InvDiscAmount, currency."Amount Rounding Precision");

        if VATPercentage <= 0 then
            VATAmountText := Text000
        else
            VATAmountText := STRSUBSTNO(Text001, VATPercentage);

        if rG_SalesInvoiceHeader."Currency Code" = '' then
            AmountLCY := CustAmount
        else
            AmountLCY :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                WORKDATE, rG_SalesInvoiceHeader."Currency Code", CustAmount, rG_SalesInvoiceHeader."Currency Factor");

        SalesCrMemoLine.CalcVATAmountLines(rG_SalesCrMemoHeader, TempVATAmountLine);

        //MESSAGE(FORMAT(TempVATAmountLine.COUNT));
        //----------------------------------------------------------------------------------------------------------

        CurrentLine := '';
        CurrentLine += WriteText(rG_SalesCrMemoHeader."No.", 14, '<', '', false); //1 Αριθμός εγγραφής [ref_number]
        CurrentLine += WriteText('CY' + rG_CompanyInfo."VAT Registration No.", 13, '<', '', false); //2 ΑΦΜ Προμηθευτή [afm_supplier]
        CurrentLine += WriteText(rG_CompanyInfo.GLN, 13, '<', '', false); //3 GLN Προμηθευτή [GLN_supplier]

        if rL_Customer."No." = 'CUST00032' then begin
            rL_Customer."VAT Registration No." := 'CY' + rL_Customer."VAT Registration No.";
        end;
        CurrentLine += WriteText(rL_Customer."VAT Registration No.", 13, '<', '', false); //4 ΑΦΜ Λιανέμπορου [afm_retailer]
        CurrentLine += WriteText(rL_Customer.GLN, 13, '<', '', false); //5 GLN Λιανέμπορου [GLN_retailer]
        CurrentLine += WriteText(rL_Customer."GLN Delivery", 13, '<', '', false); //6 GLN Τόπου παράδοσης [GLN_delivery]
        CurrentLine += WriteText('', 13, '<', '', false); //7 ΑΦΜ αντιπροσώπου [afm_distrib]
        CurrentLine += WriteText('', 13, '<', '', false); //8 ΑΦΜ εντολέα[afm_issuer]

        rG_ReasonCode.GET(rG_SalesCrMemoHeader."Reason Code");

        CurrentLine += WriteText(FORMAT(rG_ReasonCode."EDI Code"), 2, '<', '', false); //9 Τύπος παραστατικού [inv_type]

        CurrentLine += WriteText(COPYSTR(rG_SalesCrMemoHeader."No. Series", 1, 3), 3, '<', '', false); //10 Σειρά Παραστατικού  [inv_sec]

        CurrentLine += WriteText(rG_SalesCrMemoHeader."No.", 20, '<', '', false); //11 Αριθμός Παραστατικού [inv_number]
        CurrentLine += WriteText(FORMAT(rG_SalesCrMemoHeader."Posting Date", 0, Text1000010), 8, '<', '', false); //12 Ημ/νία έκδοσης παραστατικού [inv_date]
        CurrentLine += WriteText('', 2, '<', '', false); //13 Τύπος Αντίστοιχου Παραστατικού [ref_inv_type]
        CurrentLine += WriteText('', 3, '<', '', false); //14 Σειρά Αντίστοιχου Παραστατικού [ref_inv_seq]
        CurrentLine += WriteText('', 20, '<', '', false); //15 Αριθμός Αντίστοιχου Παραστατικού [ref_inv_number]
        CurrentLine += WriteText('', 8, '<', '', false); //16 Ημερομηνία Αντίστοιχου Παραστατικού [ref_inv_date]
        CurrentLine += WriteText(rG_SalesCrMemoHeader."External Document No.", 20, '<', '', false); //17 Αριθμός Αντίστοιχης Παραγγελίας [order_seq]
        CurrentLine += WriteText('', 3, '<', '', false); //18 Σειρά Αντίστοιχης Παραγγελίας[order_seq]
        CurrentLine += WriteText('', 8, '<', '', false); //19 Ημερομηνία Παραγγελίας [order_date]
        CurrentLine += WriteText(FORMAT(rG_SalesCrMemoHeader."Shipment Date", 0, Text1000010), 8, '<', '', false); //20 Ημερομηνία παράδοσης [arrival_date]

        CurrentLine += WriteText(FORMAT(rG_SalesCrMemoHeader."Shipment Date", 0, Text1000010), 8, '<', '', false); //21 Ημερομηνία αποστολής [departure_date]
        CurrentLine += WriteText('30', 2, '<', '', false); //22 Τρόπος πληρωμής [payment_type]
        CurrentLine += WriteText('', 100, '<', '', false); //23 Περιγραφή Όρων πληρωμής  [payment_terms]

        if rG_SalesCrMemoHeader."Currency Code" = '' then begin
            rG_GLSetup.GET;
            CurrentLine += WriteText(rG_GLSetup."LCY Code", 3, '<', '', false); //24 Νόμισμα  [currency]
        end else begin
            CurrentLine += WriteText(rG_SalesCrMemoHeader."Currency Code", 3, '<', '', false); //24 Νόμισμα  [currency]
        end;

        rG_PaymentTerms.GET(rG_SalesCrMemoHeader."Payment Terms Code");


        CurrentLine += WriteText(DELCHR(FORMAT(rG_PaymentTerms."Due Date Calculation"), '=', 'D'), 3, '<', '', false); //25 Αριθμός Ημερών για Πληρωμή  [payment_days]
        CurrentLine += WriteText('', 1, '<', '', false); //26 Καθεστώς ΦΠΑ Προμηθευτή [supplier_vat]
        CurrentLine += WriteText('', 1, '<', '', false); //27 Κωδικός Κίνησης [move_code]

        Amountstr := FORMAT(CustAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //28 Καθαρή Αξία προ εκπτώσεων [net_amount]

        Amountstr := FORMAT(InvDiscAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //29 Αξία Εκπτώσεων [allow_amount] 14,2
        CurrentLine += WriteText('', 5, '<', '', false); //30 Ποσοστό άλλων εκπτώσεων  [oth_allow_percent]

        CurrentLine += WriteText('', 14, '<', '', false); //31 Αξία άλλων εκπτώσεων  [oth_allow_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //32 Συνολικές Εκπτώσεις [total_allows]
        CurrentLine += WriteText('', 14, '<', '', false); //33 Αξία Επιβαρύνσεων [charges_amount]
        CurrentLine += WriteText('', 5, '<', '', false); //34 Ποσοστό άλλων Επιβαρύνσεων [oth_charges_percent]
        CurrentLine += WriteText('', 14, '<', '', false); //35 Αξία άλλων επιβαρύνσεων [oth_charges_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //36 Συνολική Αξία Επιβαρύνσεων [total_charges]

        if TempVATAmountLine.FINDSET then begin
            I := 0;
            repeat
                I += 1;

                VATArrayColumn1[I] := FORMAT(TempVATAmountLine."VAT %");

                Amountstr := FORMAT(TempVATAmountLine."VAT Amount", 0, Text1000016);
                VATArrayColumn2[I] := Amountstr;
                VATArrayColumn3[I] := '';

                Amountstr := FORMAT(TempVATAmountLine."VAT Base", 0, Text1000016);
                VATArrayColumn4[I] := Amountstr;

                Amountstr := FORMAT(TempVATAmountLine."Amount Including VAT", 0, Text1000016);
                VATArrayColumn5[I] := Amountstr;

            until TempVATAmountLine.NEXT = 0;
        end;

        if I > 3 then begin
            ERROR('Only up to 3 VAT Rates are supported');
        end;

        CurrentLine += WriteText(VATArrayColumn1[1], 2, '<', '', false); //37 Ποσοστό ΦΠΑ 1 [vat_rate1]
        CurrentLine += WriteText(VATArrayColumn2[1], 14, '<', '', false); //38 Υποκείμενη Αξία 1 [vat_amount1]
        CurrentLine += WriteText(VATArrayColumn3[1], 14, '<', '', false); //39 Αξία Επιβαρύνσεων 1[vat_charges1]
        CurrentLine += WriteText(VATArrayColumn4[1], 14, '<', '', false); //40 Φορολογούμενο Ποσό 1 [taxable_amount1]
        CurrentLine += WriteText(VATArrayColumn5[1], 14, '<', '', false); //41 Αξία ΦΠΑ 1[amount_per_vat1]

        CurrentLine += WriteText(VATArrayColumn1[2], 2, '<', '', false); //42 Ποσοστό ΦΠΑ 2 [vat_rate2]
        CurrentLine += WriteText(VATArrayColumn2[2], 14, '<', '', false); //43 Υποκείμενη Αξία 2 [vat_amount2]
        CurrentLine += WriteText(VATArrayColumn3[2], 14, '<', '', false); //44 Αξία Επιβαρύνσεων 2 [vat_charges2]
        CurrentLine += WriteText(VATArrayColumn4[2], 14, '<', '', false); //45 Φορολογούμενο Ποσό 2 [taxable_amount2]
        CurrentLine += WriteText(VATArrayColumn5[2], 14, '<', '', false); //46 Αξία ΦΠΑ 2 [amount_per_vat2]

        CurrentLine += WriteText(VATArrayColumn1[3], 2, '<', '', false); //47 Ποσοστό ΦΠΑ 3 [vat_rate3]
        CurrentLine += WriteText(VATArrayColumn2[3], 14, '<', '', false); //48 Υποκείμενη Αξία 3 [vat_amount3]
        CurrentLine += WriteText(VATArrayColumn3[3], 14, '<', '', false); //49 Αξία Επιβαρύνσεων 3 [vat_charges3]
        CurrentLine += WriteText(VATArrayColumn4[3], 50, '<', '', false); //50 Φορολογούμενο Ποσό 3 [taxable_amount3]
        CurrentLine += WriteText(VATArrayColumn5[3], 14, '<', '', false); //51 Αξία ΦΠΑ 3 [amount_per_vat3]


        CurrentLine += WriteText('', 2, '<', '', false); //52 Είδος φόρου 1[Other_tax_tax_type]
        CurrentLine += WriteText('', 5, '<', '', false); //53 Ποσοστό φόρου 1 [Other_tax_tax_rate]
        CurrentLine += WriteText('', 14, '<', '', false); //54 Αξία φόρου  1 [Other_tax_taxamount]
        CurrentLine += WriteText('', 15, '<', '', false); //55 Περιγραφή φόρου 1 [Other_tax_tax_description]
        CurrentLine += WriteText('', 2, '<', '', false); //56 Είδος φόρου 2 [Other_tax_tax_type]
        CurrentLine += WriteText('', 5, '<', '', false); //57 Ποσοστό φόρου 2  [Other_tax_tax_rate]
        CurrentLine += WriteText('', 14, '<', '', false); //58 Αξία φόρου  2 [Other_tax_taxamount]
        CurrentLine += WriteText('', 15, '<', '', false); //59 Περιγραφή φόρου 2 [Other_tax_tax_description]
        CurrentLine += WriteText('', 14, '<', '', false); //60 Συνολική Υποκείμενη Αξία [total_sub_amount]

        CurrentLine += WriteText('', 14, '<', '', false); //61 Συνολικό Φορολογούμενο Ποσό [total_taxable_amount]#

        Amountstr := FORMAT(VATAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //62 Συνολικό ΦΠΑ [total_vat_amount]


        Amountstr := FORMAT(CustAmount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //63 Μεικτή Αξία [gross_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //64 Αξία μεταφορικών [transport_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //65 ΦΠΑ μεταφορικών[transport_vat]

        Amountstr := FORMAT(AmountInclVAT, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //66 Συνολικό Ποσό Πληρωμής [total_pay_amount]
        CurrentLine += WriteText(FORMAT(LineQty, 0, Text1000017), 11, '<', '', false); //67 Σύνολο τεμαχίων [total_cu] 11,3
        CurrentLine += WriteText('', 100, '<', '', true); //68  Σχόλια  [comments] //last line

        if vG_UseDotNet = true then begin
            //streamWriter.WriteLine(CurrentLine);
            TargetFile.Write(CurrentLine);
        end else begin
            TargetText.ADDTEXT(CurrentLine);  //NOD0.7
        end;

        rG_SalesCrMemoHeader."Export DateTime" := CURRENTDATETIME;
        rG_SalesCrMemoHeader.MODIFY;
    end;

    procedure BodyInfoSCrMemoLines();
    var
        BankAcc: Record "Bank Account";

        CommentLine: Text;
        Country: Record "Country/Region";
        GenCat: Record "General Categories";
        Customer: Record Customer;

        CountryofOriginName: Text;
        PotatoesDesc: Text;
        ProductClass: Text;
    begin

        CurrentLine := '';
        CurrentLine += WriteText(rG_SalesCrMemoLine."Document No.", 14, '<', '', false); //1 Αριθμός εγγραφής [ref_number]
        CurrentLine += WriteText(FORMAT(sLineNo), 14, '<', '', false); //2 Αύξων αριθμός γραμμής [line_number]
        CurrentLine += WriteText(rG_SalesCrMemoLine."Shelf No.", 20, '<', '', false); //3 Κωδικός προϊόντος προμηθευτή [SKU]

        //find the cross reference
        rG_CrossReference.RESET;
        rG_CrossReference.SETFILTER("Item No.", rG_SalesCrMemoLine."No.");
        //rG_CrossReference.SETRANGE("Cross-Reference Type", rG_CrossReference."Cross-Reference Type"::"Bar Code");
        rG_CrossReference.SETRANGE("Reference Type", rG_CrossReference."Reference Type"::"Bar Code");
        if rG_CrossReference.FINDSET then begin
            CurrentLine += WriteText(rG_CrossReference."Reference No.", 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
            //CurrentLine += WriteText(rG_CrossReference."Cross-Reference No.", 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
        end else begin
            CurrentLine += WriteText('', 14, '<', '', false); //4 ΕΑΝ τεμαχίου [EAN_cu]
        end;


        CurrentLine += WriteText(rG_SalesCrMemoLine.Description, 70, '<', '', false); //5 Περιγραφή Προϊόντος [prod_description]
        CurrentLine += WriteText(rG_SalesCrMemoLine."Unit of Measure Code", 9, '<', '', false); //6 Μονάδα μέτρησης της ποσότητας παράδοσης [delivery_mu]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Qty. per Unit of Measure", 0, Text1000017);
        CurrentLine += WriteText(Amountstr, 11, '<', '', false); //7 Συντελεστής Κιβωτιοποίησης [delivery_capacity] 11,3

        Amountstr := FORMAT(rG_SalesCrMemoLine.Quantity, 0, Text1000017);
        CurrentLine += WriteText(Amountstr, 11, '<', '', false); //8 Ποσότητα παράδοσης  [delivery_qty]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Unit Price", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //9  Τιμή μονάδος [price]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Line Discount %", 0, Text1000018);
        CurrentLine += WriteText(Amountstr, 5, '<', '', false); //10  Ποσοστό έκπτωσης 1[allow_percent1]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Line Discount Amount", 0, Text1000018);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //11 Ποσό έκπτωσης  1 [allow_amount1]
        CurrentLine += WriteText('', 5, '<', '', false); //12 Ποσοστό έκπτωσης 2[allow_percent2]
        CurrentLine += WriteText('', 14, '<', '', false); //13  Ποσό έκπτωσης  2 [allow_amount2]
        CurrentLine += WriteText('', 5, '<', '', false); //14  Ποσοστό έκπτωσης 3[allow_percent3]
        CurrentLine += WriteText('', 14, '<', '', false); //15  Ποσό έκπτωσης  3 [allow_amount3]
        CurrentLine += WriteText('', 5, '<', '', false); //16 Ποσοστό έκπτωσης 4[allow_percent4]
        CurrentLine += WriteText('', 14, '<', '', false); //17 Ποσό έκπτωσης  4 [allow_amount4]
        CurrentLine += WriteText('', 14, '<', '', false); //18 Συνολική αξία εκπτώσεων [total_allows]
        CurrentLine += WriteText('', 5, '<', '', false); //19 Ποσοστό επιβάρυνσης 1 [charge_percent1]
        CurrentLine += WriteText('', 14, '<', '', false); //20 Ποσό επιβάρυνσης 1 [charge_amount1]


        CurrentLine += WriteText('', 5, '<', '', false); //21 Ποσοστό επιβάρυνσης 2 [charge_percent2]
        CurrentLine += WriteText('', 14, '<', '', false); //22 Ποσό επιβάρυνσης 2 [charge_amount2]
        CurrentLine += WriteText('', 14, '<', '', false); //23 Συνολική αξία επιβαρύνσεων [total_charges]
        CurrentLine += WriteText(FORMAT(rG_SalesCrMemoLine."VAT %"), 3, '<', '', false); //24 Ποσοστό ΦΠΑ [vat_percent]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Amount Including VAT" - rG_SalesCrMemoLine.Amount, 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //25 Αξία ΦΠΑ [vat_amount]
        CurrentLine += WriteText('', 5, '<', '', false); //26 Ποσοστό άλλων φόρων  [tax_percent]
        CurrentLine += WriteText('', 14, '<', '', false); //27 Αξία άλλων φόρων [tax_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //28 Καθαρή αξία προ έκπτωσεων [net_amount]
        CurrentLine += WriteText('', 14, '<', '', false); //29 Υποκείμενη αξία [sub_amount]
        Amountstr := FORMAT(rG_SalesCrMemoLine."VAT Base Amount", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //30 Φορολογούμενο ποσό [taxable_amount]

        Amountstr := FORMAT(rG_SalesCrMemoLine.Quantity * rG_SalesCrMemoLine."Unit Price", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //31 Μεικτή αξία [gross_amount]


        CurrentLine += WriteText('', 14, '<', '', false); //32 Τελική τιμή μονάδος [net_price]

        Amountstr := FORMAT(rG_SalesCrMemoLine."Line Amount", 0, Text1000016);
        CurrentLine += WriteText(Amountstr, 14, '<', '', false); //33 Συνολική τελική αξία προϊόντος [final_amount]

        CurrentLine += WriteText('', 20, '<', '', false); //34 Αριθμός αντίστοιχου παραστατικού – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_number]4
        CurrentLine += WriteText('', 20, '<', '', false); //35  Τύπος αντίστοιχου παραστατικού – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_type]
        CurrentLine += WriteText('', 8, '<', '', false); //36 Ημερομηνία αντίστοιχου παραστατικού– σε περίπτωση που ένα παραστατικό σχετίζεται με πολλά αντίστοιχα [ref_inv_date]
        CurrentLine += WriteText('', 20, '<', '', false); //37 Αριθμός αντίστοιχης παραγγελίας πελάτη – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλές παραγγελίες πελάτη [order_number]
        CurrentLine += WriteText('', 8, '<', '', false); //38 Ημερομηνία αντίστοιχης παραγγελίας πελάτη – σε περίπτωση που ένα παραστατικό σχετίζεται με πολλές παραγγελίες πελάτη [order_date]
        CurrentLine += WriteText('', 8, '<', '', false); //39 Ημερομηνία λήξης [expire_date]
        CurrentLine += WriteText('', 20, '<', '', false); //40 Αριθμός παρτίδας [lot_number]

        //+1.0.0.303
        CommentLine := '';
        Customer.GET(rG_SalesCrMemoHeader."Sell-to Customer No.");
        if Customer."Mandatory CY Fields" then begin
            ProductClass := rG_SalesCrMemoLine."Product Class";

            if Country.get(rG_SalesCrMemoLine."Country/Region of Origin Code") then begin
                CountryofOriginName := Country.Name;
                CommentLine := CountryofOriginName;
            end;

            if ProductClass <> '' then begin
                CommentLine += ',' + ProductClass;
            end;

            if GenCat.GET(27, GenCat.Type::Category9, rG_SalesCrMemoLine."Category 9") then begin
                PotatoesDesc := GenCat.Description;
                CommentLine += ',' + PotatoesDesc;
            end;
        end;
        //-1.0.0.303
        CurrentLine += WriteText(CommentLine, 50, '<', '', true); //41 Σχόλια [comments]

        if vG_UseDotNet = true then begin
            //streamWriter.WriteLine(CurrentLine);
            TargetFile.Write(CurrentLine);
        end else begin
            TargetText.ADDTEXT(CurrentLine);  //NOD0.7
        end;
    end;

    procedure MakeAmountText(Amount: Decimal; LengthBeforecomma: Integer; DecimalPlaces: Integer; FillingSign: Text[1]; DecimalSeperator: Text[1]) AmountText: Text[250];
    var
        hlpint: Integer;
        hlptxt: Text[30];
    begin
        AmountText := FORMAT((ROUND(Amount, 1, '<')), 0, Text1000015);
        AmountText := PADSTR('', LengthBeforecomma - STRLEN(AmountText), FillingSign) +
                       AmountText +
                       DecimalSeperator;
        hlpint := (Amount * (POWER(10, DecimalPlaces))) mod (POWER(10, DecimalPlaces));
        hlptxt := FORMAT(hlpint, 0, Text1000015);
        if STRLEN(hlptxt) < DecimalPlaces then
            hlptxt := PADSTR('', DecimalPlaces - STRLEN(hlptxt), '0') + hlptxt;

        if hlptxt <> '0' then begin
            AmountText := AmountText + hlptxt;
        end;
    end;

    procedure MakeAmountTextDec(Amount: Decimal; LengthBeforecomma: Integer; DecimalPlaces: Integer; FillingSign: Text[1]; DecimalSeperator: Text[1]) AmountText: Text[250];
    var
        hlpint: Integer;
        hlptxt: Text[30];
    begin
        AmountText := FORMAT((ROUND(Amount, 1, '<')), 0, Text1000015);
        AmountText := PADSTR('', LengthBeforecomma - STRLEN(AmountText), FillingSign) +
                       AmountText +
                       DecimalSeperator
                        ;
        hlpint := (Amount * (POWER(10, DecimalPlaces))) mod (POWER(10, DecimalPlaces));
        hlptxt := FORMAT(hlpint, 0, Text1000015);
        if STRLEN(hlptxt) < DecimalPlaces then
            hlptxt := PADSTR('', DecimalPlaces - STRLEN(hlptxt), '0') + hlptxt;
        AmountText := hlptxt + AmountText;
    end;

    procedure Pc2Elot(InString: Text[250]): Text[250];
    var
        TempInFile: File;
        PCTable: Text[100];
        ElotTable: Text[100];
    begin
        PCTable := 'ϊϋάέήίύώόαβγδεζηθικλμνξοπρστυφχψωςΆΈΉΊΎΏΌΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ&''"%';
        ElotTable := 'iyaeiiyooabgdeziuiklmnjoprstyfxcosAEIIYOOABGDEZIUIKLMNJOPRSTYFXCO    ';

        exit(CONVERTSTR(InString, PCTable, ElotTable));
    end;

    procedure Pc2ElotHB(InString: Text[250]): Text[250];
    var
        TempInFile: File;
        PCTable: Text[100];
        ElotTable: Text[100];
    begin
        PCTable := '.,';
        ElotTable := ',.';

        exit(CONVERTSTR(InString, PCTable, ElotTable));
    end;

    procedure CreateProductionDocuments(pWorksheetName: Code[10]; pBatchName: Code[10]);
    var
        rL_ReqLine: Record "Requisition Line";
        rL_RequisitionWkshName: Record "Requisition Wksh. Name";
        rL_ProductionOrder: Record "Production Order";
    begin
        if not CONFIRM(Text50005, false) then begin
            exit;
        end;

        rL_RequisitionWkshName.GET(pWorksheetName, pBatchName);

        //check data
        rL_ReqLine.RESET;
        rL_ReqLine.SETFILTER("Worksheet Template Name", pWorksheetName);
        rL_ReqLine.SETFILTER("Journal Batch Name", pBatchName);
        rL_ReqLine.SETFILTER(Quantity, '<>%1', 0);
        if rL_ReqLine.FINDSET then begin
            repeat
                rL_ReqLine.TESTFIELD("Location Code");
                rL_ReqLine.TESTFIELD("Vendor No.");
            until rL_ReqLine.NEXT = 0;
        end;


        rL_ReqLine.RESET;
        rL_ReqLine.SETFILTER("Worksheet Template Name", pWorksheetName);
        rL_ReqLine.SETFILTER("Journal Batch Name", pBatchName);
        rL_ReqLine.SETFILTER(Quantity, '<>%1', 0);
        if rL_ReqLine.FINDSET then begin
            repeat


                if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Inbound then begin
                    case rL_ReqLine."Replenishment System" of
                        rL_ReqLine."Replenishment System"::"Box":
                            begin
                                CreateBox(true, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                            end;


                        rL_ReqLine."Replenishment System"::Transfer://FROM VENDOR TO ARADIPOU
                            begin
                                CreateTransfer(true, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                            end;


                        rL_ReqLine."Replenishment System"::"Sale", rL_ReqLine."Replenishment System"::"Sales Return Order": //TAL0.1
                            begin
                                CreateSalesDocument(true, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                            end;

                        rL_ReqLine."Replenishment System"::Purchase:
                            begin
                                CreatePurchaseDocument(true, rL_ReqLine, rL_ReqLine."Vendor No.");
                            end;

                    end;

                end else
                    if rL_RequisitionWkshName."Transaction Type" = rL_RequisitionWkshName."Transaction Type"::Outbound then begin
                        case rL_ReqLine."Replenishment System" of
                            rL_ReqLine."Replenishment System"::"Box":
                                begin
                                    CreateBox(false, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                                end;


                            rL_ReqLine."Replenishment System"::Transfer: //FROM ARADIPOU TO VENDOR
                                begin
                                    CreateTransfer(false, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                                end;

                            rL_ReqLine."Replenishment System"::"Sale":
                                begin
                                    CreateSalesDocument(false, rL_ReqLine, rL_RequisitionWkshName."Vendor No.");
                                end;

                            rL_ReqLine."Replenishment System"::Purchase:
                                begin
                                    CreatePurchaseDocument(false, rL_ReqLine, rL_ReqLine."Vendor No.");
                                end;

                        end;
                    end;

                //+TAL0.10
                if rL_ReqLine."Prod. Order No. Ref" <> '' then begin
                    rL_ProductionOrder.RESET;
                    rL_ProductionOrder.SETRANGE(Status, rL_ProductionOrder.Status::Released);
                    rL_ProductionOrder.SETFILTER("No.", rL_ReqLine."Prod. Order No. Ref");
                    if rL_ProductionOrder.FINDFIRST then begin
                        rL_ProductionOrder.VALIDATE("Documents Created", true);
                        rL_ProductionOrder.MODIFY;
                    end;
                end;
            //-TAL0.10


            until rL_ReqLine.NEXT = 0;
        end;

        rL_ReqLine.RESET;
        rL_ReqLine.SETFILTER("Worksheet Template Name", pWorksheetName);
        rL_ReqLine.SETFILTER("Journal Batch Name", pBatchName);
        if rL_ReqLine.FINDSET then begin
            repeat
                rL_ReqLine.DELETE;
            until rL_ReqLine.NEXT = 0;
        end;

        MESSAGE('Documents Created');
    end;

    local procedure CreateBox(pInbound: Boolean; var pReqLine: Record "Requisition Line"; pVendorNo: Code[20]);
    var
        rL_PurchaseHeaderAddon: Record "Purchase Header Addon";
        rL_PurchaseLineAddon: Record "Purchase Line Addon";
        vL_LineNo: Integer;
    begin

        rL_PurchaseHeaderAddon.RESET;
        rL_PurchaseHeaderAddon.SETRANGE("Document Type", rL_PurchaseHeaderAddon."Document Type"::Order);
        rL_PurchaseHeaderAddon.SETFILTER("Buy-from Vendor No.", pVendorNo);
        rL_PurchaseHeaderAddon.SETRANGE("Posting Date", TODAY);
        if not rL_PurchaseHeaderAddon.FINDSET then begin
            CLEAR(rL_PurchaseHeaderAddon);
            rL_PurchaseHeaderAddon.INIT;
            rL_PurchaseHeaderAddon.SetHideValidationDialog(true);
            rL_PurchaseHeaderAddon.VALIDATE("Document Type", rL_PurchaseHeaderAddon."Document Type"::Order);
            rL_PurchaseHeaderAddon.INSERT(true);
            rL_PurchaseHeaderAddon.VALIDATE("Buy-from Vendor No.", pVendorNo);
            rL_PurchaseHeaderAddon.VALIDATE("Posting Date", TODAY);
            rL_PurchaseHeaderAddon.MODIFY;
        end;


        vL_LineNo := 0;
        CLEAR(rL_PurchaseLineAddon);
        rL_PurchaseLineAddon.RESET;
        rL_PurchaseLineAddon.SETRANGE("Document Type", rL_PurchaseHeaderAddon."Document Type");
        rL_PurchaseLineAddon.SETFILTER("Document No.", rL_PurchaseHeaderAddon."No.");
        if rL_PurchaseLineAddon.FINDLAST then begin
            vL_LineNo := rL_PurchaseLineAddon."Line No.";
        end;

        vL_LineNo += 10000;

        rL_PurchaseLineAddon.RESET;
        rL_PurchaseLineAddon.VALIDATE("Document Type", rL_PurchaseHeaderAddon."Document Type");
        rL_PurchaseLineAddon.VALIDATE("Document No.", rL_PurchaseHeaderAddon."No.");
        rL_PurchaseLineAddon."Line No." := vL_LineNo;
        rL_PurchaseLineAddon.INSERT(true);

        rL_PurchaseLineAddon.VALIDATE(Type, rL_PurchaseLineAddon.Type::Item);
        rL_PurchaseLineAddon.VALIDATE("No.", pReqLine."No.");
        rL_PurchaseLineAddon.VALIDATE("Location Code", pReqLine."Location Code");
        if pInbound then begin
            rL_PurchaseLineAddon.VALIDATE(Quantity, pReqLine.Quantity);
        end else begin
            rL_PurchaseLineAddon.VALIDATE(Quantity, pReqLine.Quantity * -1);
        end;

        rL_PurchaseLineAddon.MODIFY;
    end;

    local procedure CreateTransfer(pInbound: Boolean; var pReqLine: Record "Requisition Line"; pVendorNo: Code[20]);
    var
        vL_LineNo: Integer;
        rL_TransferHeader: Record "Transfer Header";
        rL_TransferLine: Record "Transfer Line";
        VendorLocation: Code[20];
    begin
        //MESSAGE('Before:'+pVendorNo);
        VendorLocation := DELSTR(pVendorNo, 2, 3);
        //MESSAGE('After:'+VendorLocation);


        rL_TransferHeader.RESET;
        rL_TransferHeader.SETFILTER("Req. Vendor No.", pVendorNo);
        rL_TransferHeader.SETRANGE("Posting Date", TODAY);
        if pInbound then begin
            rL_TransferHeader.SETFILTER("Transfer-from Code", VendorLocation);
        end else begin
            rL_TransferHeader.SETFILTER("Transfer-to Code", VendorLocation);
        end;

        if not rL_TransferHeader.FINDSET then begin
            CLEAR(rL_TransferHeader);
            rL_TransferHeader.InitRecord;
            rL_TransferHeader.SetHideValidationDialog(true);
            rL_TransferHeader.VALIDATE("Req. Vendor No.", pVendorNo);
            rL_TransferHeader.VALIDATE("Posting Date", TODAY);
            rL_TransferHeader.INSERT(true);

            if pInbound then begin
                rL_TransferHeader.VALIDATE("Transfer-from Code", VendorLocation);
                rL_TransferHeader.VALIDATE("Transfer-to Code", pReqLine."Location Code");
            end else begin
                rL_TransferHeader.VALIDATE("Transfer-from Code", pReqLine."Location Code");
                rL_TransferHeader.VALIDATE("Transfer-to Code", VendorLocation);
            end;
            rL_TransferHeader.VALIDATE("In-Transit Code", 'TRANSIT');

            rL_TransferHeader.MODIFY;

        end;



        vL_LineNo := 0;
        CLEAR(rL_TransferLine);
        rL_TransferLine.RESET;
        rL_TransferLine.SETFILTER("Document No.", rL_TransferHeader."No.");
        if rL_TransferLine.FINDLAST then begin
            vL_LineNo := rL_TransferLine."Line No.";
        end;

        vL_LineNo += 10000;
        CLEAR(rL_TransferLine);
        rL_TransferLine.VALIDATE("Document No.", rL_TransferHeader."No.");
        rL_TransferLine.VALIDATE("Line No.", vL_LineNo);
        rL_TransferLine.INSERT(true);

        rL_TransferLine.VALIDATE("Item No.", pReqLine."No.");
        rL_TransferLine.VALIDATE(Quantity, pReqLine.Quantity);
        rL_TransferLine.MODIFY;
    end;

    local procedure CreateSalesDocument(pInbound: Boolean; var pReqLine: Record "Requisition Line"; pVendorNo: Code[20]);
    var
        rL_Vendor: Record Vendor;
        rL_SalesHeader: Record "Sales Header";
        rL_SalesLine: Record "Sales Line";
        vL_LineNo: Integer;
    begin

        rL_Vendor.GET(pVendorNo);
        rL_Vendor.TESTFIELD(Customer);

        //find the customer from the vendor
        rL_SalesHeader.RESET;
        if pInbound then begin
            rL_SalesHeader.SETRANGE("Document Type", rL_SalesHeader."Document Type"::"Return Order");
        end else begin
            rL_SalesHeader.SETRANGE("Document Type", rL_SalesHeader."Document Type"::Order);
        end;

        rL_SalesHeader.SETFILTER("Sell-to Customer No.", rL_Vendor.Customer);
        rL_SalesHeader.SETRANGE("Posting Date", TODAY);
        rL_SalesHeader.SETFILTER("Req. Vendor No.", rL_Vendor."No.");
        if not rL_SalesHeader.FINDSET then begin
            CLEAR(rL_SalesHeader);
            rL_SalesHeader.INIT;
            rL_SalesHeader.SetHideValidationDialog(true);
            if pInbound then begin
                rL_SalesHeader.VALIDATE("Document Type", rL_SalesHeader."Document Type"::"Return Order");
            end else begin
                rL_SalesHeader.VALIDATE("Document Type", rL_SalesHeader."Document Type"::Order);
            end;
            rL_SalesHeader.INSERT(true);
            //rL_SalesHeader.VALIDATE("Bill-to Customer No.",rL_Vendor.Customer);
            rL_SalesHeader.VALIDATE("Sell-to Customer No.", rL_Vendor.Customer);//anp-gp
            rL_SalesHeader.VALIDATE("Posting Date", TODAY);
            rL_SalesHeader.VALIDATE("Req. Vendor No.", rL_Vendor."No.");
            rL_SalesHeader.MODIFY;
        end;


        vL_LineNo := 0;
        CLEAR(rL_SalesLine);
        rL_SalesLine.RESET;
        rL_SalesLine.SETRANGE("Document Type", rL_SalesHeader."Document Type");
        rL_SalesLine.SETFILTER("Document No.", rL_SalesHeader."No.");
        if rL_SalesLine.FINDLAST then begin
            vL_LineNo := rL_SalesLine."Line No.";
        end;

        vL_LineNo += 10000;

        rL_SalesLine.RESET;
        rL_SalesLine.VALIDATE("Document Type", rL_SalesHeader."Document Type");
        rL_SalesLine.VALIDATE("Document No.", rL_SalesHeader."No.");
        rL_SalesLine."Line No." := vL_LineNo;
        rL_SalesLine.INSERT(true);

        rL_SalesLine.VALIDATE(Type, rL_SalesLine.Type::Item);
        rL_SalesLine.VALIDATE("No.", pReqLine."No.");
        rL_SalesLine.VALIDATE("Location Code", pReqLine."Location Code");
        rL_SalesLine.VALIDATE(Quantity, pReqLine.Quantity);

        rL_SalesLine.MODIFY;
    end;

    local procedure CreatePurchaseDocument(pInbound: Boolean; var pReqLine: Record "Requisition Line"; pVendorNo: Code[20]);
    var
        rL_Vendor: Record Vendor;
        rL_PurchaseHeader: Record "Purchase Header";
        rL_PurchaseLine: Record "Purchase Line";
        vL_LineNo: Integer;
    begin

        rL_Vendor.GET(pVendorNo);
        //rL_Vendor.TESTFIELD(Customer);

        //find the customer from the vendor
        rL_PurchaseHeader.RESET;
        if pInbound then begin
            rL_PurchaseHeader.SETRANGE("Document Type", rL_PurchaseHeader."Document Type"::Order);
        end else begin
            rL_PurchaseHeader.SETRANGE("Document Type", rL_PurchaseHeader."Document Type"::"Return Order");
        end;

        rL_PurchaseHeader.SETFILTER("Buy-from Vendor No.", rL_Vendor."No.");
        rL_PurchaseHeader.SETRANGE("Posting Date", TODAY);
        rL_PurchaseHeader.SETFILTER("Req. Vendor No.", rL_Vendor."No.");
        if not rL_PurchaseHeader.FINDSET then begin
            CLEAR(rL_PurchaseHeader);
            rL_PurchaseHeader.INIT;
            rL_PurchaseHeader.SetHideValidationDialog(true);
            if pInbound then begin
                rL_PurchaseHeader.VALIDATE("Document Type", rL_PurchaseHeader."Document Type"::Order);
            end else begin
                rL_PurchaseHeader.VALIDATE("Document Type", rL_PurchaseHeader."Document Type"::"Return Order");
            end;
            rL_PurchaseHeader.INSERT(true);
            rL_PurchaseHeader.VALIDATE("Buy-from Vendor No.", rL_Vendor."No.");
            rL_PurchaseHeader.VALIDATE("Posting Date", TODAY);
            rL_PurchaseHeader.Validate("Expected Receipt Date", TODAY);
            rL_PurchaseHeader.VALIDATE("Req. Vendor No.", rL_Vendor."No.");
            rL_PurchaseHeader.MODIFY;
        end;


        vL_LineNo := 0;
        CLEAR(rL_PurchaseLine);
        rL_PurchaseLine.RESET;
        rL_PurchaseLine.SETRANGE("Document Type", rL_PurchaseHeader."Document Type");
        rL_PurchaseLine.SETFILTER("Document No.", rL_PurchaseHeader."No.");
        if rL_PurchaseLine.FINDLAST then begin
            vL_LineNo := rL_PurchaseLine."Line No.";
        end;

        vL_LineNo += 10000;

        rL_PurchaseLine.RESET;
        CLEAR(rL_PurchaseLine);
        rL_PurchaseLine.VALIDATE("Document Type", rL_PurchaseHeader."Document Type");
        rL_PurchaseLine.VALIDATE("Document No.", rL_PurchaseHeader."No.");
        rL_PurchaseLine."Line No." := vL_LineNo;
        rL_PurchaseLine.INSERT(true);

        rL_PurchaseLine.VALIDATE(Type, rL_PurchaseLine.Type::Item);
        rL_PurchaseLine.VALIDATE("No.", pReqLine."No.");
        rL_PurchaseLine.VALIDATE("Location Code", pReqLine."Location Code");
        rL_PurchaseLine.VALIDATE(Quantity, pReqLine.Quantity);
        //rL_PurchaseLine."Prod. Order No.":=pReqLine."Prod. Order No. Ref";
        rL_PurchaseLine.MODIFY;
    end;

    procedure ExportChainOfCustody(pDeliveryNo: Code[20]; pDraft: Boolean);
    var
        l_Text50000: Label 'Vorgabe Dateiname und Betreff: EAvis Agenturname Datum';
        l_Text50000_Draft: Label 'Vorgabe Dateiname und Betreff: EAvis Agenturname Datum  - DRAFT';
        l_Text50001: Label 'Ημ.Παράδοσης Datum Anlieferung';
        l_Text50002: Label 'Χώρα Παράδοσης Land der Ablade-stelle';
        l_Text50003: Label 'Αρ.Αποθήκης Nr. der Ablade-stelle';
        l_Text50004: Label 'Όνομα Αποθήκης Abladestelle  Gesellschaft';
        l_Text50005: Label 'Κωδικός Προϊόντος IAN';
        l_Text50006: Label 'Ονομασία Προϊόντος Artikel-Bezeichnung';
        l_Text50007: Label 'Συσκευασία Gebinde';
        l_Text50008: Label '"Προϊόν Ernteprodukt(e) "';
        l_Text50009: Label 'Προέλευση Ursprung';
        l_Text50010: Label 'Κλάση Klasse';
        l_Text50011: Label 'Περιεχόμενο Κιβωτίου Kolli-inhalt';
        l_Text50012: Label 'Καλίμπρα Μέγεθος Kaliber';
        l_Text50013: Label 'Ποικιλία Sorte';
        l_Text50014: Label 'Μάρκα LIDL  Eigenmarke (LIDL)';
        l_Text50015: Label 'LOT Los';
        l_Text50016: Label 'Αρ. Αντιπροσώπου Agentur-nummer';
        l_Text50017: Label 'Αντιπρόσωπος Agentur (Name)';
        l_Text50018: Label 'Προμηθευτής Lieferant (GLN)';
        l_Text50019: Label 'Προμηθευτής  Lieferant (Name)';
        l_Text50020: Label 'Συσκευαστήριο Packbetrieb (GLN)';
        l_Text50021: Label 'Συσκευαστήριο Packbetrieb (Name)';
        l_Text50022: Label 'Παραγωγός Erzeuger (GGN)';
        l_Text50023: Label 'Παραγωγός Erzeuger (Name)';
        l_Text50024: Label 'Ποσότητα Παράδοσης (κιβώτια) Liefer-menge [Kolli]';
        l_Text50025: Label 'Ετικέτα Transparenz-Etikett vorhanden? [Ναι / Όχι]';
        l_Text50026: Label 'Προηγήθηκε Ανάλυση? Analyse liegt vor [Ναι / Όχι]';
        l_Text50027: Label 'Πινακίδες Φορτηγού / Μεταφορικής LKW';
        rL_ExcelBuf: Record "Excel Buffer" temporary;
        rL_CompanyInformation: Record "Company Information";
        vL_FileName: Text;
        rL_DeliverySchedule: Record "Delivery Schedule";
        rL_Customer: Record Customer;
        vL_Week: Text;
        l_Text50028: Label 'ΠΑΡΑΔΩΣΕΙΣ %1 %2 - WEEK %3.xlsx';
        rL_SalesShipmentHeader: Record "Sales Shipment Header";
        rL_SalesHeader: Record "Sales Header";
        rL_SalesLine: Record "Sales Line";
        rL_LidlItem: Record "General Categories";
        vL_Packaging: Text;
        vL_Caliber: Text;
        rL_GeneralCategories: Record "General Categories";
        vL_Variety: Text;
        rL_Vendor: Record Vendor;
        rL_Grower: Record Vendor;
        rL_ItemLedgerEntry: Record "Item Ledger Entry";
        rL_SalesShipmentLine: Record "Sales Shipment Line";
        //rL_ItemCrossReference: Record "Item Cross Reference";
        rL_ItemCrossReference: Record "Item Reference";
        SheetNameTxt: Text;
    begin

        rL_DeliverySchedule.GET(pDeliveryNo);
        rL_CompanyInformation.GET;
        rL_CompanyInformation.TESTFIELD("Lidl Rep. No");
        rL_CompanyInformation.TESTFIELD("Lidl Rep. Name");
        rL_CompanyInformation.TESTFIELD("Packaging Location GLN");
        rL_CompanyInformation.TESTFIELD("Packaging Location Name");

        if pDraft then begin //Sales Header
            rL_SalesHeader.RESET;
            rL_SalesHeader.SETCURRENTKEY("Delivery No.", "Delivery Sequence");
            rL_SalesHeader.SETFILTER("Delivery No.", rL_DeliverySchedule."Delivery No.");
            if rL_SalesHeader.FINDSET then begin


                vL_Week := PADSTR('', 2 - STRLEN(FORMAT(rL_DeliverySchedule."Week No.")), '0') + FORMAT(rL_DeliverySchedule."Week No.");

                rL_Customer.GET(rL_SalesHeader."Bill-to Customer No.");
                rL_Customer.TESTFIELD("Country/Region Code");
                vL_FileName := STRSUBSTNO(l_Text50028, rL_Customer."Country/Region Code", FORMAT(rL_DeliverySchedule."Delivery Date"), vL_Week);
                //'ΠΑΡΑΔΩΣΕΙΣ '+ rL_Customer."Country/Region Code" +' '+FORMAT(rL_DeliverySchedule."Delivery Date")+' - WEEK '+vL_Week;

                CLEAR(rL_ExcelBuf);
                rL_ExcelBuf.AddColumn(l_Text50000_Draft, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text);
                rL_ExcelBuf.NewRow;

                rL_ExcelBuf.AddColumn(l_Text50001, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //1
                rL_ExcelBuf.AddColumn(l_Text50002, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //2
                rL_ExcelBuf.AddColumn(l_Text50003, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //3
                rL_ExcelBuf.AddColumn(l_Text50004, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //4
                rL_ExcelBuf.AddColumn(l_Text50005, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //5
                rL_ExcelBuf.AddColumn(l_Text50006, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //6
                rL_ExcelBuf.AddColumn(l_Text50007, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //7
                rL_ExcelBuf.AddColumn(l_Text50008, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //8
                rL_ExcelBuf.AddColumn(l_Text50009, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //9
                rL_ExcelBuf.AddColumn(l_Text50010, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //10
                rL_ExcelBuf.AddColumn(l_Text50011, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //11
                rL_ExcelBuf.AddColumn(l_Text50012, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //12
                rL_ExcelBuf.AddColumn(l_Text50013, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //13
                rL_ExcelBuf.AddColumn(l_Text50014, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //14
                rL_ExcelBuf.AddColumn(l_Text50015, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //15
                rL_ExcelBuf.AddColumn(l_Text50016, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //16
                rL_ExcelBuf.AddColumn(l_Text50017, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //17
                rL_ExcelBuf.AddColumn(l_Text50018, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //18
                rL_ExcelBuf.AddColumn(l_Text50019, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //19
                rL_ExcelBuf.AddColumn(l_Text50020, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //20
                rL_ExcelBuf.AddColumn(l_Text50021, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //21
                rL_ExcelBuf.AddColumn(l_Text50022, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //22
                rL_ExcelBuf.AddColumn(l_Text50023, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //23
                rL_ExcelBuf.AddColumn(l_Text50024, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //24
                rL_ExcelBuf.AddColumn(l_Text50025, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //25
                rL_ExcelBuf.AddColumn(l_Text50026, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //26
                rL_ExcelBuf.AddColumn(l_Text50027, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //27

                rL_ExcelBuf.NewRow;


                repeat
                    rL_Customer.GET(rL_SalesHeader."Bill-to Customer No.");


                    rL_SalesLine.RESET;
                    rL_SalesLine.SETFILTER("Document No.", rL_SalesHeader."No.");
                    rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SETFILTER(Quantity, '<>%1', 0);
                    if rL_SalesLine.FINDSET then begin
                        repeat
                            rL_SalesLine.TESTFIELD("Shelf No.");

                            rL_ItemCrossReference.RESET;
                            //rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                            rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                            rL_ItemCrossReference.SETFILTER("Item No.", rL_SalesLine."No.");
                            //rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", rL_Customer."No.");
                            rL_ItemCrossReference.SETFILTER("Reference Type No.", rL_Customer."No.");
                            if not rL_ItemCrossReference.FINDSET then begin
                                ERROR('Item Cross Reference for Item No. ' + rL_SalesLine."No." + ' not found.');
                            end;

                            rL_LidlItem.RESET;
                            rL_LidlItem.SETRANGE("Table No.", DATABASE::Item);
                            rL_LidlItem.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                            rL_LidlItem.SETFILTER(Code, rL_ItemCrossReference."Reference No.");
                            //rL_LidlItem.SETFILTER(Code, rL_ItemCrossReference."Cross-Reference No.");
                            if not rL_LidlItem.FINDSET then begin
                                ERROR('Lidl Item not found ' + rL_ItemCrossReference."Reference No.");
                                //ERROR('Lidl Item not found ' + rL_ItemCrossReference."Cross-Reference No.");
                            end;



                            //rL_Item.GET(rL_SalesLine."No.");
                            //rL_Item.CALCFIELDS("Ship-to Product Name");
                            //CLEAR(rL_GeneralCategories_ShiptoProduct);
                            //IF rL_GeneralCategories_ShiptoProduct.GET(DATABASE::Item, rL_GeneralCategories_ShiptoProduct.Type::Category2,rL_Item."Category 2") THEN BEGIN

                            //END;

                            vL_Packaging := FORMAT(rL_LidlItem."Package Qty") + ' ' + Capitalise(FORMAT(rL_LidlItem."Unit of Measure"));
                            vL_Caliber := '';
                            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, rL_LidlItem."Category 6") then begin
                                vL_Caliber := rL_LidlItem."Category 4" + '-' + rL_LidlItem."Category 5" + ' ' + rL_GeneralCategories.Description;
                            end;

                            vL_Variety := '';
                            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category7, rL_LidlItem."Category 7") then begin
                                vL_Variety := rL_GeneralCategories.Description;
                            end;

                            //rL_Vendor.GET(rL_SalesLine."Vendor No.");
                            //rL_Vendor.TESTFIELD(GLN);
                            //rL_Grower.GET(rL_SalesLine."Grower No.");
                            // rL_Grower.TESTFIELD(GGN);

                            rL_ExcelBuf.AddColumn(FORMAT(rL_DeliverySchedule."Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>'), false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //1
                            rL_ExcelBuf.AddColumn(rL_SalesHeader."Ship-to Country/Region Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //2
                            rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //3
                            rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //4
                            rL_ExcelBuf.AddColumn(rL_SalesLine."Shelf No.", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //5
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Ship-to Description", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //6
                            rL_ExcelBuf.AddColumn(vL_Packaging, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //7
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Description 2", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //8
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Country/Region Purchased Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //9
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Category 3", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //10
                            rL_ExcelBuf.AddColumn(vL_Packaging, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //11
                            rL_ExcelBuf.AddColumn(vL_Caliber, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //12
                            rL_ExcelBuf.AddColumn(vL_Variety, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //13
                            rL_ExcelBuf.AddColumn('-', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //14
                            rL_ExcelBuf.AddColumn(rL_SalesHeader."Lot No.", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //15
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. No", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //16
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //17
                            rL_ExcelBuf.AddColumn(rL_Vendor.GLN, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //18
                            rL_ExcelBuf.AddColumn(rL_Vendor.Name, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //19
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location GLN", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //20
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //21
                            rL_ExcelBuf.AddColumn(rL_Grower.GGN, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //22
                            rL_ExcelBuf.AddColumn(rL_Grower.Name + rL_Grower."Name 2", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //23
                            rL_ExcelBuf.AddColumn(ROUND(rL_SalesLine."Quantity (Base)", 1, '>'), false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //24
                            rL_ExcelBuf.AddColumn('ΝΑΙ', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //25
                            rL_ExcelBuf.AddColumn('', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //26
                            rL_ExcelBuf.AddColumn(rL_DeliverySchedule.Van, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //27
                            rL_ExcelBuf.NewRow;
                        until rL_SalesLine.NEXT = 0;

                    end;

                until rL_SalesHeader.NEXT = 0;

            end;


        end else begin //Sales Shipment Lines

            rL_SalesShipmentHeader.RESET;
            rL_SalesShipmentHeader.SETCURRENTKEY("Delivery No.", "Delivery Sequence");
            rL_SalesShipmentHeader.SETFILTER("Delivery No.", rL_DeliverySchedule."Delivery No.");
            if rL_SalesShipmentHeader.FINDSET then begin


                vL_Week := PADSTR('', 2 - STRLEN(FORMAT(rL_DeliverySchedule."Week No.")), '0') + FORMAT(rL_DeliverySchedule."Week No.");

                rL_Customer.GET(rL_SalesShipmentHeader."Bill-to Customer No.");
                rL_Customer.TESTFIELD("Country/Region Code");
                vL_FileName := STRSUBSTNO(l_Text50028, rL_Customer."Country/Region Code", FORMAT(rL_DeliverySchedule."Delivery Date"), vL_Week);
                //'ΠΑΡΑΔΩΣΕΙΣ '+ rL_Customer."Country/Region Code" +' '+FORMAT(rL_DeliverySchedule."Delivery Date")+' - WEEK '+vL_Week;

                CLEAR(rL_ExcelBuf);
                rL_ExcelBuf.AddColumn(l_Text50000, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text);
                rL_ExcelBuf.NewRow;

                rL_ExcelBuf.AddColumn(l_Text50001, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //1
                rL_ExcelBuf.AddColumn(l_Text50002, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //2
                rL_ExcelBuf.AddColumn(l_Text50003, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //3
                rL_ExcelBuf.AddColumn(l_Text50004, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //4
                rL_ExcelBuf.AddColumn(l_Text50005, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //5
                rL_ExcelBuf.AddColumn(l_Text50006, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //6
                rL_ExcelBuf.AddColumn(l_Text50007, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //7
                rL_ExcelBuf.AddColumn(l_Text50008, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //8
                rL_ExcelBuf.AddColumn(l_Text50009, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //9
                rL_ExcelBuf.AddColumn(l_Text50010, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //10
                rL_ExcelBuf.AddColumn(l_Text50011, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //11
                rL_ExcelBuf.AddColumn(l_Text50012, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //12
                rL_ExcelBuf.AddColumn(l_Text50013, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //13
                rL_ExcelBuf.AddColumn(l_Text50014, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //14
                rL_ExcelBuf.AddColumn(l_Text50015, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //15
                rL_ExcelBuf.AddColumn(l_Text50016, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //16
                rL_ExcelBuf.AddColumn(l_Text50017, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //17
                rL_ExcelBuf.AddColumn(l_Text50018, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //18
                rL_ExcelBuf.AddColumn(l_Text50019, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //19
                rL_ExcelBuf.AddColumn(l_Text50020, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //20
                rL_ExcelBuf.AddColumn(l_Text50021, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //21
                rL_ExcelBuf.AddColumn(l_Text50022, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //22
                rL_ExcelBuf.AddColumn(l_Text50023, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //23
                rL_ExcelBuf.AddColumn(l_Text50024, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //24
                rL_ExcelBuf.AddColumn(l_Text50025, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //25
                rL_ExcelBuf.AddColumn(l_Text50026, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //26
                rL_ExcelBuf.AddColumn(l_Text50027, false, '', true, false, false, '', rL_ExcelBuf."Cell Type"::Text); //27

                rL_ExcelBuf.NewRow;


                repeat
                    rL_Customer.GET(rL_SalesShipmentHeader."Bill-to Customer No.");


                    /*
                    rL_SalesShipmentLine.RESET;
                    rL_SalesShipmentLine.SETFILTER("Document No.",rL_SalesShipmentHeader."No.");
                    rL_SalesShipmentLine.SETRANGE(Type,rL_SalesShipmentLine.Type::Item);
                    rL_SalesShipmentLine.SETFILTER(Quantity,'<>%1',0);
                    IF rL_SalesShipmentLine.FINDSET THEN BEGIN
                      REPEAT
                        rL_SalesShipmentLine.TESTFIELD("Shelf No.");
                        rL_Item.GET(rL_SalesShipmentLine."No.");
                        rL_Item.CALCFIELDS("Ship-to Product Name");
                        //CLEAR(rL_GeneralCategories_ShiptoProduct);
                        //IF rL_GeneralCategories_ShiptoProduct.GET(DATABASE::Item, rL_GeneralCategories_ShiptoProduct.Type::Category2,rL_Item."Category 2") THEN BEGIN

                        //END;

                        vL_Packaging:=FORMAT(rL_Item."Package Qty")+' '+Capitalise(FORMAT(rL_Item."Sales Unit of Measure"));
                        vL_Caliber:='';
                        IF rL_GeneralCategories.GET(27,rL_GeneralCategories.Type::Category6,rL_Item."Category 6") THEN BEGIN
                          vL_Caliber:=rL_Item."Category 4"+'-'+rL_Item."Category 5"+' ' + rL_GeneralCategories.Description;
                        END;

                        vL_Variety:='';
                        IF rL_GeneralCategories.GET(27,rL_GeneralCategories.Type::Category7,rL_Item."Category 7") THEN BEGIN
                          vL_Variety:=rL_GeneralCategories.Description;
                        END;

                        rL_Vendor.GET(rL_SalesShipmentLine."Vendor No.");
                        rL_Vendor.TESTFIELD(GLN);
                        rL_Grower.GET(rL_SalesShipmentLine."Grower No.");
                        rL_Grower.TESTFIELD(GGN);

                        rL_ExcelBuf.AddColumn(FORMAT(rL_DeliverySchedule."Delivery Date",0,'<Day,2>/<Month,2>/<Year4>'),FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //1
                        rL_ExcelBuf.AddColumn(rL_SalesShipmentHeader."Ship-to Country/Region Code",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //2
                        rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Code",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //3
                        rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Name",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //4
                        rL_ExcelBuf.AddColumn(rL_SalesShipmentLine."Shelf No.",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //5
                        rL_ExcelBuf.AddColumn(rL_Item."Ship-to Description",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //6
                        rL_ExcelBuf.AddColumn(vL_Packaging,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //7
                        rL_ExcelBuf.AddColumn(rL_Item."Ship-to Product Name",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //8
                        rL_ExcelBuf.AddColumn(rL_Item."Country/Region of Origin Code",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //9
                        rL_ExcelBuf.AddColumn(rL_Item."Category 3",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //10
                        rL_ExcelBuf.AddColumn(vL_Packaging,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //11
                        rL_ExcelBuf.AddColumn(vL_Caliber,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //12
                        rL_ExcelBuf.AddColumn(vL_Variety,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //13
                        rL_ExcelBuf.AddColumn('-',FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //14
                        rL_ExcelBuf.AddColumn(rL_SalesShipmentHeader."Lot No.",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //15
                        rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. No",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //16
                        rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. Name",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //17
                        rL_ExcelBuf.AddColumn(rL_Vendor.GLN,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //18
                        rL_ExcelBuf.AddColumn(rL_Vendor.Name,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //19
                        rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location GLN",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //20
                        rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location Name",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //21
                        rL_ExcelBuf.AddColumn(rL_Grower.GGN,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //22
                        rL_ExcelBuf.AddColumn(rL_Grower.Name+rL_Grower."Name 2",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //23
                        rL_ExcelBuf.AddColumn(ROUND(rL_SalesShipmentLine."Quantity (Base)",1,'>'),FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //24
                        rL_ExcelBuf.AddColumn('ΝΑΙ',FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //25
                        rL_ExcelBuf.AddColumn('',FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //26
                        rL_ExcelBuf.AddColumn(rL_DeliverySchedule.Van,FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //27
                         rL_ExcelBuf.NewRow;
                      UNTIL rL_SalesShipmentLine.NEXT=0;

                    END;
                    */

                    //TAL0.12
                    rL_ItemLedgerEntry.RESET;
                    rL_ItemLedgerEntry.SETFILTER("Document No.", rL_SalesShipmentHeader."No.");
                    if rL_ItemLedgerEntry.FINDSET then begin
                        repeat
                            rL_SalesShipmentLine.GET(rL_ItemLedgerEntry."Document No.", rL_ItemLedgerEntry."Document Line No.");

                            rL_SalesShipmentLine.TESTFIELD("Shelf No.");

                            rL_ItemCrossReference.RESET;
                            //rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                            rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                            rL_ItemCrossReference.SETFILTER("Item No.", rL_ItemLedgerEntry."Item No.");
                            //rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", rL_Customer."No.");
                            rL_ItemCrossReference.SETFILTER("Reference Type No.", rL_Customer."No.");
                            if not rL_ItemCrossReference.FINDSET then begin
                                ERROR('Item Cross Reference for Item No. ' + rL_SalesLine."No." + ' not found.');
                            end;

                            rL_LidlItem.RESET;
                            rL_LidlItem.SETRANGE("Table No.", DATABASE::Item);
                            rL_LidlItem.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                            rL_LidlItem.SETFILTER(Code, rL_ItemCrossReference."Reference No.");
                            //rL_LidlItem.SETFILTER(Code, rL_ItemCrossReference."Cross-Reference No.");
                            if not rL_LidlItem.FINDSET then begin
                                ERROR('Lidl Item not found ' + rL_ItemCrossReference."Reference No.");
                                //ERROR('Lidl Item not found ' + rL_ItemCrossReference."Cross-Reference No.");
                            end;


                            //rL_Item.GET(rL_ItemLedgerEntry."Item No.");
                            //rL_Item.CALCFIELDS("Ship-to Product Name");
                            //CLEAR(rL_GeneralCategories_ShiptoProduct);
                            //IF rL_GeneralCategories_ShiptoProduct.GET(DATABASE::Item, rL_GeneralCategories_ShiptoProduct.Type::Category2,rL_Item."Category 2") THEN BEGIN

                            //END;

                            vL_Packaging := FORMAT(rL_LidlItem."Package Qty") + ' ' + Capitalise(FORMAT(rL_LidlItem."Unit of Measure"));
                            vL_Caliber := '';
                            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category6, rL_LidlItem."Category 6") then begin
                                vL_Caliber := rL_LidlItem."Category 4" + '-' + rL_LidlItem."Category 5" + ' ' + rL_GeneralCategories.Description;
                            end;

                            vL_Variety := '';
                            if rL_GeneralCategories.GET(27, rL_GeneralCategories.Type::Category7, rL_LidlItem."Category 7") then begin
                                vL_Variety := rL_GeneralCategories.Description;
                            end;

                            //rL_ItemLedgerEntry.CALCFIELDS("Lot Grower No.");
                            CLEAR(rL_Grower);
                            rL_Grower.GET(rL_ItemLedgerEntry."Lot Grower No.");
                            rL_Grower.TESTFIELD(GGN);

                            CLEAR(rL_Vendor);
                            if rL_Grower."Grower Vendor No." = '' then begin
                                rL_Vendor.GET(rL_Grower."No.");
                                rL_Vendor.TESTFIELD(GLN);
                            end else begin
                                rL_Vendor.GET(rL_Grower."Grower Vendor No.");
                                rL_Vendor.TESTFIELD(GLN);

                            end;



                            rL_ExcelBuf.AddColumn(FORMAT(rL_DeliverySchedule."Delivery Date", 0, '<Day,2>/<Month,2>/<Year4>'), false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //1
                            rL_ExcelBuf.AddColumn(rL_SalesShipmentHeader."Ship-to Country/Region Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //2
                            rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //3
                            rL_ExcelBuf.AddColumn(rL_Customer."Ship-to Warehouse Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //4
                            rL_ExcelBuf.AddColumn(rL_SalesShipmentLine."Shelf No.", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //5
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Ship-to Description", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //6
                            rL_ExcelBuf.AddColumn(vL_Packaging, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //7
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Description 2", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //8
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Country/Region Purchased Code", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //9
                            rL_ExcelBuf.AddColumn(rL_LidlItem."Category 3", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //10
                            rL_ExcelBuf.AddColumn(vL_Packaging, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //11
                            rL_ExcelBuf.AddColumn(vL_Caliber, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //12
                            rL_ExcelBuf.AddColumn(vL_Variety, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //13
                            rL_ExcelBuf.AddColumn('-', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //14
                            rL_ExcelBuf.AddColumn(rL_SalesShipmentHeader."Lot No.", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //15
                                                                                                                                                        //rL_ExcelBuf.AddColumn(rL_ItemLedgerEntry."Lot No.",FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //15
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. No", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //16
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Lidl Rep. Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //17
                            rL_ExcelBuf.AddColumn(rL_Vendor.GLN, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //18
                            rL_ExcelBuf.AddColumn(rL_Vendor.Name, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //19
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location GLN", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //20
                            rL_ExcelBuf.AddColumn(rL_CompanyInformation."Packaging Location Name", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //21
                            rL_ExcelBuf.AddColumn(rL_Grower.GGN, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //22
                            rL_ExcelBuf.AddColumn(rL_Grower.Name + rL_Grower."Name 2", false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //23
                                                                                                                                                           //rL_ExcelBuf.AddColumn(ROUND(rL_ItemLedgerEntry.Quantity,1,'>'),FALSE,'',FALSE,FALSE,FALSE,'',rL_ExcelBuf."Cell Type"::Text); //24
                            rL_ExcelBuf.AddColumn(ROUND(rL_ItemLedgerEntry.Quantity * -1, 2), false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //24
                            rL_ExcelBuf.AddColumn('ΝΑΙ', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //25
                            rL_ExcelBuf.AddColumn('', false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //26
                            rL_ExcelBuf.AddColumn(rL_DeliverySchedule.Van, false, '', false, false, false, '', rL_ExcelBuf."Cell Type"::Text); //27
                            rL_ExcelBuf.NewRow;
                        until rL_ItemLedgerEntry.NEXT = 0;

                    end;


                until rL_SalesShipmentHeader.NEXT = 0;

            end;

        end;


        if pDraft then begin
            //rL_ExcelBuf.CreateBookAndOpenExcel('', 'Deliveries DRAFT', 'Deliveries DRAFT', COMPANYNAME, USERID);
            SheetNameTxt := 'Deliveries DRAFT';
        end else begin
            // rL_ExcelBuf.CreateBookAndOpenExcel('', 'Deliveries', 'Deliveries', COMPANYNAME, USERID);
            SheetNameTxt := 'Deliveries';
        end;

        rL_ExcelBuf.CreateNewBook(SheetNameTxt);   //Which will create a New Excel Book.
        rL_ExcelBuf.WriteSheet(SheetNameTxt, CompanyName, UserId);  //Write Data in Excel Sheet in New Book.
        rL_ExcelBuf.CloseBook();   //As Writing is complete we will close the book.
        rL_ExcelBuf.SetFriendlyFilename(SheetNameTxt);   //Optional to provide a valid Name to Excel File.
        rL_ExcelBuf.OpenExcel();  //Opens Downloads the Excel File for user.


        //rL_ExcelBuf.GiveUserControl;

    end;

    procedure Capitalise(pText: Text): Text;
    var
        tmpText: Text;
    begin
        if STRLEN(pText) < 1 then begin
            exit(pText);
        end;

        tmpText := pText;

        pText := UPPERCASE(COPYSTR(pText, 1, 1)) + LOWERCASE(DELSTR(pText, 1, 1));

        exit(pText);
    end;

    procedure GrowerReceiptNos(pDocNo: Code[20]);
    var
        rL_ILE: Record "Item Ledger Entry";
        vL_OldGrowerNo: Code[20];
        vL_NextDocNo: Code[20];
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "No. Series";
        vL_TmpNoSeries: Code[20];
    begin
        //+TAL0.13
        vL_OldGrowerNo := '';

        rL_ILE.RESET;
        rL_ILE.SETCURRENTKEY("Document No.", "Lot Grower No.");
        rL_ILE.SETRANGE("Document Type", rL_ILE."Document Type"::"Purchase Receipt");
        rL_ILE.SETFILTER("Document No.", pDocNo);
        rL_ILE.SETFILTER("Lot Grower No.", '<>%1', '');
        rL_ILE.SETFILTER("Lot No.", '<>%1', '');
        if rL_ILE.FINDSET then begin
            repeat
                //rL_ILE.CALCFIELDS("Lot Grower No.");

                if vL_OldGrowerNo <> rL_ILE."Lot Grower No." then begin
                    //IF  rL_ILE."Receipt Doc. No." = '' THEN BEGIN
                    vL_NextDocNo := '';
                    PurchSetup.GET;
                    NoSeriesMgt.AreRelated(PurchSetup."Grower Receipt Nos.", vL_TmpNoSeries);// InitSeries(PurchSetup."Grower Receipt Nos.", vL_TmpNoSeries, 0D, vL_NextDocNo, vL_TmpNoSeries); 28FEB2026
                    //END;
                end;

                vL_OldGrowerNo := rL_ILE."Lot Grower No.";

                rL_ILE."Receipt Doc. No." := vL_NextDocNo;
                rL_ILE.MODIFY();

            until rL_ILE.NEXT = 0;
        end;
        //-TAL0.13
    end;

    procedure ImportVendors();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_Vendor: Record Vendor;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        rL_GeneralCategories: Record "General Categories";
        rL_RowCount: Integer;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 7; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;

        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            //Grower
            //COUNTRY
            //GGN
            //TC
            //VENDOR
            //VENDOR NO.
            //Producer Group

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';



            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        5:
                            begin
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        6:
                            begin
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        7:
                            begin
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //Create or update vendor
            if Colmn1_Valid <> '' then begin

                CLEAR(rL_Vendor);
                rL_Vendor.INIT;
                rL_Vendor.VALIDATE("No. Series", 'VEND-GROW');

                if STRLEN(Colmn1_Valid) > 50 then begin

                    rL_Vendor.VALIDATE(Name, COPYSTR(Colmn1_Valid, 1, 50));
                    rL_Vendor.VALIDATE("Name 2", COPYSTR(Colmn1_Valid, 51, STRLEN(Colmn1_Valid) - 50));

                end else begin
                    rL_Vendor.VALIDATE(Name, Colmn1_Valid);
                end;


                rL_Vendor.VALIDATE("Vendor Posting Group", 'GROWER');
                rL_Vendor.INSERT(true);

                if Colmn2_Valid = 'GR' then begin
                    Colmn2_Valid := 'EL';
                end;

                if Colmn2_Valid = 'SP' then begin
                    Colmn2_Valid := 'ES';
                end;

                if Colmn2_Valid = 'USA' then begin
                    Colmn2_Valid := 'US';
                end;

                if Colmn2_Valid = 'HL' then begin
                    Colmn2_Valid := 'NL';
                end;



                rL_Vendor.VALIDATE("Country/Region Code", Colmn2_Valid);
                rL_Vendor.VALIDATE(GGN, Colmn3_Valid);
                rL_Vendor.VALIDATE(TC, Colmn4_Valid);

                if Colmn6_Valid <> '' then begin
                    rL_Vendor.VALIDATE("Grower Vendor No.", Colmn6_Valid);
                end;

                if Colmn7_Valid <> '' then begin
                    rL_GeneralCategories.RESET;
                    rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Vendor);
                    rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category1);
                    rL_GeneralCategories.SETRANGE(Description, Colmn7_Valid);
                    if not rL_GeneralCategories.FINDSET then begin
                        CLEAR(rL_GeneralCategories);
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Vendor);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category1);
                        if rL_GeneralCategories.FINDSET then;
                        rL_RowCount := rL_GeneralCategories.COUNT + 1;

                        CLEAR(rL_GeneralCategories);
                        rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Vendor);
                        rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category1);
                        rL_GeneralCategories.VALIDATE(Code, FORMAT(rL_RowCount));
                        rL_GeneralCategories.VALIDATE(Description, Colmn7_Valid);
                        rL_GeneralCategories.INSERT(true);
                        rL_Vendor.VALIDATE("Category 1", rL_GeneralCategories.Code);

                    end else begin
                        rL_Vendor.VALIDATE("Category 1", rL_GeneralCategories.Code);
                    end;



                    //rL_Vendor.VALIDATE("Grower Vendor No.",Colmn6_Valid);
                end;

                rL_Vendor.MODIFY(true);

            end;




        end; //end for 1
        Window.CLOSE;

        MESSAGE('Import Vendor Completed');
    end;

    procedure ImportItemsW07();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_LidlItem: Record "General Categories";
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;
        Colmn11_Valid: Text;
        Colmn12_Valid: Text;
        Colmn13_Valid: Text;
        Colmn14_Valid: Text;
        tmp_Decimal: Decimal;
        rL_GeneralCategories: Record "General Categories";
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 14; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;




        for RowNo := 3 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';
            Colmn11_Valid := '';
            Colmn12_Valid := '';
            Colmn13_Valid := '';
            Colmn14_Valid := '';


            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        5:
                            begin
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        6:
                            begin
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        7:
                            begin
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        8:
                            begin
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        9:
                            begin
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        10:
                            begin
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        11:
                            begin
                                EVALUATE(Colmn11_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        12:
                            begin
                                EVALUATE(Colmn12_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        13:
                            begin
                                EVALUATE(Colmn13_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        14:
                            begin
                                EVALUATE(Colmn14_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin
                CLEAR(rL_LidlItem);
                rL_LidlItem.SETRANGE("Table No.", DATABASE::Item);
                rL_LidlItem.SETRANGE(Type, rL_LidlItem.Type::Category2);
                rL_LidlItem.SETFILTER(Code, Colmn1_Valid);
                if rL_LidlItem.FINDFIRST then begin
                    rL_LidlItem.VALIDATE("Ship-to Description", Colmn2_Valid);


                    if Colmn4_Valid = 'GR' then begin
                        Colmn4_Valid := 'EL';
                    end;

                    if rL_LidlItem."Country/Region Purchased Code" <> Colmn4_Valid then begin
                        rL_LidlItem.VALIDATE("Country/Region Purchased Code", Colmn4_Valid);
                    end;
                    //rL_Item.TESTFIELD("Country/Region of Origin Code",Colmn4_Valid);

                    EVALUATE(tmp_Decimal, Colmn3_Valid);
                    rL_LidlItem.VALIDATE("Pallet Qty", tmp_Decimal);
                    rL_LidlItem.VALIDATE("Category 3", Colmn5_Valid);

                    if rL_LidlItem."Package Qty" = 0 then begin
                        EVALUATE(tmp_Decimal, Colmn6_Valid);
                        rL_LidlItem.VALIDATE("Package Qty", tmp_Decimal);
                    end;



                    //Cat 4
                    if Colmn7_Valid <> '' then begin
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category4);
                        rL_GeneralCategories.SETRANGE(Code, Colmn7_Valid);
                        if not rL_GeneralCategories.FINDSET then begin

                            CLEAR(rL_GeneralCategories);
                            rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Item);
                            rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category4);
                            rL_GeneralCategories.VALIDATE(Code, Colmn7_Valid);
                            rL_GeneralCategories.VALIDATE(Description, Colmn7_Valid);
                            rL_GeneralCategories.INSERT(true);
                        end;

                        rL_LidlItem.VALIDATE("Category 4", rL_GeneralCategories.Code);
                    end;


                    //Cat 5
                    if Colmn8_Valid <> '' then begin
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category5);
                        rL_GeneralCategories.SETRANGE(Code, Colmn8_Valid);
                        if not rL_GeneralCategories.FINDSET then begin

                            CLEAR(rL_GeneralCategories);
                            rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Item);
                            rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category5);
                            rL_GeneralCategories.VALIDATE(Code, Colmn8_Valid);
                            rL_GeneralCategories.VALIDATE(Description, Colmn8_Valid);
                            rL_GeneralCategories.INSERT(true);
                        end;

                        rL_LidlItem.VALIDATE("Category 5", rL_GeneralCategories.Code);
                    end;

                    //Cat 6
                    if Colmn9_Valid <> '' then begin
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category6);
                        rL_GeneralCategories.SETRANGE(Code, Colmn9_Valid);
                        if not rL_GeneralCategories.FINDSET then begin

                            CLEAR(rL_GeneralCategories);
                            rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Item);
                            rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category6);
                            rL_GeneralCategories.VALIDATE(Code, Colmn9_Valid);
                            rL_GeneralCategories.VALIDATE(Description, Colmn9_Valid);
                            rL_GeneralCategories.INSERT(true);
                        end;

                        rL_LidlItem.VALIDATE("Category 6", rL_GeneralCategories.Code);
                    end;

                    //Cat 7
                    if Colmn10_Valid <> '' then begin
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category7);
                        rL_GeneralCategories.SETRANGE(Code, Colmn10_Valid);
                        if not rL_GeneralCategories.FINDSET then begin

                            CLEAR(rL_GeneralCategories);
                            rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Item);
                            rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category7);
                            rL_GeneralCategories.VALIDATE(Code, Colmn10_Valid);
                            rL_GeneralCategories.VALIDATE(Description, Colmn10_Valid);
                            rL_GeneralCategories.INSERT(true);
                        end;

                        rL_LidlItem.VALIDATE("Category 7", rL_GeneralCategories.Code);
                    end;


                    //rL_Item.TESTFIELD("Sales Unit of Measure",UPPERCASE(Colmn11_Valid));
                    rL_LidlItem.VALIDATE("Unit of Measure", Colmn11_Valid);
                    //IF UPPERCASE(rL_LidlItem."Unit of Measure")<>UPPERCASE(Colmn11_Valid) THEN BEGIN
                    //  MESSAGE(rL_LidlItem.Code+' Sales UOM'+ rL_LidlItem."Unit of Measure" +' <> '+Colmn11_Valid);
                    //END;



                    rL_LidlItem.MODIFY(true);

                end;





            end;






        end; //end for 1
        Window.CLOSE;
    end;

    procedure ImportLidlCrossReference();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        //rL_ItemCrossReference: Record "Item Cross Reference";
        rL_ItemCrossReference: Record "Item Reference";
        rL_Item: Record Item;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 3; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;




        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';



            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin

                rL_Item.RESET;
                rL_Item.SETFILTER("Shelf No.", Colmn1_Valid);
                if rL_Item.FINDSET then begin
                    CLEAR(rL_ItemCrossReference);
                    rL_ItemCrossReference.SETFILTER("Item No.", rL_Item."No.");
                    /* rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                    rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", 'CUST00032');
                    rL_ItemCrossReference.SETFILTER("Cross-Reference No.", rL_Item."Shelf No."); */
                    rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                    rL_ItemCrossReference.SETFILTER("Reference Type No.", 'CUST00032');
                    rL_ItemCrossReference.SETFILTER("Reference No.", rL_Item."Shelf No.");
                    if not rL_ItemCrossReference.FINDSET then begin
                        CLEAR(rL_ItemCrossReference);
                        rL_ItemCrossReference.VALIDATE("Item No.", rL_Item."No.");
                        /* rL_ItemCrossReference.VALIDATE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                        rL_ItemCrossReference.VALIDATE("Cross-Reference Type No.", 'CUST00032');
                        rL_ItemCrossReference.VALIDATE("Cross-Reference No.", rL_Item."Shelf No."); */
                        rL_ItemCrossReference.VALIDATE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                        rL_ItemCrossReference.VALIDATE("Reference Type No.", 'CUST00032');
                        rL_ItemCrossReference.VALIDATE("Reference No.", rL_Item."Shelf No.");
                        rL_ItemCrossReference.VALIDATE(Description, Colmn2_Valid);
                        rL_ItemCrossReference.VALIDATE("Description 2", Colmn3_Valid);
                        rL_ItemCrossReference.INSERT(true);

                    end;

                end;

            end;


        end; //end for 1
        Window.CLOSE;

        MESSAGE('Import Item Cross Reference completed');
    end;

    procedure ImportLidlProductNo();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_GeneralCategories: Record "General Categories";
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 3; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;


        //rL_GeneralCategories.RESET;
        //rL_GeneralCategories.SETRANGE("Table No.",DATABASE::Item);
        //rL_GeneralCategories.SETRANGE(Type,rL_GeneralCategories.Type::Category2);
        //IF rL_GeneralCategories.FINDSET THEN BEGIN
        //  rL_GeneralCategories.DELETEALL(TRUE);
        //END;


        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';



            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin

                rL_GeneralCategories.RESET;
                rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                rL_GeneralCategories.SETRANGE(Code, Colmn1_Valid);
                if not rL_GeneralCategories.FINDSET then begin

                    CLEAR(rL_GeneralCategories);
                    rL_GeneralCategories.VALIDATE("Table No.", DATABASE::Item);
                    rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category2);
                    rL_GeneralCategories.VALIDATE(Code, Colmn1_Valid);
                    rL_GeneralCategories.VALIDATE(Description, Colmn2_Valid);
                    rL_GeneralCategories.VALIDATE("Description 2", Colmn3_Valid);
                    rL_GeneralCategories.INSERT(true);
                end;
            end;


        end; //end for 1
        Window.CLOSE;

        MESSAGE('ImportLidlProductNo completed');
    end;

    procedure ValidateCustomerCross();
    var
        rL_Item: Record Item;
        //rL_ItemCrossReference: Record "Item Cross Reference";
        rL_ItemCrossReference: Record "Item Reference";
        vL_CustCode: Code[20];
        rL_GeneralCategories: Record "General Categories";
    begin
        vL_CustCode := 'CUST00032';

        rL_Item.RESET;
        rL_Item.SETFILTER("Shelf No.", '<>%1', '');
        if rL_Item.FINDSET then begin
            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_Item.COUNT;
            WindowLineCount := 0;

            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));


                //check if the Shelf No exists in item categories
                rL_GeneralCategories.RESET;
                rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Item);
                rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category2);
                rL_GeneralCategories.SETFILTER(Code, rL_Item."Shelf No.");
                if rL_GeneralCategories.FINDSET then begin
                    CLEAR(rL_ItemCrossReference);
                    rL_ItemCrossReference.RESET;
                    rL_ItemCrossReference.SETFILTER("Item No.", rL_Item."No.");
                    /* rL_ItemCrossReference.SETRANGE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                    rL_ItemCrossReference.SETFILTER("Cross-Reference Type No.", vL_CustCode); */
                    rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                    rL_ItemCrossReference.SETFILTER("Reference Type No.", vL_CustCode);
                    if not rL_ItemCrossReference.FINDSET then begin
                        CLEAR(rL_ItemCrossReference);
                        rL_ItemCrossReference.VALIDATE("Item No.", rL_Item."No.");
                        /* rL_ItemCrossReference.VALIDATE("Cross-Reference Type", rL_ItemCrossReference."Cross-Reference Type"::Customer);
                        rL_ItemCrossReference.VALIDATE("Cross-Reference Type No.", vL_CustCode); */
                        rL_ItemCrossReference.VALIDATE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                        rL_ItemCrossReference.VALIDATE("Reference Type No.", vL_CustCode);
                        rL_ItemCrossReference.VALIDATE("Category 2", rL_Item."Shelf No.");
                        rL_ItemCrossReference.INSERT(true);
                    end else begin
                        rL_ItemCrossReference.VALIDATE("Category 2", rL_Item."Shelf No.");
                        rL_ItemCrossReference.MODIFY(true);
                    end;
                end;
            //rL_Item.VALIDATE("Shelf No.");
            //rL_Item.MODIFY;
            until rL_Item.NEXT = 0;
            Window.CLOSE;
        end;


        MESSAGE('Validation completed');
    end;

    procedure DeleteGrowers();
    var
        rL_Vendor: Record Vendor;
    begin
        if not CONFIRM(Text50006, false) then begin
            exit;
        end;


        rL_Vendor.RESET;
        rL_Vendor.SETFILTER("No. Series", 'VEND-GROW');
        if rL_Vendor.FINDSET then begin
            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_Vendor.COUNT;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
                rL_Vendor.DELETE(true);


            until rL_Vendor.NEXT = 0;
            Window.CLOSE;
        end;
    end;

    procedure ImportVendorsV2();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_Vendor: Record Vendor;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;
        Colmn11_Valid: Text;
        Colmn12_Valid: Text;
        Colmn13_Valid: Text;
        Colmn14_Valid: Text;
        Colmn15_Valid: Text;
        rL_GeneralCategories: Record "General Categories";
        rL_RowCount: Integer;
        vL_VendorNo: Code[20];
        rL_ItemGrowerVendor: Record "Item Grower Vendor";
        rL_GrowerVendor: Record Vendor;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 15; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;

        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            //Grower
            //COUNTRY
            //GGN
            //TC
            //VENDOR
            //VENDOR NO.
            //Producer Group

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';
            Colmn11_Valid := '';
            Colmn12_Valid := '';
            Colmn13_Valid := '';
            Colmn14_Valid := '';
            Colmn15_Valid := '';



            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        5:
                            begin
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        6:
                            begin
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        7:
                            begin
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        8:
                            begin
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        9:
                            begin
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        10:
                            begin
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        11:
                            begin
                                EVALUATE(Colmn11_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        12:
                            begin
                                EVALUATE(Colmn12_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        13:
                            begin
                                EVALUATE(Colmn13_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        14:
                            begin
                                EVALUATE(Colmn14_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        15:
                            begin
                                EVALUATE(Colmn15_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2


            //1 "α/α ID"
            //2 GGNHμερομηνία λήξης πισοποιητικού
            //3 GLOBALG.A.P. Certificate valid until
            //4 GLOBALG.A.P. Option (1,2,3,4)
            //5 "Status GRASP ΝΑΙ / OΧΙ"
            //6 "Προϊόν (ένα προϊόν σε κάθε γραμμή) / Product(only one product in each line)"
            //7 "Status LIDL supply chain"
            //8 Όνομα Παραγωγού / Name
            //9 Όνομα Αντιπροσώπου Lidl / Related Agency Name
            //10 "Αριθμός  Αντιπροσώπου Lidl / LIDL-Key of agency"
            //11 Όνομα Προμηθευτή / Related Supplier Name
            //12 "GGN Προμηθευτή / Related Supplier GGN"
            //13 Όνομα Συσκευαστηρίου / Related Packhouse Name
            //14 "GLN Συσκευαστηρίου / Related Packhouse GLN"
            //15 Σχόλια / comments

            //Create or update vendor
            if Colmn1_Valid <> '' then begin

                CLEAR(rL_Vendor);
                //rL_Vendor.INIT;
                //rL_Vendor.VALIDATE("No. Series",'VEND-GROW');

                //ZGRO001
                if STRLEN(Colmn1_Valid) = 1 then begin
                    vL_VendorNo := 'ZGRO00' + Colmn1_Valid;
                end else
                    if STRLEN(Colmn1_Valid) = 2 then begin
                        vL_VendorNo := 'ZGRO0' + Colmn1_Valid;
                    end;

                rL_Vendor.RESET;
                rL_Vendor.SETFILTER("No.", vL_VendorNo);
                if not rL_Vendor.FINDSET then begin
                    CLEAR(rL_Vendor);
                    rL_Vendor.INIT;
                    rL_Vendor.VALIDATE("No.", vL_VendorNo);
                    rL_Vendor.VALIDATE("No. Series", 'VEND-GROW');
                    rL_Vendor.INSERT(true);

                    if STRLEN(Colmn8_Valid) > 50 then begin

                        rL_Vendor.VALIDATE(Name, COPYSTR(Colmn8_Valid, 1, 50));
                        rL_Vendor.VALIDATE("Name 2", COPYSTR(Colmn8_Valid, 51, STRLEN(Colmn8_Valid) - 50));

                    end else begin
                        rL_Vendor.VALIDATE(Name, Colmn8_Valid);
                    end;


                    rL_Vendor.VALIDATE("Vendor Posting Group", 'GROWER');

                    rL_Vendor.GGN := Colmn2_Valid;
                    EVALUATE(TmpDate, Colmn3_Valid);
                    rL_Vendor."GGN Expiry Date" := TmpDate;

                    rL_Vendor.VALIDATE("Category 2", Colmn4_Valid);
                    rL_Vendor.VALIDATE("Category 3", Colmn5_Valid);

                    if Colmn7_Valid <> '' then begin
                        rL_GeneralCategories.RESET;
                        rL_GeneralCategories.SETRANGE("Table No.", DATABASE::Vendor);
                        rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category4);
                        rL_GeneralCategories.SETRANGE(Description, Colmn7_Valid);
                        if rL_GeneralCategories.FINDSET then begin
                            rL_Vendor.VALIDATE("Category 4", rL_GeneralCategories.Code);
                        end;
                    end;


                    /*
                    IF Colmn11_Valid<>'' THEN BEGIN
                        rL_GrowerVendor.RESET;
                        rL_GrowerVendor.SETFILTER(Name,'%1','@*'+Colmn11_Valid+'*');
                        rL_GrowerVendor.SETFILTER("Vendor Posting Group",'<>%1','GROWER');
                        IF rL_GrowerVendor.FINDSET THEN BEGIN
                             rL_Vendor.VALIDATE("Grower Vendor No.",rL_GrowerVendor."No.");
                           // rL_GrowerVendor.VALIDATE(GLN,Colmn12_Valid);
                            //rL_GrowerVendor.MODIFY();
                        END;
                    END;
                    */



                    rL_Vendor.VALIDATE(Comments, Colmn15_Valid);

                    rL_Vendor.MODIFY(true);
                end;

                if Colmn6_Valid <> '' then begin
                    rL_GeneralCategories.RESET;
                    rL_GeneralCategories.SETRANGE("Table No.", DATABASE::"Item Grower Vendor");
                    rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category1);
                    rL_GeneralCategories.SETRANGE(Description, Colmn6_Valid);
                    if rL_GeneralCategories.FINDSET then begin
                        rL_ItemGrowerVendor.RESET;
                        rL_ItemGrowerVendor.SETFILTER("Grower No.", rL_Vendor."No.");
                        rL_ItemGrowerVendor.SETFILTER("Category 1", rL_GeneralCategories.Code);
                        if not rL_ItemGrowerVendor.FINDSET then begin
                            CLEAR(rL_ItemGrowerVendor);
                            rL_ItemGrowerVendor.VALIDATE("Grower No.", rL_Vendor."No.");
                            rL_ItemGrowerVendor.VALIDATE("Category 1", rL_GeneralCategories.Code);
                            rL_ItemGrowerVendor.INSERT();
                        end;

                    end;
                end;




            end; //end column1




        end; //end for 1
        Window.CLOSE;

        MESSAGE('Import Vendor Completed');

    end;

    procedure ImportGrowerProductCategories();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_GeneralCategories: Record "General Categories";
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 2; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;




        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';




            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin

                rL_GeneralCategories.RESET;
                rL_GeneralCategories.SETRANGE("Table No.", DATABASE::"Item Grower Vendor");
                rL_GeneralCategories.SETRANGE(Type, rL_GeneralCategories.Type::Category1);
                rL_GeneralCategories.SETRANGE(Code, Colmn1_Valid);
                if not rL_GeneralCategories.FINDSET then begin

                    CLEAR(rL_GeneralCategories);
                    rL_GeneralCategories.VALIDATE("Table No.", DATABASE::"Item Grower Vendor");
                    rL_GeneralCategories.VALIDATE(Type, rL_GeneralCategories.Type::Category1);
                    rL_GeneralCategories.VALIDATE(Code, Colmn1_Valid);
                    rL_GeneralCategories.VALIDATE(Description, Colmn2_Valid);
                    rL_GeneralCategories.INSERT(true);
                end;
            end;


        end; //end for 1
        Window.CLOSE;

        MESSAGE('Grower Item completed');
    end;

    procedure ExportGrowersTemplate();
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
    begin


        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('α/α ID', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GGN', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Hμερομηνία λήξης πισοποιητικού GLOBALG.A.P. Certificate valid until', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GLOBALG.A.P. Option (1,2,3,4)', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Status GRASP ΝΑΙ / OΧΙ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Προϊόν (ένα προϊόν σε κάθε γραμμή) / Product (only one product in each line)', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Status LIDL supply chain', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Όνομα Παραγωγού / Name', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Grower Vendor Νο.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Όνομα Προμηθευτή / Related Supplier Name', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('GGN Προμηθευτή / Related Supplier GGN', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Σχόλια / comments', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.CreateBookAndOpenExcel('', 'List of Growers', 'List of Growers', COMPANYNAME, USERID);

        ERROR('');
    end;

    procedure ImportItemNetWeight();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_Item: Record Item;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 3; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;




        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';




            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin
                if rL_Item.GET(Colmn1_Valid) then begin
                    if Colmn3_Valid <> '' then begin
                        EVALUATE(TmpDecimal, Colmn3_Valid);
                        rL_Item.VALIDATE("Net Weight", TmpDecimal);
                        rL_Item.MODIFY();
                    end;

                end;

            end;


        end; //end for 1
        Window.CLOSE;

        MESSAGE('Item Net Weight completed');
    end;

    procedure ImportVendorGrowerYN();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        rL_Vendor: Record Vendor;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 4; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;




        for RowNo := 2 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';




            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end; //end case

                end;//end if
            end; //end for 2

            //update item
            if Colmn1_Valid <> '' then begin
                if rL_Vendor.GET(Colmn1_Valid) then begin
                    rL_Vendor.VALIDATE("Category 5", Colmn4_Valid);
                    rL_Vendor.MODIFY;
                end;

            end;


        end; //end for 1
        Window.CLOSE;

        MESSAGE('Vendor Grower YN completed');
    end;

    procedure TransferVendortoGrower();
    var
        rL_Vendor: Record Vendor;
        rL_Grower: Record Grower;
        rL_GrowerSearch: Record Grower;
    begin

        rL_Vendor.RESET;
        rL_Vendor.SETFILTER("Category 5", 'YES');
        rL_Vendor.SETFILTER(Name, '<>%1', '');
        if rL_Vendor.FINDSET then begin
            if not CONFIRM(Text50007, false, rL_Vendor.COUNT) then begin
                exit;
            end;

            repeat
                //add filter
                rL_GrowerSearch.RESET;
                rL_GrowerSearch.SETFILTER("Grower Vendor No.", rL_Vendor."No.");
                if not rL_GrowerSearch.FINDSET then begin
                    CLEAR(rL_Grower);
                    rL_Grower.INIT;
                    rL_Grower.INSERT(true);
                    //rL_Grower."No.":=rL_Vendor."No.";
                    rL_Grower.Name := rL_Vendor.Name;
                    rL_Grower."Search Name" := rL_Vendor."Search Name";
                    rL_Grower."Grower Vendor No." := rL_Vendor."No.";
                    rL_Grower.GGN := rL_Vendor.GGN;
                    rL_Grower.GLN := rL_Vendor.GLN;
                    rL_Grower.TC := rL_Vendor.TC;
                    rL_Grower."Category 1" := rL_Vendor."Category 1";
                    rL_Grower."Category 2" := rL_Vendor."Category 2";
                    rL_Grower."Category 3" := rL_Vendor."Category 3";
                    rL_Grower."Category 4" := rL_Vendor."Category 4";
                    rL_Grower."Category 5" := rL_Vendor."Category 5";
                    rL_Grower."GGN Expiry Date" := rL_Vendor."GGN Expiry Date";
                    rL_Grower.Comments := rL_Vendor.Comments;
                    rL_Grower."Grower Certified" := rL_Vendor."Grower Certified";
                    rL_Grower."Phone No." := rL_Vendor."Phone No.";
                    rL_Grower.MODIFY(true);
                end;



            until rL_Vendor.NEXT = 0;
        end;



        MESSAGE('Transfer Vendor Grower completed');
    end;

    procedure DeleteVendorGrower();
    var
        rL_Vendor: Record Vendor;
    begin
        rL_Vendor.RESET;
        rL_Vendor.SETFILTER("Vendor Posting Group", 'GROWER');
        if rL_Vendor.FINDSET then begin
            if not CONFIRM(Text50006, false, rL_Vendor.COUNT) then begin
                exit;
            end;

            repeat
                rL_Vendor.DELETE;

            until rL_Vendor.NEXT = 0;
        end;
        MESSAGE('Vendor Grower Deleted');
    end;

    procedure UpdateGrowerPhone();
    var
        rL_Vendor: Record Vendor;
        rL_Grower: Record Grower;
    begin
        if not CONFIRM(Text50008, false) then begin
            exit;
        end;

        rL_Grower.RESET;
        if rL_Grower.FINDSET then begin
            repeat
                if rL_Grower."Grower Vendor No." <> '' then begin
                    rL_Vendor.GET(rL_Grower."Grower Vendor No.");
                    rL_Grower."Phone No." := rL_Vendor."Phone No.";
                    rL_Grower.MODIFY;
                end;
            until rL_Grower.NEXT = 0;
        end;
        MESSAGE('Grower Phone Updated');
    end;

    procedure UpdateShipmentLotNo();
    var
        rL_SalesShipment: Record "Sales Shipment Header";
        rL_SalesShipmentLine: Record "Sales Shipment Line";
        vL_Description: Text;
        vL_Lot: Text;
    begin


        rL_SalesShipment.RESET;
        rL_SalesShipment.SETFILTER("Sell-to Customer No.", 'CUST00032');
        rL_SalesShipment.SETFILTER("Lot No.", '%1', '');
        rL_SalesShipment.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
        if rL_SalesShipment.FINDSET then begin
            if not CONFIRM(Text50009, false, rL_SalesShipment.COUNT) then begin
                exit;
            end;
            repeat
                rL_SalesShipmentLine.RESET;
                rL_SalesShipmentLine.SETFILTER("Document No.", rL_SalesShipment."No.");
                rL_SalesShipmentLine.SETRANGE("Line No.", 20000);
                rL_SalesShipmentLine.SETRANGE(Type, rL_SalesShipmentLine.Type::" ");
                if rL_SalesShipmentLine.FINDSET then begin
                    vL_Description := rL_SalesShipmentLine.Description;

                    if COPYSTR(vL_Description, 1, 3) = 'Lot' then begin
                        //MESSAGE('Before:'+vL_Description);
                        vL_Lot := DELCHR(vL_Description, '=', 'ot No: ');
                        //MESSAGE('After:'+vL_Lot);
                        //Lot No: 09-03
                        //L10-05
                        if rL_SalesShipment."Lot No." = '' then begin
                            rL_SalesShipment."Lot No." := vL_Lot;
                            rL_SalesShipment.MODIFY;
                        end;
                    end;


                end;



            until rL_SalesShipment.NEXT = 0;
        end;

        MESSAGE('Sales Shipment Update Completed');
    end;

    procedure UpdateReturnReceiptstLotNo();
    var
        rL_ReturnReceiptHeader: Record "Return Receipt Header";
        rL_ReturnReceiptLine: Record "Return Receipt Line";
        vL_Description: Text;
        vL_Lot: Text;
    begin


        rL_ReturnReceiptHeader.RESET;
        rL_ReturnReceiptHeader.SETFILTER("Sell-to Customer No.", 'CUST00032');
        rL_ReturnReceiptHeader.SETFILTER("Lot No.", '%1', '');
        rL_ReturnReceiptHeader.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
        if rL_ReturnReceiptHeader.FINDSET then begin
            if not CONFIRM(Text50010, false, rL_ReturnReceiptHeader.COUNT) then begin
                exit;
            end;
            repeat
                rL_ReturnReceiptLine.RESET;
                rL_ReturnReceiptLine.SETFILTER("Document No.", rL_ReturnReceiptHeader."No.");
                rL_ReturnReceiptLine.SETRANGE("Line No.", 20000);
                rL_ReturnReceiptLine.SETRANGE(Type, rL_ReturnReceiptLine.Type::" ");
                if rL_ReturnReceiptLine.FINDSET then begin
                    vL_Description := rL_ReturnReceiptLine.Description;

                    if COPYSTR(vL_Description, 1, 3) = 'Lot' then begin
                        //MESSAGE('Before:'+vL_Description);
                        vL_Lot := DELCHR(vL_Description, '=', 'ot No: ');
                        //MESSAGE('After:'+vL_Lot);
                        //Lot No: 09-03
                        //L10-05
                        if rL_ReturnReceiptHeader."Lot No." = '' then begin
                            rL_ReturnReceiptHeader."Lot No." := vL_Lot;
                            rL_ReturnReceiptHeader.MODIFY;
                        end;
                    end;


                end;



            until rL_ReturnReceiptHeader.NEXT = 0;
        end;

        MESSAGE('Return Receipt Update Completed');
    end;

    procedure UpdateILELot();
    var
        rL_ItemLEdgerEntries: Record "Item Ledger Entry";
        rL_ReturnReceiptHeader: Record "Return Receipt Header";
        rL_ReturnReceiptLine: Record "Return Receipt Line";
        rL_SalesShipment: Record "Sales Shipment Header";
        rL_SalesShipmentLine: Record "Sales Shipment Line";
    begin


        rL_ItemLEdgerEntries.RESET;
        rL_ItemLEdgerEntries.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
        rL_ItemLEdgerEntries.SETRANGE("Source Type", rL_ItemLEdgerEntries."Source Type"::Customer);
        rL_ItemLEdgerEntries.SETFILTER("Source No.", 'CUST00032');
        rL_ItemLEdgerEntries.SETFILTER("Gen. Prod. Posting Group", '%1', 'ST-FRVEG');

        if rL_ItemLEdgerEntries.FINDSET then begin
            if not CONFIRM(Text50011, false, rL_ItemLEdgerEntries.COUNT) then begin
                exit;
            end;
            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_ItemLEdgerEntries.COUNT;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                //sales Shipments
                if rL_ItemLEdgerEntries."Document Type" = rL_ItemLEdgerEntries."Document Type"::"Sales Shipment" then begin
                    rL_ReturnReceiptHeader.RESET;

                    rL_SalesShipment.SETFILTER("No.", rL_ItemLEdgerEntries."Document No.");
                    if rL_SalesShipment.FINDSET then begin
                        rL_ItemLEdgerEntries."Document Lot No." := rL_SalesShipment."Lot No.";
                        rL_ItemLEdgerEntries.MODIFY;

                        rL_SalesShipmentLine.RESET;
                        rL_SalesShipmentLine.SETFILTER("Document No.", rL_SalesShipment."No.");
                        rL_SalesShipmentLine.SETRANGE("Line No.", rL_ItemLEdgerEntries."Document Line No.");
                        rL_SalesShipmentLine.SETRANGE("No.", rL_ItemLEdgerEntries."Item No.");
                        if rL_SalesShipmentLine.FINDSET then begin
                            rL_ItemLEdgerEntries."Shelf No." := rL_SalesShipmentLine."Shelf No.";
                            rL_ItemLEdgerEntries.MODIFY;
                        end;
                    end;
                end;

                //return receipts
                if rL_ItemLEdgerEntries."Document Type" = rL_ItemLEdgerEntries."Document Type"::"Sales Return Receipt" then begin
                    rL_ReturnReceiptHeader.RESET;
                    rL_ReturnReceiptHeader.SETFILTER("No.", rL_ItemLEdgerEntries."Document No.");
                    if rL_ReturnReceiptHeader.FINDSET then begin
                        rL_ItemLEdgerEntries."Document Lot No." := rL_ReturnReceiptHeader."Lot No.";
                        rL_ItemLEdgerEntries.MODIFY;

                        rL_ReturnReceiptLine.RESET;
                        rL_ReturnReceiptLine.SETFILTER("Document No.", rL_ReturnReceiptHeader."No.");
                        rL_ReturnReceiptLine.SETRANGE("Line No.", rL_ItemLEdgerEntries."Document Line No.");
                        rL_ReturnReceiptLine.SETRANGE("No.", rL_ItemLEdgerEntries."Item No.");
                        if rL_ReturnReceiptLine.FINDSET then begin
                            rG_Item.GET(rL_ItemLEdgerEntries."Item No.");
                            rL_ItemLEdgerEntries."Shelf No." := rG_Item."Shelf No.";
                            rL_ItemLEdgerEntries.MODIFY;
                        end;
                    end;

                end;


            until rL_ItemLEdgerEntries.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('ILE Update Completed');
    end;

    procedure ImportILEGrowerHistory();
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;
        Colmn11_Valid: Text;
        Colmn12_Valid: Text;
        Colmn13_Valid: Text;
        Colmn14_Valid: Text;
        Colmn15_Valid: Text;
        Colmn16_Valid: Text;
        Colmn17_Valid: Text;
        Colmn18_Valid: Text;
        Colmn19_Valid: Text;
        Colmn20_Valid: Text;
        Colmn21_Valid: Text;
        Colmn22_Valid: Text;
        Colmn23_Valid: Text;
        Colmn24_Valid: Text;
        Colmn25_Valid: Text;
        Colmn26_Valid: Text;
        Colmn27_Valid: Text;
        rL_RowCount: Integer;
        rL_Item: Record Item;
        rL_ItemLEdgerEntries: Record "Item Ledger Entry";
        CRLF: array[2] of Char;
    begin
        //open the file
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        if SheetName = '' then
            exit;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 27; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;

        for RowNo := 3 to RowNoMax do begin
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            //Grower
            //COUNTRY
            //GGN
            //TC
            //VENDOR
            //VENDOR NO.
            //Producer Group

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';
            Colmn11_Valid := '';
            Colmn12_Valid := '';
            Colmn13_Valid := '';
            Colmn14_Valid := '';
            Colmn15_Valid := '';
            Colmn16_Valid := '';
            Colmn17_Valid := '';
            Colmn18_Valid := '';
            Colmn19_Valid := '';
            Colmn20_Valid := '';
            Colmn21_Valid := '';
            Colmn22_Valid := '';
            Colmn23_Valid := '';
            Colmn24_Valid := '';
            Colmn25_Valid := '';
            Colmn26_Valid := '';
            Colmn27_Valid := '';




            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin
                    case ColumnNo of
                        1:
                            begin
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        2:
                            begin
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        3:
                            begin
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        4:
                            begin
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        5:
                            begin
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        6:
                            begin
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        7:
                            begin
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        8:
                            begin
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        9:
                            begin
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        10:
                            begin
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        11:
                            begin
                                EVALUATE(Colmn11_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        12:
                            begin
                                EVALUATE(Colmn12_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        13:
                            begin
                                EVALUATE(Colmn13_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        14:
                            begin
                                EVALUATE(Colmn14_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        15:
                            begin
                                EVALUATE(Colmn15_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        16:
                            begin
                                EVALUATE(Colmn16_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        17:
                            begin
                                EVALUATE(Colmn17_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        18:
                            begin
                                EVALUATE(Colmn18_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        19:
                            begin
                                EVALUATE(Colmn19_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        20:
                            begin
                                EVALUATE(Colmn20_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        21:
                            begin
                                EVALUATE(Colmn21_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        22:
                            begin
                                EVALUATE(Colmn22_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;


                        23:
                            begin
                                EVALUATE(Colmn23_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        24:
                            begin
                                EVALUATE(Colmn24_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        25:
                            begin
                                EVALUATE(Colmn25_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        26:
                            begin
                                EVALUATE(Colmn26_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        27:
                            begin
                                EVALUATE(Colmn27_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            end;
                    end; //end case

                end;//end if
            end; //end for 2



            //update item
            if Colmn1_Valid <> '' then begin
                //check if Shelf exists
                //rL_Item.RESET;
                //rL_Item.SETFILTER("Shelf No.",Colmn5_Valid);
                //IF NOT rL_Item.FINDSET THEN BEGIN
                //  ERROR(Text50012,Colmn5_Valid);
                //END;

                //check if lot exists
                rL_ItemLEdgerEntries.RESET;
                rL_ItemLEdgerEntries.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
                rL_ItemLEdgerEntries.SETRANGE("Source Type", rL_ItemLEdgerEntries."Source Type"::Customer);
                rL_ItemLEdgerEntries.SETFILTER("Source No.", 'CUST00032');
                rL_ItemLEdgerEntries.SETFILTER("Gen. Prod. Posting Group", '%1', 'ST-FRVEG');
                rL_ItemLEdgerEntries.SETFILTER("Document Lot No.", Colmn15_Valid);
                if not rL_ItemLEdgerEntries.FINDSET then begin
                    ERROR(Text50013, Colmn15_Valid);
                end;

                //check if shelf and Lot is one row
                if (Colmn5_Valid <> '') and (Colmn15_Valid <> '') then begin
                    rL_ItemLEdgerEntries.RESET;
                    rL_ItemLEdgerEntries.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
                    rL_ItemLEdgerEntries.SETRANGE("Source Type", rL_ItemLEdgerEntries."Source Type"::Customer);
                    rL_ItemLEdgerEntries.SETFILTER("Source No.", 'CUST00032');
                    rL_ItemLEdgerEntries.SETFILTER("Gen. Prod. Posting Group", '%1', 'ST-FRVEG');
                    rL_ItemLEdgerEntries.SETFILTER("Document Lot No.", Colmn15_Valid);
                    rL_ItemLEdgerEntries.SETFILTER("Shelf No.", Colmn5_Valid);
                    rL_ItemLEdgerEntries.SETRANGE("Document Type", rL_ItemLEdgerEntries."Document Type"::"Sales Shipment");
                    rL_ItemLEdgerEntries.SETFILTER("Document Grower Name", '');
                    if rL_ItemLEdgerEntries.FINDSET then begin
                        if rL_ItemLEdgerEntries.COUNT > 1 then begin
                            //ERROR(Text50014,Colmn15_Valid,Colmn5_Valid);
                            rL_ItemLEdgerEntries."Document No. Multiple" := rL_ItemLEdgerEntries.COUNT;
                        end;
                        CRLF[1] := 13;
                        CRLF[2] := 10;

                        Colmn18_Valid := DELCHR(Colmn18_Valid, '=', FORMAT(CRLF[1]));
                        Colmn18_Valid := DELCHR(Colmn18_Valid, '=', FORMAT(CRLF[2]));

                        Colmn22_Valid := DELCHR(Colmn22_Valid, '=', FORMAT(CRLF[1]));
                        Colmn22_Valid := DELCHR(Colmn22_Valid, '=', FORMAT(CRLF[2]));

                        rL_ItemLEdgerEntries."Document Vendor GGN" := Colmn18_Valid;
                        rL_ItemLEdgerEntries."Document Vendor Name" := Colmn19_Valid;
                        rL_ItemLEdgerEntries."Document Grower GGN" := Colmn22_Valid;
                        rL_ItemLEdgerEntries."Document Grower Name" := Colmn23_Valid;
                        EVALUATE(TmpDecimal, Colmn24_Valid);
                        rL_ItemLEdgerEntries."Document Qty" := TmpDecimal;
                        rL_ItemLEdgerEntries."Document Excel Line No." := RowNo;
                        rL_ItemLEdgerEntries.MODIFY;

                    end else begin
                        MESSAGE(Text50015, Colmn15_Valid, Colmn5_Valid);
                    end;
                end;


                //Colmn5_Valid //Shelf
                //Colmn15_Valid //Lot
                //Colmn18_Valid //Vendor GGN
                //Colmn19_Valid //Vendor Name
                //Colmn22_Valid //Grower GGN
                //Colmn23_Valid //Grower Name
                //Colmn24_Valid //Grower Qty

            end;


        end; //end for 1
        Window.CLOSE;
        MESSAGE('ILE Update Completed');
    end;

    procedure UpdateILEDocumentGrowerVendNo();
    var
        rL_ItemLEdgerEntries: Record "Item Ledger Entry";
        rL_Grower: Record Grower;
        rL_Vendor: Record Vendor;
    begin
        if not CONFIRM(Text50016, false) then begin
            exit;
        end;

        rL_ItemLEdgerEntries.RESET;
        rL_ItemLEdgerEntries.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
        rL_ItemLEdgerEntries.SETRANGE("Source Type", rL_ItemLEdgerEntries."Source Type"::Customer);
        rL_ItemLEdgerEntries.SETFILTER("Source No.", 'CUST00032');
        rL_ItemLEdgerEntries.SETFILTER("Gen. Prod. Posting Group", '%1', 'ST-FRVEG');
        if rL_ItemLEdgerEntries.FINDSET then begin
            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_ItemLEdgerEntries.COUNT;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
                if rL_ItemLEdgerEntries."Document Grower GGN" <> '' then begin
                    rL_Grower.RESET;
                    rL_Grower.SETFILTER(GGN, rL_ItemLEdgerEntries."Document Grower GGN");
                    if rL_Grower.FINDSET then begin
                        rL_ItemLEdgerEntries."Document Grower No." := rL_Grower."No.";
                        rL_ItemLEdgerEntries.MODIFY;
                    end;
                end;

                if rL_ItemLEdgerEntries."Document Vendor GGN" <> '' then begin
                    rL_Vendor.RESET;
                    rL_Vendor.SETFILTER(GGN, rL_ItemLEdgerEntries."Document Vendor GGN");
                    if rL_Vendor.FINDSET then begin
                        rL_ItemLEdgerEntries."Document Vendor No." := rL_Vendor."No.";
                        rL_ItemLEdgerEntries.MODIFY;
                    end;
                end;


            until rL_ItemLEdgerEntries.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('ILE Update Completed');
    end;

    /*
    procedure UpdateShipmentTotalWeight();
    var
        rL_SalesShipment: Record "Sales Shipment Header";
        rL_SalesShipmentLine: Record "Sales Shipment Line";
        rL_Item: Record Item;
    begin
        rL_SalesShipment.RESET;
        if rL_SalesShipment.FINDSET then begin
            if not CONFIRM(Text50017, false, rL_SalesShipment.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_SalesShipment.COUNT;
            WindowLineCount := 0;

            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                rL_SalesShipmentLine.RESET;
                rL_SalesShipmentLine.SETFILTER("Document No.", rL_SalesShipment."No.");
                rL_SalesShipmentLine.SETRANGE(Type, rL_SalesShipmentLine.Type::Item);
                rL_SalesShipmentLine.SETFILTER("No.", '<>%1', '');
                if rL_SalesShipmentLine.FINDSET then begin
                    repeat
                        rL_Item.GET(rL_SalesShipmentLine."No.");
                        rL_SalesShipmentLine."Net Weight" := rL_Item."Net Weight";
                        //rL_SalesShipmentLine."Total Net Weight" := rL_SalesShipmentLine."Net Weight" * rL_SalesShipmentLine."Quantity (Base)";  //rL_SalesShipmentLine.Quantity;
                        rL_SalesShipmentLine.MODIFY;
                    until rL_SalesShipmentLine.NEXT = 0;
                end;
            until rL_SalesShipment.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('Sales Shipment Update Completed');
    end;
    */

    /*
    procedure UpdateInvoicesTotalWeight();
    var
        rL_SalesInvoice: Record "Sales Invoice Header";
        rL_SalesInvoiceLine: Record "Sales Invoice Line";
        rL_Item: Record Item;
    begin
        rL_SalesInvoice.RESET;
        if rL_SalesInvoice.FINDSET then begin
            if not CONFIRM(Text50018, false, rL_SalesInvoice.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_SalesInvoice.COUNT;
            WindowLineCount := 0;

            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                rL_SalesInvoiceLine.RESET;
                rL_SalesInvoiceLine.SETFILTER("Document No.", rL_SalesInvoice."No.");
                rL_SalesInvoiceLine.SETRANGE(Type, rL_SalesInvoiceLine.Type::Item);
                rL_SalesInvoiceLine.SETFILTER("No.", '<>%1', '');
                if rL_SalesInvoiceLine.FINDSET then begin
                    repeat
                        rL_Item.GET(rL_SalesInvoiceLine."No.");
                        rL_SalesInvoiceLine."Net Weight" := rL_Item."Net Weight";
                        rL_SalesInvoiceLine."Total Net Weight" := rL_SalesInvoiceLine."Net Weight" * rL_SalesInvoiceLine."Quantity (Base)";  //rL_SalesShipmentLine.Quantity;
                        rL_SalesInvoiceLine.MODIFY;
                    until rL_SalesInvoiceLine.NEXT = 0;
                end;
            until rL_SalesInvoice.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('Sales Invoice Update Completed');
    end;
    */

    /*
    procedure UpdateCrMemoTotalWeight();
    var
        rL_SalesCrMemo: Record "Sales Cr.Memo Header";
        rL_SalesCrMemoLine: Record "Sales Cr.Memo Line";
        rL_Item: Record Item;
    begin
        rL_SalesCrMemo.RESET;
        if rL_SalesCrMemo.FINDSET then begin
            if not CONFIRM(Text50019, false, rL_SalesCrMemo.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_SalesCrMemo.COUNT;
            WindowLineCount := 0;

            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                rL_SalesCrMemoLine.RESET;
                rL_SalesCrMemoLine.SETFILTER("Document No.", rL_SalesCrMemo."No.");
                rL_SalesCrMemoLine.SETRANGE(Type, rL_SalesCrMemoLine.Type::Item);
                rL_SalesCrMemoLine.SETFILTER("No.", '<>%1', '');
                if rL_SalesCrMemoLine.FINDSET then begin
                    repeat
                        rL_Item.GET(rL_SalesCrMemoLine."No.");
                        rL_SalesCrMemoLine."Net Weight" := rL_Item."Net Weight";
                        rL_SalesCrMemoLine."Total Net Weight" := rL_SalesCrMemoLine."Net Weight" * rL_SalesCrMemoLine."Quantity (Base)";  //rL_SalesShipmentLine.Quantity;
                        rL_SalesCrMemoLine.MODIFY;
                    until rL_SalesCrMemoLine.NEXT = 0;
                end;
            until rL_SalesCrMemo.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('Sales Cr. Memo Update Completed');
    end;
    */

    procedure UpdateDocumentGrowerVendorNo();
    var
        rL_ItemLEdgerEntries: Record "Item Ledger Entry";
        rL_Grower: Record Grower;
    begin

        rL_ItemLEdgerEntries.RESET;
        rL_ItemLEdgerEntries.SETFILTER("Document Grower No.", '<>%1', '');
        if rL_ItemLEdgerEntries.FINDSET then begin

            if not CONFIRM(Text50020, false, rL_ItemLEdgerEntries.COUNT) then begin
                exit;
            end;


            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_ItemLEdgerEntries.COUNT;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                rL_Grower.GET(rL_ItemLEdgerEntries."Document Grower No.");
                if rL_Grower."Grower Vendor No." <> '' then begin
                    rL_ItemLEdgerEntries."Document Grower Vendor No." := rL_Grower."Grower Vendor No.";
                    rL_Grower.CALCFIELDS("Grower Vendor Name");
                    rL_ItemLEdgerEntries."Document Grower Vendor Name" := rL_Grower."Grower Vendor Name";
                    rL_ItemLEdgerEntries.MODIFY;
                end;


            until rL_ItemLEdgerEntries.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('ILE Update Completed');
    end;

    /*
    procedure UpdateReturnReceiptTotalWeight();
    var
        rL_ReturnReceipt: Record "Return Receipt Header";
        rL_ReturnReceiptLine: Record "Return Receipt Line";
        rL_Item: Record Item;
    begin
        rL_ReturnReceipt.RESET;
        if rL_ReturnReceipt.FINDSET then begin
            if not CONFIRM(Text50021, false, rL_ReturnReceipt.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_ReturnReceipt.COUNT;
            WindowLineCount := 0;

            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                rL_ReturnReceiptLine.RESET;
                rL_ReturnReceiptLine.SETFILTER("Document No.", rL_ReturnReceipt."No.");
                rL_ReturnReceiptLine.SETRANGE(Type, rL_ReturnReceiptLine.Type::Item);
                rL_ReturnReceiptLine.SETFILTER("No.", '<>%1', '');
                if rL_ReturnReceiptLine.FINDSET then begin
                    repeat
                        rL_Item.GET(rL_ReturnReceiptLine."No.");
                        rL_ReturnReceiptLine."Net Weight" := rL_Item."Net Weight";
                        rL_ReturnReceiptLine."Total Net Weight" := rL_ReturnReceiptLine."Net Weight" * rL_ReturnReceiptLine."Quantity (Base)";  //rL_SalesShipmentLine.Quantity;
                        rL_ReturnReceiptLine.MODIFY;
                    until rL_ReturnReceiptLine.NEXT = 0;
                end;
            until rL_ReturnReceipt.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('Return Receipt Update Completed');
    end;
    */

    procedure UpdateLevel1Filter();
    var
        rL_ItemLEdgerEntries: Record "Item Ledger Entry";
        vL_Filter: Text;
        ItemApplnEntry: Record "Item Application Entry";
        vL_AppRowCount: Integer;
        rL_ILE2: Record "Item Ledger Entry";
    begin


        rL_ItemLEdgerEntries.RESET;
        rL_ItemLEdgerEntries.SETFILTER("Posting Date", '>=%1', DMY2DATE(1, 1, 2021));
        rL_ItemLEdgerEntries.SETRANGE("Source Type", rL_ItemLEdgerEntries."Source Type"::Customer);
        rL_ItemLEdgerEntries.SETFILTER("Source No.", 'CUST00032');
        rL_ItemLEdgerEntries.SETFILTER("Gen. Prod. Posting Group", '%1', 'ST-FRVEG');
        if rL_ItemLEdgerEntries.FINDSET then begin
            if not CONFIRM(Text50022, false, rL_ItemLEdgerEntries.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_ItemLEdgerEntries.COUNT;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                vL_Filter := '';
                vL_AppRowCount := 0;

                if rL_ItemLEdgerEntries.Positive then begin
                    ItemApplnEntry.RESET;
                    ItemApplnEntry.SETCURRENTKEY("Inbound Item Entry No.", "Outbound Item Entry No.", "Cost Application");
                    ItemApplnEntry.SETRANGE("Inbound Item Entry No.", rL_ItemLEdgerEntries."Entry No.");
                    ItemApplnEntry.SETFILTER("Outbound Item Entry No.", '<>%1', 0);
                    ItemApplnEntry.SETRANGE("Cost Application", true);
                    if ItemApplnEntry.FINDSET then
                        repeat

                            rL_ILE2.GET(ItemApplnEntry."Outbound Item Entry No.");
                            if ItemApplnEntry.Quantity * rL_ILE2.Quantity > 0 then begin
                                if (rL_ILE2."Entry Type" = rL_ILE2."Entry Type"::Purchase) or (rL_ILE2."Entry Type" = rL_ILE2."Entry Type"::Output) then begin
                                    vL_AppRowCount += 1;

                                    if vL_AppRowCount = 1 then begin
                                        vL_Filter := rL_ILE2."Document No.";
                                    end else begin
                                        vL_Filter += '|' + rL_ILE2."Document No.";
                                    end;
                                end;
                            end;
                        until ItemApplnEntry.NEXT = 0;
                end else begin
                    ItemApplnEntry.RESET;
                    ItemApplnEntry.SETCURRENTKEY("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application");
                    ItemApplnEntry.SETRANGE("Outbound Item Entry No.", rL_ItemLEdgerEntries."Entry No.");
                    ItemApplnEntry.SETRANGE("Item Ledger Entry No.", rL_ItemLEdgerEntries."Entry No.");
                    ItemApplnEntry.SETRANGE("Cost Application", true);
                    if ItemApplnEntry.FINDSET then
                        repeat

                            rL_ILE2.GET(ItemApplnEntry."Inbound Item Entry No.");
                            if -ItemApplnEntry.Quantity * rL_ILE2.Quantity > 0 then begin
                                if (rL_ILE2."Entry Type" = rL_ILE2."Entry Type"::Purchase) or (rL_ILE2."Entry Type" = rL_ILE2."Entry Type"::Output) then begin
                                    vL_AppRowCount += 1;
                                    if vL_AppRowCount = 1 then begin
                                        vL_Filter := rL_ILE2."Document No.";
                                    end else begin
                                        vL_Filter += '|' + rL_ILE2."Document No.";
                                    end;
                                end;


                            end;




                        until ItemApplnEntry.NEXT = 0;
                end;


                rL_ItemLEdgerEntries."Level 1 Document No. Filter" := vL_Filter;
                rL_ItemLEdgerEntries.MODIFY;

            until rL_ItemLEdgerEntries.NEXT = 0;
            Window.CLOSE();
        end;

        MESSAGE('ILE Update Completed');
    end;

    procedure UpdateLotGrowerNo();
    var
        rL_LotNoInformation: Record "Lot No. Information";
        rL_ILE: Record "Item Ledger Entry";
    begin

        rL_LotNoInformation.RESET;
        if rL_LotNoInformation.FINDSET then begin

            if not CONFIRM(Text50023, false, rL_LotNoInformation.COUNT) then begin
                exit;
            end;

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_LotNoInformation.COUNT;
            WindowLineCount := 0;

            repeat
                rL_ILE.RESET;
                rL_ILE.SETFILTER("Item No.", rL_LotNoInformation."Item No.");
                rL_ILE.SETFILTER("Lot No.", rL_LotNoInformation."Lot No.");
                if rL_ILE.FINDSET then begin
                    repeat
                        rL_ILE."Lot Grower No." := rL_LotNoInformation."Grower No.";
                        rL_ILE.MODIFY;
                    until rL_ILE.NEXT = 0;
                end;

                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            until rL_LotNoInformation.NEXT = 0;

            Window.CLOSE();

        end;
        MESSAGE('ILE Update Completed');
    end;

    procedure UpdateProducerGroup();
    var
        rL_LotNoInformation: Record "Lot No. Information";
    begin
        rL_LotNoInformation.RESET;
        rL_LotNoInformation.SETFILTER("Category 1", 'PG0012');
        if rL_LotNoInformation.FINDSET then begin
            repeat
                rL_LotNoInformation."Category 1" := '';
                rL_LotNoInformation.MODIFY;

            until rL_LotNoInformation.NEXT = 0;
        end;

        MESSAGE('Process Completed');
    end;

    procedure SundryGrowerExistsPO(pDocNo: Code[20]): Boolean;
    var
        rL_ReservationEntry: Record "Reservation Entry";
        rL_SalesRecSetup: Record "Sales & Receivables Setup";
        rL_TrackingSpecification: Record "Tracking Specification";
    begin
        if pDocNo = '' then begin
            exit(false);
        end;

        rL_SalesRecSetup.GET;
        rL_SalesRecSetup.TESTFIELD("Lidl Import Sundry Grower");

        rL_ReservationEntry.RESET;
        rL_ReservationEntry.SETRANGE("Source Type", 39);
        rL_ReservationEntry.SETFILTER("Source ID", pDocNo);
        rL_ReservationEntry.SETFILTER("Lot Grower No.", rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_ReservationEntry.FINDSET then begin
            exit(true);
        end;

        rL_TrackingSpecification.RESET;
        rL_TrackingSpecification.SETRANGE("Source Type", 39);
        rL_TrackingSpecification.SETFILTER("Source ID", pDocNo);
        rL_TrackingSpecification.SETFILTER("Lot Grower No.", rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_TrackingSpecification.FINDSET then begin
            exit(true);
        end;

        exit(false);
    end;

    procedure SundryGrowerExistsSO(pDocNo: Code[20]): Boolean;
    var
        rL_ReservationEntry: Record "Reservation Entry";
        rL_SalesRecSetup: Record "Sales & Receivables Setup";
        rL_TrackingSpecification: Record "Tracking Specification";
    begin
        if pDocNo = '' then begin
            exit(false);
        end;

        rL_SalesRecSetup.GET;
        rL_SalesRecSetup.TESTFIELD("Lidl Import Sundry Grower");

        rL_ReservationEntry.RESET;
        rL_ReservationEntry.SETRANGE("Source Type", 37);
        rL_ReservationEntry.SETFILTER("Source ID", pDocNo);
        rL_ReservationEntry.SETFILTER("Lot Grower No.", rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_ReservationEntry.FINDSET then begin
            exit(true);
        end;


        rL_TrackingSpecification.RESET;
        rL_TrackingSpecification.SETRANGE("Source Type", 37);
        rL_TrackingSpecification.SETFILTER("Source ID", pDocNo);
        rL_TrackingSpecification.SETFILTER("Lot Grower No.", rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_TrackingSpecification.FINDSET then begin
            exit(true);
        end;

        exit(false);
    end;

    procedure POLotTrackingCompleted(pDocNo: Code[20]): Boolean;
    var
        rL_PurchaseLine: Record "Purchase Line";
        vL_LinesWithTracking: Integer;
        rL_Item: Record Item;
        rL_ReservationEntry: Record "Reservation Entry";
        rL_TrackingSpecification: Record "Tracking Specification";
        vL_ReservationEntryCount: Integer;
        vL_TrackingSpecificationCount: Integer;
        rL_SalesRecSetup: Record "Sales & Receivables Setup";
    begin

        vL_LinesWithTracking := 0;
        vL_ReservationEntryCount := 0;
        vL_TrackingSpecificationCount := 0;

        rL_SalesRecSetup.GET;
        rL_SalesRecSetup.TESTFIELD("Lidl Import Sundry Grower");

        //count no of lines that require tracking
        rL_PurchaseLine.RESET;
        rL_PurchaseLine.SETRANGE("Document Type", rL_PurchaseLine."Document Type"::Order);
        rL_PurchaseLine.SETFILTER("Document No.", pDocNo);
        rL_PurchaseLine.SETRANGE(Type, rL_PurchaseLine.Type::Item);
        rL_PurchaseLine.SETFILTER(Quantity, '<>%1', 0);
        if rL_PurchaseLine.FINDSET then begin
            repeat
                if rL_Item.GET(rL_PurchaseLine."No.") then begin
                    if rL_Item."Item Tracking Code" <> '' then begin
                        vL_LinesWithTracking += 1;
                    end;
                end;
            until rL_PurchaseLine.NEXT = 0;
        end;

        if vL_LinesWithTracking = 0 then begin
            exit(false);
        end;

        //count no of item traacking and Reservation entries
        rL_ReservationEntry.RESET;
        rL_ReservationEntry.SETFILTER("Source Type", '39');
        rL_ReservationEntry.SETFILTER("Source ID", pDocNo);
        rL_ReservationEntry.SETFILTER("Lot Grower No.", '<>%1', rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_ReservationEntry.FINDSET then begin
            vL_ReservationEntryCount := rL_ReservationEntry.COUNT;
        end;


        //check Posted
        rL_TrackingSpecification.RESET;
        rL_TrackingSpecification.SETFILTER("Source Type", '39');
        rL_TrackingSpecification.SETFILTER("Source ID", pDocNo);
        rL_TrackingSpecification.SETFILTER("Lot Grower No.", '<>%1', rL_SalesRecSetup."Lidl Import Sundry Grower");
        if rL_TrackingSpecification.FINDSET then begin
            vL_TrackingSpecificationCount := rL_TrackingSpecification.COUNT;
        end;

        if vL_ReservationEntryCount + vL_TrackingSpecificationCount >= vL_LinesWithTracking then begin
            exit(true);
        end;

        exit(false);
    end;

    procedure POLotTrackingRequired(pDocNo: Code[20]): Boolean;
    var
        rL_PurchaseLine: Record "Purchase Line";
        vL_LinesWithTracking: Integer;
        rL_Item: Record Item;
    begin

        vL_LinesWithTracking := 0;

        //count no of lines that require tracking
        rL_PurchaseLine.RESET;
        rL_PurchaseLine.SETRANGE("Document Type", rL_PurchaseLine."Document Type"::Order);
        rL_PurchaseLine.SETFILTER("Document No.", pDocNo);
        rL_PurchaseLine.SETRANGE(Type, rL_PurchaseLine.Type::Item);
        rL_PurchaseLine.SETFILTER(Quantity, '<>%1', 0);
        if rL_PurchaseLine.FINDSET then begin
            repeat
                if rL_Item.GET(rL_PurchaseLine."No.") then begin
                    if rL_Item."Item Tracking Code" <> '' then begin
                        vL_LinesWithTracking += 1;
                    end;
                end;
            until rL_PurchaseLine.NEXT = 0;
        end;

        if vL_LinesWithTracking > 0 then begin
            exit(true);
        end;


        exit(false);
    end;

    procedure ImportHorecaOrders(pVersion: Integer; pOneExcelFile: Boolean);
    var
        //Folder: DotNet Folder_DT;// "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.IO.Directory" RUNONCLIENT;
        //Lst: DotNet Lst_DT; //Lst_DT;// "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Collections.Generic.List`1" RUNONCLIENT;
        //Obj: DotNet Obj_DT;// "'mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'.System.Object" RUNONCLIENT;
        i: Integer;
        vL_FileName: Text[250];
        vL_FileNameOnly: Text;
        cu_FileManagement: Codeunit "File Management";
        selectedfolder: Text;
        vL_OrderProcessed: Boolean;
        vL_OrdersCounted: Integer;
        vL_OrderInserted: Integer;
        vL_Text50000: Label '%1 of %2 orders inserted.';
        vL_Instream: InStream;
        //[RunOnClient]
        //FolderBrowser: DotNet FolderBrowserDialog;
        //[RunOnClient]
        //DialogResult: DotNet DialogResult;
        WindowTitle: Text;
        Buffer: Record "Name/Value Buffer" temporary;
        SelectZIPFileMsg: Label 'Select ZIP File';
        ZipFileName: Text;
        InStream: InStream;
        DataCompression: Codeunit "Data Compression";
        EntryList: List of [Text];
        EntryListKey: Text;
        FileName: Text;
        FileExtension: Text;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        FileCount: Integer;
        EntryOutStream: OutStream;
        EntryInStream: InStream;
        Length: Integer;
    //UseWebclient: Boolean;
    begin
        if pOneExcelFile then begin
            ProcessHorecaOrders(vL_FileName, vL_FileNameOnly, pVersion, false, EntryInStream); //TAL0.16
        end else begin
            //+TAL0.15
            CLEAR(cu_FileManagement);
            WindowTitle := 'Select HORECA Excel Orders Folder';
            //UseWebclient := true;
            //if UseWebclient then begin
            if not UploadIntoStream(SelectZIPFileMsg, '', 'Zip Files|*.zip', ZipFileName, InStream) then
                Error('');

            //Extract zip file and store files to list type
            DataCompression.OpenZipArchive(InStream, false);
            DataCompression.GetEntryList(EntryList);

            FileCount := 0;

            //Loop files from the list type
            WindowLineCount := 0;
            WindowTotalCount := EntryList.Count();
            Window.OPEN('File Processing #1############### #2#####################################');

            foreach EntryListKey in EntryList do begin

                clear(TempBlob);
                clear(EntryOutStream);
                clear(EntryInStream);
                Length := 0;

                FileName := CopyStr(FileMgt.GetFileNameWithoutExtension(EntryListKey), 1, MaxStrLen(FileName));
                FileExtension := CopyStr(FileMgt.GetExtension(EntryListKey), 1, MaxStrLen(FileExtension));
                TempBlob.CreateOutStream(EntryOutStream);
                DataCompression.ExtractEntry(EntryListKey, EntryOutStream, Length);
                TempBlob.CreateInStream(EntryInStream);


                //UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);

                FileCount += 1;

                vL_FileName := FORMAT(EntryListKey);

                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                vL_FileNameOnly := cu_FileMgt.GetFileName(vL_FileName);
                if vL_FileNameOnly <> '' then begin
                    Window.UPDATE(2, vL_FileNameOnly);
                    vL_OrdersCounted += 1;
                    vL_OrderProcessed := ProcessHorecaOrders(vL_FileName, vL_FileNameOnly, pVersion, true, EntryInStream); //TAL0.16
                    if vL_OrderProcessed then begin
                        vL_OrderInserted += 1;
                    end;
                end;
                //MESSAGE(vL_FileNameOnly);



            end;

            Window.CLOSE();
            MESSAGE(vL_Text50000, vL_OrderInserted, vL_OrdersCounted);
            //Close the zip file
            DataCompression.CloseZipArchive();

        end;
        /*
        end else begin
            cu_FileManagement.SelectFolderDialog('Select HORECA Excel Orders Folder', selectedfolder);
            //cu_FileManagement.GetServerDirectoryFilesListInclSubDirs(selectedfolder);
            //File.UploadIntoStream('Select HORECA Excel Orders Folder', '', '', selectedfolder, vL_Instream);
            //cu_FileManagement.GetDirectoryName(selectedfolder);
            vL_OrdersCounted := 0;
            vL_OrderInserted := 0;
            Obj := Folder.GetFiles(selectedfolder); //,'*.xlsx,*.xls,*.csv'
            Lst := Lst.List;
            Lst.AddRange(Obj);
            //MESSAGE('%1',Lst.Count);
            if Lst.Count > 0 then begin
                WindowLineCount := 0;
                WindowTotalCount := Lst.Count;
                Window.OPEN('File Processing #1############### #2#####################################');
                //MESSAGE(FORMAT(Lst.Count));
                for i := 0 to Lst.Count - 1 do begin
                    vL_OrdersCounted += 1;

                    vL_FileName := FORMAT(Lst.Item(i));

                    WindowLineCount += 1;
                    Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));



                    vL_FileNameOnly := cu_FileMgt.GetFileName(vL_FileName);
                    //MESSAGE(vL_FileNameOnly);

                    Window.UPDATE(2, vL_FileNameOnly);

                    vL_OrderProcessed := ProcessHorecaOrders(vL_FileName, vL_FileNameOnly, pVersion, false, EntryInStream); //TAL0.16
                    if vL_OrderProcessed then begin
                        vL_OrderInserted += 1;
                    end;


                end;

                Window.CLOSE();
                MESSAGE(vL_Text50000, vL_OrderInserted, vL_OrdersCounted);

            end else begin
                MESSAGE('No files found ' + FORMAT(selectedfolder));
            end;
        end;
        */




        //-TAL0.15
    end;

    local procedure ProcessHorecaOrders(pFileName: Text; pFileNameOnly: Text; pversion: Integer; pUseStream: Boolean; pInStream: InStream) OrderCreated: Boolean;
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ExcelValue: array[4000, 30] of Text[250];
        vL_RowNo: Integer;
        vl_OrderDate: Date;
        vl_ExpectedDeliveryDate: Date;
        vl_ShiptoCode: Code[10];
        Colmn1_ItemNo: Text;
        Colmn7_Qty: Text;
        Colmn8_Qty: Text;
        SRSetup: Record "Sales & Receivables Setup";
        rL_SalesHeader: Record "Sales Header";
        rL_SalesLine: Record "Sales Line";
        rL_Customer: Record Customer;
        rL_ShipToAddress: Record "Ship-to Address";
        vL_Text50000: Label 'Order Date cannot be empty filename %1.';
        vL_Text50001: Label 'Expected Delivery Date cannot be empty filename %1.';
        vL_Text50002: Label 'Location No (Ship-to Address Code) cannot be empty filename %1.';
        vL_Text50003: Label 'Ship-to Address %1 not found. Filename %2';
        vL_Text50004: Label 'Item %1 not found. Filename %2';
        vL_Text50005: Label 'Order Date %1 cannot be less than %2. %3 Formula Validation.';
        vL_Text50006: Label 'Order Date %1 cannot be greater than %2. %3 Formula Validation.';
        vL_Text50007: Label 'Expected Delivery Date %1 cannot be less than %2. %3 Formula Validation.';
        vL_Text50008: Label 'Expected Delivery Date %1 cannot be greater than %2. %3 Formula Validation.';
        vL_LineNo: Integer;
        rL_Item: Record Item;
        vL_Qty: Decimal;

        cu_FileManagement: Codeunit "File Management";
        HorecaStartDate: Date;
        HorecaEndDate: Date;
    begin
        OrderCreated := false;
        CLEAR(ExcelBuffer);

        if pUseStream then begin
            ExcelBuffer.Reset();
            ExcelBuffer.DeleteAll();
            SheetName := ExcelBuffer.SelectSheetsNameStream(pInStream);
        end else begin
            //vL_FileName := cu_FileManagement.UploadFileSilent(pFileName); //v19
            vL_FileName := cu_FileManagement.UploadFile('', pFileName); //2017-v21
            SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        end;


        // vL_FileName := cu_FileManagement.sile()(pFileName);



        //vL_FileName := pFileName; //cu_FileMgt.UploadFile(Text50000,ExcelFileExtensionTok);


        if SheetName = '' then
            exit;



        if pUseStream then begin
            ExcelBuffer.OpenBookStream(pInStream, SheetName);
        end else begin
            ExcelBuffer.OpenBook(vL_FileName, SheetName);
        end;



        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 8; //ExcelBuffer."Column No."; //NOD0.2;

        vL_RowNo := 0;

        //Window.OPEN('Record Processing #1###############');
        //WindowTotalCount:=RowNoMax;
        //WindowLineCount:=0;

        vl_OrderDate := 0D;
        vl_ExpectedDeliveryDate := 0D;
        vl_ShiptoCode := '';

        //Get Order Date C5
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 5);
        ExcelBuffer.SETRANGE("Column No.", 3);
        if ExcelBuffer.FINDSET then begin
            EVALUATE(vl_OrderDate, Trim(ExcelBuffer."Cell Value as Text"));
        end;

        if vl_OrderDate = 0D then begin
            ERROR(vL_Text50000, pFileNameOnly);
        end;

        //+1.0.0.247
        //check order date
        //5 Days less 
        //5 Days More
        SRSetup.GET;
        if (FORMAT(SRSetup."Horeca Start Date Validation") <> '') and (FORMAT(SRSetup."Horeca End Date Validation") <> '') then begin
            HorecaStartDate := CalcDate(SRSetup."Horeca Start Date Validation", WORKDATE());
            HorecaEndDate := CalcDate(SRSetup."Horeca End Date Validation", WORKDATE());

            if vl_OrderDate < HorecaStartDate then begin
                Error(vL_Text50005, vl_OrderDate, HorecaStartDate, FORMAT(SRSetup."Horeca Start Date Validation"));
            end;

            if vl_OrderDate > HorecaEndDate then begin
                Error(vL_Text50006, vl_OrderDate, HorecaEndDate, FORMAT(SRSetup."Horeca End Date Validation"));
            end;
        end;
        //-.0.0.247


        //Get Expected Delivery Date H5
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 5);
        ExcelBuffer.SETRANGE("Column No.", 8);
        if ExcelBuffer.FINDSET then begin
            EVALUATE(vl_ExpectedDeliveryDate, Trim(ExcelBuffer."Cell Value as Text"));
        end;

        if vl_ExpectedDeliveryDate = 0D then begin
            ERROR(vL_Text50001, pFileNameOnly);
        end;

        //+1.0.0.247
        if (FORMAT(SRSetup."Horeca Start Date Validation") <> '') and (FORMAT(SRSetup."Horeca End Date Validation") <> '') then begin
            HorecaStartDate := CalcDate(SRSetup."Horeca Start Date Validation", WORKDATE());
            HorecaEndDate := CalcDate(SRSetup."Horeca End Date Validation", WORKDATE());

            if vl_ExpectedDeliveryDate < HorecaStartDate then begin
                Error(vL_Text50007, vl_ExpectedDeliveryDate, HorecaStartDate, FORMAT(SRSetup."Horeca Start Date Validation"));
            end;

            if vl_ExpectedDeliveryDate > HorecaEndDate then begin
                Error(vL_Text50008, vl_ExpectedDeliveryDate, HorecaEndDate, FORMAT(SRSetup."Horeca End Date Validation"));
            end;
        end;
        //-1.0.0.247

        //Get Location No.
        ExcelBuffer.RESET;
        ExcelBuffer.SETRANGE("Row No.", 4);
        ExcelBuffer.SETRANGE("Column No.", 4);
        if ExcelBuffer.FINDSET then begin
            EVALUATE(vl_ShiptoCode, Trim(ExcelBuffer."Cell Value as Text"));
        end;

        if vl_ShiptoCode = '' then begin
            ERROR(vL_Text50002, pFileNameOnly);
        end;

        //MESSAGE('Order Date:'+FORMAT(vl_OrderDate));
        //MESSAGE('Expected Delivery Date:'+FORMAT(vl_ExpectedDeliveryDate));
        //MESSAGE('Ship-to Code:'+FORMAT(vl_ShiptoCode));

        //find the customer
        rL_ShipToAddress.RESET;
        rL_ShipToAddress.SETFILTER(Code, vl_ShiptoCode);
        if rL_ShipToAddress.FINDSET then begin
            rL_Customer.GET(rL_ShipToAddress."Customer No.");
        end else begin
            ERROR(vL_Text50003, vl_ShiptoCode, pFileNameOnly);
        end;

        //create the header
        CLEAR(rL_SalesHeader);
        rL_SalesHeader.RESET;
        rL_SalesHeader.SetHideValidationDialog(true);
        rL_SalesHeader.VALIDATE("Document Type", rL_SalesHeader."Document Type"::Order);
        rL_SalesHeader.VALIDATE("Sell-to Customer No.", rL_Customer."No.");
        rL_SalesHeader.INSERT(true);

        rL_SalesHeader.VALIDATE("Document Date", vl_ExpectedDeliveryDate);
        rL_SalesHeader.VALIDATE("Order Date", vl_ExpectedDeliveryDate);
        rL_SalesHeader.VALIDATE("Requested Delivery Date", vl_ExpectedDeliveryDate);
        rL_SalesHeader.VALIDATE("Ship-to Code", vl_ShiptoCode);
        rL_SalesHeader.Validate("Excel Order Date", vl_OrderDate);
        rL_SalesHeader.MODIFY(true);

        //rL_SalesHeader.ValidateShortcutDimCode(5,rL_SalesHeader."Ship-to Code");
        //rL_SalesHeader.MODIFY(TRUE);


        ExcelBuffer.RESET;
        for RowNo := 9 to RowNoMax do begin //STARTING LINE
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            Colmn1_ItemNo := '';
            Colmn7_Qty := '';
            Colmn8_Qty := '';


            for ColumnNo := 1 to ColumnNoMax do begin
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                if ExcelBuffer.FINDFIRST then begin

                    case ColumnNo of

                        1:
                            begin
                                EVALUATE(Colmn1_ItemNo, Trim(ExcelBuffer."Cell Value as Text"));
                            end;



                        7:
                            begin
                                EVALUATE(Colmn7_Qty, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                        8:
                            begin
                                EVALUATE(Colmn8_Qty, Trim(ExcelBuffer."Cell Value as Text"));
                            end;

                    end;// case


                end;//if
            end;//for

            vL_Qty := 0;

            if Colmn1_ItemNo <> '' then begin
                //+TAL0.16
                case pversion of
                    1:
                        begin
                            if Colmn8_Qty <> '' then begin
                                EVALUATE(vL_Qty, Colmn8_Qty);
                            end;
                        end;

                    2:
                        begin
                            if Colmn7_Qty <> '' then begin
                                EVALUATE(vL_Qty, Colmn7_Qty);
                            end;
                        end;
                end;
                //-TAL0.16



                if rL_Item.GET(Colmn1_ItemNo) then begin
                    if (vL_Qty <> 0) then begin
                        vL_LineNo := 0;
                        CLEAR(rL_SalesLine);
                        rL_SalesLine.RESET;
                        rL_SalesLine.SETRANGE("Document Type", rL_SalesHeader."Document Type");
                        rL_SalesLine.SETFILTER("Document No.", rL_SalesHeader."No.");
                        if rL_SalesLine.FINDLAST then begin
                            vL_LineNo := rL_SalesLine."Line No.";
                        end;

                        vL_LineNo += 10000;

                        rL_SalesLine.RESET;
                        rL_SalesLine.SetHideValidationDialog(true);
                        rL_SalesLine.VALIDATE("Document Type", rL_SalesHeader."Document Type");
                        rL_SalesLine.VALIDATE("Document No.", rL_SalesHeader."No.");
                        rL_SalesLine."Line No." := vL_LineNo;
                        rL_SalesLine.INSERT(true);

                        rL_SalesLine.VALIDATE(Type, rL_SalesLine.Type::Item);
                        rL_SalesLine.VALIDATE("No.", rL_Item."No.");

                        if rL_Item."Base Unit of Measure" <> rL_Item."Sales Unit of Measure" then begin
                            rL_SalesLine.VALIDATE(Quantity, vL_Qty * rL_Item."Package Qty");
                        end else begin
                            rL_SalesLine.VALIDATE(Quantity, vL_Qty);
                        end;


                        rL_SalesLine.VALIDATE("Qty. Requested", vL_Qty);

                        rL_SalesLine.MODIFY;
                        rL_SalesLine.ValidateShortcutDimCode(5, rL_SalesHeader."Ship-to Code");
                        rL_SalesLine.MODIFY;
                    end;
                end else begin
                    //MESSAGE(vL_Text50004,Colmn1_ItemNo,pFileNameOnly);
                end;
            end;


        end; //for


        OrderCreated := true;
        exit(OrderCreated);
    end;

    procedure POCreateLot(pDocNo: Code[20])
    var

        rL_PurchaseLine: Record "Purchase Line";
        rL_PurchaseHeader: Record "Purchase Header";
        rL_Item: Record Item;
        vL_LinesWithTracking: Integer;
        ReservationEntry: Record "Reservation Entry";
        rL_ReservationEntry: Record "Reservation Entry";
        rL_Grower: Record Grower;
        rL_LotNoInformation: Record "Lot No. Information";
        NoSeriesMgt: Codeunit "No. Series";
        vL_ProducerCategory: Code[20];
        pGrowerList: Page "Grower List";
        Text50000L: Label '%1 Items with Tracking Lines have been processed.';
        Text50001L: Label 'Grower not found for Venodr No. %1.';
        Text50002L: Label 'Are you sure to run the create lot process for grower %1?';
    begin
        vL_LinesWithTracking := 0;

        rL_PurchaseHeader.GET(rL_PurchaseHeader."Document Type"::Order, pDocNo);

        rL_Grower.RESET;
        rL_Grower.SETFILTER("Grower Vendor No.", rL_PurchaseHeader."Buy-from Vendor No.");
        IF NOT rL_Grower.FINDSET THEN BEGIN
            //ERROR(Text50001L,rL_PurchaseHeader."Buy-from Vendor No.");
            rL_Grower.RESET;
        END;


        //build page
        //CLEAR(pGrowerList);
        //pGrowerList.SETTABLEVIEW(rL_Grower);
        //pGrowerList.LOOKUPMODE(TRUE);
        //IF pGrowerList.RUNMODAL() = ACTION::LookupOK THEN BEGIN
        IF PAGE.RUNMODAL(PAGE::"Grower List", rL_Grower) = ACTION::LookupOK THEN BEGIN

        END ELSE BEGIN
            EXIT;
        END;


        IF NOT CONFIRM(Text50002L, FALSE, rL_Grower.Name) THEN BEGIN
            EXIT;
        END;

        rL_PurchaseLine.RESET;
        rL_PurchaseLine.SETRANGE("Document Type", rL_PurchaseLine."Document Type"::Order);
        rL_PurchaseLine.SETFILTER("Document No.", pDocNo);
        rL_PurchaseLine.SETRANGE(Type, rL_PurchaseLine.Type::Item);
        rL_PurchaseLine.SETFILTER(Quantity, '<>%1', 0);
        IF rL_PurchaseLine.FINDSET THEN BEGIN
            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_PurchaseLine.COUNT;
            WindowLineCount := 0;
            REPEAT
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

                IF rL_Item.GET(rL_PurchaseLine."No.") THEN BEGIN
                    IF rL_Item."Item Tracking Code" <> '' THEN BEGIN
                        rL_Item.TESTFIELD("Lot Nos.");
                        vL_LinesWithTracking += 1;

                        //check if not already created
                        rL_ReservationEntry.RESET;
                        rL_ReservationEntry.SETFILTER("Item No.", rL_PurchaseLine."No.");
                        rL_ReservationEntry.SETFILTER("Location Code", rL_PurchaseLine."Location Code");
                        rL_ReservationEntry.SETFILTER("Source Type", '39');
                        rL_ReservationEntry.SETFILTER("Source ID", rL_PurchaseLine."Document No.");
                        rL_ReservationEntry.SETRANGE("Source Ref. No.", rL_PurchaseLine."Line No.");
                        IF NOT rL_ReservationEntry.FINDSET THEN BEGIN
                            //create the reservation Entry
                            CLEAR(ReservationEntry);
                            ReservationEntry.INIT;
                            ReservationEntry."Entry No." := 0;
                            ReservationEntry.VALIDATE("Item No.", rL_PurchaseLine."No.");
                            ReservationEntry.VALIDATE("Location Code", rL_PurchaseLine."Location Code");
                            ReservationEntry.VALIDATE("Quantity (Base)", rL_PurchaseLine."Quantity (Base)");
                            ReservationEntry.VALIDATE(Positive, TRUE);
                            ReservationEntry.VALIDATE("Reservation Status", ReservationEntry."Reservation Status"::Surplus);

                            ReservationEntry.VALIDATE("Creation Date", TODAY);
                            ReservationEntry.VALIDATE("Source Type", 39);
                            ReservationEntry.VALIDATE("Source Subtype", ReservationEntry."Source Subtype"::"1");
                            ReservationEntry.VALIDATE("Source ID", rL_PurchaseLine."Document No.");
                            ReservationEntry.VALIDATE("Source Ref. No.", rL_PurchaseLine."Line No.");

                            ReservationEntry.VALIDATE("Created By", USERID);
                            ReservationEntry.VALIDATE("Expected Receipt Date", rL_PurchaseLine."Expected Receipt Date");

                            //ReservationEntry.Quantity := (-1*rL_PurchaseLine.Quantity);
                            //ReservationEntry."Qty. to Handle (Base)" := (-1*rL_PurchaseLine."Quantity (Base)");
                            //ReservationEntry."Qty. to Invoice (Base)" := (-1*rL_PurchaseLine."Quantity (Base)");
                            ReservationEntry.VALIDATE("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");

                            ReservationEntry.VALIDATE("Lot No.", NoSeriesMgt.GetNextNo(rL_Item."Lot Nos.", WORKDATE, TRUE)); //"Item Ledger Entry"."Lot No.";
                            ReservationEntry.INSERT(TRUE);


                            //create the lot information card
                            rL_LotNoInformation.RESET;
                            rL_LotNoInformation.SETFILTER("Item No.", ReservationEntry."Item No.");
                            rL_LotNoInformation.SETFILTER("Lot No.", ReservationEntry."Lot No.");
                            IF NOT rL_LotNoInformation.FINDSET THEN BEGIN
                                CLEAR(rL_LotNoInformation);
                                rL_LotNoInformation.INIT;
                                rL_LotNoInformation.VALIDATE("Item No.", ReservationEntry."Item No.");
                                rL_LotNoInformation.VALIDATE("Lot No.", ReservationEntry."Lot No.");
                                rL_LotNoInformation.INSERT(TRUE);
                                rL_LotNoInformation.VALIDATE("Grower No.", rL_Grower."No.");
                                rL_LotNoInformation.MODIFY;
                            END;
                        END; //  IF NOT rL_ReservationEntry.FINDSET





                    END;// IF rL_Item."Item Tracking Code"<>''
                END; //IF rL_Item.GET(rL_PurchaseLine."No.") 
            UNTIL rL_PurchaseLine.NEXT = 0;
            Window.CLOSE;
        END;

        MESSAGE(Text50000L, vL_LinesWithTracking);
    end;

    procedure EmailSalesOrder(SalesHeader: Record "Sales Header"; Usage: Option "Order Confirmation","Work Order","Pick Instruction")
    var
        ReportSelections: Record "Report Selections";
    begin
        //+TAL0.1
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN
            EXIT;

        SalesHeader.SETRANGE("No.", SalesHeader."No.");
        //CalcSalesDisc(SalesHeader);

        ReportSelections.SendEmailToCust(
          GetSalesOrderUsage(Usage).AsInteger(), SalesHeader, SalesHeader."No.", FORMAT(Usage), TRUE, SalesHeader."Bill-to Customer No.");
        //-TAL0.1
    end;

    procedure GetSalesOrderUsage(Usage: Option "Order Confirmation","Work Order","Pick Instruction") Result: Enum "Report Selection Usage"
    var
        ReportSelections: Record "Report Selections";
        IsHandled: Boolean;
    begin
        case Usage of
            Usage::"Order Confirmation":
                exit(ReportSelections.Usage::"S.Order");
            Usage::"Work Order":
                exit(ReportSelections.Usage::"S.Work Order");
            Usage::"Pick Instruction":
                exit(ReportSelections.Usage::"S.Order Pick Instruction");

        end;
    end;

    procedure EmailSalesOrderMultiple(SalesHeader: Record "Sales Header"; Usage: Option "Order Confirmation","Work Order","Pick Instruction")
    var
        ReportSelections: Record "Report Selections";
        Location: Record Location;
        ToRecipient: List of [Text];
        CCRecipient: List of [Text];
        BCCRecipient: List of [Text];
        vBody: Text;
        SalesLine: Record "Sales Line";
        oldLocationCode: Code[20];
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        AttachementTempBlob: Codeunit "Temp Blob";
        AttachementInstream: InStream;
        AttachementOutStream: OutStream;
        recRef: RecordRef;
        ReportParameters: text;
        Text50000: Label '<?xml version="1.0" standalone="yes"?><ReportParameters name="Work Order Lidl" id="50006"><DataItems><DataItem name="Sales Header">VERSION(1) SORTING(Field1,Field3) WHERE(Field1=1(1),Field3=1(%1))</DataItem><DataItem name="PageLoop">VERSION(1) SORTING(Field1)</DataItem><DataItem name="Sales Line">VERSION(1) SORTING(Field1,Field3,Field4) WHERE(Field1=1(1),Field3=1(%1),Field5=1(2),Field7=1(%2))</DataItem><DataItem name="Order Qty">VERSION(1) SORTING(Field40)</DataItem><DataItem name="Sales Comment Line">VERSION(1) SORTING(Field1,Field2,Field7,Field3)</DataItem><DataItem name="Extra Lines">VERSION(1) SORTING(Field1)</DataItem></DataItems></ReportParameters>';

    begin

        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Order THEN
            EXIT;

        SalesHeader.SETRANGE("No.", SalesHeader."No.");

        SalesLine.RESET;
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Location Code");
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetFilter("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then begin
            repeat
                if (oldLocationCode = '') or (oldLocationCode <> SalesLine."Location Code") then begin
                    clear(EmailMessage);
                    clear(Email);
                    clear(ToRecipient);
                    clear(CCRecipient);
                    clear(AttachementTempBlob);
                    clear(AttachementOutStream);
                    clear(AttachementInstream);


                    Location.Get(SalesLine."Location Code");

                    vBody := 'Dear Colleague,<br><br> Please find attached work order for location ' + Location.Code + ' - ' + Location."Name 2" + ' Requested Delivery Date time: <b>' + Format(SalesHeader."Requested Delivery Date") + ' ' + FORMAT(SalesHeader."Requested Delivery Time", 0, '<Hours24,2>:<Minutes,2>') + '</b>' + '</br>' + Format(SalesHeader."Sell-to Customer Name") + '</br></br> Regards, <br>LOGISTICS';// + UserId;

                    // EmailMessage.Create(Location."E-Mail", 'Transfer To ' + "Transfer-to Code" + ' ' + "No.", vBody, true);//before
                    //TAL 1.0.0.95 
                    ToRecipient.Add(Location."Work Order Email");
                    ToRecipient.Add(Location."Work Order Email 2");
                    ToRecipient.Add(Location."Work Order Email 3");

                    CCRecipient.Add(Location."Work Order Email CC");
                    CCRecipient.Add(Location."Work Order Email CC 2");
                    CCRecipient.Add(Location."Work Order Email CC 3");
                    // CCRecipient.Add(LocationTo."Email CC");
                    EmailMessage.Create(ToRecipient, 'Work Order To ' + Location.Code + ' - ' + Location."Name 2" + ' ' + SalesHeader."No." + ' ' + Format(SalesHeader."Sell-to Customer Name"), vBody, true, CCRecipient, BCCRecipient);

                    ReportSelections.RESET;
                    ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Work Order");
                    if ReportSelections.FindSet() then begin
                        //Option with parameters
                        //set the xml parameters
                        ReportParameters := StrSubstNo(Text50000, SalesHeader."No.", SalesLine."Location Code");
                        AttachementTempBlob.CreateOutStream(AttachementOutStream);
                        Report.SaveAs(ReportSelections."Report ID", ReportParameters, REPORTFORMAT::Pdf, AttachementOutStream);


                        //Option with RecRef

                        /*
                        recRef.GetTable(SalesHeader);
                        //recRef.GetTable(SalesLineWorkOrder);
                        //recRef.SetView(SalesHeader.GetView());
                        AttachementTempBlob.CreateOutStream(AttachementOutStream);
                        Report.SaveAs(ReportSelections."Report ID", '', REPORTFORMAT::Pdf, AttachementOutStream, recRef);
                        */

                    END;

                    AttachementTempBlob.CreateInStream(AttachementInstream);
                    EmailMessage.AddAttachment('Work Order' + FORMAT(SalesHeader."No.") + '_' + Location.code + '.pdf', 'PDF', AttachementInstream);

                    Email.OpenInEditor(EmailMessage, "Email Scenario"::"Work Order");


                end;

                oldLocationCode := SalesLine."Location Code";

            until SalesLine.next = 0;
        end;

    end;

    //+1.0.0.48 
    procedure UpdateILE(pItemNo: Code[20]; pLotNo: Code[50]; pGrowerNo: Code[20])
    var
        rL_ILE: Record "Item Ledger Entry";
    begin
        rL_ILE.RESET;
        rL_ILE.SETFILTER("Item No.", pItemNo);
        rL_ILE.SETFILTER("Lot No.", pLotNo);
        IF rL_ILE.FINDSET THEN BEGIN
            REPEAT
                rL_ILE."Lot Grower No." := pGrowerNo;
                rL_ILE.MODIFY;
            UNTIL rL_ILE.NEXT = 0;
        END;
    end;
    //-1.0.0.48 

    procedure ExecutePaybyLink()
    var
        myInt: Integer;

        URL: Text;
        base_url: Text;
        Method: Text;
        TemplateID: Text;
        APPID: Text;
        APIKEY: Text;
        hmacKey: Text;
        BodyRQ: Text;
        RequestHeaders: HttpHeaders;
        vl_tempHeaders: HttpHeaders;
        Content: HttpContent;
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        TokenErr: Label 'Token Service Error: %1', Comment = '%1 = Error';
        GenericErrorTextErr: Label 'A generic error occurred when calling the jcc services';
        Response: Text;
        JsonResponse: JsonObject;
        ErrorToken: JsonToken;

        vL_Number: Text;
        vL_PaymentUrl: Text;
        ErrorCode: Text;
        ErrorDescription: Text;

        OrderBody: JsonObject;
        OrderDetail: JsonObject;
        vL_outputstring: Text;
        vL_HasHeaders: Boolean;

    begin
        base_url := 'https://v5test.jccsmart.com';
        TemplateID := '9624'; //when you sign in read the URL
        //URL := base_url + '/public/api/e-bill/invoices/:invoiceId/preloaded-import';
        URL := base_url + '/public/api/e-bill/invoices/' + TemplateID + '/preloaded-import';
        Method := 'Post';

        APPID := '0cd58b91-590a-4686-8dc1-084e6f3832a7';
        APIKEY := 'N07VrHjF6DtAqCVtMDZIkA1FbCY=';
        hmacKey := '';//'hmacauth 0cd58b91-590a-4686-8dc1-084e6f3832a7:RPeeGzyq0Tad6vpmvHXDvUk+RnrUaUQRBG+8AbhAh6A=:4f8d150d-6715-4290-8894-5722036bbd5b:1652693576000';
        //'hmacauth 0cd58b91-590a-4686-8dc1-084e6f3832a7:7JUHWW7V8bDsNAMOA8yWBg8W09V1Z8YkR94MHV6L3gg=:{89CAAF27-E9D7-454C-A796-7D428A08EF9D}:1652706286'
        // 'hmacauth 0cd58b91-590a-4686-8dc1-084e6f3832a7:pVSXJjXYzY6fGGaYGmqvLzi7hKmx8RCy8j33FtyBeHc=:153B1760-FE8A-4E58-92D6-2CC6B981F322:1652706519'

        BodyRQ := '';

        CLEAR(OrderDetail);
        OrderDetail.Add('number', 'JCCTEST7');
        OrderDetail.Add('amount', 13.00);
        OrderDetail.Add('paymentExpiry', '2023/03/25');
        OrderDetail.Add('penaltyFee', 15.00);
        OrderDetail.Add('penaltyPaymentExpiry', '2023/06/30');
        OrderDetail.Add('customerName', 'Vasilis Charalambous');
        //OrderDetail.Add('customerPhone', '99437128'); //only for cyprus phones
        OrderDetail.Add('preferredCulture', 'en');
        OrderDetail.Add('comments', 'Pay the bill');
        OrderDetail.WriteTo(BodyRQ);

        BodyRQ := '[' + BodyRQ + ']';

        //BodyRQ := '[{"number":"JCCTEST3","amount":13.00,"paymentExpiry":"2022/06/10","penaltyFee":15.00,"penaltyPaymentExpiry":"2022/06/12","customerName":"Vasilis Charalambous","preferredCulture":"en","comments":"Pay the bill"}]';

        hmacKey := GetHMACSignature(BodyRQ, APPID, APIKEY, URL);

        //new
        RequestHeaders.clear();
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.add('Authorization', hmacKey);
        RequestHeaders.add('Accept', '*/*'); //);
        RequestHeaders.add('Accept-Encoding', 'gzip, deflate, br');
        RequestHeaders.add('Connection', 'keep-alive');
        RequestHeaders.add('User-Agent', 'Business Central');
        RequestMessage.SetRequestUri(URL);
        RequestMessage.Content.WriteFrom(BodyRQ); //this makes the Content-Type = text/plain; charset=utf-8

        RequestMessage.Content.GetHeaders(RequestHeaders);
        if RequestHeaders.Contains('Content-Type') then
            RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/json');
        RequestMessage.Method(Method);

        Client.Send(RequestMessage, ResponseMessage);


        if not ResponseMessage.IsSuccessStatusCode() then begin
            if Format(ResponseMessage.Content()) = '' then
                Error(GenericErrorTextErr);

            ResponseMessage.Content().ReadAs(Response);

            Message(Response);
            JsonResponse.ReadFrom(Response);

            if JsonResponse.Get('error', ErrorToken) then
                ErrorToken.WriteTo(ErrorCode);
            if JsonResponse.Get('error_description', ErrorToken) then
                ErrorToken.WriteTo(ErrorDescription);

            if (ErrorCode <> '') or (ErrorDescription <> '') then
                error(TokenErr, ErrorCode + ' - ' + ErrorDescription)
            else
                error(GenericErrorTextErr);
        end;

        ResponseMessage.Content().ReadAs(Response);

        Response := DelChr(Response, '=', '[]');

        JsonResponse.ReadFrom(Response);

        vL_Number := GetTokenAsText(JsonResponse, 'Number', '');
        vL_PaymentUrl := GetTokenAsText(JsonResponse, 'PaymentUrl', '');

        Message('Number: ' + vL_Number + ' PaymentUrl : ' + vL_PaymentUrl);


    end;


    local procedure GetHMACSignature(pBody: Text; pAppId: Text; pAPIKey: Text; pbase_url: Text): Text;
    var
        myInt: Integer;
        requestContentBase64String: Text;
        requestUri: TExt;
        AppId: Text;
        APIKey: Text;
        base_url: Text;
        requestMethod: Text;

        cu_WebRequestHelper: Codeunit "Web Request Helper";
        cu_WebRequest: Codeunit "Http Web Request Mgt.";
        cu_Web: Codeunit "Web Service Management";
        Crypto: Codeunit "Cryptography Management";
        TypeHelper: Codeunit "Type Helper";

        hmacKey: Text;
        requestSignatureBase64String: Text;
        signatureRawData: Text;
        HashAlgo: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512;
        nonce: Text;
        epochStart: DateTime;
        DateTime2: DateTime;
        vl_TimeDuration: Duration; //Duration;
        epochDate: Date;
        epochTime: Date;
        requestTimeStamp: Text;
        vL_seconds: Decimal;
        vL_Minutes: Decimal;
        vL_Hours: Decimal;
        vL_Days: Decimal;
        roundup: Text;
        rounddown: Text;
        vL_TempInt: Integer;


    begin
        AppId := pAppId;

        APIKey := pAPIKey;

        base_url := pbase_url;// 'https://v5test.jccsmart.com';

        requestURI := TypeHelper.UrlEncode(base_url);
        requestMethod := 'POST';
        nonce := CreateGuid();
        nonce := DelChr(nonce, '=', '{}');

        //Crypto.Decrypt();
        //Crypto.DisableEncryption();
        //Crypto.EnableEncryption();
        //Crypto.Encrypt();
        //Crypto.GenerateBase64KeyedHash();
        //Crypto.GenerateBase64KeyedHashAsBase64String();
        //Crypto.GenerateHash()
        //Crypto.GenerateHashAsBase64String()
        //Crypto.GetEncryptionIsNotActivatedQst()

        //Crypto.IsEncryptionEnabled()
        //Crypto.IsEncryptionPossible()
        //Crypto.SignData();
        //Crypto.VerifyData();
        //Crypto.GenerateHash()

        /*
        var uuid = require('uuid');
        var moment = require("moment");

        var AppId = pm.environment.get("APPID");
        var APIKey = pm.environment.get("APIKEY");
        var requestURI = encodeURIComponent(pm.environment.values.substitute(pm.request.url, null, false).toString()).toLowerCase();
        //requestURI = requestURI.replace("https", "http");
        var requestMethod = pm.request.method;
        var requestTimeStamp = moment(new Date().toUTCString()).valueOf();
        var nonce = uuid.v4();
        var requestContentBase64String = "";

        if (pm.request.body != "") {
            var md5 = CryptoJS.MD5(pm.request.body.toString());
            requestContentBase64String = CryptoJS.enc.Base64.stringify(md5);
        }

        var signatureRawData = AppId + requestMethod + requestURI + requestTimeStamp + nonce + requestContentBase64String; //check
        var secretByteArray = CryptoJS.enc.Base64.parse(APIKey);
        var signature = CryptoJS.enc.Utf8.parse(signatureRawData);
        var signatureBytes = CryptoJS.HmacSHA256(signature, secretByteArray);
        var requestSignatureBase64String = CryptoJS.enc.Base64.stringify(signatureBytes);

        var hmacKey = "hmacauth " + AppId + ":" + requestSignatureBase64String + ":" + nonce + ":" + requestTimeStamp;
        pm.environment.set("hmacKey", hmacKey);

        */
        vl_TimeDuration := 0;            // DECIMAL
        vL_Seconds := 0;             // DECIMAL
        vL_Minutes := 0;             // DECIMAL
        vL_Hours := 0;               // DECIMAL
        vL_Days := 0;                // DECIMAL
        roundup := '>';
        rounddown := '<';


        epochStart := System.CreateDateTime(19700101D, 0T);
        DateTime2 := CurrentDateTime;

        vl_TimeDuration := DateTime2 - epochStart;
        vL_seconds := vl_TimeDuration / 1000;
        vL_TempInt := vL_seconds div 1;

        //vl_TimeDuration := vl_TimeDuration / 1000;
        //vL_Days := ROUND((vl_TimeDuration / 86400), 1, rounddown);
        //vL_Hours := ROUND(((vl_TimeDuration - (vL_Days * 86400)) / 3600), 1, rounddown);
        //vL_Minutes := ROUND(((vl_TimeDuration - (vL_Days * 86400) - (vL_Hours * 3600)) / 60), 1, rounddown);
        //vL_Seconds := ROUND(((vl_TimeDuration - (vL_Days * 86400) - (vL_Hours * 3600) - (vL_Minutes * 60))), 1, rounddown);


        // milliseconds = Duration / 1

        //seconds = Duration / 1000

        //minutes = Duration / 60000

        //hours = Duration / 3600000

        //days = Duration / 86400000

        // Set some output in a human-readable format
        //datestr := FORMAT(lvDays) + 'D ';
        //datestr := datestr + FORMAT(lvHours) + 'H ';
        //datestr := datestr + FORMAT(lvMinutes) + 'M ';
        //datestr := datestr + FORMAT(lvSeconds) + 'S';


        // new DateTime(1970, 01, 01, 0, 0, 0, 0, DateTimeKind.Utc);
        // TimeSpan timeSpan = DateTime.UtcNow - epochStart;
        //string requestTimeStamp = Convert.ToUInt64(timeSpan.TotalSeconds).ToString();

        requestTimeStamp := Format(vL_TempInt); //Format(round(vl_TimeDuration / 1000, 0.01, '>')); //FORMAT(vL_Seconds);

        requestContentBase64String := Crypto.GenerateHashAsBase64String(pBody, HashAlgo::HMACMD5);

        signatureRawData := AppId + requestMethod + requestURI + requestTimeStamp + nonce + requestContentBase64String; //check

        requestSignatureBase64String := Crypto.GenerateBase64KeyedHashAsBase64String(signatureRawData, APIKey, HashAlgo::HMACSHA256);



        hmacKey := 'hmacauth ' + AppId + ':' + requestSignatureBase64String + ':' + nonce + ':' + requestTimeStamp;

        exit(hmacKey);

    end;

    procedure GetSignature(Uri: Text; keyName: Text; keyText: Text; ttl: Duration): Text

    var

        Crypto: Codeunit "Cryptography Management";

        TypeHelper: Codeunit "Type Helper";

        expiry: Text;

        stringToSign: Text;

        signature: Text;

        HashAlgo: Option HMACMD5,HMACSHA1,HMACSHA256,HMACSHA384,HMACSHA512;

    begin

        //expiry := GetExpiry(ttl);

        stringToSign := TypeHelper.UrlEncode(Uri) + '\' + 'n' + expiry;

        signature := Crypto.GenerateBase64KeyedHashAsBase64String(stringToSign, keyText, HashAlgo::HMACSHA256);

        exit(signature);

    end;

    procedure GetTokenAsText(JsonObject: JsonObject; TokenKey: Text;
      Error: Text): Text;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit('');
        end;
        exit(JsonToken.AsValue.AsText);

    end;

    procedure GetTokenAsBoolean(JsonObject: JsonObject; TokenKey: Text;
        Error: Text): Boolean;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit(false);
        end;
        exit(JsonToken.AsValue.AsBoolean());

    end;

    procedure GetTokenAsInteger(JsonObject: JsonObject; TokenKey: Text;
   Error: Text): Integer;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit(0);
        end;
        exit(JsonToken.AsValue.AsInteger());

    end;

    procedure GetTokenAsDate(JsonObject: JsonObject; TokenKey: Text;
   Error: Text): Date;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit(0D);
        end;
        exit(JsonToken.AsValue.AsDate());

    end;

    procedure GetTokenAsDateTime(JsonObject: JsonObject; TokenKey: Text;
  Error: Text): DateTime;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit(0DT);
        end;
        exit(JsonToken.AsValue.AsDateTime());

    end;

    procedure GetTokenAsDecimal(JsonObject: JsonObject; TokenKey: Text;
   Error: Text): Decimal;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            exit(0);
        end;
        exit(JsonToken.AsValue.AsDecimal());

    end;


    procedure GetTokenAsArray(JsonObject: JsonObject; TokenKey: Text; Error: Text): JsonArray;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            if Error <> '' then
                Error(Error);
        exit(JsonToken.AsArray());
    end;

    procedure GetArrayElementAsObject(JsonArray: JsonArray; Index: Integer; Error: Text): JsonObject;
    var
        JsonToken: JsonToken;
    begin
        if not JsonArray.Get(Index, JsonToken) then
            if Error <> '' then
                Error(Error);
        exit(JsonToken.AsObject());
    end;

    procedure GetTokenAsObject(JsonObject: JsonObject; TokenKey: Text;
        Error: Text): JsonObject;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            //exit('');
        end;
        exit(JsonToken.AsObject());

    end;

    procedure isTokenAsValue(JsonObject: JsonObject; TokenKey: Text;
       Error: Text): Boolean;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then begin
            if Error <> '' then
                Error(Error);
            //exit('');
        end;
        exit(JsonToken.IsValue());

    end;

    procedure ImportFoodyHeader(var SalesHeader: Record "Sales Header")
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;

        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";
        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        SalesLine: Record "Sales Line";
        ItemReference: Record "Item Reference";
        SKU: Record "Stockkeeping Unit";
        tempDec: Decimal;

    begin
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 6; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;
        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));


            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';


            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                    END; //end case

                END;//end if
            END; //end for 2


            //1 po_number	
            //2 sku_id
            //3 supplier_sku
            //4 product_name
            //5 barcode_array
            //6 ordered_qty

            if Colmn1_Valid <> '' then begin
                ItemReference.RESET;
                ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                ItemReference.SetFilter("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetFilter("Reference No.", Colmn2_Valid);
                if ItemReference.FindSet() then begin


                    SalesHeader."External Document No." := Colmn1_Valid;
                    SalesHeader.Modify();


                    //find the last line No.
                    vL_LineNo := 0;
                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetFilter("Document No.", SalesHeader."No.");
                    if SalesLine.FindLast() then begin
                        vL_LineNo := SalesLine."Line No.";
                    end;

                    vL_LineNo += 10000;

                    //create the line
                    Clear(SalesLine);
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", vL_LineNo);
                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Insert(true);

                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", ItemReference."Item No.");
                    SalesLine.Description := copystr(Colmn4_Valid, 1, 100);

                    SKU.REset;
                    SKU.SetFilter("Item No.", SalesLine."No.");
                    SKU.SetFilter("Location Code", '<>%1', '');
                    if SKU.FindSet() then begin
                        SalesLine.Validate("Location Code", SKU."Location Code");
                    end;

                    Evaluate(tempDec, Colmn6_Valid);
                    SalesLine.Validate(Quantity, tempDec);
                    SalesLine.Validate("Qty. Requested", tempDec);
                    SalesLine.Modify(true);






                end else begin

                    Message('SKU not found: ' + Colmn2_Valid);
                end;





            END; //end for 1
                 //Window.CLOSE();

        end;


    end;

    procedure ImportFoodyLines(var SalesHeader: Record "Sales Header")
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;


        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";
        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        SalesLine: Record "Sales Line";
        ItemReference: Record "Item Reference";
        SKU: Record "Stockkeeping Unit";
        tempDec: Decimal;

    begin
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 3; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;
        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));


            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';



            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                    END; //end case

                END;//end if
            END; //end for 2


            //1 po_number	
            //2 sku_id
            //3 supplier_sku
            //4 product_name
            //5 barcode_array
            //6 ordered_qty

            if Colmn1_Valid <> '' then begin
                ItemReference.RESET;
                ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::Customer);
                ItemReference.SetFilter("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetFilter("Reference No.", Colmn1_Valid);
                if ItemReference.FindSet() then begin


                    // SalesHeader."External Document No." := Colmn1_Valid;
                    // SalesHeader.Modify();


                    //find the last line No.
                    vL_LineNo := 0;
                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetFilter("Document No.", SalesHeader."No.");
                    if SalesLine.FindLast() then begin
                        vL_LineNo := SalesLine."Line No.";
                    end;

                    vL_LineNo += 10000;

                    //create the line
                    Clear(SalesLine);
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", vL_LineNo);
                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Insert(true);

                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", ItemReference."Item No.");
                    //SalesLine.Description := copystr(Colmn4_Valid, 1, 100);

                    SKU.REset;
                    SKU.SetFilter("Item No.", SalesLine."No.");
                    SKU.SetFilter("Location Code", '<>%1', '');
                    if SKU.FindSet() then begin
                        SalesLine.Validate("Location Code", SKU."Location Code");
                    end;

                    Evaluate(tempDec, Colmn3_Valid);
                    SalesLine.Validate(Quantity, tempDec);
                    SalesLine.Validate("Qty. Requested", tempDec);
                    SalesLine.Modify(true);






                end else begin

                    Message('SKU not found: ' + Colmn2_Valid);
                end;





            END; //end for 1
                 //Window.CLOSE();

        end;


    end;


    procedure ImportWolt(var SalesHeader: Record "Sales Header")
    var
        vL_FileName: Text[250];
        vL_FileNameParse: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;


        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";
        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        SalesLine: Record "Sales Line";
        ItemReference: Record "Item Reference";
        SKU: Record "Stockkeeping Unit";
        tempDec: Decimal;
        tempDate: Date;
        vL_FileNameParseResult: List of [Text];
        vL_FileNameMapCode: Text;
        CustShipAddress: Record "Ship-to Address";
        vL_HeaderCount: Integer;

    begin
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        vL_FileNameParse := cu_FileMgt.GetFileName(vL_FileName);
        vL_FileNameParseResult := vL_FileNameParse.Split('_');
        vL_FileNameMapCode := vL_FileNameParseResult.Get(1) + '_' + vL_FileNameParseResult.Get(2);

        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 5; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;
        vL_HeaderCount := 0;

        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));


            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';



            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;



                    END; //end case

                END;//end if
            END; //end for 2


            //1 Vendor SKU	
            //2 GTIN
            //3 Item name
            //4 Ordered Units
            //5 Delivery Date


            if Colmn1_Valid <> '' then begin
                ItemReference.RESET;
                ItemReference.SetRange("Reference Type", ItemReference."Reference Type"::"Bar Code");
                //ItemReference.SetFilter("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetFilter("Reference No.", Colmn2_Valid);
                ItemReference.SetFilter("Item No.", Colmn1_Valid);
                if ItemReference.FindSet() then begin

                    vL_HeaderCount += 1;
                    if vL_HeaderCount = 1 then begin
                        Evaluate(tempDate, Colmn5_Valid);

                        SalesHeader.validate("Document Date", tempDate);
                        SalesHeader.validate("Posting Date", tempDate);
                        SalesHeader.validate("Order Date", tempDate);
                        SalesHeader.validate("Requested Delivery Date", tempDate);
                        SalesHeader.validate("Shipment Date", tempDate);

                        //if SalesHeader."Ship-to Code" = '' then begin
                        CustShipAddress.RESET;
                        CustShipAddress.SetFilter("Customer No.", SalesHeader."Sell-to Customer No.");
                        CustShipAddress.SetFilter("Interface Code", vL_FileNameMapCode);
                        if CustShipAddress.FindSet() then begin
                            SalesHeader.validate("Ship-to Code", CustShipAddress.Code);
                        end;
                        //end;
                        SalesHeader.Modify();
                    end;



                    //find the last line No.
                    vL_LineNo := 0;
                    SalesLine.RESET;
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetFilter("Document No.", SalesHeader."No.");
                    if SalesLine.FindLast() then begin
                        vL_LineNo := SalesLine."Line No.";
                    end;

                    vL_LineNo += 10000;

                    //create the line
                    Clear(SalesLine);
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", vL_LineNo);
                    SalesLine.SetHideValidationDialog(true);
                    SalesLine.Insert(true);

                    SalesLine.Validate(Type, SalesLine.Type::Item);
                    SalesLine.Validate("No.", ItemReference."Item No.");
                    SalesLine.Description := copystr(Colmn3_Valid, 1, 100);

                    SKU.REset;
                    SKU.SetFilter("Item No.", SalesLine."No.");
                    SKU.SetFilter("Location Code", '<>%1', '');
                    if SKU.FindSet() then begin
                        SalesLine.Validate("Location Code", SKU."Location Code");
                    end;

                    Evaluate(tempDec, Colmn4_Valid);
                    SalesLine.Validate(Quantity, tempDec);
                    SalesLine.Validate("Qty. Requested", tempDec);
                    SalesLine.Modify(true);






                end else begin

                    Message('SKU not found: ' + Colmn2_Valid);
                end;





            END; //end for 1
                 //Window.CLOSE();

        end;


    end;


    procedure ImportLidlHistory(var SalesHeader: Record "Sales Header")
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;

        Colmn13_Valid: Text;
        Colmn14_Valid: Text;
        Colmn15_Valid: Text;
        Colmn16_Valid: Text;
        Colmn17_Valid: Text;
        Colmn18_Valid: Text;
        Colmn19_Valid: Text;
        Colmn20_Valid: Text;
        Colmn21_Valid: Text;
        Colmn22_Valid: Text;
        Colmn23_Valid: Text;
        Colmn24_Valid: Text;
        Colmn25_Valid: Text;
        Colmn26_Valid: Text;
        Colmn27_Valid: Text;
        Colmn28_Valid: Text;
        Colmn29_Valid: Text;

        Colmn32_Valid: Text;
        Colmn33_Valid: Text;
        Colmn34_Valid: Text;
        Colmn35_Valid: Text;
        Colmn36_Valid: Text;
        Colmn37_Valid: Text;
        Colmn38_Valid: Text;
        Colmn39_Valid: Text;
        Colmn40_Valid: Text;
        Colmn41_Valid: Text;
        Colmn42_Valid: Text;

        Colmn49_Valid: Text;
        Colmn50_Valid: Text;

        Colmn51_Valid: Text;
        Colmn52_Valid: Text;

        Colmn53_Valid: Text;
        Colmn55_Valid: Text;


        Colmn155_Valid: Text;
        Colmn156_Valid: Text;
        Colmn157_Valid: Text;
        Colmn158_Valid: Text;
        Colmn163_Valid: Text;
        Colmn164_Valid: Text;

        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";
        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        SalesLine: Record "Sales Line";
        tempDec: Decimal;
        tempInt: Integer;
        tempDate: Date;
        enumCalibrationUOM: Enum "Calibration UOM";
    begin
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 164; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        Window.OPEN('Record Processing #1###############');
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;
        FOR RowNo := 8 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));


            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';

            Colmn13_Valid := '';
            Colmn14_Valid := '';
            Colmn15_Valid := '';
            Colmn16_Valid := '';
            Colmn17_Valid := '';
            Colmn18_Valid := '';
            Colmn19_Valid := '';
            Colmn20_Valid := '';
            Colmn21_Valid := '';
            Colmn22_Valid := '';
            Colmn23_Valid := '';
            Colmn24_Valid := '';
            Colmn25_Valid := '';
            Colmn26_Valid := '';
            Colmn27_Valid := '';
            Colmn28_Valid := '';
            Colmn29_Valid := '';

            Colmn32_Valid := '';
            Colmn33_Valid := '';
            Colmn34_Valid := '';
            Colmn35_Valid := '';
            Colmn36_Valid := '';
            Colmn37_Valid := '';
            Colmn38_Valid := '';
            Colmn39_Valid := '';
            Colmn40_Valid := '';
            Colmn41_Valid := '';
            Colmn42_Valid := '';

            Colmn49_Valid := '';
            Colmn50_Valid := '';
            Colmn51_Valid := '';
            Colmn52_Valid := '';
            Colmn53_Valid := '';

            Colmn155_Valid := '';
            Colmn156_Valid := '';
            Colmn157_Valid := '';
            Colmn158_Valid := '';
            Colmn163_Valid := '';
            Colmn164_Valid := '';


            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        7:
                            BEGIN
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        8:
                            BEGIN
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        9:
                            BEGIN
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        10:
                            BEGIN
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        //10
                        11:
                            BEGIN
                                //EVALUATE(Colmn11_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        12:
                            BEGIN
                                //EVALUATE(Colmn12_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        13:
                            BEGIN
                                EVALUATE(Colmn13_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        14:
                            BEGIN
                                EVALUATE(Colmn14_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        15:
                            BEGIN
                                EVALUATE(Colmn15_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        16:
                            BEGIN
                                EVALUATE(Colmn16_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        17:
                            BEGIN
                                EVALUATE(Colmn17_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        18:
                            BEGIN
                                EVALUATE(Colmn18_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        19:
                            BEGIN
                                EVALUATE(Colmn19_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        20:
                            BEGIN
                                EVALUATE(Colmn20_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                        //20
                        21:
                            BEGIN
                                EVALUATE(Colmn21_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        22:
                            BEGIN
                                EVALUATE(Colmn22_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        23:
                            BEGIN
                                EVALUATE(Colmn23_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        24:
                            BEGIN
                                EVALUATE(Colmn24_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        25:
                            BEGIN
                                EVALUATE(Colmn25_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        26:
                            BEGIN
                                EVALUATE(Colmn26_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        27:
                            BEGIN
                                EVALUATE(Colmn27_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        28:
                            BEGIN
                                EVALUATE(Colmn28_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        29:
                            BEGIN
                                EVALUATE(Colmn29_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        30:
                            BEGIN
                                //EVALUATE(Colmn30_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                        //30
                        31:
                            BEGIN
                                //EVALUATE(Colmn31_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        32:
                            BEGIN
                                EVALUATE(Colmn32_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        33:
                            BEGIN
                                EVALUATE(Colmn33_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        34:
                            BEGIN
                                EVALUATE(Colmn34_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        35:
                            BEGIN
                                EVALUATE(Colmn35_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        36:
                            BEGIN
                                EVALUATE(Colmn36_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        37:
                            BEGIN
                                EVALUATE(Colmn37_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        38:
                            BEGIN
                                EVALUATE(Colmn38_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        39:
                            BEGIN
                                EVALUATE(Colmn39_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        40:
                            BEGIN
                                EVALUATE(Colmn40_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                        //40
                        41:
                            BEGIN
                                EVALUATE(Colmn41_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        42:
                            BEGIN
                                EVALUATE(Colmn42_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        43:
                            BEGIN
                                //EVALUATE(Colmn43_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        44:
                            BEGIN
                                //EVALUATE(Colmn44_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        45:
                            BEGIN
                                //EVALUATE(Colmn45_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        46:
                            BEGIN
                                // EVALUATE(Colmn46_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        47:
                            BEGIN
                                // EVALUATE(Colmn47_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        48:
                            BEGIN
                                //EVALUATE(Colmn48_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        49:
                            BEGIN
                                EVALUATE(Colmn49_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        50:
                            BEGIN
                                EVALUATE(Colmn50_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                        //50
                        51:
                            BEGIN
                                EVALUATE(Colmn51_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        52:
                            BEGIN
                                EVALUATE(Colmn52_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        53:
                            BEGIN
                                EVALUATE(Colmn53_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        55:
                            BEGIN
                                EVALUATE(Colmn55_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        //155
                        155:
                            BEGIN
                                EVALUATE(Colmn155_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        156:
                            BEGIN
                                EVALUATE(Colmn156_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        157:
                            BEGIN
                                EVALUATE(Colmn157_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;
                        158:
                            BEGIN
                                EVALUATE(Colmn158_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        163:
                            BEGIN
                                EVALUATE(Colmn163_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        164:
                            BEGIN
                                EVALUATE(Colmn164_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;


                    END; //end case

                END;//end if
            END; //end for 2


            //1 IAN	 
            //2 Περιγραφή προϊόντος
            //3 Περιεχ.Παλ.
            //4 Προέλευση
            //5 Κατηγορία
            //6 Κιβώτιο -  Περιεχόμενο
            //7 Καλιμπράζ Ελαχ.
            //8 Καλιμπράζ Μεγ.
            //9 Καλιμπράζ 47
            //10 Ποικιλία
            //13 Νόμισμα
            //14 Τιμές προηγούμενης Εβδομάδας ανά  Κιβ.
            //15 Τιμές προηγούμενης Εβδομάδας ανά τεμ/συσκ
            //16 Τιμές προηγούμενης Εβδομάδας  ανά kg
            //17 Τιμές ανά Κιβ.
            //18 Τιμές ανά τεμ/συσκ
            //19 Τιμές ανά kg
            //20 Ποσότητα ανά σειρά
            //21 Date 1 Ποσότητα σε κιβώτια
            //22 Date 2 Ποσότητα σε κιβώτια
            //23 Date 3 Ποσότητα σε κιβώτια
            //24 Date 4 Ποσότητα σε κιβώτια
            //25 Date 5 Ποσότητα σε κιβώτια
            //26 Date 6 Ποσότητα σε κιβώτια
            //27 Date 7 Ποσότητα σε κιβώτια
            //28 Date 8 Ποσότητα σε κιβώτια
            //29 Συνολική ποσότητα σε κιβώτια
            //32 Πρόσθετες πληροφορίες
            //33 Πίεση kg/cm² Ελαχ. 
            //34 Πίεση kg/cm² Μεγ.
            //35 Brix σε ° Ελαχ.
            //36 Επωνυμία
            //37 Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ.
            //38 Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ.
            //39 Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον.
            //40 Πρόσθετα Ποιοτικά Χαρακτηριστικά Ελαχ.
            //41 Πρόσθετα Ποιοτικά Χαρακτηριστικά Μεγ.
            //42 Πρόσθετα Ποιοτικά Χαρακτηριστικά Μον.

            //49 Κιβώτιο / Στάντζα Πλάτος σε cm
            //50 Κιβώτιο / Στάντζα X
            //51 Κιβώτιο / Στάντζα Μήκος σε cm
            //52 Κιβώτιο / Στάντζα X
            //53 Κιβώτιο / Στάντζα Ύψος σε cm

            //55 Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου

            //155 Θερμοκρασία συγκομιδής σε Cº Από
            //156 Θερμοκρασία συγκομιδής σε Cº Έως
            //157 Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº Από
            //158 Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε CºΈως
            //163 Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Από
            //164 Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº Έως


            if Colmn1_Valid <> '' then begin

                //find the last line No.
                vL_LineNo := 0;
                SalesLine.RESET;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetFilter("Document No.", SalesHeader."No.");
                if SalesLine.FindLast() then begin
                    vL_LineNo := SalesLine."Line No.";
                end;

                vL_LineNo += 10000;

                //create the line
                Clear(SalesLine);
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", vL_LineNo);
                SalesLine.SetHideValidationDialog(true);
                SalesLine.Insert(true);

                SalesLine.Validate(Type, SalesLine.Type::Item);
                SalesLine."Shelf No." := Colmn1_Valid;
                ConvertStringtoDesc(tempDec, Colmn6_Valid);
                SalesLine.validate("Package Qty", tempDec);
                SalesLine.GetItemFromShelfNo();

                SalesLine.Description := colmn2_Valid;
                SalesLine.Modify(true);



                ConvertStringtoDesc(tempDec, Colmn3_Valid);
                SalesLine.validate("Pallet Qty", tempDec);


                SalesLine."Country/Region of Origin Code" := Colmn4_Valid;


                SalesLine.validate("Product Class", Colmn5_Valid);


                ConvertStringtoDesc(tempDec, Colmn6_Valid);
                SalesLine.validate("Package Qty", tempDec);


                ConvertStringtoDesc(tempDec, Colmn7_Valid);
                SalesLine.validate("Calibration Min.", tempDec);


                ConvertStringtoDesc(tempDec, Colmn8_Valid);
                SalesLine.validate("Calibration Max.", tempDec);


                CASE Colmn9_Valid OF


                    ' ':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::" ";
                        END;
                    '-':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::"-";
                        END;

                    'cm':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::cm;
                        END;

                    'mm':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::mm;
                        END;

                    'kg':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::kg;
                        END;

                    'g':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::g;
                        END;
                    'Stk.':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::"Stk.";
                        END;
                    'PK':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::PK;
                        END;
                    'Topf':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::Topf;
                        END;
                    'l':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::l;
                        END;
                    'Netz':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::Netz;
                        END;
                    'BTL':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::BTL;
                        END;
                    'BE':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::BE;
                        END;
                    'Stiele':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::Stiele;
                        END;
                    'Bund':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::Bund;
                        END;
                    'KRT':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::KRT;
                        END;
                    'FS':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::FS;
                        END;
                    'STRS':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::STRS;
                        END;
                    'SC':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::SC;
                        END;
                    'EIM':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::EIM;
                        END;
                    'DS':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::DS;
                        END;
                    'ATM-PK':
                        BEGIN
                            enumCalibrationUOM := enumCalibrationUOM::"ATM-PK";
                        END;
                    else
                        Error(Colmn9_Valid + ' Καλιμπράζ Μον. not found. RowNo: ' + FORMAT(RowNo));
                END;

                SalesLine.validate("Calibration UOM", enumCalibrationUOM);


                SalesLine.validate("Variety", Colmn10_Valid);


                if Colmn13_Valid = 'EUR' then begin
                    Colmn13_Valid := '';
                end;

                SalesLine.validate("Currency Code", Colmn13_Valid);




                ConvertStringtoDesc(tempDec, Colmn14_Valid);
                SalesLine.validate("Price Previous Week Box", tempDec);



                ConvertStringtoDesc(tempDec, Colmn15_Valid);
                SalesLine.validate("Price Previous Week PCS", tempDec);



                ConvertStringtoDesc(tempDec, Colmn16_Valid);
                SalesLine.validate("Price Previous Week KG", tempDec);



                ConvertStringtoDesc(tempDec, Colmn17_Valid);
                SalesLine.validate("Price Box", tempDec);


                ConvertStringtoDesc(tempDec, Colmn18_Valid);
                SalesLine.validate("Price PCS", tempDec);


                ConvertStringtoDesc(tempDec, Colmn19_Valid);
                SalesLine.validate("Price KG", tempDec);


                ConvertStringtoInt(tempInt, Colmn20_Valid);
                SalesLine.validate("Row Index", tempInt);


                ConvertStringtoDesc(tempDec, Colmn21_Valid);
                SalesLine.validate("Qty Box Date 1", tempDec);


                ConvertStringtoDesc(tempDec, Colmn22_Valid);
                SalesLine.validate("Qty Box Date 2", tempDec);


                ConvertStringtoDesc(tempDec, Colmn23_Valid);
                SalesLine.validate("Qty Box Date 3", tempDec);


                ConvertStringtoDesc(tempDec, Colmn24_Valid);
                SalesLine.validate("Qty Box Date 4", tempDec);


                ConvertStringtoDesc(tempDec, Colmn25_Valid);
                SalesLine.validate("Qty Box Date 5", tempDec);


                ConvertStringtoDesc(tempDec, Colmn26_Valid);
                SalesLine.validate("Qty Box Date 6", tempDec);


                ConvertStringtoDesc(tempDec, Colmn27_Valid);
                SalesLine.validate("Qty Box Date 7", tempDec);


                ConvertStringtoDesc(tempDec, Colmn28_Valid);
                SalesLine.validate("Qty Box Date 8", tempDec);


                ConvertStringtoDesc(tempDec, Colmn29_Valid);
                SalesLine.validate("Total Qty on Boxes", tempDec);


                SalesLine.validate("Additional Information", Colmn32_Valid);


                ConvertStringtoDesc(tempDec, Colmn33_Valid);
                SalesLine.validate("Pressure Min.", tempDec);


                ConvertStringtoDesc(tempDec, Colmn34_Valid);
                SalesLine.validate("Pressure Max.", tempDec);


                ConvertStringtoDesc(tempDec, Colmn35_Valid);
                SalesLine.validate("Brix Min", tempDec);


                SalesLine.validate("Vendor Name", Colmn36_Valid);


                ConvertStringtoDesc(tempDec, Colmn37_Valid);
                SalesLine.validate("QC 1 Min", tempDec);


                ConvertStringtoDesc(tempDec, Colmn38_Valid);
                SalesLine.validate("QC 1 Max", tempDec);


                SalesLine.validate("QC 1 Text", Colmn39_Valid);


                ConvertStringtoDesc(tempDec, Colmn40_Valid);
                SalesLine.validate("QC 2 Min", tempDec);


                ConvertStringtoDesc(tempDec, Colmn41_Valid);
                SalesLine.validate("QC 2 Max", tempDec);


                SalesLine.validate("QC 2 Text", Colmn42_Valid);


                ConvertStringtoDesc(tempDec, Colmn49_Valid);
                SalesLine.validate("Box Width", tempDec);


                SalesLine.validate("Box Char 1", Colmn50_Valid);


                ConvertStringtoDesc(tempDec, Colmn51_Valid);
                SalesLine.validate("Box Length", tempDec);


                SalesLine.validate("Box Char 2", Colmn52_Valid);



                ConvertStringtoDesc(tempDec, Colmn53_Valid);
                SalesLine.validate("Box Height", tempDec);


                //ConvertStringtoDate(tempDate, );
                SalesLine.validate("Box Changed Date", Colmn55_Valid);


                ConvertStringtoDesc(tempDec, Colmn155_Valid);
                SalesLine.validate("Harvest Temp. From", tempDec);


                ConvertStringtoDesc(tempDec, Colmn156_Valid);
                SalesLine.validate("Harvest Temp. To", tempDec);


                ConvertStringtoDesc(tempDec, Colmn157_Valid);
                SalesLine.validate("Freezer Harvest Temp. From", tempDec);


                ConvertStringtoDesc(tempDec, Colmn158_Valid);
                SalesLine.validate("Freezer Harvest Temp. To", tempDec);


                ConvertStringtoDesc(tempDec, Colmn163_Valid);
                SalesLine.validate("Transfer Temp. From", tempDec);


                ConvertStringtoDesc(tempDec, Colmn164_Valid);
                SalesLine.validate("Transfer Temp. To", tempDec);

                SalesLine.Modify();


            END; //end for 1
                 //Window.CLOSE();

        end;
    end;

    local procedure ConvertStringtoDesc(var tempDec: Decimal; pStr: Text)
    var
    begin
        tempDec := 0;
        if pStr = '' then begin
            tempDec := 0;
        end else begin
            Evaluate(tempDec, pStr);
        end;
    end;

    local procedure ConvertStringtoInt(var tempInt: Integer; pStr: Text)
    var
    begin
        tempInt := 0;
        if pStr = '' then begin
            tempInt := 0;
        end else begin
            Evaluate(tempInt, pStr);
        end;
    end;

    local procedure ConvertStringtoDate(var tempDate: Date; pStr: Text)
    var
    begin
        tempDate := 0D;
        if pStr = '' then begin
            tempDate := 0D;
        end else begin
            Evaluate(tempDate, pStr);
        end;
    end;


    procedure LocationAddress(var AddrArray: array[8] of Text[100]; var Location: Record "Location")
    var
        FormatAddr: Codeunit "Format Address";
    begin


        with Location do
            FormatAddr.FormatAddr(
              AddrArray, Code, Name, "Name 2", Address, "Address 2",
              City, "Post Code", County, '');
    end;


    procedure ImportLidlBudget(pItemBudgetName: Record "Item Budget Name")
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;
        Colmn11_Valid: Text;
        Colmn12_Valid: Text;
        Colmn13_Valid: Text;
        Colmn14_Valid: Text;
        Colmn15_Valid: Text;

        Date1_Valid: Date;
        Date2_Valid: Date;
        Date3_Valid: Date;
        Date4_Valid: Date;
        Date5_Valid: Date;
        Date6_Valid: Date;
        Date7_Valid: Date;
        Date8_Valid: Date;
        Date9_Valid: Date;
        Date10_Valid: Date;
        Date11_Valid: Date;
        Date12_Valid: Date;
        Date13_Valid: Date;


        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";

        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        rL_Item: Record Item;
        TmpDecimal: Decimal;

    begin
        //open excel file and process 17 rows
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 15; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        //Window.OPEN('Record Processing #1###############', MyNext);
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;


        FOR RowNo := 1 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            //Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
            //MyNext := FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount);
            //Window.UPDATE();//1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';
            Colmn11_Valid := '';
            Colmn12_Valid := '';
            Colmn13_Valid := '';
            Colmn14_Valid := '';
            Colmn15_Valid := '';



            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn1_Valid := RemoveDash(Colmn1_Valid);
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn2_Valid := RemoveDash(Colmn2_Valid);
                            END;

                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn3_Valid := RemoveDash(Colmn3_Valid);
                            END;

                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn4_Valid := RemoveDash(Colmn4_Valid);
                            END;

                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn5_Valid := RemoveDash(Colmn5_Valid);
                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn6_Valid := RemoveDash(Colmn6_Valid);
                            END;
                        7:
                            BEGIN
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn7_Valid := RemoveDash(Colmn7_Valid);
                            END;
                        8:
                            BEGIN
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn8_Valid := RemoveDash(Colmn8_Valid);
                            END;
                        9:
                            BEGIN
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn9_Valid := RemoveDash(Colmn9_Valid);
                            END;
                        10:
                            BEGIN
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn10_Valid := RemoveDash(Colmn10_Valid);
                            END;

                        11:
                            BEGIN
                                EVALUATE(Colmn11_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn11_Valid := RemoveDash(Colmn11_Valid);
                            END;

                        12:
                            BEGIN
                                EVALUATE(Colmn12_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn12_Valid := RemoveDash(Colmn12_Valid);
                            END;

                        13:
                            BEGIN
                                EVALUATE(Colmn13_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn13_Valid := RemoveDash(Colmn13_Valid);
                            END;

                        14:
                            BEGIN
                                EVALUATE(Colmn14_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn14_Valid := RemoveDash(Colmn14_Valid);
                            END;

                        15:
                            BEGIN
                                EVALUATE(Colmn15_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                                Colmn15_Valid := RemoveDash(Colmn15_Valid);
                            END;
                    END; //end case

                END;//end if
            END; //end for 2


            //1 Cross Reference	
            //2 Package Qty
            //3 Date 1
            //4 Date 2
            //5 Date 3
            //6 Date 4
            //7 Date 5
            //8 Date 6
            //9 Date 7
            //10 Date 8
            //11 Date 9
            //12 Date 10
            //13 Date 11
            //14 Date 12
            //15 Date 13	

            if RowNo = 1 then begin
                //if Colmn1_Valid <> '' then begin
                //    Evaluate(Date1_Valid, Colmn1_Valid);
                //end;

                //if Colmn2_Valid <> '' then begin
                //    Evaluate(Date2_Valid, Colmn2_Valid);
                //end;

                if Colmn3_Valid <> '' then begin
                    Evaluate(Date1_Valid, Colmn3_Valid);
                end;

                if Colmn4_Valid <> '' then begin
                    Evaluate(Date2_Valid, Colmn4_Valid);
                end;

                if Colmn5_Valid <> '' then begin
                    Evaluate(Date3_Valid, Colmn5_Valid);
                end;

                if Colmn6_Valid <> '' then begin
                    Evaluate(Date4_Valid, Colmn6_Valid);
                end;

                if Colmn7_Valid <> '' then begin
                    Evaluate(Date5_Valid, Colmn7_Valid);
                end;

                if Colmn8_Valid <> '' then begin
                    Evaluate(Date6_Valid, Colmn8_Valid);
                end;
                if Colmn9_Valid <> '' then begin
                    Evaluate(Date7_Valid, Colmn9_Valid);
                end;

                if Colmn10_Valid <> '' then begin
                    Evaluate(Date8_Valid, Colmn10_Valid);
                end;

                if Colmn11_Valid <> '' then begin
                    Evaluate(Date9_Valid, Colmn11_Valid);
                end;

                if Colmn12_Valid <> '' then begin
                    Evaluate(Date10_Valid, Colmn12_Valid);
                end;

                if Colmn13_Valid <> '' then begin
                    Evaluate(Date11_Valid, Colmn13_Valid);
                end;

                if Colmn14_Valid <> '' then begin
                    Evaluate(Date12_Valid, Colmn14_Valid);
                end;

                if Colmn15_Valid <> '' then begin
                    Evaluate(Date13_Valid, Colmn15_Valid);
                end;


            end;


            if (Colmn1_Valid <> '') and (RowNo > 1) then begin
                if (Colmn3_Valid <> '') and (Date1_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn3_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date1_Valid, TmpDecimal);
                end;

                if (Colmn4_Valid <> '') and (Date2_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn4_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date2_Valid, TmpDecimal);
                end;

                if (Colmn5_Valid <> '') and (Date3_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn5_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date3_Valid, TmpDecimal);
                end;

                if (Colmn6_Valid <> '') and (Date4_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn6_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date4_Valid, TmpDecimal);
                end;

                if (Colmn7_Valid <> '') and (Date5_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn7_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date5_Valid, TmpDecimal);
                end;

                if (Colmn8_Valid <> '') and (Date6_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn8_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date6_Valid, TmpDecimal);
                end;

                if (Colmn9_Valid <> '') and (Date7_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn9_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date7_Valid, TmpDecimal);
                end;

                if (Colmn10_Valid <> '') and (Date8_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn10_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date8_Valid, TmpDecimal);
                end;

                if (Colmn11_Valid <> '') and (Date9_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn11_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date9_Valid, TmpDecimal);
                end;
                if (Colmn12_Valid <> '') and (Date10_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn12_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date10_Valid, TmpDecimal);
                end;

                if (Colmn13_Valid <> '') and (Date11_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn13_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date11_Valid, TmpDecimal);
                end;

                if (Colmn14_Valid <> '') and (Date12_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn14_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date12_Valid, TmpDecimal);
                end;

                if (Colmn15_Valid <> '') and (Date13_Valid <> 0D) then begin
                    Evaluate(TmpDecimal, Colmn15_Valid);
                    InsertItemSalesBudget(pItemBudgetName.Name, Colmn1_Valid, Colmn2_Valid, Date13_Valid, TmpDecimal);
                end;


            END; //end for 1
            //Window.CLOSE();

        end;
    end;


    local procedure InsertItemSalesBudget(pBudgetName: code[20]; pColmn1_Valid: Text; pColmn2_Valid: Text; pDate: Date; pQty: Decimal)
    var
        ItemBudgetEntry: Record "Item Budget Entry";
        Item: Record Item;
        PackageQty: Decimal;
        Txt50000: Label 'Item Budget Entry exists %1,%2,%3  IAN: %4 Package Qty: %5';
        vL_ItemNo: Code[20];
    begin
        Evaluate(PackageQty, pColmn2_Valid);
        vL_ItemNo := '';

        Item.RESET;
        Item.SETFILTER("Shelf No.", pColmn1_Valid);
        Item.SETRANGE("Package Qty", PackageQty);
        if Item.FINDSET then begin
            vL_ItemNo := Item."No.";
        end else begin
            Item.RESET;
            Item.SETFILTER("Shelf No.", pColmn1_Valid);
            if Item.FINDSET then begin
                vL_ItemNo := Item."No.";
            end;
        end;

        if vL_ItemNo <> '' then begin
            //IF ENTRY EXISTS SHOW ERROR
            ItemBudgetEntry.Reset;
            ItemBudgetEntry.SetRange("Analysis Area", ItemBudgetEntry."Analysis Area"::Sales);
            ItemBudgetEntry.SetRange("Budget Name", pBudgetName);
            ItemBudgetEntry.SetRange(Date, pDate);
            ItemBudgetEntry.SetRange("Item No.", Item."No.");
            ItemBudgetEntry.SetRange("Source Type", ItemBudgetEntry."Source Type"::Customer);
            ItemBudgetEntry.SetFilter("Source No.", 'CUST00032');
            IF ItemBudgetEntry.FindSet() THEN BEGIN
                Error(Txt50000, pBudgetName, pDate, Item."No.", pColmn1_Valid, PackageQty);
            END;

            clear(ItemBudgetEntry);
            ItemBudgetEntry.Validate("Analysis Area", ItemBudgetEntry."Analysis Area"::Sales);
            ItemBudgetEntry.Validate("Budget Name", pBudgetName);
            ItemBudgetEntry.Validate(Date, pDate);
            ItemBudgetEntry.Validate("Item No.", Item."No.");
            ItemBudgetEntry.Validate("Source Type", ItemBudgetEntry."Source Type"::Customer);
            ItemBudgetEntry.Validate("Source No.", 'CUST00032');
            ItemBudgetEntry.Validate(Quantity, pQty); // ROUND(pQty, 1)
            ItemBudgetEntry.Insert(true);
        end;


    end;


    procedure PopulateLidlItemReference()
    var
        myInt: Integer;
        rL_Item: Record Item;
        rL_ItemCrossReference: Record "Item Reference";
    begin
        rL_Item.RESET;
        rL_Item.SETFILTER("Shelf No.", '<>%1', '');
        rL_Item.SetFilter("No.", 'PFV*');

        if rL_Item.FINDSET then begin
            repeat
                CLEAR(rL_ItemCrossReference);
                rL_ItemCrossReference.SETFILTER("Item No.", rL_Item."No.");
                rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                rL_ItemCrossReference.SETFILTER("Reference Type No.", 'CUST00032');
                rL_ItemCrossReference.SETFILTER("Reference No.", rL_Item."Shelf No.");
                rL_ItemCrossReference.SETFILTER("Unit of Measure", rL_Item."Sales Unit of Measure");
                if not rL_ItemCrossReference.FINDSET then begin
                    CLEAR(rL_ItemCrossReference);
                    rL_ItemCrossReference.VALIDATE("Item No.", rL_Item."No.");
                    rL_ItemCrossReference.VALIDATE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                    rL_ItemCrossReference.VALIDATE("Reference Type No.", 'CUST00032');
                    rL_ItemCrossReference.VALIDATE("Reference No.", rL_Item."Shelf No.");
                    rL_ItemCrossReference.VALIDATE(Description, rL_Item.Description);
                    rL_ItemCrossReference.VALIDATE("Description 2", rL_Item."Description 2");
                    rL_ItemCrossReference.Validate("Unit of Measure", rL_Item."Sales Unit of Measure");
                    rL_ItemCrossReference.INSERT(true);

                end;
            until rL_Item.Next() = 0;


        end;
    end;

    procedure PopulateSalesQuoteDescription()
    var

        rL_Item: Record Item;
        rL_ItemCrossReference: Record "Item Reference";
        rL_SalesLine: Record "Sales Line";
    begin
        rL_Item.RESET;
        rL_Item.SETFILTER("Shelf No.", '<>%1', '');
        rL_Item.SetFilter("No.", 'PFV*');

        if rL_Item.FINDSET then begin
            repeat
                CLEAR(rL_ItemCrossReference);
                rL_ItemCrossReference.SETFILTER("Item No.", rL_Item."No.");
                rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
                rL_ItemCrossReference.SETFILTER("Reference Type No.", 'CUST00032');
                rL_ItemCrossReference.SETFILTER("Reference No.", rL_Item."Shelf No.");
                rL_ItemCrossReference.SETFILTER("Unit of Measure", rL_Item."Sales Unit of Measure");
                if rL_ItemCrossReference.FINDSET then begin
                    rL_SalesLine.RESET;
                    rL_SalesLine.SetRange("Document Type", rL_SalesLine."Document Type"::Quote);
                    rL_SalesLine.SetFilter("Bill-to Customer No.", 'CUST00032');
                    rL_SalesLine.SetFilter("No.", rL_Item."No.");
                    rL_SalesLine.SetRange("Package Qty", rL_Item."Package Qty");
                    rL_SalesLine.SetFilter(Variety, '<>%1', '');
                    if rL_SalesLine.FindSet() then begin
                        rL_ItemCrossReference."S. Quote Description" := rL_SalesLine.Description;
                        rL_ItemCrossReference.Modify();
                    end;

                end;
            until rL_Item.Next() = 0;


        end;
    end;

    procedure PopulateMissingSalesQuoteDescription()
    var
        rL_ItemCrossReference: Record "Item Reference";
        SaleLine: Record "Sales Line";
    begin
        rL_ItemCrossReference.RESET;
        rL_ItemCrossReference.SETRANGE("Reference Type", rL_ItemCrossReference."Reference Type"::Customer);
        rL_ItemCrossReference.SETFILTER("Reference Type No.", 'CUST00032');
        rL_ItemCrossReference.SetRange("S. Quote Description", '');
        if rL_ItemCrossReference.FindSet() then begin
            repeat
                SaleLine.RESET;
                SaleLine.SetRange("Document Type", SaleLine."Document Type"::Quote);
                SaleLine.SetFilter("No.", rL_ItemCrossReference."Item No.");
                SaleLine.SetFilter("Product Class", '<>%1', '');
                SaleLine.SetFilter("Bill-to Customer No.", rL_ItemCrossReference."Reference Type No.");
                if SaleLine.FindSet() then begin
                    rL_ItemCrossReference."S. Quote Description" := SaleLine.Description;
                    rL_ItemCrossReference.Modify();
                end;
            until rL_ItemCrossReference.Next() = 0;

        end;

    end;

    procedure ExportLidlQuote(pDocumentNo: Code[20])
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        rL_SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        vL_Date1: Date;
        vL_Date2: Date;
        vL_Date3: Date;
        vL_Date4: Date;
        vL_Date5: Date;
        vL_Date6: Date;
        vL_Date7: Date;
        vL_Date8: Date;
        MATRIX_ColumnCaption: array[8] of Text;
        vL_Index: Integer;
    begin

        SalesHeader.GET(SalesHeader."Document Type"::Quote, pDocumentNo);

        rL_SalesLine.RESET;
        rL_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        rL_SalesLine.SetFilter("Document No.", SalesHeader."No.");
        if rL_SalesLine.FindSet() then begin
            vL_Index := 7;
            repeat
                vL_Index += 1;
                rL_SalesLine."Row Index" := vL_Index;
                rL_SalesLine.Modify();

            until rL_SalesLine.Next() = 0;
        end;


        vL_Date1 := CalcDate('-WD6', SalesHeader."Requested Delivery Date");
        vL_Date2 := CalcDate('-WD6+1D', SalesHeader."Requested Delivery Date");
        vL_Date3 := CalcDate('-WD6+2D', SalesHeader."Requested Delivery Date");
        vL_Date4 := CalcDate('-WD6+3D', SalesHeader."Requested Delivery Date");
        vL_Date5 := CalcDate('-WD6+4D', SalesHeader."Requested Delivery Date");
        vL_Date6 := CalcDate('-WD6+5D', SalesHeader."Requested Delivery Date");
        vL_Date7 := CalcDate('-WD6+6D', SalesHeader."Requested Delivery Date");
        vL_Date8 := CalcDate('-WD6+7D', SalesHeader."Requested Delivery Date");




        if vL_Date1 <> 0D then begin
            MATRIX_ColumnCaption[1] := FORMAT(vL_Date1, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[2] := FORMAT(vL_Date2, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[3] := FORMAT(vL_Date3, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[4] := FORMAT(vL_Date4, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[5] := FORMAT(vL_Date5, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[6] := FORMAT(vL_Date6, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[7] := FORMAT(vL_Date7, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
            MATRIX_ColumnCaption[8] := FORMAT(vL_Date8, 0, '<Day,2>/<Month,2>/<Year4>');// + BoxLabel;
        end;
        //headers
        ExcelBuffer.NewRow; //1

        ExcelBuffer.AddColumn('Ημερομηνία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."Document Date", false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);
        ExcelBuffer.AddColumn('Προμ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('FFH FARMER''S FRESH & HEALTHY PRODUCTS LTD.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);


        ExcelBuffer.NewRow; //2
        ExcelBuffer.AddColumn('Εβδομάδα', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(SalesHeader."External Document No.", false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Τύπ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('60', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Εβδομαδιαία γκάμα προϊόντων', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);

        ExcelBuffer.NewRow; //3
        ExcelBuffer.NewRow; //4

        ExcelBuffer.NewRow; //5

        ExcelBuffer.NewRow; //6
        ExcelBuffer.AddColumn('IAN', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //1
        ExcelBuffer.AddColumn('Περιγραφή προϊόντος ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//2
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//3
        ExcelBuffer.AddColumn('Προέ-λευση', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//4
        ExcelBuffer.AddColumn('Κατηγορία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//5
        ExcelBuffer.AddColumn('Κιβώτιο', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//6
        ExcelBuffer.AddColumn('Καλιμπράζ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//7
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//8
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//9
        ExcelBuffer.AddColumn('Ποικιλία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//10

        ExcelBuffer.AddColumn('(Ιδιωτική ετικέτα LIDL) Επωνυμία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//11
        ExcelBuffer.AddColumn('Warenherkunft (steuerl.)', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//12
        ExcelBuffer.AddColumn('Νόμισμα', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//13
        ExcelBuffer.AddColumn('Τιμές προηγούμενης Εβδομάδας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//14
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//15
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//16
        ExcelBuffer.AddColumn('Τιμές ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//17
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//18
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//19
        ExcelBuffer.AddColumn('Ποσότητα ανά σειρά', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//20

        ExcelBuffer.AddColumn(vL_Date1, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//21
        ExcelBuffer.AddColumn(vL_Date2, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//22
        ExcelBuffer.AddColumn(vL_Date3, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//23
        ExcelBuffer.AddColumn(vL_Date4, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//24
        ExcelBuffer.AddColumn(vL_Date5, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//25
        ExcelBuffer.AddColumn(vL_Date6, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//26
        ExcelBuffer.AddColumn(vL_Date7, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//27
        ExcelBuffer.AddColumn(vL_Date8, false, '', true, false, true, '', ExcelBuffer."Cell Type"::Date);//28
        ExcelBuffer.AddColumn('Συνολική ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//29
        ExcelBuffer.AddColumn('Wochen-bedarf', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//30

        ExcelBuffer.AddColumn('Bemerkung EK O+G', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//31
        ExcelBuffer.AddColumn('Πρόσθετες πληροφορίες', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//32
        ExcelBuffer.AddColumn('Πίεση', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//33
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//34
        ExcelBuffer.AddColumn('Brix σε °', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//35
        ExcelBuffer.AddColumn('Επωνυμία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//36
        ExcelBuffer.AddColumn('Πρόσθετα Ποιοτικά Χαρακτηριστικά', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//37
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//38
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//39
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//40

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//41
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//42
        ExcelBuffer.AddColumn('Επεξερ-γασία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//43
        ExcelBuffer.AddColumn('Καλλιέρ-γεια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//44
        ExcelBuffer.AddColumn('Άρδευση', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//45
        ExcelBuffer.AddColumn('Πρόσθετες πληροφορίες Πρόσθετα Ποιοτικά Χαρακτηριστικά', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//46
        ExcelBuffer.AddColumn('Συσκευασία', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//47
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//48
        ExcelBuffer.AddColumn('Κιβώτιο / Στάντζα', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//49
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//50

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//51
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//52
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//53
        ExcelBuffer.AddColumn('Υλικό Κιβωτίου', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//54
        ExcelBuffer.AddColumn('Ημερομηνία ολοκλήρωσης αλλαγής κιβωτίου', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//55
        ExcelBuffer.AddColumn('Συγκομιδή', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//56
        ExcelBuffer.AddColumn('Ιχν.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//57
        ExcelBuffer.AddColumn('Los Nr.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//58
        ExcelBuffer.AddColumn('Barcode', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//59
        ExcelBuffer.AddColumn('Πρόσθετα Πιστοπ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//60

        ExcelBuffer.AddColumn('Προμη-θευτής / Παρα-γωγός', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//61
        ExcelBuffer.AddColumn('Περιοχή Καλλιέρ-γειας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//62
        ExcelBuffer.AddColumn('Συσκευασμένο στον τόπο προέλεθσης X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//63
        ExcelBuffer.AddColumn('Ακτοπλοϊκά /Αεροπορικά ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//64
        ExcelBuffer.AddColumn('Άφιξη λιμάνι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//65
        ExcelBuffer.AddColumn('Όνομα πλοίου', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//66
        ExcelBuffer.AddColumn('Θερμοκρα-σία Μετα-φοράς', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//67
        ExcelBuffer.AddColumn('Προ-ψυγμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//68
        ExcelBuffer.AddColumn('Επεξεργασμένο μετά την συγκομιδή X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//69
        ExcelBuffer.AddColumn('Αποθη-κευμένο προϊόν X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//70

        ExcelBuffer.AddColumn('FR', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//71
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//72
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//73
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//74
        ExcelBuffer.AddColumn('IT', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//75
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//76
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//77
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//78
        ExcelBuffer.AddColumn('ES', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//79
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//80

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//81
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//82
        ExcelBuffer.AddColumn('GB', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//83
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//84
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//85
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//86
        ExcelBuffer.AddColumn('BE', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//87
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//88
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//89
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//90

        ExcelBuffer.AddColumn('PT', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//91
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//92
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//93
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//94
        ExcelBuffer.AddColumn('NL', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//95
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//96
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//97
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//98
        ExcelBuffer.AddColumn('GR', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//99
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//100

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//101
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//102
        ExcelBuffer.AddColumn('IE', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//103
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//104
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//105
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//106
        ExcelBuffer.AddColumn('PL', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//107
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//108
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//109
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//110

        ExcelBuffer.AddColumn('FI', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//111
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//112
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//113
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//114
        ExcelBuffer.AddColumn('CZ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//115
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//116
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//117
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//118
        ExcelBuffer.AddColumn('SE', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//119
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//120


        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//121
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//122
        ExcelBuffer.AddColumn('SK', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//123
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//124
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//125
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//126
        ExcelBuffer.AddColumn('HU', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//127
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//128
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//129
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//130


        ExcelBuffer.AddColumn('DK', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//131
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//132
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//133
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//134
        ExcelBuffer.AddColumn('HR', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//135
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//136
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//137
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//138
        ExcelBuffer.AddColumn('CH', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//139
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//140
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//141

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//142
        ExcelBuffer.AddColumn('BG', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//143
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//144
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//145
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//146
        ExcelBuffer.AddColumn('RO', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//147
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//148
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//149
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//150

        ExcelBuffer.AddColumn('INT', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//151
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//152
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//153
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//154
        ExcelBuffer.AddColumn('Θερμοκρασία συγκομιδής σε Cº', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//155
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//156
        ExcelBuffer.AddColumn('Θερμοκρασία συντήρησης σε θάλαμο μετά την συγκομιδή σε Cº', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//157
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//158
        ExcelBuffer.AddColumn('Πρόψυξη σε Cº', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//159
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//160

        ExcelBuffer.AddColumn('Θερμοκρασία παράδοσης στη μεταφορική σε Cº', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//161
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//162
        ExcelBuffer.AddColumn('Συμφων. Θερμοκρ.με την μεταφ. κατά την παράδοση στις αποθ.Lidl σε Cº', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//163
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//164



        ExcelBuffer.NewRow; //7
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//1
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//2
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//3
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//4
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//5
        ExcelBuffer.AddColumn('Περιεχό-μενο', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//6
        ExcelBuffer.AddColumn('Ελαχ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//7
        ExcelBuffer.AddColumn('Μεγ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//8
        ExcelBuffer.AddColumn('47', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//9
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//10

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//11
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//12
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//13
        ExcelBuffer.AddColumn('ανά Κιβ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//14
        ExcelBuffer.AddColumn('ανά τεμ/συσκ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//15
        ExcelBuffer.AddColumn('ανά kg', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//16
        ExcelBuffer.AddColumn('ανά Κιβ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//17
        ExcelBuffer.AddColumn('ανά τεμ/συσκ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//18
        ExcelBuffer.AddColumn('ανά kg', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//19
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//20

        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//21
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//22
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//23
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//24
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//25
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//26
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//27
        ExcelBuffer.AddColumn('Ποσότητα σε κιβώτια', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//28
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//29
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//30

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//31
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//32
        ExcelBuffer.AddColumn('kg/cm² Ελαχ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//33
        ExcelBuffer.AddColumn('kg/cm² Μεγ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//34
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//35
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//36
        ExcelBuffer.AddColumn('Ελαχ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//37
        ExcelBuffer.AddColumn('Μεγ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//38
        ExcelBuffer.AddColumn('Μον.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//39
        ExcelBuffer.AddColumn('Ελαχ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//40

        ExcelBuffer.AddColumn('Μεγ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//41
        ExcelBuffer.AddColumn('Μον.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//42
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//43
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//44
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//45
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//46
        ExcelBuffer.AddColumn('Προϊόν ', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//47
        ExcelBuffer.AddColumn('Ετικέτα X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//48
        ExcelBuffer.AddColumn('Πλάτος σε cm', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//49
        ExcelBuffer.AddColumn('X', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//50

        ExcelBuffer.AddColumn('Μήκος σε cm', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//51
        ExcelBuffer.AddColumn('X', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//52
        ExcelBuffer.AddColumn('Ύψος σε cm', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//53
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//54
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//55
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//56
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//57
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//58
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//59
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//60

        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//61
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//62
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//63
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//64
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//65
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//66
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//67
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//68
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//69
        ExcelBuffer.AddColumn('', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//70

        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//71
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//72
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//73
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//74
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//75
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//76
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//77
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//78
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//79
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//80

        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//81
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//82
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//83
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//84
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//85
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//86
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//87
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//88
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//89
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//90

        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//91
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//92
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//93
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//94
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//95
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//96
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//97
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//98
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//99
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//100

        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//101
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//102
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//103
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//104
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//105
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//106
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//107
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//108
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//109
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//110

        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//111
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//112
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//113
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//114
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//115
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//116
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//117
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//118
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//119
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//120


        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//121
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//122
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//123
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//124
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//125
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//126
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//127
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//128
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//129
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//130


        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//131
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//132
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//133
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//134
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//135
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//136
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//137
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//138
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//139
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//140
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//141

        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναιι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//142
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//143
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//144
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//145
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//146
        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//147
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//148
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//149
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//150

        ExcelBuffer.AddColumn('Περιεχ. Παλ.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//151
        ExcelBuffer.AddColumn('Προσαύξηση Παλέτας', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//152
        ExcelBuffer.AddColumn('Δεσμευμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//153
        ExcelBuffer.AddColumn('Μπλοκαρισμένο X = Ναι', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//154
        ExcelBuffer.AddColumn('Από', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//155
        ExcelBuffer.AddColumn('Έως', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//156
        ExcelBuffer.AddColumn('Από', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//157
        ExcelBuffer.AddColumn('Έως', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//158
        ExcelBuffer.AddColumn('Από', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//159
        ExcelBuffer.AddColumn('Έως', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//160

        ExcelBuffer.AddColumn('Από', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//161
        ExcelBuffer.AddColumn('Έως', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//162
        ExcelBuffer.AddColumn('Από', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//163
        ExcelBuffer.AddColumn('Έως', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text);//164


        rL_SalesLine.RESET;
        rL_SalesLine.SetRange("Document Type", rL_SalesLine."Document Type"::Quote);
        rL_SalesLine.SetFilter("Document No.", pDocumentNo);
        if rL_SalesLine.FindSet() then begin
            repeat
                ExcelBuffer.NewRow;
                //ExcelBuffer.AddColumn(rL_SalesLine."Line No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(rL_SalesLine."Item Reference No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //1
                //ExcelBuffer.AddColumn(rL_SalesLine."Shelf No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(rL_SalesLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //2
                ExcelBuffer.AddColumn(rL_SalesLine."Pallet Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//3
                ExcelBuffer.AddColumn(rL_SalesLine."Country/Region of Origin Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//4
                ExcelBuffer.AddColumn(rL_SalesLine."Product Class", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//5
                ExcelBuffer.AddColumn(rL_SalesLine."Package Qty", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//6
                ExcelBuffer.AddColumn(rL_SalesLine."Calibration Min.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//7
                ExcelBuffer.AddColumn(rL_SalesLine."Calibration Max.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//8
                ExcelBuffer.AddColumn(rL_SalesLine."Calibration UOM", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//9
                ExcelBuffer.AddColumn(rL_SalesLine.Variety, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//10


                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//11
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//12
                ExcelBuffer.AddColumn(rL_SalesLine."Currency Code", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//13
                ExcelBuffer.AddColumn(rL_SalesLine."Price Previous Week Box", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//14
                ExcelBuffer.AddColumn(rL_SalesLine."Price Previous Week PCS", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//15
                ExcelBuffer.AddColumn(rL_SalesLine."Price Previous Week KG", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//16
                ExcelBuffer.AddColumn(rL_SalesLine."Price Box", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//17
                ExcelBuffer.AddColumn(rL_SalesLine."Price PCS", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//18
                ExcelBuffer.AddColumn(rL_SalesLine."Price KG", false, '', false, false, false, '#0.00', ExcelBuffer."Cell Type"::Number);//19
                ExcelBuffer.AddColumn(rL_SalesLine."Row Index", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//20
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//21

                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//22
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 3", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//23
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 4", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//24
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 5", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//25
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 6", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//26
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 7", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//27
                ExcelBuffer.AddColumn(rL_SalesLine."Qty Box Date 8", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//28
                ExcelBuffer.AddColumn(rL_SalesLine."Total Qty on Boxes", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//29
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //30


                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //31
                ExcelBuffer.AddColumn(rL_SalesLine."Additional Information", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//32
                ExcelBuffer.AddColumn(rL_SalesLine."Pressure Min.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//33
                ExcelBuffer.AddColumn(rL_SalesLine."Pressure Max.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//34
                ExcelBuffer.AddColumn(rL_SalesLine."Brix Min", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//35
                ExcelBuffer.AddColumn(rL_SalesLine."Vendor Name", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//36
                ExcelBuffer.AddColumn(rL_SalesLine."QC 1 Min", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//37
                ExcelBuffer.AddColumn(rL_SalesLine."QC 1 Max", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//38
                ExcelBuffer.AddColumn(rL_SalesLine."QC 1 Text", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//39
                ExcelBuffer.AddColumn(rL_SalesLine."QC 2 Min", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//40


                ExcelBuffer.AddColumn(rL_SalesLine."QC 2 Max", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//41
                ExcelBuffer.AddColumn(rL_SalesLine."QC 2 Text", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//42
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //43
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //44
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //45
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //46
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //47
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //48
                ExcelBuffer.AddColumn(rL_SalesLine."Box Width", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//49
                ExcelBuffer.AddColumn(rL_SalesLine."Box Char 1", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//50

                ExcelBuffer.AddColumn(rL_SalesLine."Box Length", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//51
                ExcelBuffer.AddColumn(rL_SalesLine."Box Char 2", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//52
                ExcelBuffer.AddColumn(rL_SalesLine."Box Height", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//53
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//54
                ExcelBuffer.AddColumn(rL_SalesLine."Box Changed Date", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//55
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//56
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//57
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//58
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//59
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//60

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//61
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//62
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//63
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//64
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//65
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//66
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//67
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//68
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//69
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//70

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//71
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//72
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//73
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//74
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//75
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//76
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//77
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//78
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//79
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//80

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//81
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//82
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//83
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//84
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//85
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//86
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//87
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//88
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//89
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//90

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//91
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//92
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//93
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//94
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//95
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//96
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//97
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//98
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//99
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//100

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//101
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//102
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//103
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//104
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//105
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//106
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//107
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//108
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//109
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//110

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//111
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//112
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//113
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//114
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//115
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//116
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//117
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//118
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//119
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//120


                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//121
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//122
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//123
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//124
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//125
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//126
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//127
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//128
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//129
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//130


                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//131
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//132
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//133
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//134
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//135
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//136
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//137
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//138
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//139
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//140
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//141

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//142
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//143
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//144
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//145
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//146
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//147
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//148
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//149
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//150

                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//151
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//152
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//153
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);//154
                ExcelBuffer.AddColumn(rL_SalesLine."Harvest Temp. From", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//155
                ExcelBuffer.AddColumn(rL_SalesLine."Harvest Temp. To", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//156
                ExcelBuffer.AddColumn(rL_SalesLine."Freezer Harvest Temp. From", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//157
                ExcelBuffer.AddColumn(rL_SalesLine."Freezer Harvest Temp. To", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//158
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //159
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //160


                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //161
                ExcelBuffer.AddColumn('', false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text); //162
                ExcelBuffer.AddColumn(rL_SalesLine."Transfer Temp. From", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//163
                ExcelBuffer.AddColumn(rL_SalesLine."Transfer Temp. To", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);//164





            until rL_SalesLine.Next() = 0;
        end;

        ExcelBuffer.CreateNewBook('Sortiment International');

        ExcelBuffer.SetColumnWidth('A', 10);
        ExcelBuffer.SetColumnWidth('B', 40);
        ExcelBuffer.SetColumnWidth('C', 10);
        ExcelBuffer.SetColumnWidth('D', 10);
        ExcelBuffer.SetColumnWidth('H', 10);
        ExcelBuffer.SetColumnWidth('I', 10);
        ExcelBuffer.SetColumnWidth('J', 10);

        ExcelBuffer.SetColumnWidth('U', 12);
        ExcelBuffer.SetColumnWidth('V', 12);
        ExcelBuffer.SetColumnWidth('W', 12);
        ExcelBuffer.SetColumnWidth('X', 12);
        ExcelBuffer.SetColumnWidth('Y', 12);
        ExcelBuffer.SetColumnWidth('Z', 12);
        ExcelBuffer.SetColumnWidth('AA', 12);
        ExcelBuffer.SetColumnWidth('AB', 12);

        ExcelBuffer.SetColumnWidth('AF', 15);
        ExcelBuffer.SetColumnWidth('AJ', 15);

        ExcelBuffer.WriteSheet('Sortiment International', CompanyName, UserId);

        ExcelBuffer.DeleteAll();
        ExcelBuffer.SelectOrAddSheet('Warenherkunft');
        ExcelBuffer.SetCurrent(0, 0);

        //header
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Kz. EG', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Bezeichnung', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn('Auswahlwert', false, '', true, false, false, '', ExcelBuffer."Cell Type"::Text);

        //lines
        addRow(ExcelBuffer, '1', 'Inland', '1-Inland');
        addRow(ExcelBuffer, '2', 'Drittland', '2-Drittland');
        addRow(ExcelBuffer, '3', 'EU (steuerfrei)', '3-EU (steuerfrei)');
        addRow(ExcelBuffer, '5', 'EU-Steuerfrei (AT)', '5-EU-Steuerfrei(AT)');
        addRow(ExcelBuffer, '6', 'EU-Steuerfrei(BG)', '6-EU-Steuerfrei(BG)');
        addRow(ExcelBuffer, '7', 'EU-Steuerfrei(CZ)', '7-EU-Steuerfrei(CZ)');
        addRow(ExcelBuffer, '8', 'EU-Steuerfrei(GR)', '8-EU-Steuerfrei(GR)');
        addRow(ExcelBuffer, '9', 'EU-Steuerfrei(FR)', '9-EU-Steuerfrei(FR)');
        addRow(ExcelBuffer, '10', 'EU-Steuerfrei(ES)', '10-EU-Steuerfrei(ES)');
        addRow(ExcelBuffer, '11', 'EU-Steuerfrei(IT)', '11-EU-Steuerfrei(IT)');
        addRow(ExcelBuffer, '12', 'EU-Steuerfrei(NL)', '12-EU-Steuerfrei(NL)');
        addRow(ExcelBuffer, '13', 'EU-Steuerfrei(PL)', '13-EU-Steuerfrei(PL)');
        addRow(ExcelBuffer, '14', 'EU-Steuerfrei(SI)', '14-EU-Steuerfrei(SI)');
        addRow(ExcelBuffer, '15', 'EU-Steuerfrei(SK)', '15-EU-Steuerfrei(SK)');
        addRow(ExcelBuffer, '16', 'EU-Steuerfrei(GB)', '16-EU-Steuerfrei(GB)');
        addRow(ExcelBuffer, '17', 'EU-Steuerfrei(BE)', '17-EU-Steuerfrei(BE)');
        addRow(ExcelBuffer, '18', 'Inland(NL)', '18-Inland(NL)');
        addRow(ExcelBuffer, '19', 'Inland(BE)', '19-Inland(BE)');
        addRow(ExcelBuffer, '20', 'Inland(FR)', '20-Inland(FR)');
        addRow(ExcelBuffer, '21', 'Inland(AT)', '21-Inland(AT)');
        addRow(ExcelBuffer, '22', 'EU-Steuerfrei(DE)', '22-EU-Steuerfrei(DE)');
        addRow(ExcelBuffer, '23', 'Inland(DE)', '23-Inland(DE)');
        addRow(ExcelBuffer, '24', 'EU-Steuerfrei(DK)', '24-EU-Steuerfrei(DK)');
        ExcelBuffer.WriteSheet('Warenherkunft', CompanyName, UserId);
        ExcelBuffer.SetColumnWidth('A', 10);
        ExcelBuffer.SetColumnWidth('B', 40);
        ExcelBuffer.SetColumnWidth('C', 40);

        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename(pDocumentNo + '_Sortiment_International');
        ExcelBuffer.OpenExcel();


    end;

    local procedure addRow(var ExcelBuffer: Record "Excel Buffer"; p1: Text; p2: Text; p3: Text)
    var
        myInt: Integer;
    begin
        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn(p1, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
        ExcelBuffer.AddColumn(p2, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
        ExcelBuffer.AddColumn(p3, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
    end;

    procedure ExportLidlCompetitorsPrices(pDocumentNo: Code[20])
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        rL_SalesLine: Record "Sales Line";
    begin


        ExcelBuffer.NewRow;
        ExcelBuffer.AddColumn('Line No.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //A
        ExcelBuffer.AddColumn('Item No.', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //B
        ExcelBuffer.AddColumn('Description', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //C
        ExcelBuffer.AddColumn('Variety', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //D
        ExcelBuffer.AddColumn('YAM', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //E
        ExcelBuffer.AddColumn('YS', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //F
        ExcelBuffer.AddColumn('YL', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //G
        ExcelBuffer.AddColumn('YAM Comment', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //H
        ExcelBuffer.AddColumn('YS Comment', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //I
        ExcelBuffer.AddColumn('YL Comment', false, '', true, false, true, '', ExcelBuffer."Cell Type"::Text); //J

        //add 

        rL_SalesLine.RESET;
        rL_SalesLine.SetRange("Document Type", rL_SalesLine."Document Type"::Quote);
        rL_SalesLine.SetFilter("Document No.", pDocumentNo);
        if rL_SalesLine.FindSet() then begin
            repeat
                ExcelBuffer.NewRow;
                ExcelBuffer.AddColumn(rL_SalesLine."Line No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(rL_SalesLine."No.", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(rL_SalesLine.Description, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(rL_SalesLine.Variety, false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);

                ExcelBuffer.AddColumn(rL_SalesLine."Cost YAM", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(rL_SalesLine."Cost YS", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);
                ExcelBuffer.AddColumn(rL_SalesLine."Cost YL", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Number);

                ExcelBuffer.AddColumn(rL_SalesLine."Cost YAM Comment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(rL_SalesLine."Cost YS Comment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
                ExcelBuffer.AddColumn(rL_SalesLine."Cost YL Comment", false, '', false, false, false, '', ExcelBuffer."Cell Type"::Text);
            until rL_SalesLine.Next() = 0;
        end;


        ExcelBuffer.CreateNewBook('Competitors Prices');
        ExcelBuffer.WriteSheet('Competitors Prices', CompanyName, UserId);
        ExcelBuffer.SetColumnWidth('B', 10);
        ExcelBuffer.SetColumnWidth('C', 40);
        ExcelBuffer.SetColumnWidth('D', 15);
        ExcelBuffer.SetColumnWidth('H', 30);
        ExcelBuffer.SetColumnWidth('I', 30);
        ExcelBuffer.SetColumnWidth('J', 30);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename(pDocumentNo + '_Competitors_Prices');
        ExcelBuffer.OpenExcel();

        //ExcelBuffer.SetColumnWidth('C', 40);

        //ExcelBuffer.SetFriendlyFilename(pDocumentNo);
        //ExcelBuffer.CreateBookAndOpenExcel('', 'Competitors Prices', 'Competitors Prices', COMPANYNAME, USERID);

        //ERROR('');
    end;

    procedure ImportLidlCompetitorsPrices(pDocNo: Code[20])
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;
        Colmn10_Valid: Text;

        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";

        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        rL_Item: Record Item;
        TmpDecimal: Decimal;
        TmpInteger: Decimal;
        rL_SalesLine: Record "Sales Line";

    begin
        //open excel file and process 17 rows
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 10; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        //Window.OPEN('Record Processing #1###############', MyNext);
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;


        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            //Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
            //MyNext := FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount);
            //Window.UPDATE();//1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';
            Colmn10_Valid := '';

            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;
                        7:
                            BEGIN
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        8:
                            BEGIN
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        9:
                            BEGIN
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;
                        10:
                            BEGIN
                                EVALUATE(Colmn10_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;



                    END; //end case

                END;//end if
            END; //end for 2


            if (Colmn1_Valid <> '') then begin

                Evaluate(TmpInteger, Colmn1_Valid);
                // if rL_Item.get(Colmn1_Valid);

                rL_SalesLine.RESET;
                rL_SalesLine.SetRange("Document Type", rL_SalesLine."Document Type"::Quote);
                rL_SalesLine.SetFilter("Document No.", pDocNo);
                rL_SalesLine.SetRange("Line No.", TmpInteger);
                //rL_SalesLine.SetFilter("No.", Colmn1_Valid);
                if rL_SalesLine.FindSet() then begin


                    Evaluate(TmpDecimal, Colmn5_Valid);
                    rL_SalesLine."Cost YAM" := TmpDecimal;

                    Evaluate(TmpDecimal, Colmn6_Valid);
                    rL_SalesLine."Cost YS" := TmpDecimal;

                    //YL = Yperagora Lidl
                    Evaluate(TmpDecimal, Colmn7_Valid);
                    rL_SalesLine."Cost YL" := TmpDecimal;


                    //comments
                    rL_SalesLine."Cost YAM Comment" := Colmn8_Valid;
                    rL_SalesLine."Cost YS Comment" := Colmn9_Valid;
                    rL_SalesLine."Cost YL Comment" := Colmn10_Valid;

                    rL_SalesLine.Modify();

                end;

            END; //end for 1
                 //Window.CLOSE();

        end;
    end;

    procedure UpdatePrices(pDocumentNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        vL_StartDate: Date;
        vL_EndDate: Date;
        SalesLine: Record "Sales Line";
        rL_Item: Record Item;
        Txt50000: Label 'Are you sure to update Document No. %1 Prices %2-%3?';
    begin

        SalesHeader.get(SalesHeader."Document Type"::Quote, pDocumentNo);
        vL_StartDate := SalesHeader."Price Update Start Date"; //SalesHeader.GetPriceStartDatePreviousWeek();
        vL_EndDate := SalesHeader."Price Update End Date"; //SalesHeader.GetPriceEndDatePreviousWeek();

        if not Confirm(Txt50000, false, SalesHeader."No.", vL_StartDate, vL_EndDate) then begin
            exit;
        end;

        SalesLine.RESET;
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetFilter("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("No.", '<>%1', '');
        if SalesLine.FindSet() then begin
            repeat
                if rL_Item.GET(SalesLine."No.") then begin
                    if rL_Item."Category 1" = '' then begin
                        exit;
                    end;

                    rL_Item.TestField("Package Qty");
                    SalesLine."Price Previous Week Box" := 0;
                    SalesLine."Price Previous Week KG" := 0;
                    SalesLine."Price Previous Week PCS" := 0;
                    if rL_Item."Package Qty" <> 0 then begin
                        if rL_Item."Category 1" = 'LOSE' then begin
                            SalesLine."Price Previous Week KG" := SalesLine.GetCostingPriceUpdate();
                            SalesLine."Price Previous Week Box" := SalesLine."Price Previous Week KG" * rL_Item."Package Qty";
                        end else begin
                            SalesLine."Price Previous Week PCS" := SalesLine.GetCostingPriceUpdate();
                        end;
                    end;

                    SalesLine.Modify();
                end;
            until SalesLine.Next() = 0;
        end;
    end;


    procedure ImportLidlIAN()
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;


        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";

        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        rL_Item: Record Item;
        TmpDecimal: Decimal;
        TmpInteger: Decimal;
        ItemReference: Record "Item Reference";

    begin
        //open excel file and process 17 rows
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 8; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        //Window.OPEN('Record Processing #1###############', MyNext);
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;


        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            //Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
            //MyNext := FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount);
            //Window.UPDATE();//1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';


            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;
                        7:
                            BEGIN
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        8:
                            BEGIN
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;





                    END; //end case

                END;//end if
            END; //end for 2


            if (Colmn1_Valid <> '') then begin
                ItemReference.RESET;
                ItemReference.SETRANGE("Reference Type", ItemReference."Reference Type"::Customer);
                ItemReference.SETFILTER("Reference Type No.", 'CUST00032');
                ItemReference.SETFILTER("Reference No.", Colmn1_Valid);
                if ItemReference.FindSet() then begin

                    ItemReference.Package := Colmn3_Valid;
                    ItemReference.EAN := copystr(Colmn4_Valid, 1, 100);
                    ItemReference."Family Code" := Colmn5_Valid;
                    ItemReference.Modify();
                end;

            END; //end for 1
                 //Window.CLOSE();

        end;
    end;

    procedure UpdateSalesShipmentLine()
    var

        rL_SalesShipmentLine: Record "Sales Shipment Line";
        TxtLbl50000: Label 'Are you sure to update Sales Shipment Line?';
    begin

        if not Confirm(TxtLbl50000, false) then begin
            exit;
        end;
        rL_SalesShipmentLine.RESET;
        rL_SalesShipmentLine.SetFilter("Qty. Requested", '<>%1', 0);
        rL_SalesShipmentLine.SetRange(Quantity, 0);
        if rL_SalesShipmentLine.FindSet() then begin

            Window.OPEN('Record Processing #1###############');
            WindowTotalCount := rL_SalesShipmentLine.Count;
            WindowLineCount := 0;
            repeat
                WindowLineCount += 1;
                Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
                if rL_SalesShipmentLine.Quantity = 0 then begin
                    rL_SalesShipmentLine."Qty. Requested" := 0;
                    rL_SalesShipmentLine.Modify();
                end;
            until rL_SalesShipmentLine.Next() = 0;

            Window.Close();
        end;
        Message('Process Completed');
    end;

    //+1.0.0.204
    procedure UpdateDeletedSOLine(Var SalesLine: Record "Sales Line")
    var
        SalesShptLineSearch: Record "Sales Shipment Line";
        vL_SumTotalQty: Decimal;
    begin

        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine.Quantity = 0) then begin

            SalesShptLineSearch.RESET;
            SalesShptLineSearch.SetFilter("Order No.", SalesLine."Document No.");
            SalesShptLineSearch.SetRange("Order Line No.", SalesLine."Line No.");
            SalesShptLineSearch.SetRange("Posting Date", SalesLine."Posting Date");
            if SalesShptLineSearch.FindSet() then begin
                repeat
                    vL_SumTotalQty += SalesShptLineSearch.Quantity;
                until SalesShptLineSearch.Next() = 0;

                if vL_SumTotalQty = 0 then begin
                    SalesShptLineSearch."Qty. Requested" := SalesLine."Qty. Requested";
                    SalesShptLineSearch."Qty. Confirmed" := SalesLine."Qty. Confirmed";
                    SalesShptLineSearch.Modify();
                end;
            end;
        end;

    end;
    //-1.0.0.204

    procedure GetComputerName()
    var
        myInt: Integer;
        vL_ComputerName: Text;
    begin
        // EXIT(SysEnv.GetEnvironmentVariable(property));
        //'COMPUTERNAME'
        vL_ComputerName := '';
        /* vL_ComputerName := vG_Environment.GetEnvironmentVariable('COMPUTERNAME');
        vL_ComputerName += '  - ' + vG_Environment.GetEnvironmentVariable('REMOTE_USER');
        vL_ComputerName += '  - ' + vG_Environment.UserName; */
        vL_ComputerName := Format(SessionId());
        vL_ComputerName += '  - ' + Format(Session.CurrentClientType());
        vL_ComputerName += '  - ' + UserId();


        Message(vL_ComputerName);
    end;


    procedure ImportHorecDeliveryDays()
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        Colmn4_Valid: Text;
        Colmn5_Valid: Text;
        Colmn6_Valid: Text;
        Colmn7_Valid: Text;
        Colmn8_Valid: Text;
        Colmn9_Valid: Text;


        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";

        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        rL_Item: Record Item;
        TmpDecimal: Decimal;
        TmpInteger: Decimal;
        ItemReference: Record "Item Reference";
        ShiptoAddress: Record "Ship-to Address";

    begin
        //open excel file and process 17 rows
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 9; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        //Window.OPEN('Record Processing #1###############', MyNext);
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;


        FOR RowNo := 2 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            //Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
            //MyNext := FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount);
            //Window.UPDATE();//1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';
            Colmn4_Valid := '';
            Colmn5_Valid := '';
            Colmn6_Valid := '';
            Colmn7_Valid := '';
            Colmn8_Valid := '';
            Colmn9_Valid := '';


            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        4:
                            BEGIN
                                EVALUATE(Colmn4_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        5:
                            BEGIN
                                EVALUATE(Colmn5_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        6:
                            BEGIN
                                EVALUATE(Colmn6_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;
                        7:
                            BEGIN
                                EVALUATE(Colmn7_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        8:
                            BEGIN
                                EVALUATE(Colmn8_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;

                        9:
                            BEGIN
                                EVALUATE(Colmn9_Valid, Trim(ExcelBuffer."Cell Value as Text"));

                            END;





                    END; //end case

                END;//end if
            END; //end for 2


            if ((Colmn1_Valid <> '') and (StrLen(Colmn1_Valid) <= 10)) then begin

                ShiptoAddress.RESET;
                ShiptoAddress.SetFilter("Customer No.", '%1|%2', 'CUST00166', 'CUST00238');
                ShiptoAddress.SetFilter(Code, Colmn1_Valid);
                if ShiptoAddress.findfirst then begin
                    case Colmn7_Valid of
                        'TUESDAY / FRIDAY':
                            begin
                                ShiptoAddress.Tuesday := true;
                                ShiptoAddress.Friday := true;
                                ShiptoAddress.Modify();
                            end;

                        'MONDAY / THURSDAY':
                            begin
                                ShiptoAddress.Monday := true;
                                ShiptoAddress.Thursday := true;
                                ShiptoAddress.Modify();
                            end;

                        'WEDNESDAY / SATURDAY':
                            begin
                                ShiptoAddress.Wednesday := true;
                                ShiptoAddress.Saturday := true;
                                ShiptoAddress.Modify();
                            end;


                    end;

                    if ShiptoAddress."Phone No." = '' then begin
                        ShiptoAddress."Phone No." := Colmn4_Valid;
                        ShiptoAddress.modify();
                    end;

                    if ShiptoAddress."E-Mail" = '' then begin
                        ShiptoAddress."E-Mail" := Colmn5_Valid;
                        ShiptoAddress.modify();

                    end;


                end;



            END; //end for 1
                 //Window.CLOSE();

        end;
    end;

    procedure ImportHorecItems()
    var
        vL_FileName: Text[250];
        ExcelBuffer: Record "Excel Buffer" temporary;
        SheetName: Text[250];
        RowNo: Integer;
        ColumnNo: Integer;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        vL_RowNo: Integer;

        Colmn1_Valid: Text;
        Colmn2_Valid: Text;



        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
        cu_FileMgt: Codeunit "File Management";

        Text50000: Label 'Import Excel File';
        ExcelFileExtensionTok: Label '.xlsx';
        ExcelFileExtensionTok2: Label '.xls';
        vL_LineNo: integer;
        rL_Item: Record Item;
        TmpDecimal: Decimal;
        TmpInteger: Decimal;

        StandardSalesLine: Record "Standard Sales Line";
        Item: Record Item;
        LineNo: Integer;

    begin
        //open excel file and process 17 rows
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := ExcelBuffer.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        ExcelBuffer.OpenBook(vL_FileName, SheetName);
        ExcelBuffer.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        ExcelBuffer.RESET;
        ExcelBuffer.FINDLAST;
        RowNoMax := ExcelBuffer."Row No.";
        ColumnNoMax := 2; //ExcelBuffer."Column No.";

        vL_RowNo := 0;
        CLEAR(Window);
        //Window.OPEN('Record Processing #1###############', MyNext);
        WindowTotalCount := RowNoMax;
        WindowLineCount := 0;
        LineNo := 0;


        FOR RowNo := 3 TO RowNoMax DO BEGIN
            ExcelBuffer.SETRANGE("Row No.", RowNo);

            WindowLineCount += 1;
            //Window.UPDATE(1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));
            //MyNext := FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount);
            //Window.UPDATE();//1, FORMAT(WindowLineCount) + '/' + FORMAT(WindowTotalCount));

            Colmn1_Valid := '';
            Colmn2_Valid := '';

            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                ExcelBuffer.SETRANGE("Column No.", ColumnNo);
                IF ExcelBuffer.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF
                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(ExcelBuffer."Cell Value as Text"));
                            END;

                    END; //end case

                END;//end if
            END; //end for 2


            //Recurring Sales Lines
            if ((Colmn1_Valid <> '') and (StrLen(Colmn1_Valid) <= 10)) then begin
                case SheetName of
                    'USER 1 - KFC Items':
                        begin
                            //KFC ITEMS
                            LineNo += 10000;
                            clear(StandardSalesLine);
                            StandardSalesLine.validate("Standard Sales Code", 'WEB_KFC');
                            StandardSalesLine.Validate("Line No.", LineNo);
                            StandardSalesLine.Validate(Type, StandardSalesLine.type::Item);
                            if Item.GET(Colmn1_Valid) then begin
                                StandardSalesLine.Validate("No.", Item."No.");
                                StandardSalesLine.Validate(Description, Colmn2_Valid);
                                StandardSalesLine.insert(true);
                            end;


                        end;

                    'USER 2 - PIZZA HUT ITEMS':
                        begin
                            //PIZZA HUT
                            LineNo += 10000;
                            clear(StandardSalesLine);
                            StandardSalesLine.validate("Standard Sales Code", 'WEB_PH');
                            StandardSalesLine.Validate("Line No.", LineNo);
                            StandardSalesLine.Validate(Type, StandardSalesLine.type::Item);
                            if Item.GET(Colmn1_Valid) then begin
                                StandardSalesLine.Validate("No.", Item."No.");
                                StandardSalesLine.Validate(Description, Colmn2_Valid);
                                StandardSalesLine.insert(true);
                            end;

                        end;

                    'USER 3 - TACO BELL ITEMS':
                        begin
                            //TACO BELL
                            LineNo += 10000;
                            clear(StandardSalesLine);
                            StandardSalesLine.validate("Standard Sales Code", 'WEB_TC');
                            StandardSalesLine.Validate("Line No.", LineNo);
                            StandardSalesLine.Validate(Type, StandardSalesLine.type::Item);
                            if Item.GET(Colmn1_Valid) then begin
                                StandardSalesLine.Validate("No.", Item."No.");
                                StandardSalesLine.Validate(Description, Colmn2_Valid);
                                StandardSalesLine.insert(true);
                            end;

                        end;

                    'USER 4 - BURGER KING':
                        begin
                            //BURGER KI
                            LineNo += 10000;
                            clear(StandardSalesLine);
                            StandardSalesLine.validate("Standard Sales Code", 'WEB_BK');
                            StandardSalesLine.Validate("Line No.", LineNo);
                            StandardSalesLine.Validate(Type, StandardSalesLine.type::Item);
                            if Item.GET(Colmn1_Valid) then begin
                                StandardSalesLine.Validate("No.", Item."No.");
                                StandardSalesLine.Validate(Description, Colmn2_Valid);
                                StandardSalesLine.insert(true);
                            end;

                        end;
                end;



            END; //end for 1
                 //Window.CLOSE();

        end;
    end;

    procedure GetScheduleDays(pCustomerNo: Code[20]; pShiptoAddress: Code[20]) OnSchedule: Text
    var
        ShiptoAddress: Record "Ship-to Address";
    begin
        OnSchedule := '';

        if ShiptoAddress.GET(pCustomerNo, pShiptoAddress) then begin
            if (ShiptoAddress.Monday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += 'Monday';
                end else begin
                    OnSchedule := 'Monday';
                end;

            end;

            if (ShiptoAddress.Tuesday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Tuesday';
                end else begin
                    OnSchedule := 'Tuesday';
                end;

            end;

            if (ShiptoAddress.Wednesday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Wednesday';
                end else begin
                    OnSchedule := 'Wednesday';
                end;

            end;

            if (ShiptoAddress.Thursday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Thursday';
                end else begin
                    OnSchedule := 'Thursday';
                end;

            end;

            if (ShiptoAddress.Friday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Friday';
                end else begin
                    OnSchedule := 'Friday';
                end;

            end;

            if (ShiptoAddress.Saturday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Saturday';
                end else begin
                    OnSchedule := 'Saturday';
                end;

            end;

            if (ShiptoAddress.Sunday) then begin
                if OnSchedule <> '' then begin
                    OnSchedule += '-Sunday';
                end else begin
                    OnSchedule := 'Sunday';
                end;

            end;
        end;
    end;


    procedure HORECAAutoRelease()
    var

        SalesHeader: Record "Sales Header";
        UserSetup: Record "User Setup";
        User: Record User;
        rL_SalesLine: Record "Sales Line";
        rL_SalesLine2: Record "Sales Line";
        numdays: Integer;
        ReleaseSalesDoc: Codeunit "Release Sales Document";

        LineNo: Integer;
        SalesLine: Record "Sales Line";
    begin

        SalesHeader.RESET;
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        SalesHeader.setfilter("Requested Delivery Date", '<>%1', 0D);
        SalesHeader.setfilter("Ship-to Code", '<>%1', '');

        if SalesHeader.findset then begin
            repeat
                UserSetup.RESET;
                UserSetup.SetFilter("HORECA Customer No.", '<>%1', '');
                if UserSetup.FindSet() then begin
                    repeat
                        clear(User);
                        User.RESET;
                        User.SetFilter("User Name", UserSetup."User ID");
                        if User.FindSet() then begin
                            //order has been created from the Horeca user
                            if SalesHeader.SystemCreatedBy = User."User Security ID" then begin

                                numdays := SalesHeader."Requested Delivery Date" - WorkDate();
                                if numdays <= 1 then begin

                                    //delete zero lines
                                    rL_SalesLine.RESET;
                                    rL_SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                                    rL_SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                                    rL_SalesLine.SetRange(Type, rL_SalesLine.Type::Item);
                                    rL_SalesLine.SetRange(Quantity, 0);
                                    if rL_SalesLine.FINDSET then begin
                                        repeat
                                            rL_SalesLine.Delete(true);
                                        until rL_SalesLine.NEXT = 0;
                                    end;




                                    rL_SalesLine.RESET;
                                    rL_SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                    rL_SalesLine.SetRange("Document No.", SalesHeader."No.");
                                    rL_SalesLine.SetFilter(Type, '>0');
                                    rL_SalesLine.SetFilter(Quantity, '<>0');
                                    if rL_SalesLine.findset then begin

                                        //+1.0.0.292
                                        //check if store is allowed the package line
                                        if UserSetup."HORECA Package Item No." <> '' then begin

                                            //check if package line exist
                                            rL_SalesLine2.RESET;
                                            rL_SalesLine2.SETRANGE("Document Type", SalesHeader."Document Type");
                                            rL_SalesLine2.SETRANGE("Document No.", SalesHeader."No.");
                                            rL_SalesLine2.SetRange(Type, rL_SalesLine2.Type::Item);
                                            rL_SalesLine2.SetFilter("No.", UserSetup."HORECA Package Item No.");
                                            if not rL_SalesLine2.FindSet() then begin
                                                //find the last line no.
                                                LineNo := 0;
                                                SalesLine.RESET;
                                                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                                                SalesLine.SetFilter("Document No.", SalesHeader."No.");
                                                if SalesLine.FindLast() then begin
                                                    LineNo := SalesLine."Line No.";
                                                end;

                                                LineNo += 10000;
                                                clear(SalesLine);
                                                SalesHeader.SetHideValidationDialog(true);
                                                SalesLine.validate("Document Type", SalesHeader."Document Type");
                                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                                SalesLine.Validate("Line No.", LineNo);
                                                SalesLine.Insert(true);

                                                SalesLine.Validate(Type, SalesLine.Type::Item);
                                                SalesLine.Validate("No.", UserSetup."HORECA Package Item No.");
                                                SalesLine.Modify(true);

                                                SalesLine.ValidateShortcutDimCode(5, SalesHeader."Ship-to Code");
                                                SalesLine.Modify(true);
                                            end;
                                        end;
                                        //-1.0.0.292

                                        ReleaseSalesDoc.PerformManualRelease(SalesHeader);
                                        SalesHeader."HORECA Status" := SalesHeader."HORECA Status"::Released;
                                        SalesHeader.modify;
                                    end;




                                end; //end numdays <= 1

                            end; //end  if SalesHeader.SystemCreatedBy = User."User Security ID" then begin

                        end; //end User



                    until UserSetup.Next() = 0;
                end;



            until SalesHeader.next = 0;
        end;


    end;

    //+1.0.0.268
    procedure HORECAOrderReminder(padmin: Boolean)
    var
        UserSetup: Record "User Setup";
        SRSetup: Record "Sales & Receivables Setup";
        ShiptoAddress: Record "Ship-to Address";
        SalesHeaderCheck: Record "Sales Header";
        CompanyInfo: Record "Company Information";
        ReminderDate: Date;
        WeekDay: Integer;
        WeekDayAdmin: Integer;

        MinNextDeliveryDate: Date;
        NextDeliveryDate1: Date;
        NextDeliveryDate2: Date;
        TempDate1: Date;
        TempDate2: Date;
        EmailDay: Boolean;
        EmailDayAdmin: Boolean;
        vBodyAdmin: Text;
        ShipRowCount: Integer;

        ToRecipient: List of [Text];
        CCRecipient: List of [Text];
        BCCRecipient: List of [Text];
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        NextAdminDate: Date;

    begin
        SRSetup.GET;
        CompanyInfo.GET;
        ShipRowCount := 0;

        UserSetup.RESET;
        UserSetup.SetFilter("HORECA Customer No.", '<>%1', '');
        if UserSetup.FindSet() then begin

            //create the admin message



            repeat
                UserSetup.testfield("HORECA Min. Order Period");
                ReminderDate := CalcDate(UserSetup."HORECA Min. Order Period", WorkDate());
                MinNextDeliveryDate := ReminderDate;
                WeekDay := Date2DWY(ReminderDate, 1);


                WeekDayAdmin := Date2DWY(WorkDate(), 1);
                NextAdminDate := CalcDate('+1D', WorkDate());

                ShiptoAddress.RESET;
                //ShiptoAddress.SetCurrentKey("Customer No.",Code, City, Name);
                ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
                ShiptoAddress.SetFilter(Code, '%1', UserSetup."HORECA Ship-to Filter");
                ShiptoAddress.SetRange(Blocked, false);
                ShiptoAddress.SetRange("Notify Place Order", true);
                ShiptoAddress.SetFilter("E-Mail", '<>%1', '');
                if ShiptoAddress.FindSet() then begin
                    repeat
                        EmailDay := false;
                        EmailDayAdmin := false;

                        if (ShiptoAddress.Monday) then begin
                            NextDeliveryDate1 := CalcDate('WD1', MinNextDeliveryDate);
                            if WeekDay = 1 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Monday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 7 then begin
                                EmailDayAdmin := true;
                            end;
                        end;

                        if (ShiptoAddress.Tuesday) then begin
                            NextDeliveryDate1 := CalcDate('WD2', MinNextDeliveryDate);
                            if WeekDay = 2 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Tuesday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 1 then begin
                                EmailDayAdmin := true;
                            end;
                        end;

                        if (ShiptoAddress.Wednesday) then begin
                            NextDeliveryDate1 := CalcDate('WD3', MinNextDeliveryDate);

                            if WeekDay = 3 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Wednesday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate1 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 2 then begin
                                EmailDayAdmin := true;
                            end;
                        end;

                        if (ShiptoAddress.Thursday) then begin
                            NextDeliveryDate2 := CalcDate('WD4', MinNextDeliveryDate);
                            if WeekDay = 4 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Thursday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 3 then begin
                                EmailDayAdmin := true;
                            end;
                        end;

                        if (ShiptoAddress.Friday) then begin
                            NextDeliveryDate2 := CalcDate('WD5', MinNextDeliveryDate);
                            if WeekDay = 5 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Friday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 4 then begin
                                EmailDayAdmin := true;
                            end;

                        end;

                        if (ShiptoAddress.Saturday) then begin
                            NextDeliveryDate2 := CalcDate('WD6', MinNextDeliveryDate);
                            if WeekDay = 6 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Saturday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 5 then begin
                                EmailDayAdmin := true;
                            end;

                        end;

                        if (ShiptoAddress.Sunday) then begin
                            NextDeliveryDate2 := CalcDate('WD7', MinNextDeliveryDate);
                            if WeekDay = 7 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Sunday), ReminderDate);
                                EmailDay := true;
                                NextDeliveryDate2 := MinNextDeliveryDate;
                            end;

                            if WeekDayAdmin = 6 then begin
                                EmailDayAdmin := true;
                            end;

                        end;


                        if NextDeliveryDate1 > NextDeliveryDate2 then begin
                            TempDate1 := NextDeliveryDate1;
                            TempDate2 := NextDeliveryDate2;
                            NextDeliveryDate1 := TempDate2;
                            NextDeliveryDate2 := TempDate1;
                        end;


                        if (NextDeliveryDate1 <> 0D) and (EmailDay) then begin
                            SalesHeaderCheck.RESET;
                            SalesHeaderCheck.SetRange("Document Type", SalesHeaderCheck."Document Type"::Order);
                            SalesHeaderCheck.SetFilter("Sell-to Customer No.", ShiptoAddress."Customer No.");
                            SalesHeaderCheck.SetFilter("Ship-to Code", ShiptoAddress.code);
                            SalesHeaderCheck.SetFilter("Requested Delivery Date", '%1', NextDeliveryDate1);
                            if SalesHeaderCheck.Count = 0 then begin

                                if not padmin then begin
                                    EmailShiptoAddress(ShiptoAddress, Format(NextDeliveryDate1, 0, '<Weekday Text>'), NextDeliveryDate1);
                                end;

                            end;
                        end;

                        if (EmailDayAdmin) then begin
                            SalesHeaderCheck.RESET;
                            SalesHeaderCheck.SetRange("Document Type", SalesHeaderCheck."Document Type"::Order);
                            SalesHeaderCheck.SetFilter("Sell-to Customer No.", ShiptoAddress."Customer No.");
                            SalesHeaderCheck.SetFilter("Ship-to Code", ShiptoAddress.code);
                            SalesHeaderCheck.SetFilter("Requested Delivery Date", '%1', NextAdminDate);
                            if SalesHeaderCheck.Count = 0 then begin

                                if ShipRowCount = 0 then begin
                                    vBodyAdmin := 'Kindly note that the following stores did not place their orders:  </br></br>';
                                end;

                                ShipRowCount += 1;
                                vBodyAdmin += ShiptoAddress.Name + ' (p) ' + ShiptoAddress."Phone No." + ' (e) ' + ShiptoAddress."E-Mail" + ' Next Delivery Date ' + Format(NextAdminDate, 0, '<Weekday Text>') + ' ' + Format(NextAdminDate) + ' </br>';
                            end;
                        end;



                    until ShiptoAddress.Next() = 0;
                end;

            until UserSetup.Next() = 0;

            if (ShipRowCount > 0) and (padmin) then begin
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 1");
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 2");
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 3");
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 4");
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 5");
                ToRecipient.Add(SRSetup."Notify Horeca Reminder Email 6");

                if ToRecipient.Count > 0 then begin
                    EmailMessage.Create(ToRecipient, 'HORECA Reminder for Admins', vBodyAdmin, true, CCRecipient, BCCRecipient);
                    Email.Send(EmailMessage, "Email Scenario"::"Work Order");
                end;


            end;


        end;
    end;


    local procedure EmailShiptoAddress(var pShiptoAddress: Record "Ship-to Address"; pDateCaption: Text; pReminderDate: Date)
    var

        Text50000: Label 'Shop %1 Email %2 Day: %3 Date: %4';
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ToRecipient: List of [Text];
        CCRecipient: List of [Text];
        BCCRecipient: List of [Text];
        vBody: Text;
        CompanyInfo: Record "Company Information";
    begin

        // Message(Text50000, pShiptoAddress.Code + ' ' + pShiptoAddress.Name, pShiptoAddress."E-Mail", pDateCaption, pReminderDate);

        clear(EmailMessage);
        clear(Email);
        clear(ToRecipient);
        clear(CCRecipient);
        CompanyInfo.GET;

        vBody := 'Dear ' + pShiptoAddress.Name + ',<br><br> Please place your order to ' + CompanyInfo.Name + ' for ' + pDateCaption + ' ' + Format(pReminderDate) +
        '</br></br><a href=' + CompanyInfo."Web Portal URL" + '></a>' + CompanyInfo."Web Portal URL" + ' ' +
        '</br></br> Regards, <br>' + CompanyInfo.Name + '<br>Tel. ' + CompanyInfo."Phone No.";

        // EmailMessage.Create(Location."E-Mail", 'Transfer To ' + "Transfer-to Code" + ' ' + "No.", vBody, true);//before
        //TAL 1.0.0.95 
        ToRecipient.Add(pShiptoAddress."E-Mail");

        // CCRecipient.Add(LocationTo."Email CC");
        EmailMessage.Create(ToRecipient, 'Reminder for Order to store ' + pShiptoAddress.Code + ' ' + Format(pReminderDate), vBody, true, CCRecipient, BCCRecipient);
        //Email.OpenInEditor(EmailMessage, "Email Scenario"::"Work Order");



        Email.Send(EmailMessage, "Email Scenario"::"Work Order");
    end;
    //-1.0.0.268

    //+1.0.0.284
    //+1.0.0.283
    procedure HORECAOrderReminderManager()
    var
        UserSetup: Record "User Setup";
        SRSetup: Record "Sales & Receivables Setup";
        ShiptoAddress: Record "Ship-to Address";
        SalesHeaderCheck: Record "Sales Header";
        CompanyInfo: Record "Company Information";
        ReportSelections: Record "Report Selections";
        ReminderDate: Date;
        WeekDay: Integer;

        MinNextDeliveryDate: Date;

        EmailDay: Boolean;

        vBodyAdmin: Text;
        vBodyAdmin1: Text;
        vBodyAdmin2: Text;
        ShipRowCount: Integer;

        ToRecipient: List of [Text];
        CCRecipient: List of [Text];
        BCCRecipient: List of [Text];
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        NextAdminDate: Date;
        ShiptoAddressCount: Integer;
        OrdersPlacedCount: Integer;
        recRef: RecordRef;
        AttachementTempBlob: Codeunit "Temp Blob";
        AttachementInstream: InStream;
        AttachementOutStream: OutStream;
        RecipientType: Enum "Email Recipient Type";
        CustomReportSelection: Record "Custom Report Selection";
        ReportID: Integer;
    begin
        SRSetup.GET;
        CompanyInfo.GET;
        ShipRowCount := 0;

        UserSetup.RESET;
        UserSetup.SetFilter("HORECA Customer No.", '<>%1', '');
        if UserSetup.FindSet() then begin

            //create the admin message
            repeat
                clear(EmailMessage);
                Clear(Email);
                clear(AttachementTempBlob);
                ShiptoAddressCount := 0;
                OrdersPlacedCount := 0;
                vBodyAdmin := '';
                vBodyAdmin1 := '';
                vBodyAdmin2 := '';

                UserSetup.testfield("HORECA Min. Order Period");
                ReminderDate := CalcDate('+1D', WorkDate());
                MinNextDeliveryDate := ReminderDate;
                WeekDay := Date2DWY(ReminderDate, 1);


                //WeekDayAdmin := Date2DWY(WorkDate(), 1);
                NextAdminDate := CalcDate('+1D', WorkDate());

                ShiptoAddress.RESET;
                //ShiptoAddress.SetCurrentKey("Customer No.",Code, City, Name);
                ShiptoAddress.SetFilter("Customer No.", UserSetup."HORECA Customer No.");
                ShiptoAddress.SetFilter(Code, '%1', UserSetup."HORECA Ship-to Filter");
                ShiptoAddress.SetRange(Blocked, false);
                ShiptoAddress.SetRange("Notify Place Order", true);
                ShiptoAddress.SetFilter("E-Mail", '<>%1', '');
                if ShiptoAddress.FindSet() then begin
                    repeat
                        EmailDay := false;


                        if (ShiptoAddress.Monday) then begin

                            if WeekDay = 1 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Monday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Tuesday) then begin

                            if WeekDay = 2 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Tuesday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Wednesday) then begin

                            if WeekDay = 3 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Wednesday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Thursday) then begin

                            if WeekDay = 4 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Thursday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Friday) then begin

                            if WeekDay = 5 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Friday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Saturday) then begin

                            if WeekDay = 6 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Saturday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;

                        if (ShiptoAddress.Sunday) then begin

                            if WeekDay = 7 then begin
                                //EmailShiptoAddress(ShiptoAddress, ShiptoAddress.FieldCaption(Sunday), ReminderDate);
                                EmailDay := true;

                            end;


                        end;



                        if (EmailDay) then begin

                            //count where shipment will be tomorrow
                            ShiptoAddressCount += 1;

                            if ShiptoAddressCount = 1 then begin
                                EmailMessage.Create(ToRecipient, 'HORECA Reminder for Managers ' + UserSetup."User ID" + ' ' + Format(ReminderDate), vBodyAdmin, true, CCRecipient, BCCRecipient);
                            end;

                            SalesHeaderCheck.RESET;
                            SalesHeaderCheck.SetRange("Document Type", SalesHeaderCheck."Document Type"::Order);
                            SalesHeaderCheck.SetFilter("Sell-to Customer No.", ShiptoAddress."Customer No.");
                            SalesHeaderCheck.SetFilter("Ship-to Code", ShiptoAddress.code);
                            SalesHeaderCheck.SetFilter("Requested Delivery Date", '%1', ReminderDate);
                            if SalesHeaderCheck.Count = 0 then begin

                                // if not padmin then begin
                                //    EmailShiptoAddress(ShiptoAddress, Format(NextDeliveryDate1, 0, '<Weekday Text>'), NextDeliveryDate1);
                                // end;
                                //<p style="color:red">This is a paragraph.</p>

                                //Bellow Stores did not placed an order for tomorrow:
                                vBodyAdmin1 += '<font style="color:red">' + ShiptoAddress.Code + ' ' + ShiptoAddress.Name + ' (p) ' + ShiptoAddress."Phone No." + ' (e) ' + ShiptoAddress."E-Mail" + ' Next Delivery Date ' + Format(ReminderDate, 0, '<Weekday Text>') + ' ' + Format(ReminderDate) + ' </font></br>';

                            end else begin
                                SalesHeaderCheck.FindSet();
                                //Stores that have placed their orders for tomorrow’s Delivery
                                vBodyAdmin2 += ShiptoAddress.Code + ' ' + ShiptoAddress.Name + ' ' + ' (p) ' + ShiptoAddress."Phone No." + ' (e) ' + ShiptoAddress."E-Mail" + ' Next Delivery Date ' + Format(ReminderDate, 0, '<Weekday Text>') + ' ' + Format(ReminderDate) + ' </br>';
                                OrdersPlacedCount += 1;

                                //add the attachment
                                recRef.GetTable(SalesHeaderCheck);
                                recRef.SetView(SalesHeaderCheck.GetView());

                                AttachementTempBlob.CreateOutStream(AttachementOutStream);
                                ReportSelections.RESET;
                                ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Order");
                                if ReportSelections.FindSet() then begin

                                    ReportID := ReportSelections."Report ID";
                                    CustomReportSelection.RESET;
                                    CustomReportSelection.SetRange(Usage, ReportSelections.Usage);
                                    CustomReportSelection.SetRange("Source Type", 18);
                                    CustomReportSelection.SetFilter("Source No.", SalesHeaderCheck."Bill-to Customer No.");
                                    if CustomReportSelection.findset then begin
                                        ReportID := CustomReportSelection."Report ID";
                                    end;

                                    //ReportSelections.GetCustomReportSelectionByUsageOption(CustomReportSelection, SalesHeaderCheck."Bill-to Customer No.", ReportSelections.Usage, 18);

                                    // Message(FORMAT(ReportID));
                                    Report.SaveAs(ReportID, '', REPORTFORMAT::Pdf, AttachementOutStream, recRef);
                                END;
                                AttachementTempBlob.CreateInStream(AttachementInstream);
                                //'Sales Order' +
                                EmailMessage.AddAttachment(SalesHeaderCheck."Ship-to Code" + ' ' + FORMAT(SalesHeaderCheck."No.") + '.pdf', 'PDF', AttachementInstream);
                            end;
                        end;

                    until ShiptoAddress.Next() = 0;
                end;



                //Message(vBodyAdmin);

                if vBodyAdmin1 <> '' then begin
                    vBodyAdmin += '<mark>Bellow Stores did not place an order for tomorrow:</mark></br>';
                    vBodyAdmin += vBodyAdmin1;
                end;

                if vBodyAdmin2 <> '' then begin
                    vBodyAdmin += '<mark></br></br>Stores that have placed their orders for tomorrow’s Delivery</mark></br>';
                    vBodyAdmin += vBodyAdmin2;

                end;


                //overwrite message
                if (ShiptoAddressCount = OrdersPlacedCount) and (OrdersPlacedCount > 0) then begin
                    vBodyAdmin := '<mark></br></br>All stores (' + UserSetup.Name + ') have placed their orders for tomorrow’s Delivery</mark></br>';
                end;

                if (vBodyAdmin <> '') then begin
                    vBodyAdmin += '</br></br>This is an automatic messsage send from </br>';
                    vBodyAdmin += CompanyInfo.Name;

                    ToRecipient.Add(UserSetup."HORECA Manager Email 1");
                    ToRecipient.Add(UserSetup."HORECA Manager Email 2");
                    ToRecipient.Add(UserSetup."HORECA Manager Email 3");

                    if (ToRecipient.Count > 0) and (ShiptoAddressCount > 0) then begin

                        //create the message above to add the attachments in the loop
                        EmailMessage.SetBody(vBodyAdmin);
                        EmailMessage.SetRecipients(RecipientType::"To", ToRecipient);
                        EmailMessage.SetRecipients(RecipientType::"Cc", CCRecipient);
                        EmailMessage.SetRecipients(RecipientType::"Bcc", BCCRecipient);
                        Email.Send(EmailMessage, "Email Scenario"::"Work Order");
                    end;


                end;

            until UserSetup.Next() = 0;


        end;
    end;

    //1.0.0.283
    //-1.0.0.284

    //+1.0.0.292
    procedure ExportProductionOrderTemplate()
    var

        rL_ExcelBuf: Record "Excel Buffer" temporary;
        SheetNameTxt: Text;
    begin
        rL_ExcelBuf.NewRow;
        //col 1
        rL_ExcelBuf.AddColumn('Item No.', FALSE, '', TRUE, FALSE, TRUE, '', rL_ExcelBuf."Cell Type"::Text);
        //col 2
        rL_ExcelBuf.AddColumn('Description', FALSE, '', TRUE, FALSE, TRUE, '', rL_ExcelBuf."Cell Type"::Text);
        //col 3
        rL_ExcelBuf.AddColumn('Quantity', FALSE, '', TRUE, FALSE, TRUE, '', rL_ExcelBuf."Cell Type"::Text);

        SheetNameTxt := FORMAT('ProductionOrder_Template');
        rL_ExcelBuf.CreateNewBook(SheetNameTxt);   //Which will create a New Excel Book.
        rL_ExcelBuf.WriteSheet(SheetNameTxt, CompanyName, UserId);  //Write Data in Excel Sheet in New Book.
        rL_ExcelBuf.CloseBook();   //As Writing is complete we will close the book.
        rL_ExcelBuf.SetFriendlyFilename(SheetNameTxt);   //Optional to provide a valid Name to Excel File.
        rL_ExcelBuf.OpenExcel();  //Opens Downloads the Excel File for user.
    end;


    procedure ImportProductionOrderExcel()
    var

        fileInStream: InStream;
        FromFile: Text;
        SheetName: Text;
        ProductionOrder: Record "Production Order";
        ProdOrder: Record "Production Order";
        RowNo, MaxRowNo, LineNo : Integer;
        rL_ExcelBuf: Record "Excel Buffer" temporary;
        RowNoMax: Integer;
        ColumnNoMax: Integer;
        ColumnNo: Integer;
        Colmn1_Valid: Text;
        Colmn2_Valid: Text;
        Colmn3_Valid: Text;
        vL_LastLineNo: Integer;
        tmpDec: Decimal;
        Item: Record Item;
        Location: Record Location;
        LocationCode: Code[10];
        Text50001: Label 'Please Select Location Code.';
        vL_FileName: Text;
        rptRefreshProductionOrder: Report "Refresh Production Order";
    begin
        vL_FileName := cu_FileMgt.UploadFile(Text50000, ExcelFileExtensionTok);
        SheetName := rL_ExcelBuf.SelectSheetsName(vL_FileName);
        IF SheetName = '' THEN
            EXIT;

        rL_ExcelBuf.OpenBook(vL_FileName, SheetName);
        rL_ExcelBuf.ReadSheet;
        RowNo := 0;
        ColumnNo := 0;

        /*
        //This procedure allows you to upload a file to Business Central
        if not UploadIntoStream('Select the Excel file to Import', '', '', FromFile, fileInStream) then
            Error('');

        if FromFile = '' then
            Error('File not found');

        SheetName := rL_ExcelBuf.SelectSheetsNameStream(fileInStream);
        IF SheetName = '' THEN
            EXIT;


        //Subsequently, it loads the Excel Buffer data type with the information from the excel file.
        rL_ExcelBuf.Reset();
        rL_ExcelBuf.DeleteAll();
        rL_ExcelBuf.OpenBookStream(fileInStream, SheetName);
        rL_ExcelBuf.ReadSheet();
        */

        RowNo := 0;
        ColumnNo := 0;

        rL_ExcelBuf.RESET;
        rL_ExcelBuf.FINDLAST;
        RowNoMax := rL_ExcelBuf."Row No.";
        ColumnNoMax := 3; //ExcelBuffer."Column No."; //NOD0.2;


        //popup location
        Location.RESET;
        Location.setrange("Use As In-Transit", false);
        Location.setfilter(code, '<>%1', 'V*');
        if PAGE.RunModal(PAGE::"Location List", Location) = ACTION::LookupOK then begin
            LocationCode := Location.Code;
        end;

        if LocationCode = '' then begin
            Error(Text50001);
        end;


        FOR RowNo := 2 TO RowNoMax DO BEGIN
            rL_ExcelBuf.SETRANGE("Row No.", RowNo);

            //Column1 Item No.
            //Column2 Description
            //column3 Quantity

            Colmn1_Valid := '';
            Colmn2_Valid := '';
            Colmn3_Valid := '';

            FOR ColumnNo := 1 TO ColumnNoMax DO BEGIN
                rL_ExcelBuf.SETRANGE("Column No.", ColumnNo);
                IF rL_ExcelBuf.FINDFIRST THEN BEGIN
                    CASE ColumnNo OF

                        1:
                            BEGIN
                                EVALUATE(Colmn1_Valid, Trim(rL_ExcelBuf."Cell Value as Text"));
                            END;

                        2:
                            BEGIN
                                EVALUATE(Colmn2_Valid, Trim(rL_ExcelBuf."Cell Value as Text"));
                            END;
                        3:
                            BEGIN
                                EVALUATE(Colmn3_Valid, Trim(rL_ExcelBuf."Cell Value as Text"));
                            END;

                    END; //end case

                END;//end if
            END; //end for 2

            if (Colmn1_Valid <> '') and (Colmn3_Valid <> '') then begin
                //Message(LocationCode);
                Item.GET(Colmn1_Valid);

                Evaluate(tmpDec, Colmn3_Valid);
                //ProductionOrder
                clear(ProductionOrder);
                ProductionOrder.validate(Status, ProductionOrder.Status::Released);
                ProductionOrder.insert(true);

                ProductionOrder.validate("Source Type", ProductionOrder."Source Type"::Item);
                ProductionOrder.validate("Source No.", Item."No.");
                ProductionOrder.validate(Quantity, tmpDec);
                // ProductionOrder.validate("Packing Agent", Item."Packing Agent");
                ProductionOrder.validate("Location Code", LocationCode);
                ProductionOrder.modify(true);

                commit;
                //refresh production order
                ProdOrder.RESET;
                ProdOrder.SetRange(Status, ProductionOrder.Status);
                ProdOrder.SetRange("No.", ProductionOrder."No.");
                clear(rptRefreshProductionOrder);
                rptRefreshProductionOrder.settableview(ProdOrder);
                rptRefreshProductionOrder.UseRequestPage(false);
                rptRefreshProductionOrder.RUN();
                commit;
                //clear(ProdOrder);
                //ProdOrder.SetRange(Status, ProductionOrder.Status);
                //ProdOrder.SetRange("No.", ProductionOrder."No.");
                //REPORT.RunModal(REPORT::"Refresh Production Order", true, true, ProdOrder);

            end;

        END; //end for 1
             //-1.0.0.292

    end;

}