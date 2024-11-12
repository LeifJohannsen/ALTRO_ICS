@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Conjunction', 
    typeNamePlural: 'Conjunctions', 
    title: { 
        type: #STANDARD, 
        value: 'ConjunctionDescription' //Dataset_Description
            }
              } 
     }

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_FEATURE_CONJ
  as projection on ZI_FEATURE_CONJ
{

  
  @UI.facet: [ { id:              'Conjunction', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Conjunction',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['ConjunctionDescription']
  key ID as ConjunctionID,
    
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  
  _ConjunctionText.Description as ConjunctionDescription: localized     
}
