report 50100 "PDS Prescription"
{
    ApplicationArea = All;
    Caption = 'Prescription';
    UsageCategory = None;
    DefaultRenderingLayout = PrescriptionLayout;

    dataset
    {
        dataitem(PDSPrescriptionHdrBuffer; "PDS Prescription Hdr Buffer")
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
            dataitem(PDSPrescriptionLineBuffer; "PDS Prescription Line Buffer")
            {
                DataItemLink = "Prescription ID" = field("Prescription ID");
                DataItemTableView = sorting("Line No.");
                column(Medicine_Name; Medicine)
                { }
                column(Dosage; Dosage)
                { }
                column(Duration; Duration)
                { }
                column(Frequency; Frequency)
                { }
                column(Qty; Qty)
                { }
                column(Qty__to_Dispense; "Qty. to Dispense")
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

}
