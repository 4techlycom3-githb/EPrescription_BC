page 50036 "PDS E-Prescription List"
{
    ApplicationArea = All;
    Caption = 'E-Prescription List';
    PageType = List;
    SourceTable = "PDS EPrescription Hdr Buffer";
    UsageCategory = Documents;
    CardPageId = "PDS E-Prescription Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Prescription ID"; Rec."Prescription ID")
                {
                    ToolTip = 'Specifies the value of the Prescription ID field.', Comment = '%';
                }
                field("Patient ID"; Rec."Patient ID")
                {
                    ToolTip = 'Specifies the value of the Patient ID field.', Comment = '%';
                }
                field("Patient First Name"; Rec."Patient First Name")
                {
                    ToolTip = 'Specifies the value of the Patient First Name field.', Comment = '%';
                }
                field("Patient Middle Name"; Rec."Patient Middle Name")
                {
                    ToolTip = 'Specifies the value of the Patient Middle Name field.', Comment = '%';
                }
                field("Patient Last Name"; Rec."Patient Last Name")
                {
                    ToolTip = 'Specifies the value of the Patient Last Name field.', Comment = '%';
                }
                field("Prescribing Doctor"; Rec."Prescribing Doctor")
                {
                    ToolTip = 'Specifies the value of the Prescribing Doctor field.', Comment = '%';
                }
                field("Healthcare Assistant"; Rec."Healthcare Assistant")
                {
                    ToolTip = 'Specifies the value of the Healthcare Assistant field.', Comment = '%';
                }
            }
        }
    }
}
