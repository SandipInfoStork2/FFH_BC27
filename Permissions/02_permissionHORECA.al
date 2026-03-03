permissionset 50002 TAL_HORECA_EXT
{
    Assignable = true;
    Access = Public;

    /*
        Values	Represents	Description
        R or r	Read	Specifies direct (R) or indirect (r) read permission.
        I or i	Insert	Specifies direct (I) or indirect (i) insert permission.
        M or m	Modify	Specifies direct (M) or indirect (m) modify permission.
        D or d	Delete	Specifies direct (D) or indirect (d) delete permission.
        X or x	Execute	Specifies direct (X) or indirect (x) execute permission.
    */


    Permissions =

    tabledata "Country/Region" = R,
    tabledata Customer = R,
    tabledata Item = R,
    tabledata "Sales Header" = RIMD,
    tabledata "Sales Line" = RIMd,
     tabledata "Standard Sales Line" = R,
    tabledata "Company Information" = R,
    tabledata "User Setup" = R,
    tabledata "General Ledger Setup" = R,
    tabledata "Sales & Receivables Setup" = R,
    tabledata "No. Series" = R,
    tabledata "No. Series Line" = RM,
    tabledata Location = R,
    tabledata "Source Code Setup" = R,
    tabledata "Salesperson/Purchaser" = R,
     tabledata "Payment Terms" = R,
    tabledata "Signup Context Values" = Rim,
    tabledata "Unit of Measure" = R,
    tabledata "Ship-to Address" = R,

    tabledata Currency = R,
    tabledata "Currency Exchange Rate" = R,
    tabledata "Payment Method" = R,
    tabledata "Bank Account" = R,
    tabledata Contact = R,
    tabledata "Contact Business Relation" = R,
    tabledata "Office Add-in Setup" = R,
    tabledata "Standard Customer Sales Code" = R,
     tabledata "Standard Sales Code" = R,

    tabledata "Post Code" = R,
    tabledata Dimension = R,
    tabledata "Dimension Value" = R,
    tabledata "Dimension Combination" = R,
    tabledata "Dimension Value Combination" = R,
    tabledata "Default Dimension" = R,
    tabledata "Dimension ID Buffer" = R,
    tabledata "Change Log Setup" = r,
    tabledata "Change Log Setup (Table)" = r,
    tabledata "Change Log Setup (Field)" = r,
    tabledata "Change Log Entry" = rim,
    tabledata "My Notifications" = RIDM,
    //TableData "Checklist Item Role" = R,
    //TableData "Checklist Item User" = R,
    //TableData "User Checklist Status" = RIM,
    tabledata "Item Unit of Measure" = R,
    tabledata "My Item" = RIDM,
    //TableData "Upgrade Tags" = R,
    tabledata Company = R,
    tabledata "User Personalization" = RIM,
    tabledata "Page Data Personalization" = RIDM,
    tabledata User = RIM,
    tabledata "Privacy Notice" = RIDM,
    tabledata "Privacy Notice Approval" = RIDM,
    tabledata "Field Monitoring Setup" = R,
    tabledata "Detailed Cust. Ledg. Entry" = R,
    tabledata "Manufacturing Setup" = R,
    tabledata "General Categories" = R,
    tabledata "Dimension Set Tree Node" = RIDM,
    tabledata "Dimension Set Entry" = RIDM,
    tabledata "VAT Posting Setup" = R,
    tabledata "General Posting Setup" = R,
    tabledata "Inventory Posting Setup" = R,
    tabledata "Item Reference" = R,
    tabledata "Reservation Entry" = RIDM,
    tabledata "Feature Data Update Status" = R,
    tabledata "Sales Line Discount" = R,
    tabledata "Sales Price" = R,
    tabledata "Cust. Invoice Disc." = R,
    tabledata "Customer Discount Group" = R,
    tabledata "Item Discount Group" = R,
    tabledata "Item Ledger Entry" = R,
    tabledata "Prod. Order Component" = R,
    tabledata "Planning Component" = R,
    tabledata "Requisition Line" = R,
    tabledata "Transfer Line" = R,
    tabledata "Purchase Line" = R,
    tabledata "Prod. Order Line" = R,
    tabledata "Stockkeeping Unit" = R,
    tabledata "Planning Assignment" = RIDM,
    tabledata "User Preference" = RIDM,
    tabledata "Sales Header Archive" = RIDM,
    tabledata "Sales Line Archive" = RIDM,
    tabledata "Item Substitution" = R,
    tabledata "Sales Shipment Header" = Rm,
    tabledata "Inventory Setup" = R,
    tabledata "Item Charge Assignment (Sales)" = R,
    tabledata "Item Charge Assignment (Purch)" = R,
    tabledata "Document Attachment" = R,
    tabledata "Custom Report Selection" = R,
    tabledata "Report Selections" = R,
    tabledata Language = R,
    tabledata "Shipment Method" = R,
    tabledata "Sales Shipment Line" = R,
    tabledata "Source Code" = R,

     tabledata "Sales Comment Line" = RIMD,
     tabledata "Record Link" = R,

     tabledata "Sales Invoice Header" = Rm,
     tabledata "Sales Invoice Line" = R,
     tabledata "Value Entry" = R,


    table * = X,
    codeunit * = X,
    page "HORECA RC" = X,
    page "Horeca Order List" = X,
    page "Horeca Order" = X,
    page "Horeca Order Subform" = X,
    page "Ship-to Address List" = X,
    page "Customer Lookup" = X,
    page "Check Credit Limit" = X,
    page "Credit Limit Details" = X,
    page "Check Prod. Order Status" = X,
    page "Item Availability Check" = X,

    page "Horeca SSH List" = X,
    page "Horeca SSH" = X,
    page "Horeca SSH Subform" = X,
    page "HORECA Password Dialog" = X,
     page "Horeca SIH List" = X,
    page "Horeca SIH" = X,
    page "Horeca SIH Subform" = X,

    page "My Notifications" = X,

    page "User Settings" = X,
    //page "My Settings" = X,

    //report "Order Confirmation - KP" = X,

    report "Order Confirmation HORECA" = X,
    report "Sales - Shipment HORECA" = X,
    report "Sales - Invoice HORECA" = X,

    system "Edit, Find" = X,
    system "Edit, Replace" = X,
    system "View, Table Filter" = X,
    system "View, FlowFilter" = X,
    system "View, Sort" = X,
    system "View, Design" = X,
    system "Tools, Security, Password" = X;

}

