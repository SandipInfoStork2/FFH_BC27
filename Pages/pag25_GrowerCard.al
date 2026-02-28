page 50025 "Grower Card"
{
    // TAL0.1 2021/04/02 VC add field Producer Group Name
    // TAL0.2 2021/11/16 VC add field Country of Destination

    SourceTable = Grower;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Search Name"; "Search Name")
                {
                    ApplicationArea = All;
                }
                field(GGN; GGN)
                {
                    ApplicationArea = All;
                }
                field("Country of Destination"; "Country of Destination")
                {
                    ApplicationArea = All;
                }
                field(GLN; GLN)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Grower Vendor No."; "Grower Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Grower Vendor Name"; "Grower Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Grower Vendor GGN"; "Grower Vendor GGN")
                {
                    ApplicationArea = All;
                }
                field("Grower Vendor GLN"; "Grower Vendor GLN")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Category 2"; "Category 2")
                {
                    ApplicationArea = All;
                }

                field("Category 4"; "Category 4")
                {
                    ApplicationArea = All;
                }
                field("Grower Certified"; "Grower Certified")
                {
                    ApplicationArea = All;
                }
                field("GGN Expiry Date"; "GGN Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("No. of Products"; "No. of Products")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Grower Item Catalog";
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                }
                field("Category 1"; "Category 1")
                {
                    ApplicationArea = All;
                }
                field("Producer Group Name"; "Producer Group Name")
                {
                    ApplicationArea = All;
                }
                field(TC; TC)
                {
                    ApplicationArea = All;
                }

                field("Category 3"; "Category 3")
                {
                    ApplicationArea = All;
                }

                field("GRASP Expiry Date"; "GRASP Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Status Biodiversity"; "Status Biodiversity")
                {
                    ApplicationArea = All;
                }

                field("Biodiversity Expiry Date"; "Biodiversity Expiry Date")
                {
                    ApplicationArea = All;
                }

                field("Status SPRING"; "Status SPRING")
                {
                    ApplicationArea = All;
                }
                field("SPRING Expiry Date"; "SPRING Expiry Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Communication)
            {
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
            }
            group(Other)
            {
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Last Modified Date"; "Last Modified Date")
                {
                    ApplicationArea = All;
                }
                field("Last Modified By"; "Last Modified By")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
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
        area(navigation)
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
                    RunObject = Page "Grower Item Catalog";
                    RunPageLink = "Grower No." = FIELD("No.");
                    RunPageView = SORTING("Grower No.");
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
                    RunObject = Page "Grower Turnover";
                    RunPageLink = "No." = FIELD("No.");
                }
            }
        }
    }
}

