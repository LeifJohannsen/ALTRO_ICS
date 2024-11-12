@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Findings History View - CDS Data Model'

define view entity ZI_ICS_FINDING_History
  as select from zics_findinghist as FindingHistory
  
  association to parent ZI_PROTOCOLS as _Finding
    on $projection.findingid = _Finding.mykey
    
  association [1..1] to I_IAMBusinessUserLogonDetails  as _User
    on $projection.responsibleclerk  = _User.UserID
    
  association [0..1] to ZI_ICS_FINDING_STATUSES  as _FindingStatus
    on $projection.status  = _FindingStatus.FindingStatusID
{
  
  _Finding,
  key FindingHistory.mykey,
  FindingHistory.findingid, 
  FindingHistory.validfrom,
  FindingHistory.validto,
  FindingHistory.responsibleclerk,
  FindingHistory.status,
  FindingHistory.note,
  
  /*-- Admin data --*/
  @Semantics.user.createdBy: true
  FindingHistory.created_by,
  @Semantics.systemDateTime.createdAt: true
  FindingHistory.created_at,
  @Semantics.user.lastChangedBy: true
  FindingHistory.last_changed_by,
  @Semantics.systemDateTime.lastChangedAt: true
  FindingHistory.last_changed_at,
  
  /*Associations*/
  
  _User,
  _FindingStatus
  
}
