@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Systemtypes Text View - CDS Data Model'

@Search.searchable: true

define view entity ZI_ICS_DATA_EXIST_CHECKTXT_2
  as select from zics_dataexisttx as DataExistanceCheckText
  
  association to parent ZI_ICS_DATA_EXISTANCE as _DataExistance
    on $projection.DataExistanceUUID = _DataExistance.mykey
    
  association [0..1] to I_Language as _language
    on $projection.DataExistanceLanguage = _language.Language

{
  @Search.defaultSearchElement: true  
  @ObjectModel.text.element: ['DataExistanceDescription']
  key DataExistanceCheckText.mykey              as DataExistanceUUID,
  
  @Semantics.language: true
  key DataExistanceCheckText.language           as DataExistanceLanguage,
  
  @Semantics.text: true
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  DataExistanceCheckText.dataexist_desc         as DataExistanceDescription,
  
  @Semantics.text: true
  DataExistanceCheckText.dataexist_long_desc    as DataExistanceLongDescription,
  
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at                               as DataExistanceLastChangedAt,
  
  _DataExistance,
  _language

}
