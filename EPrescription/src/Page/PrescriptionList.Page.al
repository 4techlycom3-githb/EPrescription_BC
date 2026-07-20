page 50036 "PDS Prescription List"
{
    ApplicationArea = All;
    Caption = 'Prescription List';
    Editable = false;
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
                field("Health Plus No."; Rec."Health Plus No.")
                {
                    ToolTip = 'Specifies the value of the Health Plus No. field.', Comment = '%';
                }
                field("Patient Name"; Rec."Patient First Name" + ' ' + Rec."Patient Middle Name" + ' ' + Rec."Patient Last Name")
                {
                    ToolTip = 'Specifies the value of the Patient Name field.', Comment = '%';
                }
                field("Prescribing Doctor"; Rec."Prescribing Doctor")
                {
                    ToolTip = 'Specifies the value of the Prescribing Doctor field.', Comment = '%';
                }
                field("Healthcare Assistant"; Rec."Healthcare Assistant")
                {
                    ToolTip = 'Specifies the value of the Healthcare Assistant field.', Comment = '%';
                }
                field("Sent to POS"; Rec."Sent to POS")
                {
                    ToolTip = 'Specifies if the prescription has been sent to the POS system.', Comment = '%';
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
            action(SendToPOS)
            {
                Caption = 'Send to POS';
                ToolTip = 'Send this prescription to the POS system.';
                Image = SendTo;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PrescriptionHeader: Record "PDS Prescription Hdr Buffer";
                    PrescriptionEventFns: Codeunit "PDS E-Prescription Event & Fns";
                begin
                    if confirm('Are you sure you want to send the selected prescription to the POS system?', false) then begin
                        currpage.SetSelectionFilter(PrescriptionHeader);
                        if PrescriptionHeader.FindSet() then
                            repeat
                                if not PrescriptionEventFns.HasIncompleteLineBeforeConvertToPOS(Rec."Prescription ID") then begin
                                    PrescriptionHeader."Sent to POS" := true;
                                    PrescriptionHeader.Modify();
                                end;
                            until PrescriptionHeader.Next() = 0;
                        if PrescriptionHeader.Count <> 0 then
                            Message('Prescription sent to POS system successfully.');
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        RetailUser: Record "LSC Retail User";
    begin
        // if RetailUser.Get(UserId) then
        //     if RetailUser."Store No." <> '' then begin
        //         Rec.FilterGroup(2);
        //         Rec.SetRange("Pharmacy No.", RetailUser."Store No.");
        //         Rec.FilterGroup(0);
        //     end;
    end;
}