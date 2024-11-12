@EndUserText.label: 'Dataset existance check projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_ICS_DATA_EXISTANCE
    as projection on ZI_ICS_DATA_EXISTANCE 
{   
    
  key mykey                                         as Finding_UUID,
      findingid                                     as Finding_ID,
      validfrom                                     as Valid_From,
      validto                                       as valid_To,
//      @ObjectModel.text.element: ['Feature_Description']
      featureid                                     as Feature,
//      _Feature._Text.FeatureDesc           as Feature_Description      :localized,
      @ObjectModel.text.element: ['Category_Description']
      categoryid                                    as Category,
      _Category._CategoryText.Description           as Category_Description      :localized,
      @ObjectModel.text.element: ['FindingType_Description']
      findingtypeid                                 as FindingType,
      _FindingType._FindingTypeText.Description     as FindingType_Description   :localized,
      _FindingType.DisplayCategory                  as FindingTypeCriticality,
      @ObjectModel.text.element: ['Destination_Name']
      destination                                   as DestinationID,
      _Destination.DestinationKey                   as Destination_Name,      
      @ObjectModel.text.element: ['Dataset_Description']
      dataset                                       as DataSet,
      _Dataset._DatasetText.Description             as Dataset_Description       :localized,
      @ObjectModel.text.element: ['Check_Type_Description']
      checktype                                     as Check_Type,
      _CheckType._ChecktypeText.Description         as Check_Type_Description    :localized,
      @ObjectModel.text.element: ['Use_In_Linked_Check_Desc']
      useinlinkedcheck                              as Use_In_Linked_Check,
      _UseInLinked._UseInLinkedText.Description     as Use_In_Linked_Check_Desc  :localized,
      _Text.DataExistanceDescription                as LocalizedDescription      :localized,
      last_check                                    as LastCheck,
      last_check_context                            as LastCheckContext,
      @ObjectModel.text.element: ['LastChangedByUserName']
      last_changed_by                               as LastChangedBy,
      _LastChangedByUser.UserName                   as LastChangedByUserName,
      last_changed_at                               as LastChangedAt,
      @ObjectModel.text.element: ['CreatedByUserName']
      created_by                                    as CreatedBy,
      _CreatedByUser.UserName                       as CreatedByUserName,
      created_at                                    as CreatedAt,
      criticality                                   as criticality,
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_DELIMITATION_EXPLANATION'
      virtual DelimitationExplanation : abap.string( 1300 ),
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_DELIMITATION_EXPLANATION'
      virtual DelimitationCriticality : abap.numc( 1 ),       
      
      _Text : redirected to composition child ZC_ICS_DATA_EXIST_CHECKTXT_2
      
}
