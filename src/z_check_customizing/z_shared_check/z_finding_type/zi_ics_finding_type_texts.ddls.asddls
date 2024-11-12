@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding types Text View - CDS Data Model'
@Search.searchable: true

define view entity ZI_ICS_Finding_Type_TEXTS
  as select from zics_findtype_t as FindingTypeText

{
  @Search.defaultSearchElement: true  
  @ObjectModel.text.element: ['Description']
  key FindingTypeText.findingtype       as FindingTypeID,
  @Semantics.language: true
  key FindingTypeText.language          as Language,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    FindingTypeText.finding_type_desc   as Description 

}
