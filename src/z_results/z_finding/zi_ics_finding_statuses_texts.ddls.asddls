@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding Statuses texts view'
define view entity ZI_ICS_FINDING_STATUSES_TEXTS 
    as select from zics_findstat_t as FindingStatusText
    
{
    key FindingStatusText.id            as FindingStatusID,
    @Semantics.language: true
    key FindingStatusText.language      as Language,
        @Semantics.text: true
        FindingStatusText.finding_status_desc   as Description
}
