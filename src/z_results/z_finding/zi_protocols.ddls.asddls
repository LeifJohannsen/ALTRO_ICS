//@AbapCatalog.viewEnhancementCategory: [#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//@EndUserText.label: 'View for IKS Protocols'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
@EndUserText.label: 'Protocols'
@AccessControl.authorizationCheck: #CHECK

define root view entity ZI_PROTOCOLS as 
    select from zics_protocols
        
    association [1] to ZI_ICS_GENERIC_CHECKS_ENT  as _GenericCheck
        on $projection.checkclass   = _GenericCheck.CheckClass
        and $projection.findingkey  = _GenericCheck.CheckUUID
            
    association [1] to ZI_ICS_FINDING_History as _latestHistoryEntry 
        on $projection.lastchangeid = _latestHistoryEntry.mykey
        
    association [1] to I_IAMBusinessUserLogonDetails  as _CreatedByUser
        on $projection.created_by  = _CreatedByUser.UserID
        
    association [1] to I_IAMBusinessUserLogonDetails  as _LastChangedByUser
        on $projection.last_changed_by  = _LastChangedByUser.UserID
        
    association [1] to ZI_ICS_Employee_subgroups  as _EmployeeSubgroup
        on $projection.employee_subgroup  = _EmployeeSubgroup.EmployeeSubgroupID
                
    composition [0..*] of ZI_ICS_FINDING_History as _Historyentry
{
    key mykey,
    employeeid,
    firstname,
    lastname,
    employee_subgroup,
    employee_image_url,
//  For leading zeros
    cast(
      case replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(findingid,
        '0', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', '')
        when ''
        then lpad(findingid, 4, '0')
        else findingid
      end as abap.char(4)
    ) as findingid,
    zics_protocols.validfrom,
    zics_protocols.validto,
    checkclass,
    findingkey,
    
    furtherinformation,
    lastchangeid,
    created_by,
    created_at,
    last_changed_by,
    last_changed_at,
    
    //For Finding Status VH
    _latestHistoryEntry.status as FindingStatusID,
    _latestHistoryEntry._FindingStatus.FindinStatusDisplayCategory as FindingStatusCriticality,
    
    //For Finding Type VH
    _GenericCheck.FindingTypeID as FindingtypeID,
    
    _GenericCheck.FeatureID as FeatureID,
    
    concat('Finding-ID: ',findingid) as ObjectpageSubTitle,
    concat(concat(concat(concat(concat(firstname, ' '),lastname),' ('),employeeid),')') as ResolvedEmployeeName,
         
    _GenericCheck,
    _Historyentry,
    _latestHistoryEntry,
    _CreatedByUser,
    _LastChangedByUser,
    _EmployeeSubgroup
    
}
