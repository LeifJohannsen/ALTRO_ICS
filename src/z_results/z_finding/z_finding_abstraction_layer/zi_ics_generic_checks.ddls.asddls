@AbapCatalog.sqlViewName: 'ZI_ICS_GENERIC_C'

define view  ZI_ICS_GENERIC_CHECKS
       as select from ZI_ICS_DATA_EXISTANCE 
        { 'DataExistenceCheck'  as checkClass, 
          mykey                 as checkUUID, 
          findingtypeid         as FindingTypeID,
          _FindingType          as _FindingType, 
          categoryid            as CategoryID,
          _Category             as _Category,
          featureid             as FeatureID,
          _Feature              as _Feature
        }
    union select from ZI_ICS_FIELD_CHECK_DUMMY
        { 'FieldCheck'          as checkClass,
          mykey                 as checkUUID,
          findingtypeid         as FindingTypeID,
          _FindingType          as _FindingType,
          categoryid            as CategoryID,
          _Category             as _Category,
          featureid             as FeatureID,
          _Feature              as _Feature        
        }
   //Hier folgen weitere Genriken
