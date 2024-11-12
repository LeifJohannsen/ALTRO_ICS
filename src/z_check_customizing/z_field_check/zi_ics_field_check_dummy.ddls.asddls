@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Generic data existance check'

define root view entity ZI_ICS_FIELD_CHECK_DUMMY
    as select from zics_data_exist as data_exist
    
    
    /* Associations */
    association [1..1] to ZI_ICS_CATEGORY     as _Category     on   $projection.categoryid        = _Category.CategoryID 
    association [1..1] to ZI_ICS_FINDING_TYPE as _FindingType  on   $projection.findingtypeid     = _FindingType.FindingTypeID
    association [1..1] to ZI_ICS_DATASETS     as _Dataset      on   $projection.dataset           = _Dataset.DatasetID
    association [1..1] to ZCE_ICS_FEATURES_VH     as _Feature      on   $projection.featureid         = _Feature.FeatureID   
//                                                                and '01'        = _Dataset.SystemTypeID 
    association [1..1] to ZI_ICS_CHECK_TYPES  as _CheckType    on   $projection.checktype         = _CheckType.CheckTypeID
    association [1..1] to ZI_ICS_USEINLINKED  as _UseInLinked  on   $projection.useinlinkedcheck  = _UseInLinked.UseInLinkedID
    composition [0..*] of ZI_ICS_FIELD_CHECK_TXT as _Text
    
{   
    
    key mykey,
    cast(
      case replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(findingid,
        '0', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', '')
        when ''
        then lpad(findingid, 4, '0')
        else findingid
      end as abap.char(4)
    ) as findingid,  
//      findingid,
      validfrom,        
      validto,
      featureid,
      categoryid,
      findingtypeid,
      dataset,
      checktype,
      useinlinkedcheck,
      description,
      language, 
      
      /*-- Admin data --*/
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.lastChangedBy: true
      last_changed_by,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
            
      case 
        when ( validto >= $session.system_date and validfrom <= $session.system_date ) then 3
        else 0
      end as criticality,
     
      
      /* Public associations */
      _Category,
      _Feature,
      _FindingType,
      _Dataset, 
      _CheckType,
      _UseInLinked,
      _Text
}
