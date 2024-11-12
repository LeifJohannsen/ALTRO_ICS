@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_FEATURE_CONJ_T
  
  as select from zdb_feat_conj_t as zdb_feat_conj_t

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key zdb_feat_conj_t.id     as Id,
  @Semantics.language: true
  key zdb_feat_conj_t.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  zdb_feat_conj_t.conjunction_desc        as Description

}
