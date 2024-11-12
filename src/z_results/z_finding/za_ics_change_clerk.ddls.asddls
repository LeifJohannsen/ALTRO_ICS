@EndUserText.label: 'Abstract entity to change the clerk'
@Metadata.allowExtensions: true
define abstract entity ZA_ICS_CHANGE_CLERK
  //with parameters parameter_name : parameter_type
{
    new_responsible_clerk : z_username;
    new_note : z_ics_description_test;
}
