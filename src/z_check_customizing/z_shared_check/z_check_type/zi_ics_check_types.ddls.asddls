@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Checktypes View - CDS Data Model'

define root view entity ZI_ICS_CHECK_TYPES
  as select from zics_checktype0 as Checktype
  
  association [0..*] to ZI_ICS_CHECK_TYPES_TEXTS as _ChecktypeText on 
    $projection.CheckTypeID = _ChecktypeText.CheckTypeID

{

  key Checktype.checktype      as CheckTypeID,
    
    _ChecktypeText

}
