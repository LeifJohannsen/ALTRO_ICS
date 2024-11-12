@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_FEATURE_NOT_OPERATION
  as select from zdb_feat_not_op as NotOperation
  
  association [0..*] to ZI_FEATURE_NOT_OPERATION_T as _NotOperationText 
    on $projection.ID = _NotOperationText.Id

{
  
  key NotOperation.id     as ID,
  
  _NotOperationText

}
