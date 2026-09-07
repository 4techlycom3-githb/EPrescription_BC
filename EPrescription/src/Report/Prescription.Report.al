report 50100 "PDS Prescription"
{
    ApplicationArea = All;
    Caption = 'Prescription';
    UsageCategory = None;
    DefaultRenderingLayout = PrescriptionLayout;

    dataset
    {
        dataitem(PrescriptionHdrBuffer; "PDS Prescription Hdr Buffer")
        {
            column(Patient_Name; "Patient First Name" + ' ' + "Patient Middle Name" + ' ' + "Patient Last Name")
            { }
            column(age; Age)
            { }
            column(Gender; Gender)
            { }
            column(Address; Address)
            { }
            column(Prescription_Date; "Prescription Date")
            { }
            column(Prescribing_Doctor; "Prescribing Doctor")
            { }
            column(Health_Plus_No_; "Health Plus No.")
            { }
            dataitem(PrescriptionLineBuffer; "PDS Prescription Line Buffer")
            {
                DataItemLink = "Prescription ID" = field("Prescription ID");
                DataItemTableView = sorting("Line No.");
                trigger OnPreDataItem()
                begin
                    LineNo := 0;
                    PrescriptionLinesTemp.Reset();
                    PrescriptionLinesTemp.DeleteAll();
                end;

                trigger OnAfterGetRecord()
                begin
                    LineNo += 1;
                    PrescriptionLinesTemp.Init();
                    PrescriptionLinesTemp.Copy(PrescriptionLineBuffer);
                    PrescriptionLinesTemp."Line No." := LineNo;
                    PrescriptionLinesTemp.Insert();
                end;

                trigger OnPostDataItem()
                var
                    i: Integer;
                begin
                    if (LineNo mod 5) <> 0 then begin
                        for i := 1 to (5 - (LineNo mod 5)) do begin
                            LineNo += 1;
                            PrescriptionLinesTemp.Init();
                            PrescriptionLinesTemp."Prescription ID" := PrescriptionLineBuffer."Prescription ID";
                            PrescriptionLinesTemp."Line No." := LineNo;
                            PrescriptionLinesTemp.Medicine := ' ';
                            PrescriptionLinesTemp.Insert();
                        end;
                    end
                end;
            }
            dataitem(PrescriptionLinesTemp; "PDS Prescription Line Buffer")
            {
                UseTemporary = true;
                DataItemLink = "Prescription ID" = field("Prescription ID");
                DataItemTableView = sorting("Line No.");
                column(Medicine_Name; UpperCase(Medicine))
                { }
                column(Dosage; Dosage)
                { }
                column(Duration; Duration)
                { }
                column(Signa; Signa)
                { }
                column(Qty; Qty)
                { }
                column(Qty__to_Dispense; "Qty. to Dispense")
                { }
                column(LineNo; "Line No.")
                { }
            }
        }
    }

    rendering
    {
        layout(PrescriptionLayout)
        {
            Type = RDLC;
            LayoutFile = '.\src\Report\Layout\PDSPrescription.rdl';
        }
    }

    var
        LineNo: Integer;
}
