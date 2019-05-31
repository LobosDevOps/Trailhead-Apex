public class UpdateContactPageLayout {
    // Add custom field to page layout
    
    public Metadata.Layout addLayoutItem() {
        
        // Retrieve Account layout and section 
        List<Metadata.Metadata> layoutsList = 
            Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
            new List<String> {'Contact-Contact Layout'});
        debug('layouts', layoutsList);
        Metadata.Layout layoutMetadata = (Metadata.Layout) layoutsList.get(0);
        debug('layoutMetadata', layoutMetadata);
        Metadata.LayoutSection contactLayoutSection = null;
        List<Metadata.LayoutSection> layoutSections = layoutMetadata.layoutSections;
        for (Metadata.LayoutSection section : layoutSections) {
            
            if (section.label == 'Additional Information') {
                contactLayoutSection = section;
                break;
            }
        }
        debug('contactLayoutSection', contactLayoutSection);
        
        // Add the field under Account info section in the left column
        List<Metadata.LayoutColumn> contactColumns = contactLayoutSection.layoutColumns;  
        debug('contactColumns size', contactColumns.size());   

        List<Metadata.LayoutItem> contactLayoutItems = contactColumns.get(0).layoutItems;
        debug('contactLayoutItems size', contactLayoutItems.size());
        
        // Create a new layout item for the custom field
        Metadata.LayoutItem newField = new Metadata.LayoutItem();
        newField.behavior = Metadata.UiBehavior.Edit;
        newField.field = 'AMAPI__Apex_MD_API_Twitter_name__c';
        contactLayoutItems.add(newField);
        
        return layoutMetadata;
    }

    public void debug(String msg, Object value){
        System.debug(msg + ': ' + value);
    }
}