page 50025 "Grower Card"
{
    // TAL0.1 2021/04/02 VC add field Producer Group Name
    // TAL0.2 2021/11/16 VC add field Country of Destination

    SourceTable = Grower;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Search Name"; Rec."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Search Name field.';
                }
                field(GGN; Rec.GGN)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN field.';
                }
                field("Country of Destination"; Rec."Country of Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country of Destination field.';
                }
                field(GLN; Rec.GLN)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the GLN field.';
                }
                field("Grower Vendor No."; Rec."Grower Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor No. field.';
                }
                field("Grower Vendor Name"; Rec."Grower Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor Name field.';
                }
                field("Grower Vendor GGN"; Rec."Grower Vendor GGN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Vendor GGN field.';
                }
                field("Grower Vendor GLN"; Rec."Grower Vendor GLN")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Grower Vendor GLN field.';
                }
                field("Category 2"; Rec."Category 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 2 field.';
                }

                field("Category 4"; Rec."Category 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 4 field.';
                }
                field("Grower Certified"; Rec."Grower Certified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Grower Certified field.';
                }
                field("GGN Expiry Date"; Rec."GGN Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GGN Expiry Date field.';
                }
                field("No. of Products"; Rec."No. of Products")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Grower Item Catalog";
                    ToolTip = 'Specifies the value of the No. of Products field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field("Category 1"; Rec."Category 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Producer Group field.';
                }
                field("Producer Group Name"; Rec."Producer Group Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Producer Group Name field.';
                }
                field(TC; Rec.TC)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TC field.';
                }

                field("Category 3"; Rec."Category 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Category 3 field.';
                }

                field("GRASP Expiry Date"; Rec."GRASP Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the GRASP Expiry Date field.';
                }

                field("Status Biodiversity"; Rec."Status Biodiversity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status Biodiversity field.';
                }

                field("Biodiversity Expiry Date"; Rec."Biodiversity Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Biodiversity Expiry Date field.';
                }

                field("Status SPRING"; Rec."Status SPRING")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status SPRING field.';
                }
                field("SPRING Expiry Date"; Rec."SPRING Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SPRING Expiry Date field.';
                }
            }
            group(Communication)
            {
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                }
            }
            group(Other)
            {
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified Date field.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Last Modified By field.';
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Control1000000024; Links)
            {
                ApplicationArea = All;
            }
            systempart(Control1000000023; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(Grower)
            {
                action("Page Vendor Gr. Item Catalog")
                {
                    ApplicationArea = All;
                    Caption = 'Grower Items';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = page "Grower Item Catalog";
                    RunPageLink = "Grower No." = field("No.");
                    RunPageView = sorting("Grower No.");
                    ToolTip = 'Executes the Grower Items action.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                Image = Statistics;
                action("T&urnover")
                {
                    ApplicationArea = All;
                    Caption = 'T&urnover';
                    Image = Turnover;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Grower Turnover";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'Executes the T&urnover action.';
                }
            }
        }
    }
}

