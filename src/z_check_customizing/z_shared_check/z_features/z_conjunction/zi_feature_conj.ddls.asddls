@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_FEATURE_CONJ
  as select from zdb_feat_conj as Conjunction
  
  association [0..*] to ZI_FEATURE_CONJ_T as _ConjunctionText 
    on $projection.ID = _ConjunctionText.Id

{
  
  key Conjunction.id     as ID,
  
  _ConjunctionText

}
