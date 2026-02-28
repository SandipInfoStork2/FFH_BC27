page 50046 "Ship-to Address List HORECA"
{
    Caption = 'Ship-to Address List';
    CardPageID = "Ship-to Address";
    //DataCaptionFields = "Customer No.";
    Editable = false;
    PageType = List;
    SourceTable = "Ship-to Address";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Code)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a ship-to address code.';
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name associated with the ship-to address.';
                    StyleExpr = StyleDescription;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ship-to address.';
                    Visible = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies additional address information.';
                    Visible = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field(City; City)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the city the items are being shipped to.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the recipient''s telephone number.';
                    Visible = false;
                }
                field("E-Mail"; "E-Mail")
                {
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the recipient''s fax number.';
                    Visible = false;
                }
                field(Contact; Contact)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the person you contact about orders shipped to this address.';
                    Visible = false;
                }
                field(GLN; GLN)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the recipient''s GLN code.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    ToolTip = 'Specifies the location code to be used for the recipient.';
                    Visible = false;
                }

                field(Monday; Monday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Tuesday; Tuesday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Wednesday; Wednesday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Thursday; Thursday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Friday; Friday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Saturday; Saturday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Sunday; Sunday)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Notify Place Order"; "Notify Place Order")
                {
                    ApplicationArea = All;
                    Visible = false;
                }

                field(vG_NoOfOrders; vG_NoOfOrders)
                {
                    Caption = 'No. of Orders';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(vG_MinOrderDate; vG_MinOrderDate)
                {
                    Caption = 'First Requested Delivery Date';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(vG_MaxOrderDate; vG_MaxOrderDate)
                {
                    Caption = 'Last Requested Delivery Date';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Address")
            {
                Caption = '&Address';
                Image = Addresses;
                action("Online Map")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'View the address on an online map.';

                    trigger OnAction()
                    begin
                        DisplayMap();
                    end;
                }
            }
        }
    }

    views
    {
        view(view_Monday)
        {
            Caption = 'Monday';
            Filters = where("Monday" = const(True), "Blocked" = const(False));
        }

        view(view_Tuesday)
        {
            Caption = 'Tuesday';
            Filters = where("Tuesday" = const(True), "Blocked" = const(False));
        }

        view(view_Wednesday)
        {
            Caption = 'Wednesday';
            Filters = where("Wednesday" = const(True), "Blocked" = const(False));
        }

        view(view_Thursday)
        {
            Caption = 'Thursday';
            Filters = where("Thursday" = const(True), "Blocked" = const(False));
        }

        view(view_Friday)
        {
            Caption = 'Friday';
            Filters = where("Friday" = const(True), "Blocked" = const(False));
        }

        view(view_Saturday)
        {
            Caption = 'Saturday';
            Filters = where("Saturday" = const(True), "Blocked" = const(False));
        }

    }

    trigger OnOpenPage()
    var
        myInt: Integer;

        UserSetup: Record "User Setup";
        CustFilter: Text;
        RowCount: Integer;
    begin

        UserSetup.RESET;
        UserSetup.SetFilter("HORECA Customer No.", '<>%1', '');
        if UserSetup.FindSet() then begin
            repeat
                RowCount += 1;

                if RowCount = 1 then begin
                    CustFilter := UserSetup."HORECA Customer No.";
                end else begin
                    CustFilter += '|' + UserSetup."HORECA Customer No.";
                end;

            until UserSetup.Next() = 0;
        end;


        FilterGroup(2);
        SetFilter("Customer No.", CustFilter);
        SetRange(Blocked, false);
        FilterGroup(0);

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        SalesHeader: Record "Sales Header";
    begin

        SalesHeader.RESET;
        SalesHeader.SetCurrentKey("Document Type", "Sell-to Customer No.", "Ship-to Code", "Requested Delivery Date");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetFilter("Sell-to Customer No.", "Customer No.");
        SalesHeader.SetFilter("Ship-to Code", rec.Code);

        vG_NoOfOrders := SalesHeader.Count;
        vG_MinOrderDate := 0D;
        vG_MaxOrderDate := 0D;
        if SalesHeader.FindFirst() then begin
            vG_MinOrderDate := SalesHeader."Requested Delivery Date";
        end;

        if SalesHeader.FindLast() then begin
            vG_MaxOrderDate := SalesHeader."Requested Delivery Date";

            if vG_MinOrderDate = vG_MaxOrderDate then begin
                vG_MaxOrderDate := 0D;
            end;
        end;

        StyleDescription := '';
        if vG_NoOfOrders = 0 then begin
            StyleDescription := 'Unfavorable';
        end;

    end;

    var

        vG_MinOrderDate: Date;

        vG_MaxOrderDate: Date;

        vG_NoOfOrders: Integer;

        StyleDescription: Text;
}

