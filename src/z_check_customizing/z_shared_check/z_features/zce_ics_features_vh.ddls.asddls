@EndUserText.label: 'Travel data custom entity from PRV'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_GET_DISTINCT_FEATURES'

@UI: {
 headerInfo: { 
    typeName: 'Grouping', 
    typeNamePlural: 'Groupings', 
    title: { 
        type: #STANDARD, 
        value: 'FeatureID' 
            }
              } 
     }
     
//@ObjectModel.resultSet.sizeCategory: #XS
@Search.searchable: false
define custom entity ZCE_ICS_FEATURES_VH 
//with parameters p_valid_from : z_valid_from, p_valid_to : z_valid_to
{

    @ObjectModel.text.element: [ 'FeatureID' ]
      @UI.facet: [ { id:              'Feature',
                     purpose:         #STANDARD,
                     type:            #IDENTIFICATION_REFERENCE,
                     label:           'Groupings',
                     position:        10 
                   }
                 ]  
    
    @EndUserText.label: 'Grouping-ID'
    @Search.defaultSearchElement: false
    @UI.lineItem: [ { position: 10 } ]
    @UI.selectionField: [{exclude: true}]
    key FeatureID : z_feature_id;
    @EndUserText.label: 'Valid from'
    @Search.defaultSearchElement: false
    @UI.lineItem: [ { position: 20 } ]
    @UI.selectionField: [{exclude: true}]
    ValidFrom : z_valid_from;
    @EndUserText.label: 'Valid to'
    @Search.defaultSearchElement: false
    @UI.lineItem: [ { position: 30 } ]
    @UI.selectionField: [{exclude: true}]
    ValidTo : z_valid_to;
    @EndUserText.label: 'Destination'
    @Search.defaultSearchElement: false
    @UI.lineItem: [ { position: 40 } ]
    @UI.selectionField: [{exclude: true}]
    @ObjectModel.text.element: [ 'DestinationName' ]
    @UI.textArrangement: #TEXT_ONLY
    Destinationid : sysuuid_x16;
    @UI.hidden: true
    DestinationName : abap.char(255);
}
