@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Features texts'

define view entity ZI_ICS_FEATURES_TEXT 
    as select from zdb_feature_text as FeatureText
    
    association to parent ZI_ICS_FEATURES as _Feature
        on $projection.Id = _Feature.Id
    
    association [1..1] to I_Language as _language
    on $projection.Language = _language.Language
{
    @Search.defaultSearchElement: true  
    @ObjectModel.text.element: ['feature_desc']
    key FeatureText.id as Id,
    
    @Semantics.language: true
    key FeatureText.language as Language,
    
    @Semantics.text: true
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.8
    FeatureText.feature_desc as feature_desc,
    
    @Semantics.text: true
    FeatureText.feature_long_desc as feature_long_desc,
    
    @Semantics.user.createdBy: true
    FeatureText.created_by as created_by,
    
    @Semantics.systemDateTime.createdAt: true
    FeatureText.created_at as created_at,
    
    @Semantics.user.lastChangedBy: true
    FeatureText.last_changed_by as last_changed_by,
    
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    FeatureText.last_changed_at as last_changed_at,
    
    _Feature,
    _language
}
