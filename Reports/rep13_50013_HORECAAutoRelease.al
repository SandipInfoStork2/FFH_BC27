report 50013 "HORECA Auto Release"
{
    ApplicationArea = All;
    Caption = 'HORECA Auto Release';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(IntegerDS; Integer)
        {
            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1));

            trigger OnAfterGetRecord()
            var
                cuGeneralMgt: Codeunit "General Mgt.";
            begin
                //Message(Format(IntegerDS.Number));
                CLEAR(cuGeneralMgt);
                cuGeneralMgt.HORECAAutoRelease();
            end;
        }
    }

}