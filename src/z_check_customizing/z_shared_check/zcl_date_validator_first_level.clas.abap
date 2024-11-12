CLASS zcl_date_validator_first_level DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS CONSTRUCTOR
        IMPORTING
            draftTableName  TYPE string
            groupIDName     TYPE string
            keyName         TYPE string
            checkClassName  TYPE string
            linesCount      TYPE i.

    METHODS changeParameters
        IMPORTING
            key             TYPE string
            groupID         TYPE string
            validFrom       TYPE dats
            validto         TYPE dats.

    METHODS validateDates
        returning value(message) type ref to IF_ABAP_BEHV_MESSAGE.

    CLASS-methods NEW_MESSAGE
    importing
      !ID type SYMSGID
      !NUMBER type SYMSGNO
      !SEVERITY type IF_ABAP_BEHV_MESSAGE=>T_SEVERITY
      !V1 type SIMPLE optional
      !V2 type SIMPLE optional
      !V3 type SIMPLE optional
      !V4 type SIMPLE optional
    returning
      value(OBJ) type ref to IF_ABAP_BEHV_MESSAGE .

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: key             TYPE string,
          groupID         TYPE string,
          validFrom       TYPE dats,
          validto         TYPE dats,
          draftTableName  TYPE string,
          groupIDName     TYPE string,
          keyName         TYPE string,
          checkClassName  TYPE string,
          linesCount      TYPE i.

    DATA: lastMinDateInFindings TYPE dats,
          lastMaxDateInFindings TYPE dats.

    METHODS getOverlappingCustomizingCount
        RETURNING value(count) TYPE i.

    METHODS getFindingInterval
        CHANGING
            minDate TYPE dats
            maxDate TYPE dats.

    METHODS getMinAndMaxDates
        CHANGING
            validFromMin TYPE dats
            validFromMax TYPE dats
            validtoMin   TYPE dats
            validToMax   TYPE dats.

ENDCLASS.



