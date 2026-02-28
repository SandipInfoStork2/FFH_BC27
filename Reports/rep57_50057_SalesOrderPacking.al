report 50057 "Sales Order Packing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/rep57_50057_SalesOrderPacking.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            RequestFilterFields = "No.", "Shortcut Dimension 2 Code", "Shipment Date", "Ship-to Code";
            column(DocumentType_SalesLine; "Sales Line"."Document Type")
            {
            }
            column(DocumentNo_SalesLine; "Sales Line"."Document No.")
            {
            }
            column(No_SalesLine; "Sales Line"."No.")
            {
            }
            column(Description_SalesLine; "Sales Line".Description)
            {
            }
            column(QuantityBase_SalesLine; "Sales Line"."Quantity (Base)")
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureBase_SalesLine; "Sales Line"."Unit of Measure (Base)")
            {
            }
            column(Quantity_SalesLine; "Sales Line".Quantity)
            {
                DecimalPlaces = 0 : 1;
            }
            column(UnitofMeasureCode_SalesLine; "Sales Line"."Unit of Measure Code")
            {
            }
            column(ShipmentDate_SalesLine; FORMAT("Sales Line"."Shipment Date"))
            {
            }
            column(ShiptoCode_SalesLine; "Sales Line"."Ship-to Code")
            {
            }
            column(DisplayName; DisplayName)
            {
            }
            column(ShiptoCity; rG_ShiptoAddress.City)
            {
            }
            column(ShiptoName; rG_ShiptoAddress.Name)
            {
            }
            column(ShiptoAddress; rG_ShiptoAddress.Address)
            {
            }

            trigger OnAfterGetRecord();
            begin
                rG_SalesHeader.GET("Sales Line"."Document Type", "Sales Line"."Document No.");
                rG_ShiptoAddress.GET(rG_SalesHeader."Bill-to Customer No.", rG_SalesHeader."Ship-to Code");
            end;

            trigger OnPreDataItem();
            begin
                "Sales Line".SETRANGE("Document Type", "Sales Line"."Document Type"::Order);
                "Sales Line".SETRANGE(Type, "Sales Line".Type::Item);
                "Sales Line".SETFILTER(Quantity, '<>%1', 0);
                "Sales Line".SETFILTER("Ship-to Code", '<>%1', '');

                rG_CompanyInformation.GET;
                DisplayName := rG_CompanyInformation.Name;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DisplayName: Text;
        rG_CompanyInformation: Record "Company Information";
        rG_ShiptoAddress: Record "Ship-to Address";
        rG_SalesHeader: Record "Sales Header";
}

