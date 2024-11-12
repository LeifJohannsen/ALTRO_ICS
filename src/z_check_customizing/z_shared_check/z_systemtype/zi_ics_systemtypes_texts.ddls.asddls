@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Systemtypes Text View - CDS Data Model'
@Search.searchable: true

define view entity ZI_ICS_SYSTEMTYPES_TEXTS
  as select from zics_systypes_t as SystemtypeText

{
  @Search.defaultSearchElement: true  
  @ObjectModel.text.element: ['Description']
  key SystemtypeText.systemtypeid   as SystemTypeID,
  @Semantics.language: true
  key SystemtypeText.language       as Language,
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    SystemtypeText.systemteype_desc as Description
      

}
