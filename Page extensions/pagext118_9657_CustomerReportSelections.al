pageextension 50218 CustomerReportSelectionsExt extends "Customer Report Selections"
{

    layout
    {
        // Add changes to page layout here


        addafter(Usage2)
        {
            field(Usage3; Usage3)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'TAL: Usage';
                OptionCaption = 'Quote,Confirmation Order,Invoice,Credit Memo,Customer Statement,Job Quote,Reminder,Shipment,S.Ret.Rcpt,Payment Receipt';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    case Usage3 of
                        Usage3::Quote:
                            Rec.Usage := Rec.Usage::"S.Quote";
                        Usage3::"Confirmation Order":
                            Rec.Usage := Rec.Usage::"S.Order";
                        Usage3::Invoice:
                            Rec.Usage := Rec.Usage::"S.Invoice";
                        Usage3::"Credit Memo":
                            Rec.Usage := Rec.Usage::"S.Cr.Memo";
                        Usage3::"Customer Statement":
                            Rec.Usage := Rec.Usage::"C.Statement";
                        Usage3::"Job Quote":
                            Rec.Usage := Rec.Usage::JQ;
                        Usage3::Reminder:
                            Rec.Usage := Rec.Usage::Reminder;
                        Usage3::Shipment:
                            Rec.Usage := Rec.Usage::"S.Shipment";
                        Usage3::"S.Ret.Rcpt.":
                            Rec.Usage := Rec.Usage::"S.Ret.Rcpt.";
                        Usage3::"Payment Receipt":
                            Rec.Usage := Rec.Usage::"Payment Receipt";

                    end;
                end;
            }
        }

        modify(Usage2)
        {
            Visible = false;
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    begin
        MapTableUsage3ValueToPageValue;

    end;

    local procedure MapTableUsage3ValueToPageValue()
    var
        CustomReportSelection: Record "Custom Report Selection";
    begin
        case Rec.Usage of
            CustomReportSelection.Usage::"S.Quote":
                Usage3 := Usage3::Quote;
            CustomReportSelection.Usage::"S.Order":
                Usage3 := Usage3::"Confirmation Order";
            CustomReportSelection.Usage::"S.Invoice":
                Usage3 := Usage3::Invoice;
            CustomReportSelection.Usage::"S.Cr.Memo":
                Usage3 := Usage3::"Credit Memo";
            CustomReportSelection.Usage::"C.Statement":
                Usage3 := Usage3::"Customer Statement";
            CustomReportSelection.Usage::JQ:
                Usage3 := Usage3::"Job Quote";
            CustomReportSelection.Usage::Reminder:
                Usage3 := Usage3::Reminder;
            CustomReportSelection.Usage::"S.Shipment":
                Usage3 := Usage3::Shipment;
            CustomReportSelection.Usage::"S.Ret.Rcpt.":
                Usage3 := Usage3::"S.Ret.Rcpt.";
            CustomReportSelection.Usage::"Payment Receipt":
                Usage3 := Usage3::"Payment Receipt";
        end;
    end;

    var
        Usage3: Option Quote,"Confirmation Order",Invoice,"Credit Memo","Customer Statement","Job Quote",Reminder,Shipment,"S.Ret.Rcpt.","Payment Receipt";
}