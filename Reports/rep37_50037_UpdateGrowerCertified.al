report 50037 "Update Grower Certified"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "GGN Expiry Date";

            trigger OnAfterGetRecord();
            begin
                if GuiAllowed then begin
                    WindowLineCount += 1;
                    Window.Update(1, Format(WindowLineCount) + '/' + Format(WindowTotalCount));
                end;


                Vendor.Validate("GGN Expiry Date");
                Vendor.Modify;
            end;

            trigger OnPostDataItem();
            begin
                if GuiAllowed then begin
                    Window.Close();
                end;
            end;

            trigger OnPreDataItem();
            begin
                if GuiAllowed then begin
                    Window.Open('Record Processing #1###############');
                    WindowTotalCount := Count;
                    WindowLineCount := 0;
                end;
            end;
        }
        dataitem(Grower; Grower)
        {
            RequestFilterFields = "GGN Expiry Date";

            trigger OnAfterGetRecord();
            begin
                if GuiAllowed then begin
                    WindowLineCount += 1;
                    Window.Update(1, Format(WindowLineCount) + '/' + Format(WindowTotalCount));
                end;


                Grower.Validate("GGN Expiry Date");
                Grower.Modify;
            end;

            trigger OnPostDataItem();
            begin

                if GuiAllowed then begin
                    Window.Close();
                    Message('Process Completed');
                end;
            end;

            trigger OnPreDataItem();
            begin
                if GuiAllowed then begin
                    Window.Open('Record Processing #1###############');
                    WindowTotalCount := Count;
                    WindowLineCount := 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
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
        Window: Dialog;
        WindowTotalCount: Integer;
        WindowLineCount: Integer;
}

