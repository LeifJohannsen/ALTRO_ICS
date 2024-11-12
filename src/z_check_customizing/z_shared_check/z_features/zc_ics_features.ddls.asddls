@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Proj. features for presorting persons'

@UI: {
 headerInfo: { 
    typeName: 'Grouping', 
    typeNamePlural: 'Groupings', 
    title: { 
        type: #STANDARD, 
        value: 'FeatureID'  //Description
            },
    description: { 
        value: 'DestinationName',
        type: #STANDARD
                 } 
              } 
     }

define root view entity ZC_ICS_FEATURES 
    as projection on ZI_ICS_FEATURES
{
    @UI.facet: [ { id:              'COLLGENERAL',
                     purpose:         #STANDARD,
                     type:            #COLLECTION,
                     label:           'Allgemeine Informationen',
                     position:        10 
                   },
                       { parentId: 'COLLGENERAL',
                         type: #FIELDGROUP_REFERENCE,
                         label: 'Identifikation',
                         position: 10,
                         targetQualifier: 'IDENTIFICATION'
                       },
                       { parentId: 'COLLGENERAL',
                         type: #FIELDGROUP_REFERENCE,
                         label: 'Parameter',
                         position: 20,
                         targetQualifier: 'PARAMETERS'
                       },
                   { 
                     id:              'TEXTS',
                     type:            #LINEITEM_REFERENCE,
                     label:           'Beschreibungen',
                     position:        20,
                     targetElement:  '_Text'
                   },
                   { 
                     id:              'EXPRESSIONS',
                     type:            #LINEITEM_REFERENCE,
                     label:           'Ausdrücke',
                     position:        30,
                     targetElement:  '_Expression'
                   },
                   { id:              'COLLADMIN',
                     purpose:         #STANDARD,
                     type:            #COLLECTION,
                     label:           'Administrative Informationen',
                     position:        9999 
                   },
                       {
                           id: 'CreatedInformation',
                           purpose: #STANDARD,
                           type: #FIELDGROUP_REFERENCE,
                           parentId: 'COLLADMIN',
                           label: 'Erstellungs Informationen',
                           position: 20,
                           targetQualifier: 'CreatedAdminGroup'
                         },
                         {
                           id: 'LastChangedInformation',
                           purpose: #STANDARD,
                           type: #FIELDGROUP_REFERENCE,
                           parentId: 'COLLADMIN',
                           label: 'Zuletzt geändert Informationen',
                           position: 30,
                           targetQualifier: 'LastChangedAdminGroup'
                         }
                 ]  
               
    @UI.lineItem: [
                        {
                            label: 'Delimit',
                            dataAction: 'delimitEntry',
                            type: #FOR_ACTION,
                            position: 99
                        }
                  ]
    @UI.identification: [{
                            label: 'Delimit',
                            dataAction: 'delimitEntry',
                            type: #FOR_ACTION,
                            position: 99
                        }]
    @UI.hidden: true
    key Id,
    
    @UI: {
              lineItem:       [ { position: 20, importance: #HIGH } ],
              identification: [ { position: 20 } ],
              selectionField: [ { position: 20 } ],
              fieldGroup:     [ { position: 10, qualifier: 'IDENTIFICATION' }]
          } 
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Grouping-ID'
    @ObjectModel.text.element: ['Description']
    @UI.textArrangement: #TEXT_FIRST
    FeatureID as FeatureID,
    
    @UI.hidden: true
    _Text.feature_desc as Description : localized,
        
    @UI: {
          lineItem:       [ { position: 40, importance: #MEDIUM } ],
          identification: [ { position: 40 } ],
          fieldGroup:     [ { position: 20, qualifier: 'IDENTIFICATION' }]
         }
//    @Consumption.derivation: { binding: [ { targetElement : 'ValidFrom' , type : #SYSTEM_FIELD, value : '#SYSTEM_DATE' }]
//    }
    ValidFrom as ValidFrom,
    
    @UI: {
          lineItem:       [ { position: 50, importance: #MEDIUM } ],
          identification: [ { position: 50 } ],
          fieldGroup:     [ { position: 30, qualifier: 'IDENTIFICATION' }]
         }
    ValidTo as ValidTo,
     
    @UI: {
          lineItem:       [ { position: 60, importance: #HIGH } ],
          identification: [ { position: 60 } ],
          selectionField: [ { position: 60 } ],
          fieldGroup:     [ { position: 10, qualifier: 'PARAMETERS' }]
         }
      @UI.textArrangement: #TEXT_ONLY 
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_ICS_Destinations', element: 'DestinationID'  } }]

      @ObjectModel.text.element: ['DestinationName']
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Destination'
      
    Destinationid,
    @EndUserText.label: 'Destination'
    _Destination.DestinationKey as DestinationName,
    
    @UI: {
          lineItem:       [ { position: 70, importance: #MEDIUM } ],
          identification: [ { position: 70 } ],
          fieldGroup:     [ { position: 20, qualifier: 'PARAMETERS' }]
         }
    @UI.textArrangement: #TEXT_ONLY 
    @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_FEATURE_EXETY', element: 'ExecutiontypeID'  } }]

      @ObjectModel.text.element: ['ExecutiontypeDescription']
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Ausführungstyp'
    Executiontype,
    _ExecutionType._ExecutionTypeText.Description as ExecutiontypeDescription : localized,
    
    @UI: {
              identification: [ { position: 9996 } ],
              fieldGroup:     [ { position: 10, qualifier: 'CreatedAdminGroup' }] 
         }
    @EndUserText.label: 'Erstellt von'
    @ObjectModel.text.element: ['CreatedByUserName']
    created_by,
    _CreatedByUser.UserName as CreatedByUserName,
    @UI: {
              identification: [ { position: 9997 } ],
              fieldGroup:     [ { position: 20, qualifier: 'CreatedAdminGroup' }] 
         }
    @EndUserText.label: 'Erstellt am'
    created_at,
    @UI: {
              lineItem:       [ { position: 9998, importance: #LOW } ],
              identification: [ { position: 9998 } ],
              fieldGroup:     [ { position: 30, qualifier: 'LastChangedAdminGroup' }] 
         }
    @EndUserText.label: 'Zuletzt geändert von'
    @ObjectModel.text.element: ['LastChangedByUserName']
    last_changed_by,
    _LastChangedByUser.UserName as LastChangedByUserName,
    @UI: {
              lineItem:       [ { position: 9999, importance: #LOW } ],
              identification: [ { position: 9999 } ],
              fieldGroup:     [ { position: 40, qualifier: 'LastChangedAdminGroup' }] 
         }
    @EndUserText.label: 'Zuletzt geändert am'
    last_changed_at,
    
    _Text : redirected to composition child ZC_ICS_FEATURE_TEXT,
    
    _Expression : redirected to composition child ZC_ICS_FEATURE_EXP
    
    
}
