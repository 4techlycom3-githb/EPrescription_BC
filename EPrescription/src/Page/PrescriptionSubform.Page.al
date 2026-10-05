page 50038 "PDS Prescription Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    LinksAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "PDS Prescription Line Buffer";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
                }
                field(Medicine; Rec.Medicine)
                {
                    ToolTip = 'Specifies the value of the Medicine field.', Comment = '%';
                }
                // field("Store No."; Rec."Store No.")
                // {
                //     ToolTip = 'Specifies the value of the Medicine field.', Comment = '%';
                // }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';

                    // trigger OnLookup(var Text: Text): Boolean
                    // var
                    //     PrescHeader: Record "PDS Prescription Hdr Buffer";
                    //     PlanetSubCode: Record "Planet Subcode";
                    // begin
                    //     if PrescHeader.Get(Rec."Prescription ID") then;
                    //     PlanetSubCode.Reset();
                    //     PlanetSubCode.SetRange("Location Code", PrescHeader."Pharmacy No.");
                    //     if Page.RunModal(Page::"Planet Item Subcode", PlanetSubCode) = Action::LookupOK then
                    //         Rec.Validate("Item No.", PlanetSubCode."Item Code");
                    // end;
                }
                field("Item Sub Description"; Rec."Item Sub Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field("Item Sub Brand"; Rec."Item Sub Brand")
                {
                    ToolTip = 'Specifies the value of the Item Brand field.', Comment = '%';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.', Comment = '%';
                }
                field("Qty. to Dispense"; Rec."Qty. to Dispense")
                {
                    Style = Attention;
                    ToolTip = 'Specifies the value of the Qty. to Dispense field.', Comment = '%';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    Style = Attention;
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                    trigger OnDrillDown()
                    var
                        InvLookupTable: Record "LSC Inventory Lookup Table";
                        RetailUser: Record "LSC Retail User";
                        EnhanceFunc: Codeunit "Enhancement Functions PDI";
                        PDSInvLookupList: Page "PDS Inventory Lookup List";
                    begin
                        Rec.TestField("Qty. to Dispense");

                        if RetailUser.Get(UserId) then;
                        RetailUser.TestField("Inventory Location");
                        EnhanceFunc.UpdateInvLookupTableQ(Rec."Item No.", '', RetailUser."Inventory Location", true);    //comment for testing

                        InvLookupTable.Reset();
                        InvLookupTable.SetRange("Item No.", Rec."Item No.");
                        InvLookupTable.SetRange(Location, RetailUser."Inventory Location");
                        if InvLookupTable.Count = 0 then
                            Error(StrSubstNo('Item No. %1 has zero inventory for the location %2.', Rec."Item No.", RetailUser."Inventory Location"));

                        Clear(PDSInvLookupList);
                        PDSInvLookupList.SetTableView(InvLookupTable);
                        PDSInvLookupList.SetRecord(InvLookupTable);
                        PDSInvLookupList.LookupMode(true);
                        PDSInvLookupList.SetUp(Rec."Item Sub Description", Rec."Item Sub Brand");
                        if PDSInvLookupList.RunModal() = Action::LookupOK then begin
                            PDSInvLookupList.GetRecord(InvLookupTable);
                            Rec."Lot No." := InvLookupTable."Lot No.";
                            Rec."Expiration Date" := InvLookupTable."Expiration Date";
                            Rec.Modify(false);
                        end;
                    end;
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Style = Attention;
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field(Dosage; Rec.Dosage)
                {
                    ToolTip = 'Specifies the value of the Dosage field.', Comment = '%';
                }
                field(Signa; Rec.Signa)
                {
                    ToolTip = 'Specifies the value of the Signa field.', Comment = '%';
                }
                field("Duration"; Rec."Duration")
                {
                    ToolTip = 'Specifies the value of the Duration field.', Comment = '%';
                }
                field("Converted to POS"; Rec."Converted to POS")
                {
                    ToolTip = 'Specifies the value of the Duration field.', Comment = '%';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        PrescHeader: Record "PDS Prescription Hdr Buffer";
        PrescLines: Record "PDS Prescription Line Buffer";
    begin
        if PrescHeader.Get(Rec."Prescription ID") then;
        PrescLines.Reset();
        PrescLines.SetRange("Prescription ID", PrescHeader."Prescription ID");
        PrescLines.SetFilter("Store No.", '<>%1', PrescHeader."Pharmacy No.");
        if PrescLines.FindSet() then
            repeat
                PrescLines."Store No." := PrescHeader."Pharmacy No.";
                PrescLines.Modify();
            until PrescLines.Next() = 0;
    end;
}
