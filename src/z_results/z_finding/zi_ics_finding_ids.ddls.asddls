@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Findings Finding IDs view'

define root view entity ZI_ICS_FINDING_IDs 
    as select distinct from zics_protocols
       
    association [1..1] to ZI_ICS_DATA_EXISTANCE  as _DataExistanceCheck
        on $projection.findingkey  = _DataExistanceCheck.mykey
{

    key findingkey,
    
    cast(
      case replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(findingid,
        '0', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', '')
        when ''
        then lpad(findingid, 4, '0')
        else findingid
      end as abap.char(4)
    ) as findingid,
        
    _DataExistanceCheck
        
}
