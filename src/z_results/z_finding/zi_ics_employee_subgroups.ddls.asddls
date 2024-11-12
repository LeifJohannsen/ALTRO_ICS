@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Use in linked check View'

@Search.searchable: true

define root view entity ZI_ICS_Employee_subgroups
  as select from zics_ee_subgroup as EmployeeSubgroup
  
  association [1..*] to ZI_ICS_EE_SUBGROUPS_TEXTS as _EmployeeSubgroupText on 
    $projection.EmployeeSubgroupID = _EmployeeSubgroupText.EmployeeSubgroupID
    
{
      @Search.defaultSearchElement: true
      
  @UI.hidden: true
  key EmployeeSubgroup.employee_subgroup_id        as EmployeeSubgroupID,
    _EmployeeSubgroupText
      

}
