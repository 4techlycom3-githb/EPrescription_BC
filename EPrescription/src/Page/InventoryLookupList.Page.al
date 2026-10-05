page 50042 "PDS Inventory Lookup List"
{
    ApplicationArea = All;
    Caption = 'PDS Inventory Lookup List';
    Editable = false;
    PageType = Worksheet;
    SourceTable = "LSC Inventory Lookup Table";

    layout
    {
        area(Content)
        {
            group(ItemDetails)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item No. field.', Comment = '%';
                }
                field(ItemDescription; ItemDescription)
                {
                    Caption = 'Item Sub Description';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
                field(ItemDescription2; ItemDescription2)
                {
                    Caption = 'Item Sub Brand';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Item Description field.', Comment = '%';
                }
            }
            repeater(General)
            {
                field("Lot No."; Rec."Lot No.")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Lot No. field.', Comment = '%';
                }
                field("Expiration Date"; Rec."Expiration Date")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Expiration Date field.', Comment = '%';
                }
                field("PDI Net Inventory"; Rec."PDI Net Inventory")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the PDI Net Inventory field.', Comment = '%';
                }
                field(Location; Rec.Location)
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Location field.', Comment = '%';
                }
            }
        }
    }

    procedure SetUp(itemDesc: Text[100]; itemDesc2: Text[100])
    begin
        ItemDescription := itemDesc;
        ItemDescription2 := itemDesc2;
    end;

    var
        ItemDescription: Text[100];
        ItemDescription2: Text[100];
}
