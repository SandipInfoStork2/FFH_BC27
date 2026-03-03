page 50005 "Purchase List Addon P"
{
    // version NAVW17.00

    Caption = 'Purchase List Addon';
    CardPageId = "Purchase Order Addon P";
    DataCaptionFields = "Document Type";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Header Addon Posted";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Buy-from Vendor No. field.';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Order Address Code field.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Buy-from Vendor Name field.';
                }
                field("Vendor Authorization No."; Rec."Vendor Authorization No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Vendor Authorization No. field.';
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Post Code field.';
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Country/Region Code field.';
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Buy-from Contact field.';
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Vendor No. field.';
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Name field.';
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Post Code field.';
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Country/Region Code field.';
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Pay-to Contact field.';
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Code field.';
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Name field.';
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Post Code field.';
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Country/Region Code field.';
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Ship-to Contact field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(1);
                    end;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';

                    trigger OnLookup(var Text: Text): Boolean;
                    begin
                        DimMgt.LookupDimValueCodeNoUpdate(2);
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Purchaser Code field.';
                }
                field("Assigned User ID"; Rec."Assigned User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Assigned User ID field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("FORMAT(vG_LineVendorDifferent)"; Format(vG_LineVendorDifferent))
                {
                    ApplicationArea = All;
                    Caption = 'Line Vendor Different';
                    StyleExpr = vG_Style;
                    ToolTip = 'Specifies the value of the Line Vendor Different field.';
                }
            }
        }
        area(FactBoxes)
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
        area(Navigation)
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
                    ShortcutKey = 'Shift+F7';
                    Visible = false;
                    ToolTip = 'Executes the Card action.';

                    trigger OnAction();
                    begin
                        case Rec."Document Type" of
                            Rec."Document Type"::Quote:
                                Page.Run(Page::"Purchase Quote", Rec);
                            Rec."Document Type"::"Blanket Order":
                                Page.Run(Page::"Blanket Purchase Order", Rec);
                            Rec."Document Type"::Order:
                                Page.Run(Page::"Purchase Order", Rec);
                            Rec."Document Type"::Invoice:
                                Page.Run(Page::"Purchase Invoice", Rec);
                            Rec."Document Type"::"Return Order":
                                Page.Run(Page::"Purchase Return Order", Rec);
                            Rec."Document Type"::"Credit Memo":
                                Page.Run(Page::"Purchase Credit Memo", Rec);
                        end;
                    end;
                }
            }
        }
        area(Reporting)
        {
            action("Boxes Statement")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Boxes Statement action.';

                trigger OnAction();
                var
                    rL_Vendor: Record Vendor;
                begin

                    rL_Vendor.Reset;
                    rL_Vendor.SETFILTER("No.", Rec."Buy-from Vendor No.");
                    if rL_Vendor.FindSet then;
                    rL_Vendor.SetRecFilter;
                    Report.RunModal(Report::"Boxes Statement", true, false, rL_Vendor);
                end;
            }
            action("Boxes Statement Balances")
            {
                ApplicationArea = All;
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                ToolTip = 'Executes the Boxes Statement Balances action.';

                trigger OnAction();
                var
                    rL_Vendor: Record Vendor;
                begin

                    rL_Vendor.Reset;
                    rL_Vendor.SETFILTER("No.", Rec."Buy-from Vendor No.");
                    if rL_Vendor.FindSet then;
                    rL_Vendor.SetRecFilter;
                    Report.RunModal(Report::"Boxes Statement Balances", true, false, rL_Vendor);
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
                RunObject = report "Purchase Reservation Avail.";
                ToolTip = 'Executes the Purchase Reservation Avail. action.';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        vG_Style := '';

        vG_LineVendorDifferent := false;
        rG_PurchaseLineAddonPosted.Reset;
        rG_PurchaseLineAddonPosted.SETFILTER("Document No.", Rec."No.");
        rG_PurchaseLineAddonPosted.SETFILTER("Buy-from Vendor No.", '<>%1', Rec."Buy-from Vendor No.");
        if rG_PurchaseLineAddonPosted.FindSet then begin
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

