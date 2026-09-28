pageextension 50101 "PDS LSC Retail User" extends "LSC Retail Users"
{
    layout
    {
        addAfter("POS Terminal")
        {
            field("Inventory Location"; Rec."Inventory Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory Location field.', Comment = '%';
            }
        }
    }
}
