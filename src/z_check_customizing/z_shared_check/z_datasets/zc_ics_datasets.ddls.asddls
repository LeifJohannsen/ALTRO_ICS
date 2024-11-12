@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Dataset', 
    typeNamePlural: 'Datasets', 
    title: { 
        type: #STANDARD, 
        value: 'Dataset_Description' //Dataset_Description
            }
              } 
     }

@Search.searchable: true

define root view entity ZC_ICS_DATASETS
  as projection on ZI_ICS_DATASETS
{

  
  @UI.facet: [ { id:              'Datasets', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Datasets',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key DestinationID              as DestinationID,
  
  @UI: {
              lineItem:       [ { position: 10, importance: #HIGH } ],
              identification: [ { position: 10 } ] }
  @ObjectModel.text.element: [ 'Dataset_Description' ]
  key DatasetID                 as DatasetID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
  @Search.defaultSearchElement: true
  _DatasetText.Description as Dataset_Description: localized  
     
}
