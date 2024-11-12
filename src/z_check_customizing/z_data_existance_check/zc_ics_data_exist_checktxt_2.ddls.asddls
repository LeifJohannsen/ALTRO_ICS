@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Data existence check text', 
    typeNamePlural: 'Data existence check texts', 
    title: { 
        type: #STANDARD, 
        value: 'DataExistanceDescription' 
            }
              } 
     }

@Search.searchable: true

define view entity ZC_ICS_DATA_EXIST_CHECKTXT_2
  as projection on ZI_ICS_DATA_EXIST_CHECKTXT_2
{

      @UI.facet: [ { id:              'DataExistenceCheckText',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Data existence check text',
                     position:        10 
                   }
                 ]  
  
  @UI.lineItem: [
                        {
                            label: 'Translate',
                            dataAction: 'translate',
                            type: #FOR_ACTION,
                            position: 99
                        }
                  ]
  
//  @UI: {
//              lineItem:       [ { position: 5, importance: #HIGH } ],
//              identification: [ { position: 5 } ] }
  @UI.hidden: true
  @ObjectModel.text.element: ['DataExistanceDescription'] ----meaning?
  key DataExistanceUUID              as DataExistenceUUID,
  
  @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  @ObjectModel.text.element: ['DataExistanceLanguageName']
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Language', element: 'Language'  } }]
  @EndUserText.label: 'Language'
  key DataExistanceLanguage as DataExistanceLanguage,
  @UI.hidden: true
  _language._Text.LanguageName as DataExistanceLanguageName:localized,
  
  
  @UI: {
          lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
  @Search.defaultSearchElement: true
  @EndUserText.label: 'Short text'
  DataExistanceDescription as DataExistanceDescription,
  
  @UI: {
          lineItem:       [ { position: 30, importance: #HIGH, cssDefault.width: '80rem' } ],
          identification: [ { position: 30 } ],
          selectionField: [ { position: 30 } ] }
  @UI.multiLineText : true
  @EndUserText.label: 'Long text'
  DataExistanceLongDescription as DataExistanceLongDescription,
  
  @UI.hidden: true
  DataExistanceLastChangedAt as DataExistanceLastChangedAt,
  
  _DataExistance : redirected to parent ZC_ICS_DATA_EXISTANCE
  
}
