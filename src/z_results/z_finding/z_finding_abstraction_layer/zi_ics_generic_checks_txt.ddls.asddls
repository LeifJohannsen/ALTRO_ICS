@AbapCatalog.sqlViewName: 'ZI_ICS_GENERIC_T'

define view  ZI_ICS_GENERIC_CHECKS_TXT
       as select from ZI_ICS_DATA_EXISTANCE 
        { key 'DataExistenceCheck'              as checkClass, 
          key mykey                             as checkUUID, 
          key _Text.DataExistanceLanguage       as Language,
          _Text.DataExistanceDescription        as ShortText,
          _Text.DataExistanceLongDescription    as LongText
          
        }
    union select from ZI_ICS_FIELD_CHECK_DUMMY
        { key 'FieldCheck'                      as checkClass,
          key mykey                             as checkUUID,
          key _Text.DataExistanceLanguage       as Language,
          _Text.DataExistanceDescription        as ShortText,
          _Text.DataExistanceLongDescription    as LongText
        
        }
    //Hier folgen weitere Genriken
