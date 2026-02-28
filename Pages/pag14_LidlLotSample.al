page 50014 "Lidl Lot Sample"
{
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Start"; "Period Start")
                {
                    ApplicationArea = all;
                }
                field(vl_ExtDocNo; vl_ExtDocNo)
                {
                    Caption = 'vl_ExtDocNo';
                    ApplicationArea = all;
                }
                field("Period No."; "Period No.")
                {
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Period Name"; "Period Name")
                {
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field("Week No"; vG_WeekNo)
                {
                    Caption = 'Week No.';
                    ApplicationArea = all;
                }
                field(vL_WeekLot; vL_WeekLot)
                {
                    Caption = 'vL_WeekLot';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(vL_DayLot; vL_DayLot)
                {
                    Caption = 'vL_DayLot';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(vl_LotNo; vl_LotNo)
                {
                    Caption = 'vl_LotNo';
                    Style = Strong;
                    StyleExpr = TRUE;
                    ApplicationArea = all;
                }
                field(vL_Week; vL_Week)
                {
                    Caption = 'vL_Week';
                    ApplicationArea = all;
                }
                field(vL_Day; vL_Day)
                {
                    Caption = 'vL_Day';
                    ApplicationArea = all;
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin

        vG_WeekNo := DATE2DWY("Period Start", 2);
        CalcLidl;
    end;

    trigger OnOpenPage();
    begin
        RESET;
        SetDateFilter;
    end;

    var
        vG_StartDate: Date;
        vG_EndDate: Date;
        vG_WeekNo: Integer;
        vl_ExtDocNo: Text;
        vl_LotNo: Text;
        vL_Day: Text;
        vL_Week: Text;
        vL_WeekLot: Text;
        vL_DayLot: Text;

    local procedure SetDateFilter();
    begin
        //IF AmountType = AmountType::"Net Change" THEN
        //Cust.SETRANGE("Date Filter","Period Start","Period End")
        //ELSE
        vG_StartDate := DMY2DATE(31, 12, 2020);
        vG_EndDate := DMY2DATE(31, 12, 2023);

        SETRANGE("Period Start", vG_StartDate, vG_EndDate);
        SETRANGE("Period Type", "Period Type"::Date);
    end;

    local procedure CalcLidl();
    var
        vl_OrderDate: Date;
        vL_WeekDayText: Text;
        vL_DayTemp: Text;
        tmp_int: Integer;
        vL_DayWeekTemp: Text;
    begin

        vl_OrderDate := "Period Start";
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

        //**************
        //Lots
        //***************
        //+TAL0.6
        //DATE2DWY Monday =1
        vL_DayLot := FORMAT(DATE2DWY(vl_OrderDate, 1));

        vL_DayTemp := vL_DayLot; //TAL0.7
        if vL_DayTemp = '8' then begin //sunday placed
            vL_DayLot := '1';
        end;
        vL_DayLot := PADSTR('', 2 - STRLEN(vL_DayLot), '0') + vL_DayLot;


        //MESSAGE(vL_DayLot);
        vL_WeekLot := FORMAT(DATE2DWY(vl_OrderDate, 2));
        vL_WeekLot := PADSTR('', 2 - STRLEN(vL_WeekLot), '0') + vL_WeekLot;
        vl_LotNo := 'Lot No: ' + vL_WeekLot + '-' + vL_DayLot;
    end;
}

