@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Systemtype', 
    typeNamePlural: 'Systemtypes', 
    title: { 
        type: #STANDARD, 
        value: 'Systemtype_Description' 
            }
              } 
     }

@Search.searchable: true

@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_SYSTEMTYPES
  as projection on ZI_ICS_SYSTEMTYPES
{

  @ObjectModel.text.element: [ 'Systemtype_Description' ]
      @UI.facet: [ { id:              'SystemTypes',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'System Types',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key SystemTypeID              as SystemTypeID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
      @Search.defaultSearchElement: false
      _SystemTypeText.Description as Systemtype_Description: localized
     
}
