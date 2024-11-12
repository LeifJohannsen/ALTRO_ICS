@EndUserText.label: 'Fields projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Field', 
    typeNamePlural: 'Fields', 
    title: { 
        type: #STANDARD, 
        value: 'Field_Description' 
            }
              } 
     }

@Search.searchable: true

define root view entity ZC_ICS_FIELDS
  as projection on ZI_ICS_FIELDS
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
              lineItem:       [ { position: 7, importance: #HIGH } ],
              identification: [ { position: 7 } ] }
  key DatasetID                    as DatasetID,
  
  @UI: {
              lineItem:       [ { position: 10, importance: #HIGH } ],
              identification: [ { position: 10 } ] }
  @ObjectModel.text.element: [ 'Field_Description' ]
  key FieldID                    as FieldID,
  
  @UI: {
          lineItem:       [ { position: 50, importance: #HIGH } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
  
  @Search.defaultSearchElement: true
  _FieldText.Description as Field_Description: localized  
     
}
