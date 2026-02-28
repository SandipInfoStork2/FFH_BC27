page 50005 "Purchase List Addon P"
{
    // version NAVW17.00

    Caption = 'Purchase List Addon';
    CardPageID = "Purchase Order Addon P";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header Addon Posted";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Order Address Code"; "Order Address Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Authorization No."; "Vendor Authorization No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pay-to Post Code"; "Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Pay-to Contact"; "Pay-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(2);
                    end;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("FORMAT(vG_LineVendorDifferent)"; FORMAT(vG_LineVendorDifferent))
                {
                    ApplicationArea = All;
                    Caption = 'Line Vendor Different';
                    StyleExpr = vG_Style;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+F7';
                    Visible = false;

                    trigger OnAction();
                    begin
                        case "Document Type" of
                            "Document Type"::Quote:
                                PAGE.RUN(PAGE::"Purchase Quote", Rec);
                            "Document Type"::"Blanket Order":
                                PAGE.RUN(PAGE::"Blanket Purchase Order", Rec);
                            "Document Type"::Order:
                                PAGE.RUN(PAGE::"Purchase Order", Rec);
                            "Document Type"::Invoice:
                                PAGE.RUN(PAGE::"Purchase Invoice", Rec);
                            "Document Type"::"Return Order":
                                PAGE.RUN(PAGE::"Purchase Return Order", Rec);
                            "Document Type"::"Credit Memo":
                                PAGE.RUN(PAGE::"Purchase Credit Memo", Rec);
                        end;
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Boxes Statement")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    rL_Vendor: Record Vendor;
                begin

                    rL_Vendor.RESET;
                    rL_Vendor.SETFILTER("No.", "Buy-from Vendor No.");
                    if rL_Vendor.FINDSET then;
                    rL_Vendor.SETRECFILTER;
                    REPORT.RUNMODAL(REPORT::"Boxes Statement", true, false, rL_Vendor);
                end;
            }
            action("Boxes Statement Balances")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                var
                    rL_Vendor: Record Vendor;
                begin

                    rL_Vendor.RESET;
                    rL_Vendor.SETFILTER("No.", "Buy-from Vendor No.");
                    if rL_Vendor.FINDSET then;
                    rL_Vendor.SETRECFILTER;
                    REPORT.RUNMODAL(REPORT::"Boxes Statement Balances", true, false, rL_Vendor);
                end;
            }
            action("Purchase Reservation Avail.")
            {
                ApplicationArea = All;
                Caption = 'Purchase Reservation Avail.';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Purchase Reservation Avail.";
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        vG_Style := '';

        vG_LineVendorDifferent := false;
        rG_PurchaseLineAddonPosted.RESET;
        rG_PurchaseLineAddonPosted.SETFILTER("Document No.", "No.");
        rG_PurchaseLineAddonPosted.SETFILTER("Buy-from Vendor No.", '<>%1', "Buy-from Vendor No.");
        if rG_PurchaseLineAddonPosted.FINDSET then begin
            vG_LineVendorDifferent := true;
            vG_Style := 'Attention';
        end;
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        rG_PurchaseLineAddonPosted: Record "Purchase Line Addon Posted";
        vG_LineVendorDifferent: Boolean;
        [InDataSet]
        vG_Style: Text;
        rG_PurchaseBoxPosted: Record "Purchase Header Addon Posted";
}

