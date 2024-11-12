@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding Type View'

@Search.searchable: true

define root view entity ZI_ICS_FINDING_TYPE
  as select from zics_findingtype as FindingType
  
  association [1..*] to ZI_ICS_Finding_Type_TEXTS as _FindingTypeText on 
    $projection.FindingTypeID = _FindingTypeText.FindingTypeID
    
{
      @Search.defaultSearchElement: true
      
  @UI.hidden: true
  key FindingType.findingtype        as FindingTypeID,
  display_category as DisplayCategory,
    _FindingTypeText
      

}
