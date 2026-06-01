codeunit 50014 "PDS E-Prescription Event & Fns"
{


    procedure HasIncompleteLineBeforeConvertToPOS(var PrescriptionID: Code[20]): Boolean
    var
        PrescriptionLineBuffer: Record "PDS EPrescription Line Buffer";
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

    procedure ConvertPrescriptionToPOS(var PrescriptionID: Code[20]; StoreNo: Code[20]; TerminalNo: Code[20]; StaffNo: Code[20])
    var
        PrescriptionHdrBuffer: Record "PDS EPrescription Hdr Buffer";
        PrescriptionLineBuffer: Record "PDS EPrescription Line Buffer";
        LSCPOSTransaction: Record "LSC POS Transaction";
        LSCPOSTransLine: Record "LSC POS Trans. Line";
        TransHeader_l: Record "LSC Transaction Header";
        PosFuncProfile: Record "LSC POS Func. Profile";
        LSCPOSTrans: codeunit "LSC POS Transaction";
        PostUtil_l: Codeunit "LSC POS Post Utility";

        StoreSetup: Record "LSC Store";
        RetailCalendar: Record "LSC Retail Calendar";
        POSSearch: Codeunit "LSC Search Index";
        RetailCalendarManagement: Codeunit "LSC Retail Calendar Management";
        Counter_l, TransNo_l : Integer;
    // Item_l: Record Item;
    begin
        if StoreSetup.Get(StoreNo) then;
        PrescriptionHdrBuffer.Reset();
        PrescriptionHdrBuffer.SetRange("Prescription ID", PrescriptionID);
        if PrescriptionHdrBuffer.FindFirst() then begin
            PrescriptionLineBuffer.Reset();
            PrescriptionLineBuffer.SetRange("Prescription ID", PrescriptionID);
            if PrescriptionLineBuffer.FindSet() then begin
                LSCPOSTransaction.Init;
                LSCPOSTransaction."Receipt No." := TerminalNo + 'Test';
                // LSCPOSTransaction."New Transaction" := true;
                LSCPOSTransaction."Store No." := StoreNo;
                LSCPOSTransaction."POS Terminal No." := TerminalNo;
                LSCPOSTransaction."Created on POS Terminal" := TerminalNo;
                LSCPOSTransaction."Trans. Date" := Today;
                LSCPOSTransaction."Original Date" := Today;
                LSCPOSTransaction."Staff ID" := StaffNo;
                LSCPOSTransaction."Shift No." := '';
                LSCPOSTransaction."Gen. Bus. Posting Group" := StoreSetup."Store Gen. Bus. Post. Gr.";
                LSCPOSTransaction."VAT Bus.Posting Group" := StoreSetup."Store VAT Bus. Post. Gr.";
                LSCPOSTransaction."Sale Is Return Sale" := false;
                LSCPOSTransaction."Sales Type" := '';

                LSCPOSTransaction."Trans Time" := Time;
                LSCPOSTransaction."Transaction Type" := LSCPOSTransaction."Transaction Type"::Sales;
                // LSCPOSTransaction."Entry Status" := LSCPOSTransaction."Entry Status"::Suspended; 
                LSCPOSTransaction."Created by Staff ID" := StaffNo;

                if not LSCPOSTransaction.Insert then
                    LSCPOSTransaction.Modify;

                // GetGeneralPosFunctionality(LSCPOSTransaction."Store No.", PosFuncProfile);
            end;
            repeat
                Counter_l += 1;
                LSCPOSTransLine.Init;
                LSCPOSTransLine.Validate("Receipt No.", LSCPOSTransaction."Receipt No.");
                LSCPOSTransLine."Store No." := LSCPOSTransaction."Store No.";
                LSCPOSTransLine."POS Terminal No." := LSCPOSTransaction."POS Terminal No.";
                LSCPOSTransLine.Validate("Line No.", Counter_l * 10000);
                LSCPOSTransLine.Insert(true);
                LSCPOSTransLine."Entry Type" := LSCPOSTransLine."Entry Type"::Item;
                // LSCPOSTransLine.Validate(Number, PrescriptionLineBuffer."Item No.");
                LSCPOSTransLine.Number := PrescriptionLineBuffer."Item No.";
                LSCPOSTransLine.Validate(Quantity, PrescriptionLineBuffer."Qty. to Dispense");
                LSCPOSTransLine.CalcPrices();
                LSCPOSTransLine."Sales Type" := '';

                LSCPOSTransLine.Modify;

                TransNo_l := PostUtil_l.ProcessTransaction(LSCPOSTransaction);
                PostUtil_l.GetLastTransaction(TransHeader_l);
                TransHeader_l.Delete(true);

            // LSCPOSTransaction."Staff ID" := StaffNo;

            // end;

            // LSCPOSTransaction."New Transaction" := false;
            // LSCPOSTransaction."Trans. Date" := Today;
            // LSCPOSTransaction."Original Date" := LSCPOSTransaction."Trans. Date";
            // LSCPOSTransaction."Trans Time" := Time;
            // LSCPOSTransaction."Trans. Date" :=
            //   RetailCalendarManagement.GetStoreTransactionDate(
            //     StoreSetup."No.", RetailCalendar."Calendar Type"::"Opening Hours",
            //     LSCPOSTransaction."Trans. Date", LSCPOSTransaction."Trans Time");
            // // LSCPOSTransaction."Shift No." := POSSESSION.WorkShiftNo;
            // LSCPOSTransaction.Validate("Trans. Currency Code", StoreSetup."Currency Code");
            // StateTxt := Format(LSCPOSTransaction."Transaction Type");

            // LSCPOSTransaction.Modify;
            /*
            REC."Transaction Type" := REC."Transaction Type"::Sales;
            LSCPOSTrans.SetPOSState("LSC POS Transaction State"::SALES);
            POSTransactionEvents.OnBeforeSalePressedStartNewTrans(REC);
            REC."Sale Is Return Sale" := false;
            LSCPOSTrans.StartNewTransaction;
            */
            until PrescriptionLineBuffer.Next() = 0;

            PrescriptionHdrBuffer."Sent to POS" := true;
            PrescriptionHdrBuffer.Modify();
        end;
    end;

    procedure GetGeneralPosFunctionality(StoreNo: Code[10]; var POSFuncProfile: Record "LSC POS Func. Profile")
    var
        Store: Record "LSC Store";
        POSSession: Codeunit "LSC POS Session";
    begin
        if POSFuncProfile."Profile ID" = '' then begin
            Store.Get(StoreNo);
            POSFuncProfile.Get(POSSession.FunctionalityProfileID);
        end;
    end;

    //***Events***
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Controller", OnLookupResult, '', false, false)]
    local procedure LSCPOSController_OnLookupResult(LookupID: Text; FilterText: Text; resultOK: Boolean; var processed: Boolean)
    var
        EPresHdrBuffer: Record "PDS EPrescription Hdr Buffer";
        LCSPOSTransaction: Record "LSC POS Transaction";
        ActiveRecordID: RecordId;
        LSC_POSControlInterface: Codeunit "LSC POS Control Interface";
    begin
        if LookupID = '#PRESCRIPTIONLIST' then
            if resultOK then begin
                begin
                    if LSC_POSControlInterface.GetLookupActiveRecordID(LookupID, ActiveRecordID) then
                        EPresHdrBuffer.Get(ActiveRecordID);
                    message('Lookup Result: %1, %2, %3, ActiveRecordID %4', LookupID, FilterText, resultOK, EPresHdrBuffer."Prescription ID");
                    /*
                     POSTransCU.GetPOSTransaction(LPOSTransaction);
                        if not LPOSTransaction.IsEmpty then begin
                            // Perform validations
                            LPOSTransaction.Validate("MCHDOCID", DoctorRec."No.");
                            LPOSTransaction.Validate("MCHDOCLICENSE", DoctorRec."License No.");
                            LPOSTransaction.Validate("MCHDOCNAME", DoctorRec.Name);
                            LPOSTransaction.Validate(MedicalType, Format(DoctorRec."Medical Type"));

                            // Instead of calling Modify(), we pass it back to LS Central
                            POSTransCU.SetPOSTransaction(LPOSTransaction);

                            // Display confirmation and tag
                            Message('Physician %1 (%2) selected successfully!', LPOSTransaction.MCHDOCID, LPOSTransaction.MCHDOCNAME);
                            POSSession.SetValue(LSC_POSTAG::"Physician", LPOSTransaction.MCHDOCNAME);
                            processed := true;
                        end else begin
                            Message('Current POS transaction not found.');
                            processed := false;
                        end;
                    */
                end;
            end;
    end;

}
