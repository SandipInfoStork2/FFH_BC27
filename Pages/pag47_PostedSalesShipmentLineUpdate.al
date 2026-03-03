//+1080
page 50047 "Posted Sales Line S - Update"
{
    Caption = 'Posted Sales Shipment Line - Update';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Sales Shipment Line";
    SourceTableTemporary = true;
    Permissions = tabledata "Sales Shipment Line" = m;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No."; rG_SalesShipmentHeader."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer Name"; rG_SalesShipmentHeader."Sell-to Customer Name")
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

                //1

                field(OldDescription; xSalesShipmentLine.Description)
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
                    field(OldCountryRegionofOriginCode; xSalesShipmentLine."Country/Region of Origin Code")
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
                    field(OldProductClass; xSalesShipmentLine."Product Class")
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

                    field(OldCategory9; xSalesShipmentLine."Category 9")
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
        xSalesShipmentLine := Rec;
        rG_SalesShipmentHeader.Get(xSalesShipmentLine."Document No.");
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rL_SalesShipmentLine: Record "Sales Shipment Line";
    begin
        if CloseAction = Action::LookupOK then
            if RecordChanged then begin
                //CODEUNIT.Run(CODEUNIT::"Shipment Header - Edit", Rec);
                rL_SalesShipmentLine.Get(Rec."Document No.", Rec."Line No.");
                rL_SalesShipmentLine.Description := Rec.Description;
                rL_SalesShipmentLine."Country/Region of Origin Code" := Rec."Country/Region of Origin Code";
                rL_SalesShipmentLine."Product Class" := Rec."Product Class";
                rL_SalesShipmentLine."Category 9" := Rec."Category 9";
                rL_SalesShipmentLine.Modify();
            end;

    end;

    var
        xSalesShipmentLine: Record "Sales Shipment Line";
        rG_SalesShipmentHeader: Record "Sales Shipment Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
         (Rec.Description <> xSalesShipmentLine.Description) or
          (Rec."Country/Region of Origin Code" <> xSalesShipmentLine."Country/Region of Origin Code") or
          (Rec."Product Class" <> xSalesShipmentLine."Product Class") or
          (Rec."Category 9" <> xSalesShipmentLine."Category 9");

        OnAfterRecordChanged(Rec, xSalesShipmentLine, IsChanged);
    end;

    //  [Scope('OnPrem')]
    procedure SetRec(SalesShipmentLine: Record "Sales Shipment Line")
    begin
        Rec := SalesShipmentLine;
        Rec.Insert;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var SalesShipmentLine: Record "Sales Shipment Line"; xSalesShipmentLine: Record "Sales Shipment Line"; var IsChanged: Boolean)
    begin
    end;
}
//-1080

