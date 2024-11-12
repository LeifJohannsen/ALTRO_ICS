@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee subgroups Text View - CDS Data Model'

define view entity ZI_ICS_EE_SUBGROUPS_TEXTS
  as select from zics_ee_sbgrp_t as EmployeeSubgroupText

{

  key EmployeeSubgroupText.employee_subgroup_id             as EmployeeSubgroupID,
  @Semantics.language: true
  key EmployeeSubgroupText.language       as Language,
    @Semantics.text: true
    EmployeeSubgroupText.employee_subgroup_desc      as Description
      

}
