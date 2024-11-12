@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Features texts'

define view entity ZI_ICS_FEATURES_EXP 
    as select from zdb_feature_exp as FeatureExpression
    
    association to parent ZI_ICS_FEATURES as _Feature
        on $projection.Id = _Feature.Id
        
    association [1..1] to ZI_ICS_DATASETS     as _Dataset      on   $projection.Dataset           = _Dataset.DatasetID 
                                                               and $projection.DestinationID = _Dataset.DestinationID
    association [1..1] to ZI_ICS_FIELDS     as _Field      on   $projection.Dataset           = _Field.DatasetID 
                                                               and $projection.DestinationID = _Field.DestinationID
                                                               and $projection.Property = _Field.FieldID
    association [1..1] to ZI_FEATURE_NOT_OPERATION as _NotOperation on $projection.Not_Operator = _NotOperation.ID
    association [1..1] to ZI_FEATURE_SIGN as _Sign on $projection.Sign = _Sign.ID
    association [1..1] to ZI_FEATURE_OPER as _Operation on $projection.Operation = _Operation.ID
    association [1..1] to ZI_FEATURE_CONJ as _Conjunction on $projection.Operation = _Conjunction.ID
    
    
{
    key FeatureExpression.id as Id,
    key FeatureExpression.exp_id as Exp_ID,
    FeatureExpression.line as Line,
    FeatureExpression.not_operator as Not_Operator,
    FeatureExpression.left_parenthesis as Left_Parenthesis,
    FeatureExpression.dataset as Dataset,
    FeatureExpression.property as Property,
    FeatureExpression.sign as Sign,
    FeatureExpression.operation as Operation,
    FeatureExpression.low as Low,
    FeatureExpression.high as High,
    FeatureExpression.right_parenthesis as Right_Parenthesis,
    FeatureExpression.conjunction as Conjunction,
    
    _Feature.Destinationid as DestinationID,
    
    @Semantics.user.createdBy: true
    FeatureExpression.created_by as Created_By,
    
    @Semantics.systemDateTime.createdAt: true
    FeatureExpression.created_at as Created_At,
    
    @Semantics.user.lastChangedBy: true
    FeatureExpression.last_changed_by as Last_Changed_By,
    
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    FeatureExpression.last_changed_at as Last_Changed_At,
    
    _Feature,
    _Dataset,
    _Field,
    _NotOperation,
    _Sign,
    _Operation,
    _Conjunction
}