CLASS ZCL_DATE_VALIDATOR_FIRST_LEVEL IMPLEMENTATION.

  METHOD CONSTRUCTOR.

    me->draftTableName = draftTableName.
    me->groupIDName = groupIDName.
    me->keyName = keyName.
    me->checkClassName = checkClassName.
    me->linesCount = linesCount.

  ENDMETHOD.

  METHOD CHANGEPARAMETERS.

    me->key = key.
    me->groupID = groupID.
    me->validFrom = validFrom.
    me->validto = validto.

  ENDMETHOD.

  METHOD validateDates.

        DATA: lv_valid_from_maxdate TYPE dats,
              lv_valid_from_mindate TYPE dats,
              lv_valid_to_maxdate   TYPE dats,
              lv_valid_to_mindate   TYPE dats.

        me->getMinAndMaxDates( CHANGING
                                validfrommin = lv_valid_from_mindate
                                validfrommax = lv_valid_from_maxdate
                                validtomin   = lv_valid_to_mindate
                                validtomax   = lv_valid_to_maxdate ).

        """"""""""""""""""""""""""""CHECKS""""""""""""""""""""""""""""""""""

        "@TODO: Check if there is a check with the same id, that has the same valid from/to

        IF me->validto > lv_valid_to_maxdate AND lv_valid_to_maxdate IS NOT INITIAL.
            "Begindate after findings-creation (min)
            message = new_message( id       = 'Z_CHECKS_CSTM_MSG'
                                   number   = 001
                                   v1       = me->validto
                                   v2       = lv_valid_to_maxdate
                                   severity = if_abap_behv_message=>severity-error ).

        ENDIF.

        IF me->validto < lv_valid_to_mindate AND lv_valid_to_mindate IS NOT INITIAL.
            "Enddate before findings-creation (max)
            message = new_message( id       = 'Z_CHECKS_CSTM_MSG'
                                   number   = 002
                                   v1       = me->validto
                                   v2       = lv_valid_to_mindate
                                   severity = if_abap_behv_message=>severity-error ).

        ENDIF.

        IF me->validfrom > lv_valid_from_maxdate AND lv_valid_from_maxdate IS NOT INITIAL.
            "Begindate after findings-creation (min)
            message = new_message( id       = 'Z_CHECKS_CSTM_MSG'
                                   number   = 003
                                   v1       = me->validfrom
                                   v2       = lv_valid_from_maxdate
                                   severity = if_abap_behv_message=>severity-error ).

        ENDIF.

        IF me->validfrom < lv_valid_from_mindate AND lv_valid_from_mindate IS NOT INITIAL.
            "Enddate before findings-creation (max)
            message = new_message( id       = 'Z_CHECKS_CSTM_MSG'
                                   number   = 004
                                   v1       = me->validfrom
                                   v2       = lv_valid_from_mindate
                                   severity = if_abap_behv_message=>severity-error ).

        ENDIF.

        IF me->getOverlappingCustomizingCount(  ) > 0.

            message = new_message( id       = 'Z_CHECKS_CSTM_MSG'
                                   number   = 005
                                   v1       = me->validfrom
                                   v2       = me->validfrom
                                   severity = if_abap_behv_message=>severity-error ).

        ENDIF.
        """"""""""""""""""""""""""""CHECKS""""""""""""""""""""""""""""""""""

  ENDMETHOD.

  METHOD getOverlappingCustomizingCount.
    CONCATENATE me->groupIDName ' = '''  me->groupID
                    ''' AND ' me->keyName ' <> ''' me->key ''''
                    INTO DATA(lv_where_condition) RESPECTING BLANKS.

        SELECT COUNT( * )
            FROM  (draftTableName) "zics_data_exist
            WHERE (lv_where_condition)
              AND
                ( validfrom BETWEEN @me->validfrom AND @me->validto    "Customizings überlappen
                  OR validto BETWEEN @me->validfrom AND @me->validto
                  OR
                  ( validfrom > @me->validfrom                                            "neues Customizing umfasst altes komplett
                  AND validto < @me->validto )
                  OR
                  ( validfrom < @me->validfrom                                            "altes Customizing umfasst neues komplett
                  AND validto > @me->validto )
                )
            INTO @count.

  ENDMETHOD.

  METHOD getFindingInterval.

    DATA: lv_maxDate_tmp TYPE zics_protocols-created_at,
          lv_minDate_tmp TYPE zics_protocols-created_at.

        DATA(lv_key) = CONV sysuuid_x16( me->key ).

        "Mindestdatum für Valid to (Höchstes Checkdatum)
        SELECT MAX( created_at )
            FROM zics_protocols
            WHERE checkclass = @me->checkClassName
              AND findingkey = @lv_key
            INTO @lv_maxDate_tmp.

        CONVERT TIME STAMP lv_maxDate_tmp
            TIME ZONE cl_abap_context_info=>get_user_time_zone( )
            INTO DATE maxDate.

        "Mindestdatum für Valid from (Niedrigstes Checkdatum)
        SELECT MIN( created_at )
            FROM zics_protocols
            WHERE checkclass = @me->checkClassName
              AND findingkey = @lv_key
            INTO @lv_minDate_tmp.

        CONVERT TIME STAMP lv_minDate_tmp
            TIME ZONE cl_abap_context_info=>get_user_time_zone( )
            INTO DATE minDate.

  ENDMETHOD.

  METHOD NEW_MESSAGE.
    obj = new lcl_abap_behv_msg(
    textid = value #(
               msgid = id
               msgno = number
               attr1 = cond #( when v1 is not initial then 'IF_T100_DYN_MSG~MSGV1' )
               attr2 = cond #( when v2 is not initial then 'IF_T100_DYN_MSG~MSGV2' )
               attr3 = cond #( when v3 is not initial then 'IF_T100_DYN_MSG~MSGV3' )
               attr4 = cond #( when v4 is not initial then 'IF_T100_DYN_MSG~MSGV4' )
    )
    msgty = 'E'
*    msgty = switch #( severity
*              WHEN ms-error       then 'E'
*              when ms-WARNING     then 'W'
*              when ms-INFORMATION then 'I'
*              when ms-SUCCESS     then 'S' )
    msgv1 = |{ v1 }|
    msgv2 = |{ v2 }|
    msgv3 = |{ v3 }|
    msgv4 = |{ v4 }|
    ).

    obj->m_severity = severity.
  ENDMETHOD.

  METHOD GETMINANDMAXDATES.

    DATA: lv_minDateInFindings TYPE dats,
          lv_maxDateInFindings TYPE dats.

        me->getFindingInterval( CHANGING mindate = lv_minDateInFindings maxdate = lv_maxDateInFindings ).

    IF me->linesCount = 2.
        IF lv_minDateInFindings IS INITIAL.
            lv_minDateInFindings = me->lastmindateinfindings.
        ENDIF.
        IF lv_maxDateInFindings IS INITIAL.
            lv_maxDateInFindings = me->lastmaxdateinfindings.
        ENDIF.
        IF ValidTo < '99991231'.
            validFromMin = '18000101'.
            validFromMax = lv_minDateInFindings.

            validToMin = lv_maxDateInFindings.
            validToMax = '99991231'.
        ELSE.
            validFromMin = lv_maxDateInFindings + 1.
            validFromMax = me->validto.

            validToMin = me->validfrom.
            validToMax = '99991231'.
        ENDIF.
        me->lastmindateinfindings = lv_minDateInFindings.
        me->lastmaxdateinfindings = lv_maxDateInFindings.
    ElSE.
        validFromMin = '18000101'.
        validToMax = '99991231'.
        validFromMax = me->validto.
        validToMin = me->validfrom.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
