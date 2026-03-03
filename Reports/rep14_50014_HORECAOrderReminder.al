report 50014 "HORECA Order Reminder"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Reminder';
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
                cuGeneralMgt.HORECAOrderReminder(false);
            end;
        }
    }

}