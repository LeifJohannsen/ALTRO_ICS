@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Use in linked check View'

@Search.searchable: true

define root view entity ZI_ICS_USEINLINKED
  as select from zics_useinlinked as UseInLinked
  
  association [1..*] to ZI_ICS_USEINLINKED_TEXTS as _UseInLinkedText on 
    $projection.UseInLinkedID = _UseInLinkedText.UseInLinkedID
    
{
      @Search.defaultSearchElement: true
      
  @UI.hidden: true
  key UseInLinked.id        as UseInLinkedID,
    _UseInLinkedText
      

}
