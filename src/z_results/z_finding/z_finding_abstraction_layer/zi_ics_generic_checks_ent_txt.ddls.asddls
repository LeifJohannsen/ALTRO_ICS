@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Generic checks entity'

@Search.searchable: true
define root view entity ZI_ICS_GENERIC_CHECKS_ENT_TXT
    as select from ZI_ICS_GENERIC_CHECKS_TXT
{   
    @Search.defaultSearchElement: true
    @ObjectModel.text.element: ['ShortText']
    key checkClass as CheckClass,
    key checkUUID as CheckUUID,
    @Semantics.language: true
    key Language as Language,
    
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    ShortText as ShortText,
    LongText as LongText
    
}
