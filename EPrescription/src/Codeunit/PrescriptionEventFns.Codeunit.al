codeunit 50020 "PDS E-Prescription Event & Fns"
{


    procedure HasIncompleteLineBeforeConvertToPOS(var PrescriptionID: Code[20]): Boolean
    var
        PrescriptionHeader: Record "PDS Prescription Hdr Buffer";
        PrescriptionLineBuffer: Record "PDS Prescription Line Buffer";
    begin
        if PrescriptionHeader.Get(PrescriptionID) then begin
            PrescriptionHeader.TestField("Health Plus No.");
            PrescriptionHeader.TestField("Member Account No.");
            PrescriptionHeader.TestField("Member Card No.");
            PrescriptionHeader.TestField("Patient First Name");
            PrescriptionHeader.TestField("Patient Middle Name");
            PrescriptionHeader.TestField("Patient Last Name");
            PrescriptionHeader.TestField(Gender);
            PrescriptionHeader.TestField(Birthdate);
            PrescriptionHeader.TestField(Age);
            PrescriptionHeader.TestField(Address);
            PrescriptionHeader.TestField("Prescribing Doctor");
            PrescriptionHeader.TestField("Healthcare Assistant");
            PrescriptionHeader.TestField("Pharmacy No.");
        end;

        PrescriptionLineBuffer.Reset();
        PrescriptionLineBuffer.SetRange("Prescription ID", PrescriptionID);
        if PrescriptionLineBuffer.FindSet() then
            repeat
                if PrescriptionLineBuffer."Item No." = '' then
                    exit(true);
                if PrescriptionLineBuffer."Qty. to Dispense" < 1 then
                    exit(true);
                if PrescriptionLineBuffer."Lot No." = '' then
                    exit(true);
                if PrescriptionLineBuffer."Expiration Date" = 0D then
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

    local procedure UpdatePOSTransactionFields(var POSTransaction: Record "LSC POS Transaction"; PrescHdr: Record "PDS Prescription Hdr Buffer")
    var
        MemberContact: Record "LSC Member Contact";
    begin
        MemberContact.Reset();
        MemberContact.SetRange("Account No.", PrescHdr."Member Account No.");
        if MemberContact.FindFirst() then;
        POSTransaction."Primary Card No." := MemberContact."Primary Card No.";
        POSTransaction."PWD ID" := MemberContact."PWD ID No.";
        POSTransaction.PWD := MemberContact.PWD;
        POSTransaction.Pregnant := MemberContact.Pregnant;
        POSTransaction."Booklet No." := MemberContact."Booklet No.";
        POSTransaction."PDI Account Type" := MemberContact."PDI Account Type";
        POSTransaction."PDI Patient Relation" := MemberContact."PDI Patient Relation";
        POSTransaction."PDI Cluster" := MemberContact."PDI Cluster";
        POSTransaction."PDI Brgy. Name" := MemberContact."PDI Brgy. Name";
        POSTransaction."PDI Date of Birth" := MemberContact."Date of Birth";
        POSTransaction."PDI Age" := MemberContact."PDI Age";
        POSTransaction."PDI Main Member Card No." := PrescHdr."Member Card No.";
        POSTransaction."PDI Member Name" := MemberContact.Name;
        POSTransaction."PDI Member Address" := MemberContact.Address;
    end;

    local procedure UpdatePOSTransLinesFields(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line";
                                                        PrescLine: Record "PDS Prescription Line Buffer")
    var
        Item: Record Item;
    begin
        if Item.Get(POSTransLine.Number) then;
        POSTransLine.Validate("Internal Group Code", Item."Internal Group Code");
        POSTransLine.Validate("Sub Description", PrescLine."Item Sub Description");
        POSTransLine.Validate("Sub Description 2", PrescLine."Item Sub Brand");
        POSTransLine.Validate("Dispense Date", POSTransaction."Dispense Date");
        POSTransLine.Validate("Unit of Measure", Item."Base Unit of Measure");
        POSTransLine.Validate("Sales Type Loc. Code", PrescLine."Location Code");
    end;

    //***Events***
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Controller", OnLookupResult, '', false, false)]
    local procedure LSCPOSController_OnLookupResult(LookupID: Text; FilterText: Text; resultOK: Boolean; var processed: Boolean)
    var
        PresHdrBuffer: Record "PDS Prescription Hdr Buffer";
        PresLineBuffer: Record "PDS Prescription Line Buffer";
        PresLineBuffer2: Record "PDS Prescription Line Buffer";
        LSCPOSTransaction: Record "LSC POS Transaction";
        LSCPOSTransLine: Record "LSC POS Trans. Line";
        LSCPOSControlInterface: Codeunit "LSC POS Control Interface";
        LSCPOSTrans: Codeunit "LSC POS Transaction";
        LSCPOSFunctions: Codeunit "LSC POS Functions";
        ActiveRecordID: RecordId;
        Counter_l: Integer;
    begin
        if LookupID = '#PRESCRIPTIONLIST' then
            if resultOK then begin
                begin
                    if LSCPOSControlInterface.GetLookupActiveRecordID(LookupID, ActiveRecordID) then
                        PresHdrBuffer.Get(ActiveRecordID);

                    LSCPOSTrans.GetPOSTransaction(LSCPOSTransaction);
                    if not LSCPOSTransaction.IsEmpty then begin

                        LSCPOSTransaction."Prescribing Doctor" := PresHdrBuffer."Prescribing Doctor";
                        LSCPOSTransaction."Healthcare Assistant" := PresHdrBuffer."Healthcare Assistant";
                        UpdatePOSTransactionFields(LSCPOSTransaction, PresHdrBuffer);
                        if PresHdrBuffer."Member Card No." <> '' then
                            LSCPOSTrans.InputMemberCard(PresHdrBuffer."Member Card No.");
                        LSCPOSTrans.SetPOSTransaction(LSCPOSTransaction);

                        //--Insert POS Lines
                        PresLineBuffer.Reset();
                        PresLineBuffer.SetRange("Prescription ID", PresHdrBuffer."Prescription ID");
                        PresLineBuffer.SetRange("Converted to POS", false);
                        if PresLineBuffer.FindSet() then
                            repeat
                                Counter_l += GetLastPOSLineNo(LSCPOSTransaction."Receipt No.") + 10000;
                                LSCPOSTransLine.Init;
                                LSCPOSTransLine.Validate("Receipt No.", LSCPOSTransaction."Receipt No.");
                                LSCPOSTransLine."Store No." := LSCPOSTransaction."Store No.";
                                LSCPOSTransLine."POS Terminal No." := LSCPOSTransaction."POS Terminal No.";
                                LSCPOSTransLine.Validate("Line No.", Counter_l);
                                LSCPOSTransLine.Validate("Parent Line", LSCPOSTransLine."Line No.");
                                LSCPOSTransLine.Insert(true);
                                LSCPOSTransLine."Entry Type" := LSCPOSTransLine."Entry Type"::Item;
                                LSCPOSTransLine.Validate(Number, PresLineBuffer."Item No.");
                                LSCPOSTransLine.Validate(Quantity, PresLineBuffer."Qty. to Dispense");
                                LSCPOSTransLine.Validate("Lot No.", PresLineBuffer."Lot No.");
                                LSCPOSTransLine.Validate("Expiration Date", PresLineBuffer."Expiration Date");
                                LSCPOSTransLine.CalcPrices();
                                LSCPOSTransLine."Prescription ID" := PresLineBuffer."Prescription ID";
                                LSCPOSTransLine."Prescription Line No." := PresLineBuffer."Line No.";
                                //--
                                UpdatePOSTransLinesFields(LSCPOSTransaction, LSCPOSTransLine, PresLineBuffer);
                                //--
                                LSCPOSTransLine.Modify;

                                //--update prescription lines converted
                                if PresLineBuffer2.Get(PresLineBuffer."Prescription ID", PresLineBuffer."Line No.") then begin
                                    PresLineBuffer2."Converted to POS" := true;
                                    PresLineBuffer2."Date Converted to POS" := Today;
                                    PresLineBuffer2.Modify();
                                end;
                            until PresLineBuffer.Next() = 0;
                        LSCPOSTrans.CalcTotals;
                        PresHdrBuffer."Converted to POS" := true;
                        PresHdrBuffer."Date Converted to POS" := Today();
                        PresHdrBuffer.Modify;

                        processed := true;
                    end else begin
                        Message('Current POS Transaction Not Found.');
                        processed := false;
                    end;
                end;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", OnAfterVoidLine, '', false, false)]
    local procedure LSCPOSTransactionEvents_OnAfterVoidLine(var POSTransLine: Record "LSC POS Trans. Line")
    var
        PrescLines: Record "PDS Prescription Line Buffer";
    begin
        if PrescLines.Get(POSTransLine."Prescription ID", POSTransLine."Prescription Line No.") then begin
            PrescLines."Converted to POS" := false;
            PrescLines."Date Converted to POS" := 0D;
            PrescLines.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", OnAfterVoidTransaction, '', false, false)]
    local procedure LSCPOSTransactionEvents_OnAfterVoidTransaction(var POSTransaction: Record "LSC POS Transaction")
    var
        PrescHeader: Record "PDS Prescription Hdr Buffer";
        PrescLines: Record "PDS Prescription Line Buffer";
        POSTransLine: Record "LSC POS Trans. Line";
    begin
        if PrescHeader.Get(POSTransaction."Prescription ID") then begin
            PrescHeader."Converted to POS" := false;
            PrescHeader."Date Converted to POS" := 0D;
            PrescHeader.Modify();
        end;

        POSTransLine.Reset();
        POSTransLine.SetRange("Receipt No.", POSTransaction."Receipt No.");
        if POSTransLine.FindSet() then
            repeat
                if PrescLines.Get(POSTransLine."Prescription ID", POSTransLine."Prescription Line No.") then begin
                    PrescLines."Converted to POS" := false;
                    PrescLines."Date Converted to POS" := 0D;
                    PrescLines.Modify();
                end;
            until POSTransLine.Next() = 0;
    end;
}
