@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checktypes View - CDS Data Model'
@Search.searchable: true

define view entity ZI_ICS_CHECK_TYPES_TEXTS
  as select from zics_checktype0t as ChecktypeText

{
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key ChecktypeText.checktype      as CheckTypeID,
  @Semantics.language: true
  key ChecktypeText.language       as Language,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    ChecktypeText.checktype_desc      as Description
      

}
