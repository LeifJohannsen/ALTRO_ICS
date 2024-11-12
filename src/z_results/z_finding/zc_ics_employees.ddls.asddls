@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Employee', 
    typeNamePlural: 'Employees', 
    title: { 
        type: #STANDARD, 
        value: 'Lastname' 
            }
              } 
     }
@Search.searchable: false

define root view entity ZC_ICS_EMPLOYEES as projection on ZI_ICS_EMPLOYEES
{

       @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ]
       }
  
      @Search.defaultSearchElement: true
      key employeeid as EmployeeID,
      
      @UI: {
          lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ]
       }
  
      @Search.defaultSearchElement: true
      firstname as Firstname,
      
      @UI: {
          lineItem:       [ { position: 30, importance: #HIGH } ],
          identification: [ { position: 30 } ],
          selectionField: [ { position: 30 } ]
       }
  
      @Search.defaultSearchElement: true
      lastname as Lastname,
      
      @UI: {
          lineItem:       [ { position: 40, importance: #HIGH } ],
          identification: [ { position: 40 } ],
          selectionField: [ { position: 40 } ]
       }
      @ObjectModel.text.element: ['EmployeeSubgroupDesc']
      @Search.defaultSearchElement: true
      employee_subgroup as EmployeeSubgroup,
      
      @UI.hidden: true
      _EmployeeSubgroup._EmployeeSubgroupText.Description as EmployeeSubgroupDesc : localized
    

    
}
