@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_FEATURE_OPER_T
  
  as select from zdb_feat_oper_t as OperationText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key OperationText.id     as Id,
  @Semantics.language: true
  key OperationText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  OperationText.operation_desc        as Description

}
