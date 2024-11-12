@EndUserText.label: 'Finding types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Finding type', 
    typeNamePlural: 'Finding types', 
    title: { 
        type: #STANDARD, 
        value: 'FindingType_Description'
            }
              } 
     }

@Search.searchable: true

@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_FINDING_TYPES
  as projection on ZI_ICS_FINDING_TYPE
{

  @ObjectModel.text.element: [ 'FindingType_Description' ]
      @UI.facet: [ { id:              'UseInLinked',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Finding type',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key FindingTypeID              as FindingTypeID,
  
  @UI.hidden: true
  DisplayCategory as DisplayCategory,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ]
       }
  
      @Search.defaultSearchElement: true
      _FindingTypeText.Description as FindingType_Description: localized
     
}
