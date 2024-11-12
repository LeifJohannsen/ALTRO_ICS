@EndUserText.label: 'Abstract entity to change the clerk'
@Metadata.allowExtensions: true
define abstract entity ZA_ICS_DELIMIT_ENTRY
{
    @Semantics.businessDate.at: true
    new_delimitation : z_valid_from ; 
}
