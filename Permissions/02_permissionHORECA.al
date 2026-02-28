permissionset 50002 "TAL_HORECA_EXT"
{
    Assignable = True;
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

    TableData "Country/Region" = R,
    TableData "Customer" = R,
    TableData "Item" = R,
    TableData "Sales Header" = RIMD,
    TableData "Sales Line" = RIMd,
     TableData "Standard Sales Line" = R,
    TableData "Company Information" = R,
    TableData "User Setup" = R,
    TableData "General Ledger Setup" = R,
    tabledata "Sales & Receivables Setup" = R,
    tabledata "No. Series" = R,
    tabledata "No. Series Line" = RM,
    tabledata "Location" = R,
    tabledata "Source Code Setup" = R,
    tabledata "Salesperson/Purchaser" = R,
     tabledata "Payment Terms" = R,
    TableData "Signup Context Values" = Rim,
    TableData "Unit of Measure" = R,
    TableData "Ship-to Address" = R,

    TableData "Currency" = R,
    TableData "Currency Exchange Rate" = R,
    TableData "Payment Method" = R,
    TableData "Bank Account" = R,
    TableData "Contact" = R,
    TableData "Contact Business Relation" = R,
    TableData "Office Add-in Setup" = R,
    TableData "Standard Customer Sales Code" = R,
     TableData "Standard Sales Code" = R,

    TableData "Post Code" = R,
    TableData "Dimension" = R,
    TableData "Dimension Value" = R,
    TableData "Dimension Combination" = R,
    TableData "Dimension Value Combination" = R,
    TableData "Default Dimension" = R,
    TableData "Dimension ID Buffer" = R,
    TableData "Change Log Setup" = r,
    TableData "Change Log Setup (Table)" = r,
    TableData "Change Log Setup (Field)" = r,
    TableData "Change Log Entry" = rim,
    TableData "My Notifications" = RIDM,
    //TableData "Checklist Item Role" = R,
    //TableData "Checklist Item User" = R,
    //TableData "User Checklist Status" = RIM,
    TableData "Item Unit of Measure" = R,
    TableData "My Item" = RIDM,
    //TableData "Upgrade Tags" = R,
    TableData "Company" = R,
    TableData "Profile" = R,
    TableData "User Personalization" = RIM,
    TableData "Page Data Personalization" = RIDM,
    TableData "User" = RIM,
    TableData "Tenant Profile" = R,
    TableData "Privacy Notice" = RIDM,
    TableData "Privacy Notice Approval" = RIDM,
    TableData "Field Monitoring Setup" = R,
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
    TableData "Item Ledger Entry" = R,
    TableData "Prod. Order Component" = R,
    TableData "Planning Component" = R,
    TableData "Requisition Line" = R,
    TableData "Transfer Line" = R,
    TableData "Purchase Line" = R,
    TableData "Prod. Order Line" = R,
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
    tabledata "Language" = R,
    tabledata "Shipment Method" = R,
    tabledata "Sales Shipment Line" = R,
    tabledata "Source Code" = R,

     tabledata "Sales Comment Line" = RIMD,
     tabledata "Record Link" = R,

     tabledata "Sales Invoice Header" = Rm,
     tabledata "Sales Invoice Line" = R,
     tabledata "Value Entry" = R,


    Table * = X,
    Codeunit * = X,
    Page "HORECA RC" = X,
    Page "Horeca Order List" = X,
    Page "Horeca Order" = X,
    Page "Horeca Order Subform" = X,
    Page "Ship-to Address List" = X,
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

    System "Edit, Find" = X,
    System "Edit, Replace" = X,
    System "View, Table Filter" = X,
    System "View, FlowFilter" = X,
    System "View, Sort" = X,
    System "View, Design" = X,
    System "Tools, Security, Password" = X;

}

