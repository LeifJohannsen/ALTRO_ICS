@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Employee subgroup', 
    typeNamePlural: 'Employee subgroups', 
    title: { 
        type: #STANDARD, 
        value: 'EmployeeSubgroup_Description'
            }
              } 
     }

@Search.searchable: true

define root view entity ZC_ICS_EMPLOYEE_SUBGROUPS
  as projection on ZI_ICS_Employee_subgroups
{

  @ObjectModel.text.element: [ 'EmployeeSubgroup_Description' ]
      @UI.facet: [ { id:              'UseInLinked',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Employee subgroup',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key EmployeeSubgroupID              as EmployeeSubgroupID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
      @Search.defaultSearchElement: true
      _EmployeeSubgroupText.Description as EmployeeSubgroup_Description: localized
     
}
