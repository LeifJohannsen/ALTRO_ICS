@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_FEATURE_SIGN_T
  
  as select from zdb_feat_sign_t as SignText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key SignText.id     as Id,
  @Semantics.language: true
  key SignText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  SignText.sign_desc        as Description

}
