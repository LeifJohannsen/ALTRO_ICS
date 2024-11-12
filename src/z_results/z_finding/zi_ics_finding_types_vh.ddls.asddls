@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding types valuehelp view'

define root view entity ZI_ICS_FINDING_TYPES_VH 
//    as select distinct from zics_protocols
    as select distinct from ZI_PROTOCOLS
    
    association [1..1] to ZI_ICS_FINDING_TYPE as _FindingType on 
        $projection.findingtypeid = _FindingType.FindingTypeID
{

    key FindingtypeID as findingtypeid,
    
    _FindingType
        
}
