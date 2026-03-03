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
    Permissions = tabledata "Sales Invoice Line" = m;
    ApplicationArea = All;

    layout
    {
        area(Content)
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies what you are selling, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';
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


                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    Caption = 'Description';
                    ToolTip = 'Custom: Description';
                    Editable = true;
                }

                //2
                group(GrpReqCountry)
                {
                    Caption = '';
                    field(OldCountryRegionofOriginCode; xSalesInvoiceLine."Country/Region of Origin Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Country/Region of Origin Code';
                        ToolTip = 'Custom: Country/Region of Origin Code';
                        Editable = false;
                    }

                    field(CountryRegionofOriginCode; Rec."Country/Region of Origin Code")
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
                    Caption = '';
                    field(OldProductClass; xSalesInvoiceLine."Product Class")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Product Class (Κατηγορία)';
                        ToolTip = 'Custom: Product Class (Κατηγορία)';
                        Editable = false;
                    }

                    field(ProductClass; Rec."Product Class")
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
                    Caption = '';
                    field(OldCategory9; xSalesInvoiceLine."Category 9")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Old Potatoes District Region';
                        ToolTip = 'Custom: Potatoes District Region';
                        Editable = false;
                    }

                    field(Category9; Rec."Category 9")
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
        rG_SalesInvoiceHeader.Get(xSalesInvoiceLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        if CloseAction = Action::LookupOK then
            if RecordChanged then begin
                //CODEUNIT.Run(CODEUNIT::"Shipment Header - Edit", Rec);
                rL_SalesInvoiceLine.Get(Rec."Document No.", Rec."Line No.");
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
         (Rec.Description <> xSalesInvoiceLine.Description) or
          (Rec."Country/Region of Origin Code" <> xSalesInvoiceLine."Country/Region of Origin Code") or
          (Rec."Product Class" <> xSalesInvoiceLine."Product Class") or
          (Rec."Category 9" <> xSalesInvoiceLine."Category 9");

        OnAfterRecordChanged(Rec, xSalesInvoiceLine, IsChanged);
    end;

    //  [Scope('OnPrem')]
    procedure SetRec(SalesInvoiceLine: Record "Sales Invoice Line")
    begin
        Rec := SalesInvoiceLine;
        Rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var SalesInvoiceLine: Record "Sales Invoice Line"; xSalesInvoiceLine: Record "Sales Invoice Line"; var IsChanged: Boolean)
    begin
    end;
}
//-1080

