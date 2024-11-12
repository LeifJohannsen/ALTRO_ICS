@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_FEATURE_OPER
  as select from zdb_feat_oper as Operation
  
  association [0..*] to ZI_FEATURE_OPER_T as _OperationText 
    on $projection.ID = _OperationText.Id

{
  
  key Operation.id     as ID,
  
  _OperationText

}
