@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_FEATURE_SIGN
  as select from zdb_feat_sign as Sign
  
  association [0..*] to ZI_FEATURE_SIGN_T as _SignText 
    on $projection.ID = _SignText.Id

{
  
  key Sign.id     as ID,
  
  _SignText

}
