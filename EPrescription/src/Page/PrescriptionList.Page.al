page 50036 "PDS Prescription List"
{
    ApplicationArea = All;
    Caption = 'Prescription List';
    PageType = List;
    SourceTable = "PDS Prescription Hdr Buffer";
    UsageCategory = Documents;
    CardPageId = "PDS Prescription Card";

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
                field("Member Card No."; Rec."Member Card No.")
                {
                    ToolTip = 'Specifies the value of the Member Card No. field.', Comment = '%';
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

    actions
    {
        area(Processing)
        {
            action(PrintPrescription)
            {
                Caption = 'Print Prescription';
                ToolTip = 'Print this prescription.';
                Image = Print;
                Promoted = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                // PresPrintMgmt: Codeunit "PDS Prescription Print Management";
                begin
                    // PresPrintMgmt.PrintPrescription(Rec."Prescription ID");
                end;
            }
        }
    }
}
