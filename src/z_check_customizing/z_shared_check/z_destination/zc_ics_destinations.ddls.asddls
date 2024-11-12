@EndUserText.label: 'Check types projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@UI: {
 headerInfo: { 
    typeName: 'Destination', 
    typeNamePlural: 'Destinations', 
    title: { 
        type: #STANDARD, 
        value: 'DestinationKey' 
            }
              } 
     }

@Search.searchable: true

define root view entity ZC_ICS_Destinations
  as projection on ZI_ICS_DESTINATIONS
{

      @UI.facet: [ { id:              'Destinations',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Destinations',
                     position:        10 
                   }
                 ]  
  
  @UI: {
              lineItem:       [ { position: 5, importance: #HIGH } ],
              identification: [ { position: 5 } ] }
  @UI.hidden: true
  key ID              as DestinationID,
  
  @UI: {
          lineItem:       [ { position: 30, importance: #HIGH } ],
          identification: [ { position: 30 } ],
          selectionField: [ { position: 30 } ] }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_ICS_SYSTEMTYPES', element: 'SystemTypeID'  } }]

      @ObjectModel.text.element: ['System_Type_Description'] ----meaning?
      @Search.defaultSearchElement: true
      key SystemType                    as SystemType,
      
      
      @UI: {
          lineItem:       [ { position: 70, importance: #MEDIUM } ],
          identification: [ { position: 70 } ] }
      @EndUserText.label: 'Destination Name'
      key DestinationKey         as DestinationKey,
      
      @EndUserText.label: 'Systemtype'
      _SystemType._SystemTypeText.Description       as System_Type_Description: localized,
      
      @UI: {
          lineItem:       [ { position: 80, importance: #MEDIUM } ],
          identification: [ { position: 80 } ] }
      @EndUserText.label: 'Destination Purpose'
      Purpose         as Purpose
     
}
