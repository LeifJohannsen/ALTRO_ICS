@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fields Text View - CDS Data Model'

@Search.searchable: true
define view entity ZI_ICS_FIELDS_TEXT
  
  as select from zics_fieldstxt as FieldText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key FieldText.destination     as DestinationID,
  key FieldText.dataset         as DatasetID,
  key FieldText.fieldname       as FieldID,
  @Semantics.language: true
  key FieldText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  FieldText.field_desc          as Description

}
