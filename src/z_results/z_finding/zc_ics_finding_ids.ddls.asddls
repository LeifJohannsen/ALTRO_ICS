@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Finding ID', 
    typeNamePlural: 'Finding IDs', 
    title: { 
        type: #STANDARD, 
        value: 'FindingID' 
            }
              } 
     }
@Search.searchable: false

define root view entity ZC_ICS_FINDING_IDs as projection on ZI_ICS_FINDING_IDs
{
      
      @UI.hidden: true
      key findingkey as FindingKey,
      
       @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ]
       }
  
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Finding-ID'
      findingid as FindingID
      
//      @UI: {
//          lineItem:       [ { position: 20, importance: #HIGH } ],
//          identification: [ { position: 20 } ],
//          selectionField: [ { position: 20 } ]
//       }
//  
//      @Search.defaultSearchElement: false
//      _DataExistanceCheck._Text.description as DataExistanceCheckDesc : localized

    
}
