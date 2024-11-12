@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_FEATURE_EXETY_T
  
  as select from zdb_feat_exety_t as ExecutionTypeText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key ExecutionTypeText.id     as Id,
  @Semantics.language: true
  key ExecutionTypeText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  ExecutionTypeText.executiontype_desc        as Description

}
