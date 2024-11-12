@EndUserText.label: 'Finding types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Category', 
    typeNamePlural: 'Categories', 
    title: { 
        type: #STANDARD, 
        value: 'CategoryDescription'
            }
              } 
     }

@Search.searchable: true

@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

define root view entity ZC_ICS_CATEGORIES
  as projection on ZI_ICS_CATEGORY
{

  @ObjectModel.text.element: [ 'CategoryDescription' ]
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
  key CategoryID as CategoryID,
  
  @UI.hidden: true
  ValidFrom as ValidFrom,
  
  @UI.hidden: true
  ValidTo as ValidTo,
   
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ]
       }
  
  @Search.defaultSearchElement: true
  _CategoryText.Description as CategoryDescription: localized
     
}

