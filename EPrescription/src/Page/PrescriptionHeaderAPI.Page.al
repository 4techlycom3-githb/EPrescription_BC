page 50039 "PDS Prescription Header API"
{
    APIGroup = 'prescriptionData';
    APIPublisher = 'planetSysAd';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'pdsPrescriptionAPI';
    DelayedInsert = true;
    EntityName = 'prescription';
    EntitySetName = 'prescriptions';
    PageType = API;
    SourceTable = "PDS Prescription Hdr Buffer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(prescriptionID; Rec."Prescription ID")
                {
                    Caption = 'Prescription ID';
                }
                field(memberCardNo; Rec."Member Card No.")
                {
                    Caption = 'Member Card No.';
                }
                field(healthPlusNo; Rec."Health Plus No.")
                {
                    Caption = 'Health Plus No.';
                }
                field(prescriptionDate; Rec."Prescription Date")
                {
                    Caption = 'Prescription Date';
                }
                field(patientFirstName; Rec."Patient First Name")
                {
                    Caption = 'Patient First Name';
                }
                field(patientMiddleName; Rec."Patient Middle Name")
                {
                    Caption = 'Patient Middle Name';
                }
                field(patientLastName; Rec."Patient Last Name")
                {
                    Caption = 'Patient Last Name';
                }
                field(age; Rec.Age)
                {
                    Caption = 'Age';
                }
                field(gender; Rec.Gender)
                {
                    Caption = 'Gender';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(prescribingDoctor; Rec."Prescribing Doctor")
                {
                    Caption = 'Prescribing Doctor';
                }
                field(healthcareAssistant; Rec."Healthcare Assistant")
                {
                    Caption = 'Healthcare Assistant';
                }
                field(pharmacyNo; Rec."Pharmacy No.")
                {
                    Caption = 'Pharmacy No.';
                }
                part(presciptionLines; "PDS Prescription Line API")
                {
                    EntityName = 'prescriptionLine';
                    EntitySetName = 'prescriptionLines';
                    SubPageLink = "Prescription ID" = field("Prescription ID");
                }
            }
        }
    }
}
