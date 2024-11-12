@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Operation', 
    typeNamePlural: 'Operations', 
    title: { 
        type: #STANDARD, 
        value: 'OperationDescription' //Dataset_Description
            }
              } 
     }

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_FEATURE_OPER
  as projection on ZI_FEATURE_OPER
{

  
  @UI.facet: [ { id:              'Operation', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Operation',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['OperationDescription']
  key ID as OperationID,
    
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  
  _OperationText.Description as OperationDescription: localized  
     
}
