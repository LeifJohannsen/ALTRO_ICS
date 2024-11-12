@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Category View'

define root view entity ZI_ICS_CATEGORY
  as select from zics_category as Category
  
  association [0..*] to ZI_ICS_CATEGORY_TEXTS as _CategoryText 
    on $projection.CategoryID = _CategoryText.CategoryID 
    and $projection.ValidFrom = _CategoryText.ValidFrom 
    and $projection.ValidTo = _CategoryText.ValidTo
    
  
{
   
    key mykey as CategoryID,
    validfrom as ValidFrom,
    validto   as ValidTo,
    
    _CategoryText

}
