@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Categories Text View - CDS Data Model'

@Search.searchable: true

define view entity ZI_ICS_CATEGORY_TEXTS
  as select from zics_category_t as CategoryText
  
{
  @Search.defaultSearchElement: true
  @ObjectModel.text.element: ['Description']
  key CategoryText.mykey          as CategoryID,
  @Semantics.language: true
  key CategoryText.language       as Language,
  CategoryText.validfrom          as ValidFrom,
  CategoryText.validto            as ValidTo,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.8
  @Semantics.text: true
  CategoryText.category_desc      as Description

}
