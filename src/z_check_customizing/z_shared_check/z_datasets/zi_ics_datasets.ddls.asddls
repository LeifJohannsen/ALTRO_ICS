@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Datasets View - CDS Data Model'
define root view entity ZI_ICS_DATASETS
  as select from zics_datasets as Dataset
  
  association [0..*] to ZI_ICS_DATASETS_TEXT as _DatasetText 
    on $projection.DatasetID  = _DatasetText.DatasetID
   and $projection.DestinationID = _DatasetText.DestinationID

{
  
  key Dataset.destination     as DestinationID,
  key Dataset.dataset         as DatasetID,
  
  _DatasetText

}
