//+1080
page 50048 "Posted Sales Line I- Update"
{
    Caption = 'Posted Sales Invoice Line - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;
    Permissions = TableData "Sales Invoice Line" = m;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; rG_SalesInvoiceHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer Name"; rG_SalesInvoiceHeader."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Editable = false;
                    ToolTip = 'Specifies the name of customer at the sell-to address.';
                }
                field("Posting Date"; rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("No."; rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
            }
            group(Lines)
            {
                Caption = 'Lines';


                field(OldDescription; xSalesInvoiceLine.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Old Description';
                    ToolTip = 'Custom: Description';
                    Editable = false;
                }


                field(Description; rec.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Description';
                    ToolTip = 'Custom: Description';
                    Editable = true;
                }

                //2
                group(GrpReqCountry)
                {
                    caption = '';
                    field(OldCountryRegionofOriginCode; xSalesInvoiceLine."Country/Region of Origin Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Country/Region of Origin Code';
                        ToolTip = 'Custom: Country/Region of Origin Code';
                        Editable = false;
                    }

                    field(CountryRegionofOriginCode; rec."Country/Region of Origin Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Country/Region of Origin Code';
                        ToolTip = 'Custom: Country/Region of Origin Code';
                        Editable = true;
                    }
                }



                //3
                group(GrpProductClass)
                {
                    caption = '';
                    field(OldProductClass; xSalesInvoiceLine."Product Class")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Product Class (Κατηγορία)';
                        ToolTip = 'Custom: Product Class (Κατηγορία)';
                        Editable = false;
                    }

                    field(ProductClass; rec."Product Class")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Product Class (Κατηγορία)';
                        ToolTip = 'Custom: Product Class (Κατηγορία)';
                        Editable = true;
                    }
                }


                //4
                group(GrpCategory9)
                {
                    caption = '';
                    field(OldCategory9; xSalesInvoiceLine."Category 9")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Potatoes District Region';
                        ToolTip = 'Custom: Potatoes District Region';
                        Editable = false;
                    }

                    field(Category9; rec."Category 9")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Potatoes District Region';
                        ToolTip = 'Custom: Potatoes District Region';
                        Editable = true;
                    }
                }



            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        xSalesInvoiceLine := Rec;
        rG_SalesInvoiceHeader.GET(xSalesInvoiceLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged then begin
                //CODEUNIT.Run(CODEUNIT::"Shipment Header - Edit", Rec);
                rL_SalesInvoiceLine.GET(rec."Document No.", rec."Line No.");
                rL_SalesInvoiceLine.Description := Rec.Description;
                rL_SalesInvoiceLine."Country/Region of Origin Code" := Rec."Country/Region of Origin Code";
                rL_SalesInvoiceLine."Product Class" := Rec."Product Class";
                rL_SalesInvoiceLine."Category 9" := Rec."Category 9";
                rL_SalesInvoiceLine.Modify();
            end;

    end;

    var
        xSalesInvoiceLine: Record "Sales Invoice Line";
        rG_SalesInvoiceHeader: Record "Sales Invoice Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
         (rec."Description" <> xSalesInvoiceLine."Description") or
          (rec."Country/Region of Origin Code" <> xSalesInvoiceLine."Country/Region of Origin Code") or
          (rec."Product Class" <> xSalesInvoiceLine."Product Class") or
          (rec."Category 9" <> xSalesInvoiceLine."Category 9");

        OnAfterRecordChanged(Rec, xSalesInvoiceLine, IsChanged);
    end;

    //  [Scope('OnPrem')]
    procedure SetRec(SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        Rec := SalesInvoiceLine;
        rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceLine: Record "Sales Invoice Line"; xSalesInvoiceLine: Record "Sales Invoice Line"; var IsChanged: Boolean)
    begin
    end;
}
//-1080

