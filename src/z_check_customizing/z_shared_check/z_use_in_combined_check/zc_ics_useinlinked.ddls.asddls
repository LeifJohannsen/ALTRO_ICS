@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Use in linked check', 
    typeNamePlural: 'Use in linked checks', 
    title: { 
        type: #STANDARD, 
        value: 'UseInLinked_Description' 
            }
              } 
     }

@Search.searchable: true

@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_USEINLINKED
  as projection on ZI_ICS_USEINLINKED
{

  @ObjectModel.text.element: [ 'UseInLinked_Description' ]
      @UI.facet: [ { id:              'UseInLinked',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Use in linked check',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key UseInLinkedID              as UseInLinkedID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
      @Search.defaultSearchElement: true
      _UseInLinkedText.Description as UseInLinked_Description: localized
     
}
