xmlport 50002 "SEPA CT pain.001.001.03 HB"
{
    // version NAVW18.00,TAL.SEPA

    // TAL0.1 2018/06/01 VC review code
    // TAL0.2 2018/07/16 VC encode remittance text

    Caption = 'SEPA CT pain.001.001.03 HB';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03 pain.001.001.03.xsd', xsi = 'http://www.w3.org/2001/XMLSchema-instance';
    UseDefaultNamespace = false;

    schema
    {
        tableelement("Gen. Journal Line"; "Gen. Journal Line")
        {
            XmlName = 'Document';
            UseTemporary = true;
            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'CstmrCdtTrfInitn';
                textelement(GrpHdr)
                {
                    textelement(messageid)
                    {
                        XmlName = 'MsgId';
                    }
                    textelement(createddatetime)
                    {
                        XmlName = 'CreDtTm';
                    }
                    textelement(nooftransfers)
                    {
                        XmlName = 'NbOfTxs';
                    }
                    textelement(controlsum)
                    {
                        XmlName = 'CtrlSum';
                    }
                    textelement(InitgPty)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(initgptyid)
                        {
                            XmlName = 'Id';
                            textelement(initgptyorgid)
                            {
                                XmlName = 'OrgId';
                                textelement(initgptyothrinitgpty)
                                {
                                    XmlName = 'Othr';
                                    textelement(companycode)
                                    {
                                        XmlName = 'Id';
                                    }
                                }
                            }
                        }
                    }
                }
                tableelement(paymentexportdatagroup; "Payment Export Data")
                {
                    XmlName = 'PmtInf';
                    UseTemporary = true;
                    fieldelement(PmtInfId; PaymentExportDataGroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd; PaymentExportDataGroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; PaymentExportDataGroup."SEPA Batch Booking")
                    {
                    }
                    textelement(PmtTpInf)
                    {
                        textelement(SvcLvl)
                        {
                            textelement(servicelevel)
                            {
                                XmlName = 'Cd';
                            }
                        }
                    }
                    fieldelement(ReqdExctnDt; PaymentExportDataGroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; CompanyInformation.Name)
                        {
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(Ctry; CompanyInformation."Country/Region Code")
                            {
                            }
                        }
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(BICOrBEI; PaymentExportDataGroup."Sender Bank BIC")
                                {
                                }
                                textelement(Othr)
                                {
                                    textelement(companycode2)
                                    {
                                        XmlName = 'Id';
                                    }
                                }
                            }
                        }
                    }
                    textelement(DbtrAcct)
                    {
                        textelement(dbtracctid)
                        {
                            XmlName = 'Id';
                            fieldelement(IBAN; PaymentExportDataGroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                        fieldelement(Ccy; PaymentExportDataGroup."Sender Bank Account Currency")
                        {
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC; PaymentExportDataGroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                    }
                    fieldelement(ChrgBr; PaymentExportDataGroup."SEPA Charge Bearer Text")
                    {
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = FIELD("Sender Bank BIC"), "SEPA Instruction Priority Text" = FIELD("SEPA Instruction Priority Text"), "Transfer Date" = FIELD("Transfer Date"), "SEPA Batch Booking" = FIELD("SEPA Batch Booking"), "SEPA Charge Bearer Text" = FIELD("SEPA Charge Bearer Text");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(InstrId; PaymentExportData."End-to-End ID")
                            {
                            }
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
                            }
                        }
                        textelement(pmttpinf2)
                        {
                            XmlName = 'PmtTpInf';
                            textelement(svclvl2)
                            {
                                XmlName = 'SvcLvl';
                                textelement(servicelevel2)
                                {
                                    XmlName = 'Cd';
                                }
                            }
                            textelement(CtgyPurp)
                            {
                                fieldelement(Cd; PaymentExportData."Category Purpose")
                                {
                                }
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; PaymentExportData.Amount)
                            {
                                fieldattribute(Ccy; PaymentExportData."Currency Code")
                                {
                                }
                            }
                        }
                        fieldelement(ChrgBr; PaymentExportDataGroup."SEPA Charge Bearer Text")
                        {
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BIC; PaymentExportData."Recipient Bank BIC")
                                {
                                    FieldValidate = yes;
                                }
                            }
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; PaymentExportData."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(Ctry; PaymentExportData."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField();
                                    begin
                                        if PaymentExportData."Recipient Country/Region Code" = '' then
                                            currXMLport.SKIP;
                                    end;
                                }
                                fieldelement(AdrLine; PaymentExportData."Recipient Address")
                                {

                                    trigger OnBeforePassField();
                                    begin
                                        if PaymentExportData."Recipient Address" = '' then
                                            currXMLport.SKIP;
                                    end;
                                }

                                trigger OnBeforePassVariable();
                                begin
                                    if (PaymentExportData."Recipient Address" = '') and
                                       (PaymentExportData."Recipient Post Code" = '') and
                                       (PaymentExportData."Recipient City" = '') and
                                       (PaymentExportData."Recipient Country/Region Code" = '')
                                    then
                                        currXMLport.SKIP;
                                end;
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(IBAN; PaymentExportData."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = yes;
                                    MaxOccurs = Once;
                                    MinOccurs = Once;
                                }
                            }
                        }
                        textelement(RmtInf)
                        {
                            MinOccurs = Zero;
                            textelement(remittancetext1)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';
                            }
                            textelement(remittancetext2)
                            {
                                MinOccurs = Zero;
                                XmlName = 'Ustrd';

                                trigger OnBeforePassVariable();
                                begin
                                    if RemittanceText2 = '' then
                                        currXMLport.SKIP;
                                end;
                            }

                            trigger OnBeforePassVariable();
                            begin
                                RemittanceText1 := '';
                                RemittanceText2 := '';
                                TempPaymentExportRemittanceText.SETRANGE("Pmt. Export Data Entry No.", PaymentExportData."Entry No.");
                                if not TempPaymentExportRemittanceText.FINDSET then
                                    currXMLport.SKIP;
                                RemittanceText1 := COPYSTR(rG_CompanyInfo."Name" + '-' + cu_Convert.Pc2Elot(TempPaymentExportRemittanceText.Text), 1, 140);
                                if TempPaymentExportRemittanceText.NEXT = 0 then
                                    exit;
                                RemittanceText2 := COPYSTR(rG_CompanyInfo."Name" + '-' + cu_Convert.Pc2Elot(TempPaymentExportRemittanceText.Text), 1, 140);
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters then
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
                end;
            }
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

    trigger OnPreXmlPort();
    begin
        InitData;
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: TextConst Comment = '%1=Field;%2=Value;%3=Value', ENU = 'There is no data to export.';
        cu_Convert: Codeunit "General Mgt.";
        rG_CompanyInfo: Record "Company Information";

    local procedure InitData();
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        PaymentGroupNo: Integer;
        rL_BankAccount: record "Bank Account";
        rL_GenJournalLine: Record "Gen. Journal Line";
        rL_Vendor: Record VEndor;
        rL_Customer: Record Customer;
        rL_VendorBankAccount: Record "Vendor Bank Account";
        rL_CustomerBankAccount: Record "Customer Bank Account";
        rL_GLSetup: Record "General Ledger Setup";
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);

        rL_GLSetup.GET;
        PaymentExportData.RESET;
        if PaymentExportData.FindSet() then begin
            // WITH PaymentExportData DO BEGIN
            //Message(Format(PaymentExportData.Count));
            repeat
                rL_Customer.RESET;
                rL_Customer.SetFilter(Name, PaymentExportData."Recipient Name");
                rL_Customer.SetFilter(Address, PaymentExportData."Recipient Address");
                if rL_Customer.FindSet then begin
                    if rL_Customer.Count > 1 then begin
                        Error('More than one customer found');
                    end;

                    rL_CustomerBankAccount.RESET;
                    rL_CustomerBankAccount.SetFilter("Customer No.", rL_Customer."No.");
                    rL_CustomerBankAccount.SetFilter(IBAN, PaymentExportData."Recipient Bank Acc. No.");
                    IF rL_CustomerBankAccount.FindFirst THEN BEGIN
                        //+TAL0.5
                        PaymentExportData."Intermediary Bank Swift Code" := rL_CustomerBankAccount."Intermediary Bank Swift Code";
                        PaymentExportData."Sorting Code" := rL_CustomerBankAccount."Sorting Code";
                        PaymentExportData."R Correspondent Swift Code" := rL_CustomerBankAccount."R Correspondent Swift Code";
                        //PaymentExportData."R Correspondent Bank Name" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Bank Name");
                        PaymentExportData."R Correspondent Bank Name" := rL_CustomerBankAccount."R Correspondent Bank Name";
                        //PaymentExportData."R Correspondent Address 1" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 1");
                        PaymentExportData."R Correspondent Address 1" := rL_CustomerBankAccount."R Correspondent Address 1";
                        //PaymentExportData."R Correspondent Address 2" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 2");
                        PaymentExportData."R Correspondent Address 2" := rL_CustomerBankAccount."R Correspondent Address 2";
                        //PaymentExportData."R Correspondent Address 3" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 3");
                        PaymentExportData."R Correspondent Address 3" := rL_CustomerBankAccount."R Correspondent Address 3";
                        PaymentExportData."Thrd R Institution Swift Code" := rL_CustomerBankAccount."Thrd R Institution Swift Code";
                        //PaymentExportData."Thrd R Institution Bank Name" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thrd R Institution Bank Name");
                        PaymentExportData."Thrd R Institution Bank Name" := rL_CustomerBankAccount."Thrd R Institution Bank Name";
                        //PaymentExportData."Thr R Institution RC Address 1" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 1");
                        PaymentExportData."Thr R Institution RC Address 1" := rL_CustomerBankAccount."Thr R Institution RC Address 1";
                        //PaymentExportData."Thr R Institution RC Address 2" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 2");
                        PaymentExportData."Thr R Institution RC Address 2" := rL_CustomerBankAccount."Thr R Institution RC Address 2";
                        //PaymentExportData."Thr R Institution RC Address 3" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 3");
                        PaymentExportData."Thr R Institution RC Address 3" := rL_CustomerBankAccount."Thr R Institution RC Address 3";
                        //-TAL0.5
                    END;

                end ELSE BEGIN
                    rL_Vendor.RESET;
                    rL_Vendor.SetFilter(Name, PaymentExportData."Recipient Name");
                    rL_Vendor.SetFilter(Address, PaymentExportData."Recipient Address");
                    if rL_Vendor.FindSet then begin
                        if rL_Vendor.Count > 1 then begin
                            Error('More than one vendor found');
                        end;

                        rL_VendorBankAccount.RESET;
                        rL_VendorBankAccount.SetFilter("Vendor No.", rL_Vendor."No.");
                        rL_VendorBankAccount.SetFilter(IBAN, PaymentExportData."Recipient Bank Acc. No.");
                        IF rL_VendorBankAccount.FindFirst THEN BEGIN
                            //+TAL0.5
                            PaymentExportData."Intermediary Bank Swift Code" := rL_VendorBankAccount."Intermediary Bank Swift Code";
                            PaymentExportData."Sorting Code" := rL_VendorBankAccount."Sorting Code";
                            PaymentExportData."R Correspondent Swift Code" := rL_VendorBankAccount."R Correspondent Swift Code";
                            //PaymentExportData."R Correspondent Bank Name" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Bank Name");
                            PaymentExportData."R Correspondent Bank Name" := rL_VendorBankAccount."R Correspondent Bank Name";
                            //PaymentExportData."R Correspondent Address 1" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 1");
                            PaymentExportData."R Correspondent Address 1" := rL_VendorBankAccount."R Correspondent Address 1";
                            //PaymentExportData."R Correspondent Address 2" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 2");
                            PaymentExportData."R Correspondent Address 2" := rL_VendorBankAccount."R Correspondent Address 2";
                            //PaymentExportData."R Correspondent Address 3" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 3");
                            PaymentExportData."R Correspondent Address 3" := rL_VendorBankAccount."R Correspondent Address 3";
                            PaymentExportData."Thrd R Institution Swift Code" := rL_VendorBankAccount."Thrd R Institution Swift Code";
                            //PaymentExportData."Thrd R Institution Bank Name" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thrd R Institution Bank Name");
                            PaymentExportData."Thrd R Institution Bank Name" := rL_VendorBankAccount."Thrd R Institution Bank Name";
                            //PaymentExportData."Thr R Institution RC Address 1" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 1");
                            PaymentExportData."Thr R Institution RC Address 1" := rL_VendorBankAccount."Thr R Institution RC Address 1";
                            //PaymentExportData."Thr R Institution RC Address 2" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 2");
                            PaymentExportData."Thr R Institution RC Address 2" := rL_VendorBankAccount."Thr R Institution RC Address 2";
                            //PaymentExportData."Thr R Institution RC Address 3" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 3");
                            PaymentExportData."Thr R Institution RC Address 3" := rL_VendorBankAccount."Thr R Institution RC Address 3";
                            //-TAL0.5
                        END;

                    end;
                END;



                //convert characters
                //PaymentExportData."Recipient Name" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Name"), 1, 35);
                PaymentExportData."Recipient Name" := COPYSTR(PaymentExportData."Recipient Name", 1, 35);
                //PaymentExportData."Recipient Address" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Address"), 1, 35);
                PaymentExportData."Recipient Address" := COPYSTR(PaymentExportData."Recipient Address", 1, 35);
                //PaymentExportData."Recipient Address 2" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Address 2"), 1, 35);
                PaymentExportData."Recipient Address 2" := COPYSTR(PaymentExportData."Recipient Address 2", 1, 35);
                //PaymentExportData."Recipient City" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient City"), 1, 35);
                PaymentExportData."Recipient City" := COPYSTR(PaymentExportData."Recipient City", 1, 35);
                //PaymentExportData."Recipient County" := cu_Convert.Pc2Elot(PaymentExportData."Recipient County");
                PaymentExportData."Recipient County" := PaymentExportData."Recipient County";
                //PaymentExportData."Recipient Post Code" := cu_Convert.Pc2Elot(PaymentExportData."Recipient Post Code");
                PaymentExportData."Recipient Post Code" := PaymentExportData."Recipient Post Code";

                rL_BankAccount.GET(PaymentExportData."Sender Bank Account Code");
                rL_BankAccount.testfield("Bank Transfer Company Code");
                PaymentExportData."Bank Transfer Company Code" := rL_BankAccount."Bank Transfer Company Code";
                PaymentExportData."Category Purpose" := 'SUPP'; //TempGenJnlLine."Reason Code";
                PaymentExportData.SetPreserveNonLatinCharacters(true);

                //+TAL0.1   
                IF rL_BankAccount."Currency Code" = '' THEN BEGIN
                    PaymentExportData."Sender Bank Account Currency" := rL_GLSetup."LCY Code";
                END ELSE BEGIN
                    PaymentExportData."Sender Bank Account Currency" := rL_BankAccount."Currency Code";
                END;
                //-TAL0.1  
                PaymentExportData.Modify();

            until PaymentExportData.Next = 0;
        end;

        //end;
        rG_CompanyInfo.GET;

        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        ServiceLevel := 'SEPA';
        ServiceLevel2 := 'SEPA';
        //CategoryPurpose:='SUPP';
        CompanyCode := PaymentExportData."Bank Transfer Company Code";
        CompanyCode2 := PaymentExportData."Bank Transfer Company Code";

        NoOfTransfers := FORMAT(PaymentExportData.COUNT);
        MessageID := PaymentExportData."Message ID";
        CreatedDateTime := FORMAT(CURRENTDATETIME, 19, 9);
        PaymentExportData.CALCSUMS(Amount);
        ControlSum := FORMAT(PaymentExportData.Amount, 0, 9);

        PaymentExportData.SETCURRENTKEY(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        if not PaymentExportData.FINDSET then
            ERROR(NoDataToExportErr);

        InitPmtGroup;
        repeat
            if IsNewGroup then begin
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup;
            end;
            PaymentExportDataGroup."Line No." += 1;
            PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        until PaymentExportData.NEXT = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean;
    begin
        exit(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") or
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") or
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") or
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") or
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup();
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer);
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          COPYSTR(
            STRSUBSTNO('%1/%2', PaymentExportData."Message ID", PaymentGroupNo),
            1, MAXSTRLEN(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.INSERT;
    end;
}

