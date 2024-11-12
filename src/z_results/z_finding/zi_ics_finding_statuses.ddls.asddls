@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding Statuses view'

@Search.searchable: true

define root view entity ZI_ICS_FINDING_STATUSES 
    as select from zics_findstat as FindingStatus
    
    association [1..*] to ZI_ICS_FINDING_STATUSES_TEXTS as _FindingStatusText on 
        $projection.FindingStatusID = _FindingStatusText.FindingStatusID
    
{
  @Search.defaultSearchElement: true
  @UI.hidden: true
  key FindingStatus.id        as FindingStatusID,
  FindingStatus.display_category as FindinStatusDisplayCategory,
    _FindingStatusText
}
