report 50019 "HORECA Order Reminder Admin"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Admin';
    ProcessingOnly = true;
    UsageCategory = Tasks;


    dataset
    {
        dataitem(IntegerDS; Integer)
        {
            DataItemTableView = sorting(Number) where(Number = filter(1));

            trigger OnAfterGetRecord()
            var
                cuGeneralMgt: Codeunit "General Mgt.";
            begin

                Clear(cuGeneralMgt);
                cuGeneralMgt.HORECAOrderReminder(true);
            end;
        }
    }

}