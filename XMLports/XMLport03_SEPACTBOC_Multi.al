xmlport 50003 "SEPA CT pain.001.001.03 BOC Mu"
{
    // version NAVW18.00,TAL.SEPA

    // TAL0.1 2018/06/1 vasilis review format for BOC
    // http://bankofcyprus.com.cy/globalassets/cyprus/org_methods/sepa/xml-implementation-guidelines-for-multiple-payments.pdf
    // http://bankofcyprus.com.cy/globalassets/cyprus/org_methods/sepa/xml-sample-file-multiple-payments-local-and-swift.xml
    // TAL0.2 2018/06/1 review mutiple payments
    //         bank operator reported 1 debit line - 1 credit line
    //         Steps
    //         1) is group is always true
    //         2) comment last line
    //         3) add Payment Information ID for line uniqueness in CdtTrfTxInf data item link
    // 
    // TAL0.1 2018/06/1 VC  review code

    Caption = 'SEPA CT pain.001.001.03 BOC MULTIPLE PAYMENTS';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    Namespaces = "" = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03', xsi = 'http://www.w3.org/2001/XMLSchema-instance';
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
                    textelement(PmtTpInf)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Zero;
                        textelement(SvcLvl)
                        {
                            textelement(servicelevel)
                            {
                                XmlName = 'Cd';
                            }
                        }
                        textelement(CtgyPurp)
                        {
                            textelement(categorypurpose)
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
                        textelement(CtctDtls)
                        {
                            MaxOccurs = Once;
                            textelement(vg_companyphoneno)
                            {
                                MaxOccurs = Once;
                                XmlName = 'PhneNb';
                            }
                            fieldelement(EmailAdr; CompanyInformation."E-Mail")
                            {
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
                    textelement(chrgbrtext)
                    {
                        XmlName = 'ChrgBr';
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = FIELD("Sender Bank BIC"), "SEPA Instruction Priority Text" = FIELD("SEPA Instruction Priority Text"), "Transfer Date" = FIELD("Transfer Date"), "SEPA Batch Booking" = FIELD("SEPA Batch Booking"), "SEPA Charge Bearer Text" = FIELD("SEPA Charge Bearer Text"), "Payment Information ID" = FIELD("Payment Information ID");
                        LinkTable = PaymentExportDataGroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId; PaymentExportData."End-to-End ID")
                            {
                            }
                        }
                        textelement("<pmttpinf>")
                        {
                            MinOccurs = Zero;
                            XmlName = 'PmtTpInf';
                            textelement(LclInstrm)
                            {
                                fieldelement(Prtry; PaymentExportDataGroup."Transfer Date")
                                {


                                }
                            }

                            //in BOC the recipient Transfer Date is optional and for SEPA is automatically handled by the bank + 1 working date
                            trigger OnBeforePassVariable()
                            var
                                myInt: Integer;
                            begin
                                //IF PaymentExportDataGroup."Recipient Transfer Date" = 0D THEN BEGIN
                                currXMLport.SKIP;
                                //END;
                            end;
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
                                RemittanceText1 := COPYSTR(UPPERCASE(CompanyInformation.Name) + '-' + TempPaymentExportRemittanceText.Text, 1, 140); //TAL0.4 TempPaymentExportRemittanceText.Text;
                                if TempPaymentExportRemittanceText.NEXT = 0 then
                                    exit;
                                RemittanceText2 := COPYSTR(UPPERCASE(CompanyInformation.Name) + '-' + TempPaymentExportRemittanceText.Text, 1, 140); //TAL0.4 TempPaymentExportRemittanceText.Text;
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters then
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);

                    vG_CompanyPhoneNo := CompanyInformation."Phone No.";
                    if STRPOS('+357', vG_CompanyPhoneNo) = 0 then begin
                        vG_CompanyPhoneNo := '+357-' + DELCHR(vG_CompanyPhoneNo, '=', ' ');
                    end;
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

    local procedure InitData();
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        PaymentGroupNo: Integer;
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);



        ServiceLevel := 'SEPA';
        //ServiceLevel2:='SEPA';
        CategoryPurpose := 'SUPP';
        ChrgBrTExt := 'SHAR';
        //CompanyCode:=PaymentExportData."Bank Transfer Company Code";
        //CompanyCode2:=PaymentExportData."Bank Transfer Company Code";

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
        //InsertPmtGroup(PaymentGroupNo); //NOD0.2
    end;

    local procedure IsNewGroup(): Boolean;
    begin
        //+NOD0.2
        exit(true);
        /*
        EXIT(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") OR
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") OR
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") OR
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") OR
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text") //OR
          //(PaymentExportData."Recipient Bank Acc. No." <> PaymentExportDataGroup."Recipient Bank Acc. No.") //NOD
        );
        */
        //-NOD0.2

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

