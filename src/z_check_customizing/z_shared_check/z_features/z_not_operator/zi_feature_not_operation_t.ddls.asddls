@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_FEATURE_NOT_OPERATION_T
  
  as select from zdb_feat_notop_t as NotOperationText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key NotOperationText.id     as Id,
  @Semantics.language: true
  key NotOperationText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  NotOperationText.not_operation_desc        as Description

}
