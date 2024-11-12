@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Feature texts'

@UI: {
 headerInfo: { 
    typeName: 'Grouping Beschreibung', 
    typeNamePlural: 'Grouping Beschreibungen', 
    title: { 
        type: #STANDARD,
        value: 'Feature_Desc' 
            }
              } 
     }

@Search.searchable: true

define view entity ZC_ICS_FEATURE_TEXT 
    as projection on ZI_ICS_FEATURES_TEXT
{
        
    @UI.facet: [ { id:              'FeatureText',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Grouping Text',
                     position:        10 
                   }
                 ]  
                 
  @UI.lineItem: [
                        {
                            label: 'translate',
                            dataAction: 'translate',
                            type: #FOR_ACTION,
                            position: 99
                        }
                  ] 
  
  @UI.hidden: true
  @ObjectModel.text.element: ['Feature_Desc'] ----meaning?
    key Id,
    
    @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
  @ObjectModel.text.element: ['FeatureLanguageName']
  @Consumption.valueHelpDefinition: [{ entity : {name: 'I_Language', element: 'Language'  } }]
  @EndUserText.label: 'Sprache'
  @Search.defaultSearchElement: true
    key Language,
    
    @UI.hidden: true
    _language._Text.LanguageName as FeatureLanguageName:localized,
    
    @UI: {
          lineItem:       [ { position: 20, importance: #HIGH } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
  @Search.defaultSearchElement: true
  @EndUserText.label: 'Kurz-Beschreibung'
    feature_desc,
    
    @UI: {
          lineItem:       [ { position: 30, importance: #HIGH, cssDefault.width: '80rem' } ],
          identification: [ { position: 30 } ],
          selectionField: [ { position: 30 } ] }
  @UI.multiLineText : true
  @EndUserText.label: 'Lang-Beschreibung'
    feature_long_desc,
    
    @UI.hidden: true
    created_by,
    
    @UI.hidden: true
    created_at,
    
    @UI.hidden: true
    last_changed_by,
    
    @UI.hidden: true
    last_changed_at,
    /* Associations */
    _Feature : redirected to parent ZC_ICS_FEATURES 

}
