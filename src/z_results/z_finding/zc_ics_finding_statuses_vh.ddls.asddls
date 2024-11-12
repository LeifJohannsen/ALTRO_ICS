@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Employee', 
    typeNamePlural: 'Employees', 
    title: { 
        type: #STANDARD, 
        value: 'FindingStatus_Description'
            }
              } 
     }
@Search.searchable: false
@ObjectModel.resultSet.sizeCategory: #XS

define root view entity ZC_ICS_FINDING_STATUSES_VH 
    as projection on ZI_ICS_FINDING_STATUSES_VH
{

  @ObjectModel.text.element: [ 'FindingStatus_Description' ]
  @UI.facet: [ { id:              'FindingStatus',
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Finding status',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key FindingStatusID              as FindingStatusID,
  
  @UI.hidden: true
  FindingStatusCriticality as FindinStatusDisplayCategory,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
      @Search.defaultSearchElement: true
      _FindingStatus._FindingStatusText.Description as FindingStatus_Description: localized
    

}
