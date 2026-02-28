codeunit 50005 "Report Management"
{
    // version NAVAP4.00

    // //


    trigger OnRun();
    begin
    end;

    var
        Text001: TextConst ENU = 'Amounts are in whole 10s', ENA = 'Amounts are in whole 10s';
        Text002: TextConst ENU = 'Amounts are in whole 100s', ENA = 'Amounts are in whole 100s';
        Text003: TextConst ENU = 'Amounts are in whole 1,000s', ENA = 'Amounts are in whole 1,000s';
        Text004: TextConst ENU = 'Amounts are in whole 100,000s', ENA = 'Amounts are in whole 100,000s';
        Text005: TextConst ENU = 'Amounts are in whole 1,000,000s', ENA = 'Amounts are in whole 1,000,000s';
        Text006: TextConst ENU = 'Amounts are not rounded', ENA = 'Amounts are not rounded';

    procedure RoundAmount(Amount: Decimal; Rounding: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions): Decimal;
    begin
        case Rounding of
            Rounding::" ":
                exit(Amount);
            Rounding::Tens:
                exit(ROUND(Amount / 10, 0.1));
            Rounding::Hundreds:
                exit(ROUND(Amount / 100, 0.1));
            Rounding::Thousands:
                exit(ROUND(Amount / 1000, 0.1));
            Rounding::"Hundred Thousands":
                exit(ROUND(Amount / 100000, 0.1));
            Rounding::Millions:
                exit(ROUND(Amount / 1000000, 0.1));
        end;
    end;

    procedure RoundDescription(Rounding: Option " ",Tens,Hundreds,Thousands,"Hundred Thousands",Millions): Text[50];
    begin
        case Rounding of
            Rounding::" ":
                exit(Text006);
            Rounding::Tens:
                exit(Text001);
            Rounding::Hundreds:
                exit(Text002);
            Rounding::Thousands:
                exit(Text003);
            Rounding::"Hundred Thousands":
                exit(Text004);
            Rounding::Millions:
                exit(Text005);
        end;
    end;
}

