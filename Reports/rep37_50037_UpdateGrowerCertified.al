report 50037 "Update Grower Certified"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "GGN Expiry Date";

            trigger OnAfterGetRecord();
            begin
                if GUIALLOWED then begin
                  WindowLineCount+=1;
                  Window.UPDATE(1,FORMAT(WindowLineCount)+'/'+FORMAT(WindowTotalCount));
                end;


                Vendor.VALIDATE("GGN Expiry Date");
                Vendor.MODIFY;
            end;

            trigger OnPostDataItem();
            begin
                if GUIALLOWED then begin
                  Window.CLOSE();
                end;
            end;

            trigger OnPreDataItem();
            begin
                if GUIALLOWED then begin
                  Window.OPEN('Record Processing #1###############');
                  WindowTotalCount:=COUNT;
                  WindowLineCount:=0;
                end;
            end;
        }
        dataitem(Grower;Grower)
        {
            RequestFilterFields = "GGN Expiry Date";

            trigger OnAfterGetRecord();
            begin
                if GUIALLOWED then begin
                  WindowLineCount+=1;
                  Window.UPDATE(1,FORMAT(WindowLineCount)+'/'+FORMAT(WindowTotalCount));
                end;


                Grower.VALIDATE("GGN Expiry Date");
                Grower.MODIFY;
            end;

            trigger OnPostDataItem();
            begin

                if GUIALLOWED then begin
                  Window.CLOSE();
                  MESSAGE('Process Completed');
                end;
            end;

            trigger OnPreDataItem();
            begin
                if GUIALLOWED then begin
                   Window.OPEN('Record Processing #1###############');
                    WindowTotalCount:=COUNT;
                    WindowLineCount:=0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Window : Dialog;
        WindowTotalCount : Integer;
        WindowLineCount : Integer;
}

