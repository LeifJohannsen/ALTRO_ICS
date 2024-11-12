@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Features for presorting persons'

define root view entity ZI_ICS_FEATURES 
    as select from zdb_feature_head
    
    association [1] to ZI_ICS_DESTINATIONS as _Destination on $projection.Destinationid = _Destination.ID
    association [1] to ZI_FEATURE_EXETY as _ExecutionType on $projection.Executiontype = _ExecutionType.ID
    association [1] to I_IAMBusinessUserLogonDetails  as _CreatedByUser on $projection.created_by  = _CreatedByUser.UserID
    association [1] to I_IAMBusinessUserLogonDetails  as _LastChangedByUser on $projection.last_changed_by  = _LastChangedByUser.UserID
    
    composition [0..*] of ZI_ICS_FEATURES_TEXT as _Text
    
    composition [0..*] of ZI_ICS_FEATURES_EXP as _Expression
    
{
          
    key id        as Id,
    featureid     as FeatureID,
    destinationid as Destinationid,
    executiontype as Executiontype,
    validfrom     as ValidFrom,
    validto       as ValidTo,
    
    @Semantics.user.createdBy: true
    created_by as created_by,
    @Semantics.systemDateTime.createdAt: true
    created_at as created_at,
    @Semantics.user.lastChangedBy: true
    last_changed_by as last_changed_by,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as last_changed_at,
    
    _Destination,
    _ExecutionType,
    _CreatedByUser,
    _LastChangedByUser,
    @ObjectModel.association.toHierarchy: true
    _Text,
    _Expression            
}
