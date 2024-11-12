@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fields View - CDS Data Model'
define root view entity ZI_ICS_FIELDS
  as select from zics_fields as Field
  
  association [0..*] to ZI_ICS_FIELDS_TEXT as _FieldText 
    on $projection.FieldID       = _FieldText.FieldID
   and $projection.DatasetID     = _FieldText.DatasetID
   and $projection.DestinationID = _FieldText.DestinationID

{
  
  key Field.destination     as DestinationID,
  key Field.dataset         as DatasetID,
  key Field.fieldname       as FieldID,
  
  _FieldText

}
