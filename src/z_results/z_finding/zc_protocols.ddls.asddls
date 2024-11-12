@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_PROTOCOLS as projection on ZI_PROTOCOLS
{
    //Key
    key mykey as Mykey,
    
    //Employee Data  
    employeeid as Employeeid,
    firstname as FirstName,
    lastname as LastName,
    @ObjectModel.text.element: ['EmployeeSubgroupText']
    employee_subgroup as EmployeeSubgroup,
    _EmployeeSubgroup._EmployeeSubgroupText.Description as EmployeeSubgroupText : localized,
    employee_image_url as EmployeeImageURL,
    
    //Finding Data
    @ObjectModel.text.element: ['FindingTypeText']
    FindingtypeID as Findingtype,
    _GenericCheck._FindingType._FindingTypeText.Description as FindingTypeText : localized,
    _GenericCheck._FindingType.DisplayCategory as FindingTypeCriticality,
    @ObjectModel.text.element: ['CategoryText']
    _GenericCheck.CategoryID as CategoryID,
    _GenericCheck._Category._CategoryText.Description as CategoryText : localized,
    findingid as Findingid,
    validfrom as ValidFrom,
    validto as ValidTo,    
    findingkey as FindingKey,
    _GenericCheck._GenericCheckText.ShortText as Text_desc: localized,
    _GenericCheck._GenericCheckText.LongText as Furtherinformation: localized,
    lastchangeid as LastChangeID,
    
    //History Data
    @ObjectModel.text.element: ['FindingStatusDescription']
    FindingStatusID as FindingStatusID,
    FindingStatusCriticality as FindingStatusCriticality,
    _latestHistoryEntry._FindingStatus._FindingStatusText.Description as FindingStatusDescription:localized,
    _latestHistoryEntry._User.UserName as ResponsibleClerkDesc,
    
    
    
    //Administrative Data
    @ObjectModel.text.element: ['CreatedByUserName']
    created_by as CreatedBy,
    _CreatedByUser.UserName as CreatedByUserName,
    created_at as CreatedAt,
    @ObjectModel.text.element: ['LastChangedByUserName']
    last_changed_by as LastChangedBy,
    _LastChangedByUser.UserName as LastChangedByUserName,
    last_changed_at as LastChangedAt,
    
    //Only for Objectpage (Beautiful textes)
    ObjectpageSubTitle as ObjectpageSubTitle,
    ResolvedEmployeeName as ResolvedEmployeeName,
    
    _Historyentry : redirected to composition child ZC_ICS_FINDING_HISTORY
}
