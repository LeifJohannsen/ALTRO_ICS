@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'

@Search.searchable: true
define view entity ZI_ICS_DATASETS_TEXT
  
  as select from zics_datasetstxt as DatasetText

{
  
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key DatasetText.destination     as DestinationID,
  key DatasetText.dataset         as DatasetID,
  @Semantics.language: true
  key DatasetText.language        as Language,
  @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
  DatasetText.dataset_desc        as Description

}
