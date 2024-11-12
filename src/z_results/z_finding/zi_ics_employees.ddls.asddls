@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Findings Employees view'

define root view entity ZI_ICS_EMPLOYEES 
    as select distinct from zics_protocols
    
    association [0..1] to ZI_ICS_Employee_subgroups  as _EmployeeSubgroup
        on $projection.employee_subgroup  = _EmployeeSubgroup.EmployeeSubgroupID
{

    key employeeid,
    firstname,
    lastname,
    employee_subgroup,
    
    _EmployeeSubgroup
        
}
