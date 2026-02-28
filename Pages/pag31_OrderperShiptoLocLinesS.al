page 50031 "Order per Ship-to Loc Lines S"
{
    // TAL0.2 2021/12/16 VC review captions
    // TAL0.3 2022/01/11 VC add field "Production BOM No."
    //                      add action Production BOM

    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = false;
    SourceTable = Item;
    SourceTableView = SORTING(Description);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                    trigger OnDrillDown();
                    var
                        rL_Item: Record Item;
                    begin
                        rL_Item.GET("No.");
                        PAGE.RUN(PAGE::"Item Card", rL_Item);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Qty. on Sales Order"; "Qty. on Sales Order")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. on SO';
                    DecimalPlaces = 0 : 1;
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Qty. on Sales Order';
                }
                field("Base Unit of Measure"; "Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Buom';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ToolTip = 'Base Unit of Measure';
                }
                field(vG_QtyPerBuom; vG_QtyPerBuom)
                {
                    ApplicationArea = All;
                    Caption = 'Qty/Buom';
                    DecimalPlaces = 0 : 1;
                    ToolTip = 'Qty Suom / Qty Buom  (Content of Buom)';
                }
                field("Qty. Out on Sales Order"; "Qty. Out on Sales Order")
                {
                    ApplicationArea = All;
                    Caption = 'Qty/Suom';
                    ToolTip = 'Qty. Outstanding on Sales Order';
                }
                field("Sales Unit of Measure"; "Sales Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Production BOM No."; "Production BOM No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Routing No."; "Routing No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Field1; MATRIX_CellDataBase[1])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field1Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field1Qty; MATRIX_CellDataQty[1])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[1];
                    Caption = 'Field1Qty';
                    DecimalPlaces = 0 : 0;
                    ToolTip = 'Qty';
                    Visible = Field1VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(1);
                    end;
                }
                field(Field2; MATRIX_CellDataBase[2])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field2Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field2Qty; MATRIX_CellDataQty[2])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[2];
                    DecimalPlaces = 0 : 0;
                    Visible = Field2VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellDataBase[3])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field3Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field3Qty; MATRIX_CellDataQty[3])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[3];
                    DecimalPlaces = 0 : 0;
                    Visible = Field3VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellDataBase[4])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field4Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field4Qty; MATRIX_CellDataQty[4])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[4];
                    DecimalPlaces = 0 : 0;
                    Visible = Field4VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellDataBase[5])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field5Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field5Qty; MATRIX_CellDataQty[5])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[5];
                    DecimalPlaces = 0 : 0;
                    Visible = Field5VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(5);
                    end;
                }
                field(Field6; MATRIX_CellDataBase[6])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field6Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field6Qty; MATRIX_CellDataQty[6])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[6];
                    DecimalPlaces = 0 : 0;
                    Visible = Field6VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(6);
                    end;
                }
                field(Field7; MATRIX_CellDataBase[7])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field7Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field7Qty; MATRIX_CellDataQty[7])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[7];
                    DecimalPlaces = 0 : 0;
                    Visible = Field7VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(7);
                    end;
                }
                field(Field8; MATRIX_CellDataBase[8])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field8Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field8Qty; MATRIX_CellDataQty[8])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[8];
                    DecimalPlaces = 0 : 0;
                    Visible = Field8VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(8);
                    end;
                }
                field(Field9; MATRIX_CellDataBase[9])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field9Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field9Qty; MATRIX_CellDataQty[9])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[9];
                    DecimalPlaces = 0 : 0;
                    Visible = Field9VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(9);
                    end;
                }
                field(Field10; MATRIX_CellDataBase[10])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field10Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field10Qty; MATRIX_CellDataQty[10])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[10];
                    DecimalPlaces = 0 : 0;
                    Visible = Field10VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(10);
                    end;
                }
                field(Field11; MATRIX_CellDataBase[11])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field11Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field11Qty; MATRIX_CellDataQty[11])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[11];
                    DecimalPlaces = 0 : 0;
                    Visible = Field11VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(11);
                    end;
                }
                field(Field12; MATRIX_CellDataBase[12])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field12Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field12Qty; MATRIX_CellDataQty[12])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[12];
                    DecimalPlaces = 0 : 0;
                    Visible = Field12VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(12);
                    end;
                }
                field(Field13; MATRIX_CellDataBase[13])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field13Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field13Qty; MATRIX_CellDataQty[13])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[13];
                    DecimalPlaces = 0 : 0;
                    Visible = Field13VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(13);
                    end;
                }
                field(Field14; MATRIX_CellDataBase[14])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field14Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field14Qty; MATRIX_CellDataQty[14])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[14];
                    DecimalPlaces = 0 : 0;
                    Visible = Field14VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(14);
                    end;
                }
                field(Field15; MATRIX_CellDataBase[15])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field15Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field15Qty; MATRIX_CellDataQty[15])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[15];
                    DecimalPlaces = 0 : 0;
                    Visible = Field15VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(15);
                    end;
                }
                field(Field16; MATRIX_CellDataBase[16])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field16Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field16Qty; MATRIX_CellDataQty[16])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[16];
                    DecimalPlaces = 0 : 0;
                    Visible = Field16VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(16);
                    end;
                }
                field(Field17; MATRIX_CellDataBase[17])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field17Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field17Qty; MATRIX_CellDataQty[17])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[17];
                    DecimalPlaces = 0 : 0;
                    Visible = Field17VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(17);
                    end;
                }
                field(Field18; MATRIX_CellDataBase[18])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field18Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field18Qty; MATRIX_CellDataQty[18])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[18];
                    DecimalPlaces = 0 : 0;
                    Visible = Field18VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(18);
                    end;
                }
                field(Field19; MATRIX_CellDataBase[19])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field19Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field19Qty; MATRIX_CellDataQty[19])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[19];
                    DecimalPlaces = 0 : 0;
                    Visible = Field19VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(19);
                    end;
                }
                field(Field20; MATRIX_CellDataBase[20])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field20Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field20Qty; MATRIX_CellDataQty[20])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[20];
                    DecimalPlaces = 0 : 0;
                    Visible = Field20VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(20);
                    end;
                }
                field(Field21Qty; MATRIX_CellDataQty[21])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21];
                    DecimalPlaces = 0 : 0;
                    Visible = Field21VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field21; MATRIX_CellDataBase[21])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[21] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field21Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(21);
                    end;
                }
                field(Field22; MATRIX_CellDataBase[22])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field22Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field22Qty; MATRIX_CellDataQty[22])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[22];
                    DecimalPlaces = 0 : 0;
                    Visible = Field22VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(22);
                    end;
                }
                field(Field23; MATRIX_CellDataBase[23])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field23Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field23Qty; MATRIX_CellDataQty[23])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[23];
                    DecimalPlaces = 0 : 0;
                    Visible = Field23VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(23);
                    end;
                }
                field(Field24; MATRIX_CellDataBase[24])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field24Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field24Qty; MATRIX_CellDataQty[24])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[24];
                    DecimalPlaces = 0 : 0;
                    Visible = Field24VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(24);
                    end;
                }
                field(Field25; MATRIX_CellDataBase[25])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field25Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field25Qty; MATRIX_CellDataQty[25])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[25];
                    DecimalPlaces = 0 : 0;
                    Visible = Field25VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(25);
                    end;
                }
                field(Field26; MATRIX_CellDataBase[26])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field26Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field26Qty; MATRIX_CellDataQty[26])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[26];
                    DecimalPlaces = 0 : 0;
                    Visible = Field26VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(26);
                    end;
                }
                field(Field27; MATRIX_CellDataBase[27])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field27Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field27Qty; MATRIX_CellDataQty[27])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[27];
                    DecimalPlaces = 0 : 0;
                    Visible = Field27VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(27);
                    end;
                }
                field(Field28; MATRIX_CellDataBase[28])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field28Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field28Qty; MATRIX_CellDataQty[28])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[28];
                    DecimalPlaces = 0 : 0;
                    Visible = Field28VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(28);
                    end;
                }
                field(Field29; MATRIX_CellDataBase[29])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field29Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field29Qty; MATRIX_CellDataQty[29])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[29];
                    DecimalPlaces = 0 : 0;
                    Visible = Field29VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(29);
                    end;
                }
                field(Field30; MATRIX_CellDataBase[30])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field30Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field30Qty; MATRIX_CellDataQty[30])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[30];
                    DecimalPlaces = 0 : 0;
                    Visible = Field30VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(30);
                    end;
                }
                field(Field31; MATRIX_CellDataBase[31])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field31Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field31Qty; MATRIX_CellDataQty[31])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[31];
                    DecimalPlaces = 0 : 0;
                    Visible = Field31VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(31);
                    end;
                }
                field(Field32; MATRIX_CellDataBase[32])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field32Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(32);
                    end;
                }
                field(Field32Qty; MATRIX_CellDataQty[32])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[32];
                    DecimalPlaces = 0 : 0;
                    Visible = Field32VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(32);
                    end;
                }
                field(Field33; MATRIX_CellDataBase[33])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[33] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field33Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(33);
                    end;
                }
                field(Field33Qty; MATRIX_CellDataQty[33])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[33];
                    DecimalPlaces = 0 : 0;
                    Visible = Field33VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(33);
                    end;
                }
                field(Field34; MATRIX_CellDataBase[34])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[34] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field34Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(34);
                    end;
                }
                field(Field34Qty; MATRIX_CellDataQty[34])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[34];
                    DecimalPlaces = 0 : 0;
                    Visible = Field34VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(34);
                    end;
                }
                field(Field35; MATRIX_CellDataBase[35])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[35] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field35Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(35);
                    end;
                }
                field(Field35Qty; MATRIX_CellDataQty[35])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[35];
                    DecimalPlaces = 0 : 0;
                    Visible = Field35VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(35);
                    end;
                }
                field(Field36; MATRIX_CellDataBase[36])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[36] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field36Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(36);
                    end;
                }
                field(Field36Qty; MATRIX_CellDataQty[36])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[36];
                    DecimalPlaces = 0 : 0;
                    Visible = Field36VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(36);
                    end;
                }
                field(Field37; MATRIX_CellDataBase[37])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[37] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field37Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(37);
                    end;
                }
                field(Field37Qty; MATRIX_CellDataQty[37])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[37];
                    DecimalPlaces = 0 : 0;
                    Visible = Field37VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(37);
                    end;
                }
                field(Field38; MATRIX_CellDataBase[38])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[38] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field38Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(38);
                    end;
                }
                field(Field38Qty; MATRIX_CellDataQty[38])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[38];
                    DecimalPlaces = 0 : 0;
                    Visible = Field38VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(38);
                    end;
                }
                field(Field39; MATRIX_CellDataBase[39])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[39] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field39Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(39);
                    end;
                }
                field(Field39Qty; MATRIX_CellDataQty[39])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[39];
                    DecimalPlaces = 0 : 0;
                    Visible = Field39VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(39);
                    end;
                }
                field(Field40; MATRIX_CellDataBase[40])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[40] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field40Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(40);
                    end;
                }
                field(Field40Qty; MATRIX_CellDataQty[40])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[40];
                    DecimalPlaces = 0 : 0;
                    Visible = Field40VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(40);
                    end;
                }
                field(Field41; MATRIX_CellDataBase[41])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[41] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field41Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(41);
                    end;
                }
                field(Field41Qty; MATRIX_CellDataQty[41])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[41];
                    DecimalPlaces = 0 : 0;
                    Visible = Field41VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(41);
                    end;
                }
                field(Field42; MATRIX_CellDataBase[42])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[42] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field42Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(42);
                    end;
                }
                field(Field42Qty; MATRIX_CellDataQty[42])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[42];
                    DecimalPlaces = 0 : 0;
                    Visible = Field42VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(42);
                    end;
                }
                field(Field43; MATRIX_CellDataBase[43])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[43] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field43Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(43);
                    end;
                }
                field(Field43Qty; MATRIX_CellDataQty[43])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[43];
                    DecimalPlaces = 0 : 0;
                    Visible = Field43VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(43);
                    end;
                }
                field(Field44; MATRIX_CellDataBase[44])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[44] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field44Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(44);
                    end;
                }
                field(Field44Qty; MATRIX_CellDataQty[44])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[44];
                    DecimalPlaces = 0 : 0;
                    Visible = Field44VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(44);
                    end;
                }
                field(Field45; MATRIX_CellDataBase[45])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[45] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field45Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(45);
                    end;
                }
                field(Field45Qty; MATRIX_CellDataQty[45])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[45];
                    DecimalPlaces = 0 : 0;
                    Visible = Field45VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(45);
                    end;
                }
                field(Field46; MATRIX_CellDataBase[46])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[46] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field46Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(46);
                    end;
                }
                field(Field46Qty; MATRIX_CellDataQty[46])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[46];
                    DecimalPlaces = 0 : 0;
                    Visible = Field46VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(46);
                    end;
                }
                field(Field47; MATRIX_CellDataBase[47])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[47] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field47Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(47);
                    end;
                }
                field(Field47Qty; MATRIX_CellDataQty[47])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[47];
                    DecimalPlaces = 0 : 0;
                    Visible = Field47VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(47);
                    end;
                }
                field(Field48; MATRIX_CellDataBase[48])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[48] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field48Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(48);
                    end;
                }
                field(Field48Qty; MATRIX_CellDataQty[48])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[48];
                    DecimalPlaces = 0 : 0;
                    Visible = Field48VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(48);
                    end;
                }
                field(Field49; MATRIX_CellDataBase[49])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[49] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field49Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(49);
                    end;
                }
                field(Field49Qty; MATRIX_CellDataQty[49])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[49];
                    DecimalPlaces = 0 : 0;
                    Visible = Field49VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(49);
                    end;
                }
                field(Field50; MATRIX_CellDataBase[50])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[50] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field50Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(50);
                    end;
                }
                field(Field50Qty; MATRIX_CellDataQty[50])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[50];
                    DecimalPlaces = 0 : 0;
                    Visible = Field50VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(50);
                    end;
                }
                field(Field51; MATRIX_CellDataBase[51])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[51] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field51Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(51);
                    end;
                }
                field(Field51Qty; MATRIX_CellDataQty[51])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[51];
                    DecimalPlaces = 0 : 0;
                    Visible = Field51VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(51);
                    end;
                }
                field(Field52; MATRIX_CellDataBase[52])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[52] + FORMAT(NewLine) + FORMAT(NewLine2) + ' Base';
                    DecimalPlaces = 0 : 0;
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = Field52Visible;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(52);
                    end;
                }
                field(Field52Qty; MATRIX_CellDataQty[52])
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaption[52];
                    DecimalPlaces = 0 : 0;
                    Visible = Field52VisibleQty;

                    trigger OnDrillDown();
                    begin
                        MatrixOnDrillDown(52);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Order Details")
            {
                ApplicationArea = All;
                Image = Line;

                trigger OnAction();
                var
                    rL_SalesLine: Record "Sales Line";
                begin

                    CLEAR(rL_SalesLine);
                    rL_SalesLine.RESET;
                    rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
                    rL_SalesLine.SETFILTER("No.", "No.");
                    if DateFilter <> '' then begin
                        rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
                    end;
                    if rL_SalesLine.FINDSET then begin

                    end;


                    PAGE.RUN(0, rL_SalesLine);
                end;
            }
            action("Production BOM")
            {
                ApplicationArea = All;
                Caption = 'Production BOM';
                Image = BOM;
                RunObject = Page "Production BOM";
                RunPageLink = "No." = FIELD("Production BOM No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        SetGlobalFilters();
    end;

    trigger OnAfterGetRecord();
    var
        MATRIX_CurrentColumnOrdinal: Integer;
    begin
        SetGlobalFilters();
        //IF DateFilter<>'' THEN BEGIN

        //WHERE(Qty. on Sales Order=FILTER(<>0),Global Dimension 2 Code=CONST(F-CUTS))
        //  END;



        MATRIX_CurrentColumnOrdinal := 0;
        while MATRIX_CurrentColumnOrdinal < MATRIX_CurrentNoOfMatrixColumn do begin
            MATRIX_CurrentColumnOrdinal := MATRIX_CurrentColumnOrdinal + 1;
            MATRIX_OnAfterGetRecord(MATRIX_CurrentColumnOrdinal);
        end;

        //SETFILTER("Date Filter",'%1',ShipmentDateFilter);
        //SETFILTER("Qty. on Sales Order",'<>%1',0);
        //SETFILTER("Global Dimension 2 Code",'F-CUTS');

        vG_QtyPerBuom := 0;
        CALCFIELDS("Qty. Out on Sales Order", "Qty. on Sales Order");
        if "Qty. Out on Sales Order" <> 0 then begin
            vG_QtyPerBuom := "Qty. Out on Sales Order" / "Qty. on Sales Order";
        end;
    end;

    trigger OnInit();
    begin
        Field52Visible := true;
        Field51Visible := true;
        Field50Visible := true;
        Field49Visible := true;
        Field48Visible := true;
        Field47Visible := true;
        Field46Visible := true;
        Field45Visible := true;
        Field44Visible := true;
        Field43Visible := true;
        Field42Visible := true;
        Field41Visible := true;
        Field40Visible := true;
        Field39Visible := true;
        Field38Visible := true;
        Field37Visible := true;
        Field36Visible := true;
        Field35Visible := true;
        Field34Visible := true;
        Field33Visible := true;

        Field32Visible := true;
        Field31Visible := true;
        Field30Visible := true;
        Field29Visible := true;
        Field28Visible := true;
        Field27Visible := true;
        Field26Visible := true;
        Field25Visible := true;
        Field24Visible := true;
        Field23Visible := true;
        Field22Visible := true;
        Field21Visible := true;
        Field20Visible := true;
        Field19Visible := true;
        Field18Visible := true;
        Field17Visible := true;
        Field16Visible := true;
        Field15Visible := true;
        Field14Visible := true;
        Field13Visible := true;
        Field12Visible := true;
        Field11Visible := true;
        Field10Visible := true;
        Field9Visible := true;
        Field8Visible := true;
        Field7Visible := true;
        Field6Visible := true;
        Field5Visible := true;
        Field4Visible := true;
        Field3Visible := true;
        Field2Visible := true;
        Field1Visible := true;

        //+TAL0.8
        //Qty
        Field52VisibleQty := false;// rG_MarketingSetup."Matrix Report Show Qty";
        Field51VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field50VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field49VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field48VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field47VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field46VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field45VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field44VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field43VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field42VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field41VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field40VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field39VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field38VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field37VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field36VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field35VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field34VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field33VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";

        Field32VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field31VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field30VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field29VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field28VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field27VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field26VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field25VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field24VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field23VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field22VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field21VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field20VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field19VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field18VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field17VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field16VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field15VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field14VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field13VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field12VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field11VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field10VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field9VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field8VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field7VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field6VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field5VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field4VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field3VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field2VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";
        Field1VisibleQty := false;//  rG_MarketingSetup."Matrix Report Show Qty";

        NewLine := 13;
        NewLine2 := 10;
    end;

    trigger OnOpenPage();
    begin
        SetGlobalFilters();
        //RESET;
        //SETFILTER("Qty. on Sales Order",'<>%1',0);
        //IF DateFilter<>'' THEN BEGIN
        //SETFILTER("Date Filter",DateFilter);
        //END;


        SetColumnVisibility;
    end;

    var
        [InDataSet]
        Field1Visible: Boolean;
        [InDataSet]
        Field2Visible: Boolean;
        [InDataSet]
        Field3Visible: Boolean;
        [InDataSet]
        Field4Visible: Boolean;
        [InDataSet]
        Field5Visible: Boolean;
        [InDataSet]
        Field6Visible: Boolean;
        [InDataSet]
        Field7Visible: Boolean;
        [InDataSet]
        Field8Visible: Boolean;
        [InDataSet]
        Field9Visible: Boolean;
        [InDataSet]
        Field10Visible: Boolean;
        [InDataSet]
        Field11Visible: Boolean;
        [InDataSet]
        Field12Visible: Boolean;
        [InDataSet]
        Field13Visible: Boolean;
        [InDataSet]
        Field14Visible: Boolean;
        [InDataSet]
        Field15Visible: Boolean;
        [InDataSet]
        Field16Visible: Boolean;
        [InDataSet]
        Field17Visible: Boolean;
        [InDataSet]
        Field18Visible: Boolean;
        [InDataSet]
        Field19Visible: Boolean;
        [InDataSet]
        Field20Visible: Boolean;
        [InDataSet]
        Field21Visible: Boolean;
        [InDataSet]
        Field22Visible: Boolean;
        [InDataSet]
        Field23Visible: Boolean;
        [InDataSet]
        Field24Visible: Boolean;
        [InDataSet]
        Field25Visible: Boolean;
        [InDataSet]
        Field26Visible: Boolean;
        [InDataSet]
        Field27Visible: Boolean;
        [InDataSet]
        Field28Visible: Boolean;
        [InDataSet]
        Field29Visible: Boolean;
        [InDataSet]
        Field30Visible: Boolean;
        [InDataSet]
        Field31Visible: Boolean;
        [InDataSet]
        Field32Visible: Boolean;
        [InDataSet]
        Field33Visible: Boolean;
        [InDataSet]
        Field34Visible: Boolean;
        [InDataSet]
        Field35Visible: Boolean;
        [InDataSet]
        Field36Visible: Boolean;
        [InDataSet]
        Field37Visible: Boolean;
        [InDataSet]
        Field38Visible: Boolean;
        [InDataSet]
        Field39Visible: Boolean;
        [InDataSet]
        Field40Visible: Boolean;
        [InDataSet]
        Field41Visible: Boolean;
        [InDataSet]
        Field42Visible: Boolean;
        [InDataSet]
        Field43Visible: Boolean;
        [InDataSet]
        Field44Visible: Boolean;
        [InDataSet]
        Field45Visible: Boolean;
        [InDataSet]
        Field46Visible: Boolean;
        [InDataSet]
        Field47Visible: Boolean;
        [InDataSet]
        Field48Visible: Boolean;
        [InDataSet]
        Field49Visible: Boolean;
        [InDataSet]
        Field50Visible: Boolean;
        [InDataSet]
        Field51Visible: Boolean;
        [InDataSet]
        Field52Visible: Boolean;
        [InDataSet]
        Field1VisibleQty: Boolean;
        [InDataSet]
        Field2VisibleQty: Boolean;
        [InDataSet]
        Field3VisibleQty: Boolean;
        [InDataSet]
        Field4VisibleQty: Boolean;
        [InDataSet]
        Field5VisibleQty: Boolean;
        [InDataSet]
        Field6VisibleQty: Boolean;
        [InDataSet]
        Field7VisibleQty: Boolean;
        [InDataSet]
        Field8VisibleQty: Boolean;
        [InDataSet]
        Field9VisibleQty: Boolean;
        [InDataSet]
        Field10VisibleQty: Boolean;
        [InDataSet]
        Field11VisibleQty: Boolean;
        [InDataSet]
        Field12VisibleQty: Boolean;
        [InDataSet]
        Field13VisibleQty: Boolean;
        [InDataSet]
        Field14VisibleQty: Boolean;
        [InDataSet]
        Field15VisibleQty: Boolean;
        [InDataSet]
        Field16VisibleQty: Boolean;
        [InDataSet]
        Field17VisibleQty: Boolean;
        [InDataSet]
        Field18VisibleQty: Boolean;
        [InDataSet]
        Field19VisibleQty: Boolean;
        [InDataSet]
        Field20VisibleQty: Boolean;
        [InDataSet]
        Field21VisibleQty: Boolean;
        [InDataSet]
        Field22VisibleQty: Boolean;
        [InDataSet]
        Field23VisibleQty: Boolean;
        [InDataSet]
        Field24VisibleQty: Boolean;
        [InDataSet]
        Field25VisibleQty: Boolean;
        [InDataSet]
        Field26VisibleQty: Boolean;
        [InDataSet]
        Field27VisibleQty: Boolean;
        [InDataSet]
        Field28VisibleQty: Boolean;
        [InDataSet]
        Field29VisibleQty: Boolean;
        [InDataSet]
        Field30VisibleQty: Boolean;
        [InDataSet]
        Field31VisibleQty: Boolean;
        [InDataSet]
        Field32VisibleQty: Boolean;
        [InDataSet]
        Field33VisibleQty: Boolean;
        [InDataSet]
        Field34VisibleQty: Boolean;
        [InDataSet]
        Field35VisibleQty: Boolean;
        [InDataSet]
        Field36VisibleQty: Boolean;
        [InDataSet]
        Field37VisibleQty: Boolean;
        [InDataSet]
        Field38VisibleQty: Boolean;
        [InDataSet]
        Field39VisibleQty: Boolean;
        [InDataSet]
        Field40VisibleQty: Boolean;
        [InDataSet]
        Field41VisibleQty: Boolean;
        [InDataSet]
        Field42VisibleQty: Boolean;
        [InDataSet]
        Field43VisibleQty: Boolean;
        [InDataSet]
        Field44VisibleQty: Boolean;
        [InDataSet]
        Field45VisibleQty: Boolean;
        [InDataSet]
        Field46VisibleQty: Boolean;
        [InDataSet]
        Field47VisibleQty: Boolean;
        [InDataSet]
        Field48VisibleQty: Boolean;
        [InDataSet]
        Field49VisibleQty: Boolean;
        [InDataSet]
        Field50VisibleQty: Boolean;
        [InDataSet]
        Field51VisibleQty: Boolean;
        [InDataSet]
        Field52VisibleQty: Boolean;
        MatrixRecords: array[52] of Record "Ship-to Address";
        rG_SalesLine: Record "Sales Line";
        Show: Boolean;
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MATRIX_CellDataBase: array[52] of Decimal;
        MATRIX_CellDataQty: array[52] of Decimal;
        MATRIX_ColumnCaption: array[52] of Text[80];
        NewLine: Char;
        NewLine2: Char;
        DateFilter: Text;
        vG_QtyPerBuom: Decimal;
        rG_GLSetup: Record "General Ledger Setup";

    local procedure MATRIX_OnAfterGetRecord(ColumnID: Integer);
    var
        rL_SalesLine: Record "Sales Line";
        vL_QtyBase: Decimal;
        vL_Qty: Decimal;
        DimSetEntry: Record "Dimension Set Entry";
    begin
        // StyleTxt[ColumnID]:='';
        //IF MATRIX_ColumnCaption[ColumnID]='' THEN BEGIN
        //  EXIT;
        //END;

        vL_QtyBase := 0;
        vL_Qty := 0;
        //MATRIX_ColumnFilter[ColumnID] is the ship-to code
        CLEAR(rL_SalesLine);
        rL_SalesLine.RESET;
        rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
        rL_SalesLine.SETFILTER("No.", "No.");
        rL_SalesLine.SETFILTER("Ship-to Code", MatrixRecords[ColumnID].Code);
        if DateFilter <> '' then begin
            //rL_SalesLine.SETRANGE("Shipment Date",ShipmentDateFilter);
            rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
            //SETFILTER("Date Filter",'%1',ShipmentDateFilter);

        end;
        if rL_SalesLine.FINDSET then begin


            repeat
                // IF DimSetEntry.GET(rL_SalesLine."Dimension Set ID",'CUSTOMERGROUP') THEN BEGIN
                //ShortcutDimExtraCode[5] := DimSetEntry."Dimension Value Code";
                //IF DimSetEntry."Dimension Value Code" = MatrixRecords[ColumnID].Code THEN BEGIN
                vL_QtyBase += rL_SalesLine."Quantity (Base)";
                vL_Qty += rL_SalesLine.Quantity;
            // END;
            //END;

            until rL_SalesLine.NEXT = 0;

            // StyleTxt[ColumnID] := rL_Campaign.SetStyle;
        end;


        MATRIX_CellDataBase[ColumnID] := vL_QtyBase;
        MATRIX_CellDataQty[ColumnID] := vL_Qty;



        //SetVisible;
    end;

    procedure Load(NewMatrixColumns: array[52] of Text[1024]; NewMatrixRecords: array[52] of Record "Ship-to Address"; NewCurrentNoOfMatrixColumns: Integer; NewShow: Boolean; NewDateFilter: Text);
    begin



        COPYARRAY(MATRIX_ColumnCaption, NewMatrixColumns, 1);
        COPYARRAY(MatrixRecords, NewMatrixRecords, 1);
        MATRIX_CurrentNoOfMatrixColumn := NewCurrentNoOfMatrixColumns;
        Show := NewShow;
        DateFilter := NewDateFilter;

        //RESET;
        //SETFILTER("No. of Campaigns",'<>%1',0);

        //MESSAGE(FORMAT(DateFilter));
        SetGlobalFilters();
        //RESET;
        //SETFILTER("Qty. on Sales Order",'<>%1',0);
        //IF DateFilter<>'' THEN BEGIN
        //SETFILTER("Date Filter",DateFilter);
        //END;
    end;

    procedure MatrixOnDrillDown(ColumnID: Integer);
    var
        rL_SalesLine: Record "Sales Line";
    begin
        //+TAL0.1
        CLEAR(rL_SalesLine);
        rL_SalesLine.RESET;
        rL_SalesLine.SETRANGE(Type, rL_SalesLine.Type::Item);
        rL_SalesLine.SETFILTER("No.", "No.");
        rL_SalesLine.SETFILTER("Ship-to Code", MatrixRecords[ColumnID].Code);
        if DateFilter <> '' then begin
            rL_SalesLine.SETFILTER("Shipment Date", DateFilter);
        end;
        if rL_SalesLine.FINDSET then begin
            // StyleTxt[ColumnID] := rL_Campaign.SetStyle;
        end;
        //EVALUATE(StartingDate,MATRIX_ColumnFilter[ColumnID]);

        PAGE.RUN(0, rL_SalesLine);
        //-TAL0.1
    end;

    procedure SetColumnVisibility();
    begin
        Field1Visible := MATRIX_CurrentNoOfMatrixColumn >= 1;
        Field2Visible := MATRIX_CurrentNoOfMatrixColumn >= 2;
        Field3Visible := MATRIX_CurrentNoOfMatrixColumn >= 3;
        Field4Visible := MATRIX_CurrentNoOfMatrixColumn >= 4;
        Field5Visible := MATRIX_CurrentNoOfMatrixColumn >= 5;
        Field6Visible := MATRIX_CurrentNoOfMatrixColumn >= 6;
        Field7Visible := MATRIX_CurrentNoOfMatrixColumn >= 7;
        Field8Visible := MATRIX_CurrentNoOfMatrixColumn >= 8;
        Field9Visible := MATRIX_CurrentNoOfMatrixColumn >= 9;
        Field10Visible := MATRIX_CurrentNoOfMatrixColumn >= 10;
        Field11Visible := MATRIX_CurrentNoOfMatrixColumn >= 11;
        Field12Visible := MATRIX_CurrentNoOfMatrixColumn >= 12;
        Field13Visible := MATRIX_CurrentNoOfMatrixColumn >= 13;
        Field14Visible := MATRIX_CurrentNoOfMatrixColumn >= 14;
        Field15Visible := MATRIX_CurrentNoOfMatrixColumn >= 15;
        Field16Visible := MATRIX_CurrentNoOfMatrixColumn >= 16;
        Field17Visible := MATRIX_CurrentNoOfMatrixColumn >= 17;
        Field18Visible := MATRIX_CurrentNoOfMatrixColumn >= 18;
        Field19Visible := MATRIX_CurrentNoOfMatrixColumn >= 19;
        Field20Visible := MATRIX_CurrentNoOfMatrixColumn >= 20;
        Field21Visible := MATRIX_CurrentNoOfMatrixColumn >= 21;
        Field22Visible := MATRIX_CurrentNoOfMatrixColumn >= 22;
        Field23Visible := MATRIX_CurrentNoOfMatrixColumn >= 23;
        Field24Visible := MATRIX_CurrentNoOfMatrixColumn >= 24;
        Field25Visible := MATRIX_CurrentNoOfMatrixColumn >= 25;
        Field26Visible := MATRIX_CurrentNoOfMatrixColumn >= 26;
        Field27Visible := MATRIX_CurrentNoOfMatrixColumn >= 27;
        Field28Visible := MATRIX_CurrentNoOfMatrixColumn >= 28;
        Field29Visible := MATRIX_CurrentNoOfMatrixColumn >= 29;
        Field30Visible := MATRIX_CurrentNoOfMatrixColumn >= 30;
        Field31Visible := MATRIX_CurrentNoOfMatrixColumn >= 31;
        Field32Visible := MATRIX_CurrentNoOfMatrixColumn >= 32;

        Field33Visible := MATRIX_CurrentNoOfMatrixColumn >= 33;
        Field34Visible := MATRIX_CurrentNoOfMatrixColumn >= 34;
        Field35Visible := MATRIX_CurrentNoOfMatrixColumn >= 35;
        Field36Visible := MATRIX_CurrentNoOfMatrixColumn >= 36;
        Field37Visible := MATRIX_CurrentNoOfMatrixColumn >= 37;
        Field38Visible := MATRIX_CurrentNoOfMatrixColumn >= 38;
        Field39Visible := MATRIX_CurrentNoOfMatrixColumn >= 39;
        Field40Visible := MATRIX_CurrentNoOfMatrixColumn >= 40;
        Field41Visible := MATRIX_CurrentNoOfMatrixColumn >= 41;
        Field42Visible := MATRIX_CurrentNoOfMatrixColumn >= 42;
        Field43Visible := MATRIX_CurrentNoOfMatrixColumn >= 43;
        Field44Visible := MATRIX_CurrentNoOfMatrixColumn >= 44;
        Field45Visible := MATRIX_CurrentNoOfMatrixColumn >= 45;
        Field46Visible := MATRIX_CurrentNoOfMatrixColumn >= 46;
        Field47Visible := MATRIX_CurrentNoOfMatrixColumn >= 47;
        Field48Visible := MATRIX_CurrentNoOfMatrixColumn >= 48;
        Field49Visible := MATRIX_CurrentNoOfMatrixColumn >= 49;
        Field50Visible := MATRIX_CurrentNoOfMatrixColumn >= 50;
        Field51Visible := MATRIX_CurrentNoOfMatrixColumn >= 51;
        Field52Visible := MATRIX_CurrentNoOfMatrixColumn >= 52;

        //+TAL0.8
        //Qty
        Field1VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 1); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field2VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 2); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field3VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 3); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field4VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 4); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field5VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 5); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field6VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 6); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field7VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 7); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field8VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 8); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field9VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 9); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field10VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 10); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field11VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 11); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field12VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 12); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field13VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 13); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field14VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 14); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field15VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 15); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field16VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 16); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field17VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 17); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field18VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 18); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field19VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 19); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field20VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 20); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field21VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 21); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field22VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 22); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field23VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 23); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field24VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 24); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field25VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 25); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field26VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 26); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field27VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 27); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field28VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 28); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field29VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 29); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field30VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 30); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field31VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 31); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field32VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 32); // (rG_MarketingSetup."Matrix Report Show Qty");

        Field33VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 33); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field34VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 34); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field35VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 35); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field36VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 36); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field37VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 37); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field38VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 38); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field39VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 39); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field40VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 40); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field41VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 41); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field42VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 42); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field43VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 43); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field44VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 44); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field45VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 45); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field46VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 46); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field47VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 47); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field48VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 48); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field49VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 49); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field50VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 50); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field51VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 51); // (rG_MarketingSetup."Matrix Report Show Qty");
        Field52VisibleQty := (MATRIX_CurrentNoOfMatrixColumn >= 52); // (rG_MarketingSetup."Matrix Report Show Qty");



        //-TAL0.8
    end;

    local procedure SetGlobalFilters();
    begin
        SETFILTER("Date Filter", DateFilter);

        if DateFilter = '' then begin
            //MESSAGE(FORMAT(Rec.FILTERGROUP));
            //Rec.FILTERGROUP(0);
            //Rec.SETFILTER("Global Dimension 2 Code",'');

            //Rec.FILTERGROUP(1);
            //Rec.SETFILTER("Global Dimension 2 Code",'');
            //Rec.SETFILTER(<field>,'')
            RESET;
            //CLEARMARKS;
        end;

        SETFILTER("Qty. on Sales Order", '<>%1', 0);
        SETFILTER("Global Dimension 2 Code", 'F-CUTS');
    end;

    procedure ShowFilters();
    begin
        MESSAGE(Rec.GETFILTERS);
    end;

    procedure ResetFilters();
    begin
        RESET;
    end;
}

