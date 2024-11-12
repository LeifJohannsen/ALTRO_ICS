@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Not operator', 
    typeNamePlural: 'Not operators', 
    title: { 
        type: #STANDARD, 
        value: 'NotOperationDescription' //Dataset_Description
            }
              } 
     }

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_FEATURE_NOT_OPERATION
  as projection on ZI_FEATURE_NOT_OPERATION
{

  
  @UI.facet: [ { id:              'NotOperator', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Not operator',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['NotOperationDescription']
  key ID as NotOperationID,
    
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  
  _NotOperationText.Description as NotOperationDescription: localized  
     
}
