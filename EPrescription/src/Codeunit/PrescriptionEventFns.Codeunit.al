codeunit 50020 "PDS E-Prescription Event & Fns"
{


    procedure HasIncompleteLineBeforeConvertToPOS(var PrescriptionID: Code[20]): Boolean
    var
        PrescriptionLineBuffer: Record "PDS Prescription Line Buffer";
    begin
        PrescriptionLineBuffer.Reset();
        PrescriptionLineBuffer.SetRange("Prescription ID", PrescriptionID);
        if PrescriptionLineBuffer.FindSet() then
            repeat
                if PrescriptionLineBuffer."Qty. to Dispense" < 1 then
                    exit(true);
                if PrescriptionLineBuffer."Item No." = '' then
                    exit(true);
            until PrescriptionLineBuffer.Next() = 0;

        exit(false);
    end;

    local procedure GetLastPOSLineNo(ReceiptNo: Code[20]): Integer
    var
        LSCPOSTransLine: Record "LSC POS Trans. Line";
    begin
        LSCPOSTransLine.SetCurrentKey("Receipt No.", "Line No.");
        LSCPOSTransLine.SetRange("Receipt No.", ReceiptNo);
        if LSCPOSTransLine.FindLast() then
            exit(LSCPOSTransLine."Line No.");
        exit(0);
    end;

    //***Events***
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Controller", OnLookupResult, '', false, false)]
    local procedure LSCPOSController_OnLookupResult(LookupID: Text; FilterText: Text; resultOK: Boolean; var processed: Boolean)
    var
        PresHdrBuffer: Record "PDS Prescription Hdr Buffer";
        PresLineBuffer: Record "PDS Prescription Line Buffer";
        LSCPOSTransaction: Record "LSC POS Transaction";
        LSCPOSTransLine: Record "LSC POS Trans. Line";
        ActiveRecordID: RecordId;
        LSCPOSControlInterface: Codeunit "LSC POS Control Interface";
        LSCPOSTrans: Codeunit "LSC POS Transaction";
        LSCPOSFunctions: Codeunit "LSC POS Functions";
        Counter_l: Integer;
    begin
        if LookupID = '#PRESCRIPTIONLIST' then
            if resultOK then begin
                begin
                    if LSCPOSControlInterface.GetLookupActiveRecordID(LookupID, ActiveRecordID) then
                        PresHdrBuffer.Get(ActiveRecordID);
                    // message('Lookup Result: %1, %2, %3, ActiveRecordID %4', LookupID, FilterText, resultOK, PresHdrBuffer."Prescription ID");

                    LSCPOSTrans.GetPOSTransaction(LSCPOSTransaction);
                    if not LSCPOSTransaction.IsEmpty then begin
                        LSCPOSTrans.SetPOSTransaction(LSCPOSTransaction);

                        LSCPOSTransaction."Prescribing Doctor" := PresHdrBuffer."Prescribing Doctor";
                        LSCPOSTransaction."Healthcare Assistant" := PresHdrBuffer."Healthcare Assistant";
                        if PresHdrBuffer."Member Card No." <> '' then
                            LSCPOSTrans.InputMemberCard(PresHdrBuffer."Member Card No.");

                        //--Insert POS Lines
                        PresLineBuffer.Reset();
                        PresLineBuffer.SetRange("Prescription ID", PresHdrBuffer."Prescription ID");
                        if PresLineBuffer.FindSet() then
                            repeat
                                Counter_l += GetLastPOSLineNo(LSCPOSTransaction."Receipt No.") + 10000;
                                LSCPOSTransLine.Init;
                                LSCPOSTransLine.Validate("Receipt No.", LSCPOSTransaction."Receipt No.");
                                LSCPOSTransLine."Store No." := LSCPOSTransaction."Store No.";
                                LSCPOSTransLine."POS Terminal No." := LSCPOSTransaction."POS Terminal No.";
                                LSCPOSTransLine.Validate("Line No.", Counter_l);
                                LSCPOSTransLine.Insert(true);
                                LSCPOSTransLine."Entry Type" := LSCPOSTransLine."Entry Type"::Item;
                                LSCPOSTransLine.Validate(Number, PresLineBuffer."Item No.");
                                LSCPOSTransLine.Validate(Quantity, PresLineBuffer."Qty. to Dispense");
                                // LSCPOSTransLine.Validate("Lot No.", PresLineBuffer."Lot No.");
                                // LSCPOSTransLine.Validate("Expiration Date", PresLineBuffer."Expiration Date");
                                LSCPOSTransLine.CalcPrices();
                                LSCPOSTransLine.Modify;
                            until PresLineBuffer.Next() = 0;
                        LSCPOSTrans.CalcTotals;
                        // PresHdrBuffer."Converted to POS" := true;
                        // PresHdrBuffer.Modify;

                        processed := true;
                    end else begin
                        Message('Current POS Transaction Not Found.');
                        processed := false;
                    end;

                end;
            end;
    end;

}
