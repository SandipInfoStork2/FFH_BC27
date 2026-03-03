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
                        fieldelement(Nm; companyinformation.Name)
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
                    fieldelement(PmtInfId; paymentexportdatagroup."Payment Information ID")
                    {
                    }
                    fieldelement(PmtMtd; paymentexportdatagroup."SEPA Payment Method Text")
                    {
                    }
                    fieldelement(BtchBookg; paymentexportdatagroup."SEPA Batch Booking")
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
                    fieldelement(ReqdExctnDt; paymentexportdatagroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; companyinformation.Name)
                        {
                        }
                        textelement(dbtrpstladr)
                        {
                            XmlName = 'PstlAdr';
                            fieldelement(Ctry; companyinformation."Country/Region Code")
                            {
                            }
                        }
                        textelement(dbtrid)
                        {
                            XmlName = 'Id';
                            textelement(dbtrorgid)
                            {
                                XmlName = 'OrgId';
                                fieldelement(BICOrBEI; paymentexportdatagroup."Sender Bank BIC")
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
                            fieldelement(IBAN; paymentexportdatagroup."Sender Bank Account No.")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                        fieldelement(Ccy; paymentexportdatagroup."Sender Bank Account Currency")
                        {
                        }
                    }
                    textelement(DbtrAgt)
                    {
                        textelement(dbtragtfininstnid)
                        {
                            XmlName = 'FinInstnId';
                            fieldelement(BIC; paymentexportdatagroup."Sender Bank BIC")
                            {
                                MaxOccurs = Once;
                                MinOccurs = Once;
                            }
                        }
                    }
                    fieldelement(ChrgBr; paymentexportdatagroup."SEPA Charge Bearer Text")
                    {
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"), "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"), "Transfer Date" = field("Transfer Date"), "SEPA Batch Booking" = field("SEPA Batch Booking"), "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text");
                        LinkTable = paymentexportdatagroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(InstrId; paymentexportdata."End-to-End ID")
                            {
                            }
                            fieldelement(EndToEndId; paymentexportdata."End-to-End ID")
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
                                fieldelement(Cd; paymentexportdata."Category Purpose")
                                {
                                }
                            }
                        }
                        textelement(Amt)
                        {
                            fieldelement(InstdAmt; paymentexportdata.Amount)
                            {
                                fieldattribute(Ccy; paymentexportdata."Currency Code")
                                {
                                }
                            }
                        }
                        fieldelement(ChrgBr; paymentexportdatagroup."SEPA Charge Bearer Text")
                        {
                        }
                        textelement(CdtrAgt)
                        {
                            textelement(cdtragtfininstnid)
                            {
                                XmlName = 'FinInstnId';
                                fieldelement(BIC; paymentexportdata."Recipient Bank BIC")
                                {
                                    FieldValidate = Yes;
                                }
                            }
                        }
                        textelement(Cdtr)
                        {
                            fieldelement(Nm; paymentexportdata."Recipient Name")
                            {
                            }
                            textelement(cdtrpstladr)
                            {
                                XmlName = 'PstlAdr';
                                fieldelement(Ctry; paymentexportdata."Recipient Country/Region Code")
                                {

                                    trigger OnBeforePassField();
                                    begin
                                        if paymentexportdata."Recipient Country/Region Code" = '' then
                                            currXMLport.Skip;
                                    end;
                                }
                                fieldelement(AdrLine; paymentexportdata."Recipient Address")
                                {

                                    trigger OnBeforePassField();
                                    begin
                                        if paymentexportdata."Recipient Address" = '' then
                                            currXMLport.Skip;
                                    end;
                                }

                                trigger OnBeforePassVariable();
                                begin
                                    if (paymentexportdata."Recipient Address" = '') and
                                       (paymentexportdata."Recipient Post Code" = '') and
                                       (paymentexportdata."Recipient City" = '') and
                                       (paymentexportdata."Recipient Country/Region Code" = '')
                                    then
                                        currXMLport.Skip;
                                end;
                            }
                        }
                        textelement(CdtrAcct)
                        {
                            textelement(cdtracctid)
                            {
                                XmlName = 'Id';
                                fieldelement(IBAN; paymentexportdata."Recipient Bank Acc. No.")
                                {
                                    FieldValidate = Yes;
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
                                    if remittancetext2 = '' then
                                        currXMLport.Skip;
                                end;
                            }

                            trigger OnBeforePassVariable();
                            begin
                                remittancetext1 := '';
                                remittancetext2 := '';
                                TempPaymentExportRemittanceText.SetRange("Pmt. Export Data Entry No.", paymentexportdata."Entry No.");
                                if not TempPaymentExportRemittanceText.FindSet then
                                    currXMLport.Skip;
                                remittancetext1 := CopyStr(rG_CompanyInfo.Name + '-' + cu_Convert.Pc2Elot(TempPaymentExportRemittanceText.Text), 1, 140);
                                if TempPaymentExportRemittanceText.Next = 0 then
                                    exit;
                                remittancetext2 := CopyStr(rG_CompanyInfo.Name + '-' + cu_Convert.Pc2Elot(TempPaymentExportRemittanceText.Text), 1, 140);
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if not paymentexportdata.GetPreserveNonLatinCharacters then
                        paymentexportdata.CompanyInformationConvertToLatin(companyinformation);
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
        rL_BankAccount: Record "Bank Account";
        rL_GenJournalLine: Record "Gen. Journal Line";
        rL_Vendor: Record Vendor;
        rL_Customer: Record Customer;
        rL_VendorBankAccount: Record "Vendor Bank Account";
        rL_CustomerBankAccount: Record "Customer Bank Account";
        rL_GLSetup: Record "General Ledger Setup";
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", paymentexportdata);

        rL_GLSetup.Get;
        paymentexportdata.Reset;
        if paymentexportdata.FindSet() then begin
            // WITH PaymentExportData DO BEGIN
            //Message(Format(PaymentExportData.Count));
            repeat
                rL_Customer.Reset;
                rL_Customer.SetFilter(Name, paymentexportdata."Recipient Name");
                rL_Customer.SetFilter(Address, paymentexportdata."Recipient Address");
                if rL_Customer.FindSet then begin
                    if rL_Customer.Count > 1 then begin
                        Error('More than one customer found');
                    end;

                    rL_CustomerBankAccount.Reset;
                    rL_CustomerBankAccount.SetFilter("Customer No.", rL_Customer."No.");
                    rL_CustomerBankAccount.SetFilter(IBAN, paymentexportdata."Recipient Bank Acc. No.");
                    if rL_CustomerBankAccount.FindFirst then begin
                        //+TAL0.5
                        paymentexportdata."Intermediary Bank Swift Code" := rL_CustomerBankAccount."Intermediary Bank Swift Code";
                        paymentexportdata."Sorting Code" := rL_CustomerBankAccount."Sorting Code";
                        paymentexportdata."R Correspondent Swift Code" := rL_CustomerBankAccount."R Correspondent Swift Code";
                        //PaymentExportData."R Correspondent Bank Name" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Bank Name");
                        paymentexportdata."R Correspondent Bank Name" := rL_CustomerBankAccount."R Correspondent Bank Name";
                        //PaymentExportData."R Correspondent Address 1" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 1");
                        paymentexportdata."R Correspondent Address 1" := rL_CustomerBankAccount."R Correspondent Address 1";
                        //PaymentExportData."R Correspondent Address 2" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 2");
                        paymentexportdata."R Correspondent Address 2" := rL_CustomerBankAccount."R Correspondent Address 2";
                        //PaymentExportData."R Correspondent Address 3" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."R Correspondent Address 3");
                        paymentexportdata."R Correspondent Address 3" := rL_CustomerBankAccount."R Correspondent Address 3";
                        paymentexportdata."Thrd R Institution Swift Code" := rL_CustomerBankAccount."Thrd R Institution Swift Code";
                        //PaymentExportData."Thrd R Institution Bank Name" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thrd R Institution Bank Name");
                        paymentexportdata."Thrd R Institution Bank Name" := rL_CustomerBankAccount."Thrd R Institution Bank Name";
                        //PaymentExportData."Thr R Institution RC Address 1" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 1");
                        paymentexportdata."Thr R Institution RC Address 1" := rL_CustomerBankAccount."Thr R Institution RC Address 1";
                        //PaymentExportData."Thr R Institution RC Address 2" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 2");
                        paymentexportdata."Thr R Institution RC Address 2" := rL_CustomerBankAccount."Thr R Institution RC Address 2";
                        //PaymentExportData."Thr R Institution RC Address 3" := cu_Convert.Pc2Elot(rL_CustomerBankAccount."Thr R Institution RC Address 3");
                        paymentexportdata."Thr R Institution RC Address 3" := rL_CustomerBankAccount."Thr R Institution RC Address 3";
                        //-TAL0.5
                    end;

                end else begin
                    rL_Vendor.Reset;
                    rL_Vendor.SetFilter(Name, paymentexportdata."Recipient Name");
                    rL_Vendor.SetFilter(Address, paymentexportdata."Recipient Address");
                    if rL_Vendor.FindSet then begin
                        if rL_Vendor.Count > 1 then begin
                            Error('More than one vendor found');
                        end;

                        rL_VendorBankAccount.Reset;
                        rL_VendorBankAccount.SetFilter("Vendor No.", rL_Vendor."No.");
                        rL_VendorBankAccount.SetFilter(IBAN, paymentexportdata."Recipient Bank Acc. No.");
                        if rL_VendorBankAccount.FindFirst then begin
                            //+TAL0.5
                            paymentexportdata."Intermediary Bank Swift Code" := rL_VendorBankAccount."Intermediary Bank Swift Code";
                            paymentexportdata."Sorting Code" := rL_VendorBankAccount."Sorting Code";
                            paymentexportdata."R Correspondent Swift Code" := rL_VendorBankAccount."R Correspondent Swift Code";
                            //PaymentExportData."R Correspondent Bank Name" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Bank Name");
                            paymentexportdata."R Correspondent Bank Name" := rL_VendorBankAccount."R Correspondent Bank Name";
                            //PaymentExportData."R Correspondent Address 1" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 1");
                            paymentexportdata."R Correspondent Address 1" := rL_VendorBankAccount."R Correspondent Address 1";
                            //PaymentExportData."R Correspondent Address 2" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 2");
                            paymentexportdata."R Correspondent Address 2" := rL_VendorBankAccount."R Correspondent Address 2";
                            //PaymentExportData."R Correspondent Address 3" := cu_Convert.Pc2Elot(rL_VendorBankAccount."R Correspondent Address 3");
                            paymentexportdata."R Correspondent Address 3" := rL_VendorBankAccount."R Correspondent Address 3";
                            paymentexportdata."Thrd R Institution Swift Code" := rL_VendorBankAccount."Thrd R Institution Swift Code";
                            //PaymentExportData."Thrd R Institution Bank Name" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thrd R Institution Bank Name");
                            paymentexportdata."Thrd R Institution Bank Name" := rL_VendorBankAccount."Thrd R Institution Bank Name";
                            //PaymentExportData."Thr R Institution RC Address 1" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 1");
                            paymentexportdata."Thr R Institution RC Address 1" := rL_VendorBankAccount."Thr R Institution RC Address 1";
                            //PaymentExportData."Thr R Institution RC Address 2" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 2");
                            paymentexportdata."Thr R Institution RC Address 2" := rL_VendorBankAccount."Thr R Institution RC Address 2";
                            //PaymentExportData."Thr R Institution RC Address 3" := cu_Convert.Pc2Elot(rL_VendorBankAccount."Thr R Institution RC Address 3");
                            paymentexportdata."Thr R Institution RC Address 3" := rL_VendorBankAccount."Thr R Institution RC Address 3";
                            //-TAL0.5
                        end;

                    end;
                end;



                //convert characters
                //PaymentExportData."Recipient Name" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Name"), 1, 35);
                paymentexportdata."Recipient Name" := CopyStr(paymentexportdata."Recipient Name", 1, 35);
                //PaymentExportData."Recipient Address" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Address"), 1, 35);
                paymentexportdata."Recipient Address" := CopyStr(paymentexportdata."Recipient Address", 1, 35);
                //PaymentExportData."Recipient Address 2" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient Address 2"), 1, 35);
                paymentexportdata."Recipient Address 2" := CopyStr(paymentexportdata."Recipient Address 2", 1, 35);
                //PaymentExportData."Recipient City" := COPYSTR(cu_Convert.Pc2Elot(PaymentExportData."Recipient City"), 1, 35);
                paymentexportdata."Recipient City" := CopyStr(paymentexportdata."Recipient City", 1, 35);
                //PaymentExportData."Recipient County" := cu_Convert.Pc2Elot(PaymentExportData."Recipient County");
                paymentexportdata."Recipient County" := paymentexportdata."Recipient County";
                //PaymentExportData."Recipient Post Code" := cu_Convert.Pc2Elot(PaymentExportData."Recipient Post Code");
                paymentexportdata."Recipient Post Code" := paymentexportdata."Recipient Post Code";

                rL_BankAccount.Get(paymentexportdata."Sender Bank Account Code");
                rL_BankAccount.TestField("Bank Transfer Company Code");
                paymentexportdata."Bank Transfer Company Code" := rL_BankAccount."Bank Transfer Company Code";
                paymentexportdata."Category Purpose" := 'SUPP'; //TempGenJnlLine."Reason Code";
                paymentexportdata.SetPreserveNonLatinCharacters(true);

                //+TAL0.1   
                if rL_BankAccount."Currency Code" = '' then begin
                    paymentexportdata."Sender Bank Account Currency" := rL_GLSetup."LCY Code";
                end else begin
                    paymentexportdata."Sender Bank Account Currency" := rL_BankAccount."Currency Code";
                end;
                //-TAL0.1  
                paymentexportdata.Modify();

            until paymentexportdata.Next = 0;
        end;

        //end;
        rG_CompanyInfo.Get;

        paymentexportdata.GetRemittanceTexts(TempPaymentExportRemittanceText);

        servicelevel := 'SEPA';
        servicelevel2 := 'SEPA';
        //CategoryPurpose:='SUPP';
        companycode := paymentexportdata."Bank Transfer Company Code";
        companycode2 := paymentexportdata."Bank Transfer Company Code";

        nooftransfers := Format(paymentexportdata.Count);
        messageid := paymentexportdata."Message ID";
        createddatetime := Format(CurrentDateTime, 19, 9);
        paymentexportdata.CalcSums(Amount);
        controlsum := Format(paymentexportdata.Amount, 0, 9);

        paymentexportdata.SetCurrentKey(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        if not paymentexportdata.FindSet then
            Error(NoDataToExportErr);

        InitPmtGroup;
        repeat
            if IsNewGroup then begin
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup;
            end;
            paymentexportdatagroup."Line No." += 1;
            paymentexportdatagroup.Amount += paymentexportdata.Amount;
        until paymentexportdata.Next = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean;
    begin
        exit(
          (paymentexportdata."Sender Bank BIC" <> paymentexportdatagroup."Sender Bank BIC") or
          (paymentexportdata."SEPA Instruction Priority Text" <> paymentexportdatagroup."SEPA Instruction Priority Text") or
          (paymentexportdata."Transfer Date" <> paymentexportdatagroup."Transfer Date") or
          (paymentexportdata."SEPA Batch Booking" <> paymentexportdatagroup."SEPA Batch Booking") or
          (paymentexportdata."SEPA Charge Bearer Text" <> paymentexportdatagroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup();
    begin
        paymentexportdatagroup := paymentexportdata;
        paymentexportdatagroup."Line No." := 0; // used for counting transactions within group
        paymentexportdatagroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer);
    begin
        PaymentGroupNo += 1;
        paymentexportdatagroup."Entry No." := PaymentGroupNo;
        paymentexportdatagroup."Payment Information ID" :=
          CopyStr(
            StrSubstNo('%1/%2', paymentexportdata."Message ID", PaymentGroupNo),
            1, MaxStrLen(paymentexportdatagroup."Payment Information ID"));
        paymentexportdatagroup.Insert;
    end;
}

