@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Sign', 
    typeNamePlural: 'Signs', 
    title: { 
        type: #STANDARD, 
        value: 'SignDescription' //Dataset_Description
            }
              } 
     }

@ObjectModel.usageType.sizeCategory: #S
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZC_FEATURE_SIGN
  as projection on ZI_FEATURE_SIGN
{

  
  @UI.facet: [ { id:              'Sign', 
                 purpose:         #STANDARD,
                 type:            #IDENTIFICATION_REFERENCE,
                 label:           'Sign',
                 position:        10 
               }
             ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['SignDescription']
  key ID as SignID,
    
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  
  _SignText.Description as SignDescription: localized  
     
}
