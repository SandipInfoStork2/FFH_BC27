page 50014 "Lidl Lot Sample"
{
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = Date;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Period Start"; Rec."Period Start")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Start field.';
                }
                field(vl_ExtDocNo; vl_ExtDocNo)
                {
                    Caption = 'vl_ExtDocNo';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vl_ExtDocNo field.';
                }
                field("Period No."; Rec."Period No.")
                {
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period No. field.';
                }
                field("Period Name"; Rec."Period Name")
                {
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Period Name field.';
                }
                field("Week No"; vG_WeekNo)
                {
                    Caption = 'Week No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Week No. field.';
                }
                field(vL_WeekLot; vL_WeekLot)
                {
                    Caption = 'vL_WeekLot';
                    Style = Strong;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vL_WeekLot field.';
                }
                field(vL_DayLot; vL_DayLot)
                {
                    Caption = 'vL_DayLot';
                    Style = Strong;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vL_DayLot field.';
                }
                field(vl_LotNo; vl_LotNo)
                {
                    Caption = 'vl_LotNo';
                    Style = Strong;
                    StyleExpr = true;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vl_LotNo field.';
                }
                field(vL_Week; vL_Week)
                {
                    Caption = 'vL_Week';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vL_Week field.';
                }
                field(vL_Day; vL_Day)
                {
                    Caption = 'vL_Day';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the vL_Day field.';
                }

            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin

        vG_WeekNo := DATE2DWY(Rec."Period Start", 2);
        CalcLidl;
    end;

    trigger OnOpenPage();
    begin
        Rec.RESET;
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
        vG_StartDate := DMY2Date(31, 12, 2020);
        vG_EndDate := DMY2Date(31, 12, 2023);

        Rec.SETRANGE("Period Start", vG_StartDate, vG_EndDate);
        Rec.SETRANGE("Period Type", Rec."Period Type"::Date);
    end;

    local procedure CalcLidl();
    var
        vl_OrderDate: Date;
        vL_WeekDayText: Text;
        vL_DayTemp: Text;
        tmp_int: Integer;
        vL_DayWeekTemp: Text;
    begin

        vl_OrderDate := Rec."Period Start";
        vL_Day := Format(Date2DWY(vl_OrderDate, 1) + 1);
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

        vL_Day := PadStr('', 2 - StrLen(vL_Day), '0') + vL_Day;


        vL_Week := Format(Date2DWY(vl_OrderDate, 2));
        vL_DayWeekTemp := Format(Date2DWY(vl_OrderDate, 1));
        //+TAL0.7
        if vL_DayWeekTemp = '7' then begin //sunday placed
            Evaluate(tmp_int, vL_Week);
            tmp_int += 1;
            vL_Week := Format(tmp_int);
        end;
        //-TAL0.7

        //check greater than 52
        Evaluate(tmp_int, vL_Week);
        if tmp_int > 52 then begin
            tmp_int := 1;
            vL_Week := Format(tmp_int);
        end;

        vL_WeekDayText := CopyStr(Format(vl_OrderDate, 0, '<Weekday Text>'), 1, 3);
        vL_WeekDayText := UpperCase(vL_WeekDayText);
        vL_Week := PadStr('', 2 - StrLen(vL_Week), '0') + vL_Week;
        vl_ExtDocNo := vL_Week + ' - ' + vL_Day + ' ' + vL_WeekDayText + ' 7019' + Format(vl_OrderDate, 0, '<Day,2><Month,2><Year,2>') + '01';

        //**************
        //Lots
        //***************
        //+TAL0.6
        //DATE2DWY Monday =1
        vL_DayLot := Format(Date2DWY(vl_OrderDate, 1));

        vL_DayTemp := vL_DayLot; //TAL0.7
        if vL_DayTemp = '8' then begin //sunday placed
            vL_DayLot := '1';
        end;
        vL_DayLot := PadStr('', 2 - StrLen(vL_DayLot), '0') + vL_DayLot;


        //MESSAGE(vL_DayLot);
        vL_WeekLot := Format(Date2DWY(vl_OrderDate, 2));
        vL_WeekLot := PadStr('', 2 - StrLen(vL_WeekLot), '0') + vL_WeekLot;
        vl_LotNo := 'Lot No: ' + vL_WeekLot + '-' + vL_DayLot;
    end;
}

