report 50079 "Notify Expiring Items"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code";
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Item No." = FIELD("No.");
                DataItemTableView = SORTING("Item No.", Open, Positive, "Location Code", "Expiration Date");

                trigger OnAfterGetRecord();
                begin
                    if ("Lot No." <> '') and ("Expiration Date" <> 0D) then begin
                        if not Buffer.GET("Item No.", "Lot No.", "Expiration Date") then begin
                            CLEAR(Buffer);
                            Buffer."Item No." := "Item No.";
                            Buffer."Lot No." := "Lot No.";
                            Buffer."Expiration Date" := "Expiration Date";
                            Buffer.INSERT;
                        end;
                        Buffer.Quantity += "Remaining Quantity";
                        Buffer.MODIFY;
                    end;

                end;

                trigger OnPostDataItem();
                var

                begin
                    //Buffer.RESET;
                    // Buffer.SetFilter("Item No.", Item."No.");

                end;

                trigger OnPreDataItem();
                begin
                    ExpirationDate := TODAY;
                    SETRANGE(Open, true);
                    SETRANGE(Positive, true);
                    //SETRANGE("Location Code", FromLocationCode);
                    SETFILTER("Expiration Date", '<=%1&<>%2', ExpirationDate, 0D);


                end;
            }

            trigger OnAfterGetRecord();
            begin

            end;


            trigger OnPreDataItem();
            var

            begin
                Buffer.DELETEALL;
            end;

            trigger OnPostDataItem();
            var
                Email: Codeunit Email;
                EmailMessage: Codeunit "Email Message";

                ToRecipient: List of [Text];
                CCRecipient: List of [Text];
                BCCRecipient: List of [Text];
                Subject: Text;
                InventorySetup: Record "Inventory Setup";
                vBody: Text;
                rL_Item: Record Item;
                recRef: RecordRef;
                AttachementTempBlob: Codeunit "Temp Blob";
                AttachementInstream: InStream;
                AttachementOutStream: OutStream;
                AttachmentName: Text;
                rpt_ItemExpirationQuantity: Report "Item Expiration - Quantity";
                em_Item: Record Item;
                PeriodLength: DateFormula;
                EndingDate: Date;
            begin

                InventorySetup.GET;
                if InventorySetup."Notify Expired Items Email 1" = '' then begin
                    exit;
                end;
                //create the email body
                with Buffer do begin
                    if Buffer.FINDFIRST then begin
                        //send email
                        Subject := 'Expired Items Notification on ' + Format(ExpirationDate);

                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 1");
                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 2");
                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 3");
                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 4");
                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 5");
                        ToRecipient.Add(InventorySetup."Notify Expired Items Email 6");

                        vBody := '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /></head><body>';

                        vBody += '<br><br><table border="1">' +
                                    '<tr>' +
                                        '<th>Item No.</th>' +
                                        '<th>Item Description</th>' +
                                        '<th>Lot No.</th>' +
                                        '<th>Expiration Date</th>' +
                                        '<th>Quantity</th>' +
                                    '</tr>';
                        repeat
                            rL_Item.GET(Buffer."Item No.");
                            vBody += '<tr>' +
                                        '<td>' + FORMAT(Buffer."Item No.") + '</td>' +
                                        '<td>' + FORMAT(rL_Item.Description) + '</td>' +
                                        '<td>' + FORMAT(Buffer."Lot No.") + '</td>' +
                                        '<td align="right">' + FORMAT(Buffer."Expiration Date") + '</td>' +
                                        '<td align="right">' + FORMAT(Buffer.Quantity) + '</td>' +
                                    '</tr>';

                        //EmailMessage.AppendToBody(Body);

                        until Buffer.NEXT = 0;
                        vBody += '</table>';
                        EmailMessage.Create(ToRecipient, Subject, vBody, true, CCRecipient, BCCRecipient);

                        //+1.0.0.241

                        //3 week forcast of items to expire
                        EndingDate := CalcDate('+3W-1D', WorkDate());
                        AttachmentName := 'Item Expiration - Quantity_EndingDate_' + Format(EndingDate) + '.pdf';

                        //Show 1 week period in the 3 columns
                        evaluate(PeriodLength, '1W');
                        recRef.GetTable(em_Item);
                        recRef.SetView(em_Item.GetView());
                        AttachementTempBlob.CreateOutStream(AttachementOutStream);

                        Clear(rpt_ItemExpirationQuantity);
                        rpt_ItemExpirationQuantity.InitializeRequest(EndingDate, PeriodLength);
                        rpt_ItemExpirationQuantity.SetTableView(em_Item);
                        rpt_ItemExpirationQuantity.SaveAs('', REPORTFORMAT::Pdf, AttachementOutStream, recRef);

                        AttachementTempBlob.CreateInStream(AttachementInstream);
                        EmailMessage.AddAttachment(AttachmentName, 'PDF', AttachementInstream);
                        //-1.0.0.241
                        Email.Send(EmailMessage);
                    end;
                end;
            end;

        }
    }

    requestpage
    {

        SaveValues = true;

        layout
        {
            area(content)
            {
                /*
                group(Options)
                {
                    caption = 'Options';

                    field(ExpirationDate; ExpirationDate)
                    {
                        Caption = 'Expiration Date';
                        ShowMandatory = true;
                    }
                    field(FromLocationCode; FromLocationCode)
                    {
                        Caption = 'From Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                    }

                    field(ToLocationCode; ToLocationCode)
                    {
                        Caption = 'To Location Code';
                        ShowMandatory = true;
                        TableRelation = Location;
                    }
                }
                */

            }

        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            myInt: Integer;
        begin
            ExpirationDate := WorkDate();
            //FromLocationCode := 'ARAD-1';
            //ToLocationCode := 'AR-WASTE';
        end;
    }

    labels
    {
    }

    var

        Buffer: Record ExpirationCalculation temporary;
        //ItemBuffer: Record ExpirationCalculation temporary;
        ExpirationDate: Date;




}

