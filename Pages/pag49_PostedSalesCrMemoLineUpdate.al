//+1080
page 50049 "Posted Sales Line C- Update"
{
    Caption = 'Posted Sales Cr. Memo Line - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Sales Cr.Memo Line";
    SourceTableTemporary = true;
    Permissions = TableData "Sales Cr.Memo Line" = m;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No."; rG_SalesCrMemoHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer Name"; rG_SalesCrMemoHeader."Sell-to Customer Name")
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



                field(OldDescription; xSalesCrMemoLine.Description)
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
                    field(OldCountryRegionofOriginCode; xSalesCrMemoLine."Country/Region of Origin Code")
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
                    field(OldProductClass; xSalesCrMemoLine."Product Class")
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

                    field(OldCategory9; xSalesCrMemoLine."Category 9")
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
        xSalesCrMemoLine := Rec;
        rG_SalesCrMemoHeader.GET(xSalesCrMemoLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged then begin
                //CODEUNIT.Run(CODEUNIT::"Shipment Header - Edit", Rec);
                rL_SalesCrMemoLine.GET(rec."Document No.", rec."Line No.");
                rL_SalesCrMemoLine.Description := Rec.Description;

                rL_SalesCrMemoLine."Country/Region of Origin Code" := Rec."Country/Region of Origin Code";
                rL_SalesCrMemoLine."Product Class" := Rec."Product Class";
                rL_SalesCrMemoLine."Category 9" := Rec."Category 9";
                rL_SalesCrMemoLine.Description := rec.Description;
                rL_SalesCrMemoLine.Modify();
            end;

    end;

    var
        xSalesCrMemoLine: Record "Sales Cr.Memo Line";
        rG_SalesCrMemoHeader: Record "Sales Cr.Memo Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
         (rec."Description" <> xSalesCrMemoLine."Description") or
          (rec."Country/Region of Origin Code" <> xSalesCrMemoLine."Country/Region of Origin Code") or
          (rec."Product Class" <> xSalesCrMemoLine."Product Class") or
          (rec."Category 9" <> xSalesCrMemoLine."Category 9");


        OnAfterRecordChanged(Rec, xSalesCrMemoLine, IsChanged);
    end;

    //  [Scope('OnPrem')]
    procedure SetRec(SalesCrMemoLine: Record "Sales Cr.Memo Line")
    begin
        Rec := SalesCrMemoLine;
        rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var SalesCrMemoLine: Record "Sales Cr.Memo Line"; xSalesCrMemoLine: Record "Sales Cr.Memo Line"; var IsChanged: Boolean)
    begin
    end;
}
//-1080

