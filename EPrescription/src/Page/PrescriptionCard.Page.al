page 50037 "PDS Prescription Card"
{
    ApplicationArea = All;
    Caption = 'Prescription Card';
    PageType = Card;
    SourceTable = "PDS Prescription Hdr Buffer";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Prescription ID"; Rec."Prescription ID")
                {
                    ToolTip = 'Specifies the value of the Prescription ID field.', Comment = '%';
                }
                field("Health Plus No."; Rec."Health Plus No.")
                {
                    ToolTip = 'Specifies the value of the Health Plus No. field.', Comment = '%';
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
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.', Comment = '%';
                }
                field(Age; Rec.Age)
                {
                    ToolTip = 'Specifies the value of the Age field.', Comment = '%';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                field("Prescribing Doctor"; Rec."Prescribing Doctor")
                {
                    ToolTip = 'Specifies the value of the Prescribing Doctor field.', Comment = '%';
                }
                field("Healthcare Assistant"; Rec."Healthcare Assistant")
                {
                    ToolTip = 'Specifies the value of the Healthcare Assistant field.', Comment = '%';
                }
                field("Pharmacy No."; Rec."Pharmacy No.")
                {
                    ToolTip = 'Specifies the value of the Pharmacy No. field.', Comment = '%';
                }
                field("Sent to POS"; Rec."Sent to POS")
                {
                    ToolTip = 'Specifies the value of the Sent to POS field.', Comment = '%';
                }
            }
            part(presciptionLines; "PDS Prescription Subform")
            {
                Caption = 'Prescription Lines';
                SubPageLink = "Prescription ID" = field("Prescription ID");
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
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PrescriptionHeader: record "PDS Prescription Hdr Buffer";
                begin
                    PrescriptionHeader.SetRange("Prescription ID", Rec."Prescription ID");
                    Report.RunModal(Report::"PDS Prescription", true, false, PrescriptionHeader);
                end;
            }
            action("SendToPOS")
            {
                Caption = 'Send to POS';
                ToolTip = 'Send the prescription to a point-of-sale transaction.';
                Image = ChangeTo;
                Promoted = true;
                promotedCategory = Process;

                trigger OnAction()
                var
                    PrescriptionEventFns: Codeunit "PDS E-Prescription Event & Fns";
                    StoreNoTxt: Code[20];
                    TerminalNoTxt: Code[20];
                    StaffNoTxt: Code[20];
                begin
                    if PrescriptionEventFns.HasIncompleteLineBeforeConvertToPOS(Rec."Prescription ID") then
                        Error('The prescription has incomplete lines and cannot be sent to POS.');

                    Rec."Sent to POS" := true;
                    Rec.Modify();
                end;
            }
        }
    }
}
