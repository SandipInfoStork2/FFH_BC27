// send email to store managers
report 50021 "HORECA Order Reminder Manager"
{
    ApplicationArea = All;
    Caption = 'HORECA Order Manager';
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
                cuGeneralMgt.HORECAOrderReminderManager();
            end;
        }
    }

}