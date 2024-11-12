@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Systemtypes View - CDS Data Model'

@Search.searchable: true

define root view entity ZI_ICS_SYSTEMTYPES
  as select from zics_systemtypes as Systemtype
    
  association [1..*] to ZI_ICS_SYSTEMTYPES_TEXTS as _SystemTypeText on 
    $projection.SystemTypeID = _SystemTypeText.SystemTypeID
{
      @Search.defaultSearchElement: true
      
  @UI.hidden: true
  key Systemtype.systemtypeid   as SystemTypeID,
    _SystemTypeText

}
