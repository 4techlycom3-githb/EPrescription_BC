codeunit 50021 "PDS Archiving Prescriptions"
{
    trigger OnRun()
    var
        GenLedgerSetup: Record "General Ledger Setup";
        PrescriptionHeader: Record "PDS Prescription Hdr Buffer";
        PrescriptionLine: Record "PDS Prescription Line Buffer";
        ArchivedPrescriptionHeader: Record "PDS Archived Presc. Header";
        ArchivedPrescriptionLine: Record "PDS Archived Presc. Line";
    begin
        GenLedgerSetup.Get();
        GenLedgerSetup.TestField("Prescription Validity Months");

        PrescriptionHeader.Reset();
        PrescriptionHeader.SetRange("Converted to POS", true);
        PrescriptionHeader.SetFilter("Date Converted to POS", '..%1', CALCDATE(StrSubstNo('-%1M', GenLedgerSetup."Prescription Validity Months"), Today()));
        if PrescriptionHeader.FindSet() then
            repeat
                ArchivedPrescriptionHeader.Init();
                ArchivedPrescriptionHeader.TransferFields(PrescriptionHeader);
                ArchivedPrescriptionHeader."Archived By User" := UserId();
                ArchivedPrescriptionHeader."Archived Date" := Today();
                ArchivedPrescriptionHeader.Insert(true);

                //--Lines
                PrescriptionLine.Reset();
                PrescriptionLine.SetRange("Prescription ID", PrescriptionHeader."Prescription ID");
                while PrescriptionLine.FindSet() do begin
                    ArchivedPrescriptionLine.Init();
                    ArchivedPrescriptionLine.TransferFields(PrescriptionLine);
                    ArchivedPrescriptionLine."Archived By User" := UserId();
                    ArchivedPrescriptionLine."Archived Date" := Today();
                    ArchivedPrescriptionLine.Insert(true);
                    PrescriptionLine.Delete(true);
                end;

                PrescriptionHeader.Delete(true);
            until PrescriptionHeader.Next() = 0;
    end;
}
