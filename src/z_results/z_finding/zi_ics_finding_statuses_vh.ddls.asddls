@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Findings Employees view'

define root view entity ZI_ICS_FINDING_STATUSES_VH 
    as select distinct from ZI_PROTOCOLS
    
    association [1..1] to ZI_ICS_FINDING_STATUSES as _FindingStatus
        on $projection.FindingStatusID = _FindingStatus.FindingStatusID
    
{

    key FindingStatusID,
    FindingStatusCriticality,
    
    _FindingStatus
        
}
