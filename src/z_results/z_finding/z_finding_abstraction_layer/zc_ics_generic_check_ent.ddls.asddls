@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generic checks entity projection'

define root view entity ZC_ICS_GENERIC_CHECK_ENT 
    as projection on ZI_ICS_GENERIC_CHECKS_ENT
{   
    key CheckClass,
    @UI.hidden: true
    key CheckUUID,
    
    @ObjectModel.text.element: [ 'CategoryDescription' ]
    CategoryID,
    @ObjectModel.text.element: [ 'FindingTypeDescription' ]
    FindingTypeID,
//    @ObjectModel.text.element: [ 'SystemTypeDescription' ]
//    SystemTypeID,
    
    _Category._CategoryText.Description as CategoryDescription: localized,
    _FindingType._FindingTypeText.Description as FindingTypeDescription: localized,
//    _SystemType._SystemTypeText.Description as SystemTypeDescription: localized,
    _GenericCheckText.ShortText as ShortText: localized,
    _GenericCheckText.LongText as LongText: localized
}
