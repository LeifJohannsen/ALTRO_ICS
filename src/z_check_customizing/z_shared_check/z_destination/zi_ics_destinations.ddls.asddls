@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checktypes View - CDS Data Model'

@Search.searchable: true

define root view entity ZI_ICS_DESTINATIONS
  as select from zdb_destination as Destination
  
  association [0..1] to ZI_ICS_SYSTEMTYPES  as _SystemType   on   $projection.SystemType = _SystemType.SystemTypeID

{
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['DestinationKey']
       
  //@UI.hidden: true
  key Destination.id                     as ID,
  key Destination.systemtype             as SystemType,
  key Destination.destinationkey         as DestinationKey,
    Destination.purpose                  as Purpose,
    
    _SystemType

}
