/*
TAL0.1 2021/04/02 VC add List Delivery Schedule, Grower List, Lidl Items
TAL0.2 2021/11/30 VC add page Item Ledger Entries for Andreas Z to print QC Reports  

*/

profile OrderProcessorRC_MC_AL
{
    Description = 'Some internal comment that only the Dev can see';
    Caption = 'Order Processor Role Center MC';
    ProfileDescription = 'A detailed description of who is this profile for, why/how to use it (etc)';
    RoleCenter = "Order Processor Role Center";
    Enabled = true;
    Promoted = true;
    Customizations = MC_PurchaseOrderList;
}

pagecustomization MC_PurchaseOrderList customizes "Purchase Order List"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = true;
        }
        movebefore("No."; "Posting Date")

        moveafter("Buy-from Vendor Name"; vG_SundryGrowerExists)
    }
}
pageextension 50203 OrderProcessorRoleCenterExt extends "Order Processor Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {

        addafter(SalesOrders)
        {
            action(SalesReturnOrders)
            {
                ApplicationArea = Warehouse;
                Caption = 'Sales Return Orders';
                Image = ReturnOrder;
                RunObject = page "Sales Return Order List";
                ToolTip = 'Compensate your customers for incorrect or damaged items that you sent to them and received payment for. Sales return orders enable you to receive items from multiple sales documents with one sales return, automatically create related sales credit memos or other return-related documents, such as a replacement sales order, and support warehouse documents for the item handling. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
            }

            action(SalesCreditMemos)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales Credit Memos';
                RunObject = page "Sales Credit Memos";
                ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
            }

            action(PurchaseOrders)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Orders';
                RunObject = page "Purchase Order List";
                ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
            }

            action(PurchaseReturnOrders)
            {
                ApplicationArea = PurchReturnOrder;
                Caption = 'Purchase Return Orders';
                RunObject = page "Purchase Return Order List";
                ToolTip = 'Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.';
            }
            action(PurchaseCreditMemos)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Purchase Credit Memos';
                RunObject = page "Purchase Credit Memos";
                ToolTip = 'Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.';
            }
        }
        // Add changes to page actions here
        addafter("Item Journals")
        {
            action("Grower List")
            {
                ApplicationArea = All;
                CaptionML = ELL = 'Growers',
                            ENU = 'Growers';
                Image = Vendor;
                RunObject = page "Grower List";
                ToolTip = 'Executes the Grower List action.';
            }
            action("Lidl Items")
            {
                ApplicationArea = All;
                RunObject = page "Lidl Item List";
                ToolTip = 'Executes the Lidl Items action.';
            }
        }

        addafter(CashReceiptJournals)
        {
            action("Item Ledger Entries")
            {
                ApplicationArea = All;
                RunObject = page "Item Ledger Entries";
                ToolTip = 'Executes the Item Ledger Entries action.';
            }
            action("Release Production Orders")
            {
                ApplicationArea = All;
                Caption = 'Release Production Order';
                RunObject = page "Released Production Orders";
                ToolTip = 'Executes the Release Production Order action.';
            }
        }

        addafter("Posted Purchase Invoices")
        {
            action("Delivery Schedule")
            {
                ApplicationArea = All;
                RunObject = page "Delivery Schedule List";
                ToolTip = 'Executes the Delivery Schedule action.';
            }
        }

        addafter("Sales &Journal")
        {
            action("General Journal")
            {
                ApplicationArea = All;
                RunObject = page "General Journal";
                ToolTip = 'Executes the General Journal action.';
            }
            action("Output Journal")
            {
                ApplicationArea = All;
                RunObject = page "Output Journal";
                ToolTip = 'Executes the Output Journal action.';
            }
            action("Phys. Inventory Journal")
            {
                ApplicationArea = All;
                RunObject = page "Phys. Inventory Journal";
                ToolTip = 'Executes the Phys. Inventory Journal action.';
            }
            action("Item Reclass. Journal")
            {
                ApplicationArea = All;
                RunObject = page "Item Reclass. Journal";
                ToolTip = 'Executes the Item Reclass. Journal action.';
            }
        }

        addafter(History)
        {
            group(Boxes)
            {
                Caption = 'Boxes';
                action("Purchase Boxes")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase Order Addon";
                    ToolTip = 'Executes the Purchase Boxes action.';
                }
                action("Purchase Boxes Posted")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase Order Addon P E";
                    ToolTip = 'Executes the Purchase Boxes Posted action.';
                }
                action("Purchase Boxes Posted List")
                {
                    ApplicationArea = All;
                    RunObject = page "Purchase List Addon P";
                    ToolTip = 'Executes the Purchase Boxes Posted List action.';
                }
                action("Purchase Boxes Posted Lines")
                {
                    ApplicationArea = All;
                    RunObject = page "Purch. Order Subform Addon P E";
                    ToolTip = 'Executes the Purchase Boxes Posted Lines action.';
                }
                action("Vendor Statement")
                {
                    ApplicationArea = All;
                    RunObject = report "Vendor Statement";
                    ToolTip = 'Executes the Vendor Statement action.';
                }
                action("Boxes Statement")
                {
                    ApplicationArea = All;
                    Image = "Report";
                    RunObject = report "Boxes Statement";
                    ToolTip = 'Executes the Boxes Statement action.';
                }

                action("Purchase Codes")
                {
                    ApplicationArea = All;
                    Image = Setup;
                    RunObject = page "Standard Purchase Codes";
                    ToolTip = 'Executes the Purchase Codes action.';
                }
                action("Req. Worksheets")
                {
                    ApplicationArea = All;
                    RunObject = page "Req. Wksh. Names";
                    RunPageView = where("Template Type" = const("Req."),
                                    Recurring = const(false));
                    ToolTip = 'Executes the Req. Worksheets action.';
                }
                action("Inventory Transaction Detail")
                {
                    ApplicationArea = All;
                    Image = "Report";
                    RunObject = report "Inventory - Transaction Detail";
                    ToolTip = 'Executes the Inventory Transaction Detail action.';
                }
            }
        }
    }

    var
        myInt: Integer;
}