@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Check type', 
    typeNamePlural: 'Check types', 
    title: { 
        type: #STANDARD, 
        value: 'CheckTypeID' 
            }
              } 
     }

@Search.searchable: true

@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_CHECK_TYPES
  as projection on ZI_ICS_CHECK_TYPES
{

  @ObjectModel.text.element: [ 'Check_Type_Description' ]
      @UI.facet: [ { id:              'CheckTypes',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Check Types',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key CheckTypeID              as CheckTypeID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
  @ObjectModel.text.element: ['Check_Type_Description'] ----meaning?
      @Search.defaultSearchElement: true
      _ChecktypeText.Description as Check_Type_Description: localized  
     
}
