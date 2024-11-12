@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Feature texts'

@UI: {
 headerInfo: { 
    typeName: 'Grouping Ausdruck', 
    typeNamePlural: 'Grouping Ausdrücke', 
    title: { 
        type: #STANDARD, 
        value: 'Line' 
            }
      },
      presentationVariant: [
    { 
        sortOrder: [
            { 
                by: 'Line',
                direction: #ASC
            }
        ],
    visualizations: [{type: #AS_LINEITEM }]
    }
 ]
}


define view entity ZC_ICS_FEATURE_EXP 
    as projection on ZI_ICS_FEATURES_EXP
{
    
    @UI.facet: [ { id:              'FeatureText',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Feature-expression',
                     position:        10 
                   }
                 ] 
                 
  @UI.lineItem: [
                        {
                            label: 'davor anlegen',
                            dataAction: 'create_before',
                            type: #FOR_ACTION,
                            position: 99
                        },
                        {
                            label: 'danach anlegen',
                            dataAction: 'create_after',
                            type: #FOR_ACTION,
                            position: 98
                        }
                  ] 
                  
                     
  @UI.hidden: true
    key Id,
    
    @UI.hidden: true
    key Exp_ID,
    
    @UI: {
          lineItem:       [ { position: 10, importance: #HIGH } ],
          identification: [ { position: 10 } ],
          selectionField: [ { position: 10 } ] }
    @EndUserText.label: 'Zeile'
    Line,
        
    @UI: {
          lineItem:       [ { position: 20, importance: #HIGH, cssDefault.width: '9rem'  } ],
          identification: [ { position: 20 } ],
          selectionField: [ { position: 20 } ] }
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_FEATURE_NOT_OPERATION',
            
            element: 'NotOperationID'
        }
      }
    ]
    @ObjectModel.text.element: ['NotOperatorText']
    @EndUserText.label: 'Nicht-Operator'
    Not_Operator,
    
    _NotOperation._NotOperationText.Description as NotOperatorText : localized,
    
    @UI: {
          lineItem:       [ { position: 30, importance: #HIGH, cssDefault.width: '6rem' } ],
          identification: [ { position: 30 } ],
          selectionField: [ { position: 30 } ] }
    @EndUserText.label: 'Linke Klammer'
    Left_Parenthesis,
    
    @UI: {
          lineItem:       [ { position: 35, importance: #LOW, cssDefault.width: '9rem'    } ],
          identification: [ { position: 35 } ],
          selectionField: [ { position: 35 } ] }
    @UI.textArrangement: #TEXT_ONLY
    @ObjectModel.text.element: ['DestinationName']
    @EndUserText.label: 'Destination'
    _Feature.Destinationid as DestinationID,
    _Feature._Destination.DestinationKey as DestinationName,
        
    @UI: {
          lineItem:       [ { position: 40, importance: #HIGH  } ],
          identification: [ { position: 40 } ],
          selectionField: [ { position: 40 } ] }
    @EndUserText.label: 'Dataset'
    @ObjectModel.text.element: ['DatasetDescription']
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_ICS_DATASETS',
            
            element: 'DatasetID'
        },
        additionalBinding: 
            [
                { 
                localElement: '_Feature.Destinationid',
                element: 'DestinationID' 
                }
            ]
      }
      ]
    Dataset,
    _Dataset._DatasetText.Description             as DatasetDescription       :localized,
    @UI: {
          lineItem:       [ { position: 50, importance: #HIGH, cssDefault.width: '10rem'  } ],
          identification: [ { position: 50 } ],
          selectionField: [ { position: 50 } ] }
    @EndUserText.label: 'Property'
    @ObjectModel.text.element: ['PropertyDescription']
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_ICS_FIELDS',
            
            element: 'FieldID'
        },
        additionalBinding: 
            [
                { 
                localElement: '_Feature.Destinationid',
                element: 'DestinationID' 
                },
                { 
                localElement: 'Dataset',
                element: 'DatasetID' 
                }
            ]
      }
      ]
    Property,
    _Field._FieldText.Description as PropertyDescription : localized,
    
    @UI: {
          lineItem:       [ { position: 60, importance: #HIGH, cssDefault.width: '11rem'   } ],
          identification: [ { position: 60 } ],
          selectionField: [ { position: 60 } ] }
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_FEATURE_SIGN',
            
            element: 'SignID'
        }
      }
    ]
    @ObjectModel.text.element: ['SignText']
    @EndUserText.label: 'Zeichen'
    Sign,
    
    _Sign._SignText.Description as SignText : localized,
    
    @UI: {
          lineItem:       [ { position: 70, importance: #HIGH, cssDefault.width: '11rem' } ],
          identification: [ { position: 70 } ],
          selectionField: [ { position: 70 } ] }
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_FEATURE_OPER',
            element: 'OperationID'
        }
      }
    ]
    @ObjectModel.text.element: ['OperationText']
    @EndUserText.label: 'Operation'
    Operation,
    
    _Operation._OperationText.Description as OperationText : localized,
    
    @UI: {
          lineItem:       [ { position: 80, importance: #HIGH, cssDefault.width: '10rem' } ],
          identification: [ { position: 80 } ],
          selectionField: [ { position: 80 } ] }
    @EndUserText.label: 'Low'
    Low,
    
    @UI: {
          lineItem:       [ { position: 90, importance: #HIGH, cssDefault.width: '10rem' } ],
          identification: [ { position: 90 } ],
          selectionField: [ { position: 90 } ] }
    @EndUserText.label: 'High'
    High,
    
    @UI: {
          lineItem:       [ { position: 100, importance: #HIGH, cssDefault.width: '6rem'  } ],
          identification: [ { position: 100 } ],
          selectionField: [ { position: 100 } ] }
    @EndUserText.label: 'Rechte Klammer'
    Right_Parenthesis,
    
    @UI: {
          lineItem:       [ { position: 110, importance: #HIGH } ],
          identification: [ { position: 110 } ],
          selectionField: [ { position: 110 } ] }
          
    @Consumption.valueHelpDefinition: [
      { entity: 
        {
            name: 'ZC_FEATURE_CONJ',
            
            element: 'ConjunctionID'
        }
      }
    ]
    @ObjectModel.text.element: ['ConjunctionText']
    @EndUserText.label: 'Konjunktion'
    Conjunction,
    _Conjunction._ConjunctionText.Description as ConjunctionText : localized,
       
    @UI.hidden: true
    Created_By,
    
    @UI.hidden: true
    Created_At,
    
    @UI.hidden: true
    Last_Changed_By,
    
    @UI.hidden: true
    Last_Changed_At,
        
    /* Associations */
    _Feature : redirected to parent ZC_ICS_FEATURES

}
