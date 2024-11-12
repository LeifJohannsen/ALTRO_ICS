@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Finding Statuses projection view'

@UI: {
 headerInfo: { 
    typeName: 'Finding status', 
    typeNamePlural: 'Finding statuses', 
    title: { 
        type: #STANDARD, 
        value: 'FindingStatus_Description'
            }
              } 
     }

@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_FINDING_STATUSES 
    as projection on ZI_ICS_FINDING_STATUSES
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
  FindinStatusDisplayCategory as FindinStatusDisplayCategory,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
      @Search.defaultSearchElement: true
      _FindingStatusText.Description as FindingStatus_Description: localized
    
}
