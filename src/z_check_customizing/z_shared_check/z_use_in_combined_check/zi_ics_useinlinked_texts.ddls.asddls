@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Systemtypes Text View - CDS Data Model'

define view entity ZI_ICS_USEINLINKED_TEXTS
  as select from zics_useinlink_t as UseInLinkedText

{

  key UseInLinkedText.id             as UseInLinkedID,
  @Semantics.language: true
  key UseInLinkedText.language       as Language,
    @Semantics.text: true
    UseInLinkedText.description      as Description
      

}
