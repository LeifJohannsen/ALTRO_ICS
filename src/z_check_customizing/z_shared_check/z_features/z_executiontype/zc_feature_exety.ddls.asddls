@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Executiontype', 
    typeNamePlural: 'Executiontypes', 
    title: { 
        type: #STANDARD, 
        value: 'ExecutiontypeDescription' //Dataset_Description
            }
              } 
     }

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_FEATURE_EXETY
  as projection on ZI_FEATURE_EXETY
{

  
  @UI.facet: [ { id:              'Executiontype', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Executiontype',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['ExecutiontypeDescription']
  key ID as ExecutiontypeID,
    
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  
  _ExecutionTypeText.Description as ExecutiontypeDescription: localized  
     
}
