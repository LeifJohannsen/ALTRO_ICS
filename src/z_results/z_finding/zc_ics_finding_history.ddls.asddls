@EndUserText.label: 'Finding History projection view'
@AccessControl.authorizationCheck: #CHECK

@UI: 
{
 headerInfo: 
    { 
    typeName: 'History', 
    typeNamePlural: 'History', 
    title: 
        { 
        type: #STANDARD,
        value: 'Status'
        }
      },
 presentationVariant: [{ sortOrder: [{ by: 'created_at', direction: #DESC }] }]
}

@Search.searchable: true

define view entity ZC_ICS_FINDING_HISTORY
  as projection on ZI_ICS_FINDING_History
{
  
    @UI.facet: [ { id:              'COLLFAC1',
                     type:            #COLLECTION,
                     label:           'General Information',
                     position:        10 
                   },
                   { parentId: 'COLLFAC1',
                     type: #FIELDGROUP_REFERENCE,
                     position: 10,
                     targetQualifier: 'GENERAL'
                   }
                 ]
  
  @UI.hidden: true
  key mykey,
  
  @UI.hidden: true
  findingid, 
  
  @UI.dataPoint: { qualifier: 'CreatedAt', title: 'Created at'}
  @UI: {
              lineItem:       [ { position: 05, importance: #MEDIUM } ]
              ,identification: [ { position: 05 } ]
              ,selectionField: [ { position: 05 } ]
              ,fieldGroup:     [ { position: 05, qualifier: 'GENERAL' }]
         }
    @EndUserText.label: 'Created at'
    @UI.textArrangement: #TEXT_ONLY 
    created_at,
  
  @UI: {
              lineItem:       [ { position: 20, importance: #LOW } ]
              ,identification: [ { position: 20 } ]
              ,selectionField: [ { position: 20 } ]
              ,fieldGroup:     [ { position: 20, qualifier: 'GENERAL' }]
       }
  @EndUserText.label: 'Valid from'
  @Search.defaultSearchElement: true
  validfrom,
  
  @UI: {
              lineItem:       [ { position: 30, importance: #LOW } ]
              ,identification: [ { position: 30 } ]
              ,selectionField: [ { position: 30 } ]
              ,fieldGroup:     [ { position: 30, qualifier: 'GENERAL' }]
       }
//  @EndUserText.label: 'Valid to test'
  @Search.defaultSearchElement: true
  validto,
  
  @UI: {
              lineItem:       [ { position: 40, importance: #MEDIUM } ]
              ,identification: [ { position: 40 } ]
              ,selectionField: [ { position: 40 } ]
              ,fieldGroup:     [ { position: 40, qualifier: 'GENERAL' }]
       }
  @ObjectModel.text.element: ['ResponsibleClerkDesc']
  @Consumption.valueHelpDefinition: [{ entity : {name: 'I_IAMBusinessUserLogonDetails', element: 'UserID'  } }]
  @UI.textArrangement: #TEXT_ONLY 
  @Search.defaultSearchElement: true
  @EndUserText.label: 'Responsible clerk'
  responsibleclerk,
  _User.UserName as ResponsibleClerkDesc,
  
  @UI: {
      lineItem:       [ { position: 50, importance: #MEDIUM } ],
      identification: [ { position: 50, label: 'Status' } ],
      fieldGroup:     [ { position: 50, qualifier: 'GENERAL' }] 
      
      }
  @EndUserText.label: 'Status'
  @UI.selectionField: [{ position: 50 }] 
    
  @Consumption.valueHelpDefinition: [{ entity : {name: 'ZC_ICS_FINDING_STATUSES', element: 'FindingStatusID'  } }]
  @UI.textArrangement: #TEXT_ONLY 
  @ObjectModel.text.element: ['FindingStatusDescription']
  @Search.defaultSearchElement: true
  status,
  @EndUserText.label: 'Finding status Description'
  _FindingStatus._FindingStatusText.Description as FindingStatusDescription:localized,
  
  @UI: {
      lineItem:       [ { position: 60, importance: #HIGH } ],
      identification: [ { position: 60, label: 'Note' } ],
      fieldGroup:     [ { position: 60, qualifier: 'GENERAL' }]
       }
  @EndUserText.label: 'Note (DeepL translated)' 
  
  @ObjectModel.text.element: [ 'postTranslation_01' ]
//  @UI.textArrangement: #TEXT_ONLY 
  note as preTranslation_01,
  

  @UI.hidden: true
  @ObjectModel.virtualElementCalculatedBy: 'ABAP:YCL_CDS_FUNCTION'
  virtual postTranslation_01 : z_ics_description_test,  
//  virtual postTranslation_01 : abap.char(1333),  
  
  @UI.dataPoint: { qualifier: 'LastChangedBy', title: 'Last changed by'}
  last_changed_by,
  
  @UI.dataPoint: { qualifier: 'LastChangedAt', title: 'Last changed at'}
  last_changed_at,
  
  @UI.dataPoint: { qualifier: 'CreatedBy', title: 'Created by'}
  created_by,
   
  
  _Finding : redirected to parent ZC_PROTOCOLS    
}
