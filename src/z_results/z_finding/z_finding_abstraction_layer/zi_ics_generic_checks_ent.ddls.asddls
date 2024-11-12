@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generic checks entity'

define root view entity ZI_ICS_GENERIC_CHECKS_ENT
    as select from ZI_ICS_GENERIC_CHECKS
    
    association [0..*] to ZI_ICS_GENERIC_CHECKS_ENT_TXT as _GenericCheckText
    on $projection.CheckClass  = _GenericCheckText.CheckClass
   and $projection.CheckUUID = _GenericCheckText.CheckUUID
   
{
    key checkClass as CheckClass,
    key checkUUID as CheckUUID,
    CategoryID,
    FindingTypeID,
    FeatureID,
    
    _Category,
    _FindingType,
    _Feature,
    _GenericCheckText
}
