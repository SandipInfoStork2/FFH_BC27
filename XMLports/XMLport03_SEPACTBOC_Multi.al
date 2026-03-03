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
                        fieldelement(Nm; companyinformation.Name)
                        {
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
                    fieldelement(ReqdExctnDt; paymentexportdatagroup."Transfer Date")
                    {
                    }
                    textelement(Dbtr)
                    {
                        fieldelement(Nm; companyinformation.Name)
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
                            fieldelement(EmailAdr; companyinformation."E-Mail")
                            {
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
                    textelement(chrgbrtext)
                    {
                        XmlName = 'ChrgBr';
                    }
                    tableelement(paymentexportdata; "Payment Export Data")
                    {
                        LinkFields = "Sender Bank BIC" = field("Sender Bank BIC"), "SEPA Instruction Priority Text" = field("SEPA Instruction Priority Text"), "Transfer Date" = field("Transfer Date"), "SEPA Batch Booking" = field("SEPA Batch Booking"), "SEPA Charge Bearer Text" = field("SEPA Charge Bearer Text"), "Payment Information ID" = field("Payment Information ID");
                        LinkTable = paymentexportdatagroup;
                        XmlName = 'CdtTrfTxInf';
                        UseTemporary = true;
                        textelement(PmtId)
                        {
                            fieldelement(EndToEndId; paymentexportdata."End-to-End ID")
                            {
                            }
                        }
                        textelement("<pmttpinf>")
                        {
                            MinOccurs = Zero;
                            XmlName = 'PmtTpInf';
                            textelement(LclInstrm)
                            {
                                fieldelement(Prtry; paymentexportdatagroup."Transfer Date")
                                {


                                }
                            }

                            //in BOC the recipient Transfer Date is optional and for SEPA is automatically handled by the bank + 1 working date
                            trigger OnBeforePassVariable()
                            var
                                myInt: Integer;
                            begin
                                //IF PaymentExportDataGroup."Recipient Transfer Date" = 0D THEN BEGIN
                                currXMLport.Skip;
                                //END;
                            end;
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
                                remittancetext1 := CopyStr(UpperCase(companyinformation.Name) + '-' + TempPaymentExportRemittanceText.Text, 1, 140); //TAL0.4 TempPaymentExportRemittanceText.Text;
                                if TempPaymentExportRemittanceText.Next = 0 then
                                    exit;
                                remittancetext2 := CopyStr(UpperCase(companyinformation.Name) + '-' + TempPaymentExportRemittanceText.Text, 1, 140); //TAL0.4 TempPaymentExportRemittanceText.Text;
                            end;
                        }
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    if not paymentexportdata.GetPreserveNonLatinCharacters then
                        paymentexportdata.CompanyInformationConvertToLatin(companyinformation);

                    vg_companyphoneno := companyinformation."Phone No.";
                    if StrPos('+357', vg_companyphoneno) = 0 then begin
                        vg_companyphoneno := '+357-' + DelChr(vg_companyphoneno, '=', ' ');
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
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", paymentexportdata);
        paymentexportdata.GetRemittanceTexts(TempPaymentExportRemittanceText);



        servicelevel := 'SEPA';
        //ServiceLevel2:='SEPA';
        categorypurpose := 'SUPP';
        chrgbrtext := 'SHAR';
        //CompanyCode:=PaymentExportData."Bank Transfer Company Code";
        //CompanyCode2:=PaymentExportData."Bank Transfer Company Code";

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

