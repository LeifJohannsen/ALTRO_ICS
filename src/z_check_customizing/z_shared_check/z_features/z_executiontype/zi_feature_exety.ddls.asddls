@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_FEATURE_EXETY
  as select from zdb_feat_exety as ExecutionType
  
  association [0..*] to ZI_FEATURE_EXETY_T as _ExecutionTypeText 
    on $projection.ID = _ExecutionTypeText.Id

{
  
  key ExecutionType.id     as ID,
  
  _ExecutionTypeText

}
