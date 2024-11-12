CLASS lhc_text DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Text RESULT result.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
          IMPORTING keys REQUEST requested_authorizations FOR Text RESULT result.
    METHODS translate FOR MODIFY
      IMPORTING keys FOR ACTION Text~translate.

ENDCLASS.

CLASS lhc_text IMPLEMENTATION.

  METHOD translate.

    DATA: lt_translations TYPE STANDARD TABLE OF ycl_cds_function=>ty_translations WITH DEFAULT KEY,
          ls_translation LIKE LINE OF lt_translations,
          lv_target_language TYPE string.

    "Just single select possible by app
    READ TABLE keys INDEX 1 INTO DATA(key).

    READ ENTITIES OF zi_ics_data_existance
        ENTITY DatasetExistanceCheck
        BY \_Text
        ALL FIELDS WITH VALUE #( ( %key-mykey = key-DataExistanceUUID ) )
        RESULT DATA(lt_texts)
        FAILED DATA(lt_failed).

    "Language field is a key field (this works like a SELECT SINGLE)
    READ TABLE lt_texts WITH KEY DataExistanceLanguage = key-DataExistanceLanguage INTO DATA(ls_pre_translation).

    ls_translation-translation_index = 1.
    ls_translation-pre_translation = ls_pre_translation-DataExistanceDescription.
    APPEND ls_translation TO lt_translations.

    CLEAR: ls_translation.
    ls_translation-translation_index = 2.
    ls_translation-pre_translation = ls_pre_translation-DataExistanceLongDescription.
    APPEND ls_translation TO lt_translations.

    lv_target_language = key-%param-new_language.

    ycl_cds_function=>TRANSLATE_TEXTS( EXPORTING iv_target_lang = lv_target_language CHANGING ct_translations = lt_translations ).

    READ TABLE lt_translations WITH KEY translation_index = 1 INTO DATA(ls_short_description_transl).
    READ TABLE lt_translations WITH KEY translation_index = 2 INTO DATA(ls_long_description_transl).

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
                ENTITY DatasetExistanceCheck
                CREATE BY  \_Text
                FROM VALUE #( ( mykey = key-DataExistanceUUID
                %is_draft = '01'
                %target = VALUE #( ( %cid = 'CID_DUMMY'
                                     DataExistanceUUID              = key-DataExistanceUUID
                                     DataExistanceLanguage          = lv_target_language
                                     DataExistanceDescription       = ls_short_description_transl-post_translation
                                     DataExistanceLongDescription   = ls_long_description_transl-post_translation
                                     %is_draft                      = '01'
                                     %control = VALUE #(
                                         DataExistanceUUID              = if_abap_behv=>mk-on
                                         DataExistanceLanguage          = if_abap_behv=>mk-on
                                         DataExistanceDescription       = if_abap_behv=>mk-on
                                         DataExistanceLongDescription   = if_abap_behv=>mk-on
                                     )
                                   )
                                 )
                            ) )
                MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).

  ENDMETHOD.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(key).
      APPEND VALUE #(
           %tky = key-%tky
           %action-translate      = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>perm-o-unauthorized )
           ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.

    LOOP AT keys INTO DATA(key).
      APPEND VALUE #(
           %tky = key-%tky
           %action-translate      = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
                     ) TO result.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.


CLASS lhc_DataExistanceCheck DEFINITION CREATE PRIVATE
    INHERITING FROM cl_abap_behavior_handler.

    PRIVATE SECTION.

        METHODS precheck_update FOR PRECHECK
            IMPORTING entities FOR UPDATE DatasetExistanceCheck.

        METHODS precheck_create FOR PRECHECK
          IMPORTING entities FOR CREATE datasetexistancecheck.

        METHODS precheck_delete FOR PRECHECK
          IMPORTING entities FOR DELETE datasetexistancecheck.

        METHODS get_instance_features FOR INSTANCE FEATURES
            IMPORTING keys REQUEST requested_features FOR DatasetExistanceCheck
            RESULT result.

        METHODS delimitentry FOR MODIFY
           IMPORTING keys FOR ACTION datasetexistancecheck~delimitentry.

        METHODS validatedates FOR VALIDATE ON SAVE
          IMPORTING keys FOR datasetexistancecheck~validatedates.

        METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
          IMPORTING keys REQUEST requested_authorizations FOR datasetexistancecheck RESULT result.

        METHODS setDefaultValues FOR DETERMINE ON MODIFY
          IMPORTING keys FOR datasetexistancecheck~setDefaultValues.

        METHODS isCheckInFindings
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(inFindings) TYPE abap_boolean.

        METHODS checkAlreadyGotProcessed
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(gotProcessed) TYPE abap_boolean.

        METHODS hasCheckNewerVersion
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(hasNewerVersion) TYPE abap_boolean.

        METHODS getNextFindingID
            RETURNING VALUE(findingID) TYPE z_finding_id.

ENDCLASS.

CLASS lhc_DataExistanceCheck IMPLEMENTATION.

METHOD precheck_update.
    "Implement check
ENDMETHOD.

  METHOD precheck_create.
"Option 1: Direkt starten
"Problem: evtl. längere Verzögerung durch Abfrage
*    DATA: s_langu TYPE ZCL_DATASET_GRABBER=>ty_range_langu.
*
*    APPEND VALUE #( sign   = 'I'
*                    option = 'EQ'
*                    low    = 'D' ) TO s_langu.
*
*    APPEND VALUE #( sign   = 'I'
*                    option = 'EQ'
*                    low    = 'E' ) TO s_langu.
*
*    ZCL_DATASET_GRABBER=>GET_DATASETS_FOR_ALL_DEST( s_langu ).

"Option 2: Direkt im Hintergrund starten
"Problem: Geht nicht
*    DATA(new) = NEW ZCL_DATASET_GRABBER(  ).
*
*    DATA background_process TYPE REF TO if_bgmc_process_single_op.
*
*    TRY.
*        background_process = cl_bgmc_process_factory=>get_default(  )->create(  ).
**        background_process->set_operation( new ).
*        background_process->set_operation_tx_uncontrolled( new ).
*        background_process->save_for_execution(  ).
*        "COMMIT WORK. "not needed in RAP since the framework will do that for you
*
*      CATCH cx_bgmc INTO DATA(exception).
*        "handle exception
*    ENDTRY.

"Option 3: Event schmeißen und starten
"Problem: Geht nicht
*    RAISE ENTITY EVENT zi_ics_data_existance~scheduleDatasetGrabber
*        FROM VALUE #( ( %key-mykey = 'abc' ) ).

"Option 4: Job einplanen und starten
"Problem: Zu Asynchron
*    ZCL_DATASET_GRABBER=>SCHEDULE_DATASET_GRABBER(  ).

  ENDMETHOD.

  METHOD precheck_delete.
    "Implement check
  ENDMETHOD.

  METHOD isCheckInFindings.
    DATA: lt_findings TYPE STANDARD TABLE OF zics_protocols.
    SELECT *
        FROM zics_protocols
        WHERE FINDINGKEY = @key
          AND CHECKCLASS = 'DataExistenceCheck'
        INTO TABLE @lt_findings.
    IF sy-subrc = 4.
        inFindings = abap_false.
    ELSE.
        inFindings = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD hasCheckNewerVersion.


    DATA: lv_next_from TYPE z_valid_to,
          lv_dummy_key TYPE sysuuid_x16.

    DATA: ls_zics_data_exist TYPE zics_data_exist.

    SELECT SINGLE *
        FROM zics_data_exist
            WHERE mykey = @key
            INTO @ls_zics_data_exist.

    lv_next_from =  ls_zics_data_exist-validto + 1.

    SELECT SINGLE mykey
        FROM zics_data_exist
            WHERE findingid = @ls_zics_data_exist-findingid
              AND mykey <> @ls_zics_data_exist-mykey
              AND validfrom = @lv_next_from
            INTO @lv_dummy_key.

    IF sy-subrc = 4.
        hasNewerVersion = abap_false.
    ELSE.
        hasNewerVersion = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD checkAlreadyGotProcessed.

    DATA: ls_zics_data_exist TYPE zics_data_exist.

    SELECT SINGLE *
        FROM zics_data_exist
            WHERE mykey = @key
            INTO @ls_zics_data_exist.

    "@TODO: nicht gegen systemdatum prüfen sondern gegen zuletzt tatsächlich durchgeführten Lauf
    IF ls_zics_data_exist-last_check IS NOT INITIAL.
        gotProcessed = abap_true.
    ELSE.
        gotProcessed = abap_false.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY zi_ics_data_existance FROM VALUE #( FOR keyval IN keys
                                                    (  %key           = keyval-%key
                                                       %control-mykey = if_abap_behv=>mk-on
                                                    )
                                                  )
                            RESULT DATA(lt_existanceChecks_result).

    DATA: lv_findingid TYPE z_finding_id.
    LOOP AT lt_existanceChecks_result ASSIGNING FIELD-SYMBOL(<fs_existanceChecks_result>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      <fs_result> = CORRESPONDING #( <fs_existanceChecks_result> ).

      "DelimitEntry nur anzeigen, wenn noch kein Nachfolgesatz existiert
    "Edit nur, wenn noch keine Prüfungen mit dem Customizing durchgeführt wurden
      IF me->isCheckInFindings( <fs_existanceChecks_result>-mykey ) = abap_true
         OR me->checkAlreadyGotProcessed( <fs_existanceChecks_result>-mykey ) = abap_true
           .
        <fs_result>-%features-%update = if_abap_behv=>fc-o-disabled.
        <fs_result>-%action-Edit = if_abap_behv=>fc-o-disabled.
        <fs_result>-%features-%delete = if_abap_behv=>fc-o-disabled.

        lv_findingid = <fs_existanceChecks_result>-findingid.
        IF me->hasCheckNewerVersion( <fs_existanceChecks_result>-mykey ) = abap_true.
            <fs_result>-%features-%action-delimitEntry  = if_abap_behv=>fc-o-disabled.
        ELSE.
            <fs_result>-%features-%action-delimitEntry  = if_abap_behv=>fc-o-enabled.
        ENDIF.

      ELSE.
        <fs_result>-%features-%update = if_abap_behv=>fc-o-enabled.
        <fs_result>-%action-Edit = if_abap_behv=>fc-o-enabled.
        <fs_result>-%features-%delete = if_abap_behv=>fc-o-enabled.
        <fs_result>-%features-%action-delimitEntry  = if_abap_behv=>fc-o-disabled.

      ENDIF.

    ENDLOOP.

*    result = VALUE #( FOR ls_existanceCheck IN lt_existanceChecks_result
*                      ( %key                           = ls_existanceCheck-%key
*                        %features-%update              = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-o-disabled
*                                                                    ELSE if_abap_behv=>fc-o-enabled
*                                                               )
*                        %features-%delete              = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-o-disabled
*                                                                    ELSE if_abap_behv=>fc-o-enabled
*                                                               )
*                        %features-%action-delimitEntry = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-o-enabled
*                                                                    ELSE if_abap_behv=>fc-o-disabled
*                                                               )
*                        %field-dataset               = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-f-read_only
*                                                                    ELSE if_abap_behv=>fc-f-mandatory
*                                                               )
*                        %field-systemtype            = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-f-read_only
*                                                                    ELSE if_abap_behv=>fc-f-mandatory
*                                                               )
*                       %field-validfrom               = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-f-read_only
*                                                                    ELSE if_abap_behv=>fc-f-mandatory
*                                                               )
*                       %field-validto               = COND #( WHEN me->isCheckInFindings( ls_existanceCheck-mykey )
*                                                                    THEN if_abap_behv=>fc-f-read_only
*                                                                    ELSE if_abap_behv=>fc-f-mandatory
*                                                               )
*                       )
*                     ).

  ENDMETHOD.

  METHOD delimitEntry.

    DATA: lt_dataExistanceCheck TYPE TABLE FOR CREATE ZI_ICS_DATA_EXISTANCE.

    DATA: lv_date TYPE dats.

    "Delimit selected entry
    lv_date = keys[ 1 ]-%param-new_delimitation.

    MODIFY ENTITIES OF zi_ics_data_existance IN LOCAL MODE
                ENTITY DatasetExistanceCheck
                   UPDATE FROM VALUE #( FOR key IN keys (
                                           mykey                    = key-mykey
                                           validto                  = lv_date               "Update valid_to
                                           last_changed_at          = cl_abap_context_info=>get_system_date( )
                                           last_changed_by          = cl_abap_context_info=>get_user_technical_name( )
                                           %control-validto         = if_abap_behv=>mk-on
                                           %control-last_changed_at = if_abap_behv=>mk-on
                                           %control-last_changed_by = if_abap_behv=>mk-on
                                         )
                                      )
                FAILED   failed
                REPORTED reported.

    "Duplicate old entry
    READ ENTITIES OF ZI_ICS_DATA_EXISTANCE IN LOCAL MODE
        ENTITY DatasetExistanceCheck
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(dataExistanceChecks)
        FAILED failed.


    LOOP AT dataExistanceChecks ASSIGNING FIELD-SYMBOL(<lfs_dataExistanceCheck>).

        <lfs_dataExistanceCheck>-validfrom = lv_date + 1.
        <lfs_dataExistanceCheck>-validto = '99991231'.

        APPEND VALUE #( %cid = keys[ KEY entity %key = <lfs_dataExistanceCheck>-%key ]-%cid
                        %data = CORRESPONDING #( <lfs_dataExistanceCheck> EXCEPT mykey )
                      ) TO lt_dataExistanceCheck ASSIGNING FIELD-SYMBOL(<lfs_newDataExistanceCheck>).

    ENDLOOP.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE IN LOCAL MODE
        ENTITY DatasetExistanceCheck
        CREATE FIELDS ( findingid validfrom validto categoryid findingtypeid destination featureid dataset
                        checktype useinlinkedcheck description language created_by created_at
                        last_changed_by last_changed_at )
        WITH lt_dataExistanceCheck
        FAILED DATA(failed_dataExistance_create)
        MAPPED DATA(mapped_dataExistance_create).

    mapped-datasetexistancecheck = mapped_dataExistance_create-datasetexistancecheck.

    "Duplicate old entrys texts
    DATA: dataExistanceCheckTexts TYPE STANDARD TABLE OF zics_dataexisttx.

    DATA(key1) = keys[ 1 ].
    SELECT * FROM zics_dataexisttx
        WHERE mykey = @key1-mykey
        INTO TABLE @dataExistanceCheckTexts.

    LOOP AT mapped_dataExistance_create-datasetexistancecheck ASSIGNING FIELD-SYMBOL(<lfs_mapped_create_dataExist>).
        LOOP AT dataExistanceCheckTexts INTO DATA(dataExistanceCheckText).

            MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE IN LOCAL MODE
                ENTITY DatasetExistanceCheck
                CREATE BY  \_Text
                FROM VALUE #( ( mykey = <lfs_mapped_create_dataExist>-mykey
                %target = VALUE #( ( %cid = 'CID_DUMMY'
                                     DataExistanceUUID              = <lfs_mapped_create_dataExist>-mykey
                                     DataExistanceLanguage          = dataExistanceCheckText-language
                                     DataExistanceDescription       = dataExistanceCheckText-dataexist_desc
                                     DataExistanceLongDescription   = dataExistanceCheckText-dataexist_long_desc
                                     %control = VALUE #(
                                         DataExistanceUUID = if_abap_behv=>mk-on
                                         DataExistanceLanguage = if_abap_behv=>mk-on
                                         DataExistanceDescription = if_abap_behv=>mk-on
                                         DataExistanceLongDescription = if_abap_behv=>mk-on
                                     )
                                   )
                                 )
                            ) )
                MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).

        ENDLOOP.
     ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

*     xco_cp_abap_dictionary=>database_table

*    SELECT * FROM dd03l
*        WHERE fieldname = 'featureid'
*        INTO TABLE @DATA(lt_featureids).

    READ ENTITY zi_ics_data_existance\\DatasetExistanceCheck
        FROM VALUE #(
        FOR <root_key> IN keys ( %key-mykey = <root_key>-mykey
                                 %control   = VALUE #( findingid = if_abap_behv=>mk-on
                                                       validfrom = if_abap_behv=>mk-on
                                                       validto   = if_abap_behv=>mk-on )
                               )
        )
        RESULT DATA(lt_dataExistanceResult).

    DATA: lo_dateValidator               TYPE REF TO zcl_shared_behavior,
          lv_key                         TYPE string,
          lv_groupID                     TYPE string,
          lv_where_cond_finding_interval TYPE string,
          lv_where_cond_overlap_cust     TYPE string.

    CREATE OBJECT lo_dateValidator
            EXPORTING
                draftTableName    = 'ZI_ICS_DATA_EXISTANCE'
                linesCount        = LINES( lt_dataExistanceResult ).

    "---- start new
    LOOP AT lt_dataExistanceResult INTO DATA(ls_dataExistanceResult).

        lv_key = CONV string( ls_dataExistanceResult-mykey ).
        lv_groupID = CONV string( ls_dataExistanceResult-findingid ).

        CONCATENATE 'findingkey = ''' lv_key ''' AND checkclass = ''DataExistenceCheck'''
                    INTO lv_where_cond_finding_interval RESPECTING BLANKS.

        CONCATENATE 'findingid = ''' lv_groupID ''' AND mykey <> ''' lv_key ''''
                    INTO lv_where_cond_overlap_cust RESPECTING BLANKS.

        lo_dateValidator->changeparameters(
                whereconditionfindinginterval = lv_where_cond_finding_interval
                whereconditionoverlappcust    = lv_where_cond_overlap_cust
                validFrom                     = ls_dataExistanceResult-validfrom
                validto                       = ls_dataExistanceResult-validto
        ).

        DATA(error_message) = lo_dateValidator->validatedates( ).

        IF error_message IS NOT INITIAL.
            APPEND VALUE #( %key        = ls_dataExistanceResult-%key
                            mykey       = ls_dataExistanceResult-mykey ) TO failed-datasetexistancecheck.

            APPEND VALUE #( %key     = ls_dataExistanceResult-%key
                            %msg     = error_message

                            %element-validfrom = if_abap_behv=>mk-on
                            %element-validto   = if_abap_behv=>mk-on ) TO reported-datasetexistancecheck.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_authorizations.



  ENDMETHOD.

  METHOD setDefaultValues.

    READ ENTITIES OF zi_ics_data_existance IN LOCAL MODE
      ENTITY DatasetExistanceCheck
        FIELDS ( validfrom validto findingid )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_dataExCheck).

    MODIFY ENTITIES OF zi_ics_data_existance IN LOCAL MODE
    ENTITY DatasetExistanceCheck
      UPDATE FIELDS ( validfrom validto findingid )
      WITH VALUE #( FOR ls_dataExCheck IN lt_dataExCheck (
                         %key      = ls_dataExCheck-%key
                         %is_draft = ls_dataExCheck-%is_draft
                         findingid  = COND #( WHEN ls_dataExCheck-findingid IS INITIAL
                                                                    THEN me->getnextfindingid( )
                                                                    ELSE ls_dataExCheck-findingid
                                                               )
                         validfrom  = COND #( WHEN ls_dataExCheck-validfrom IS INITIAL
                                                                    THEN cl_abap_context_info=>get_system_date( )
                                                                    ELSE ls_dataExCheck-validfrom
                                                               )


                         validto = COND #( WHEN ls_dataExCheck-validto IS INITIAL
                                                                    THEN '99991231'
                                                                    ELSE ls_dataExCheck-validto
                                                               )
                          ) )
  REPORTED DATA(lt_reported).

  ENDMETHOD.

  METHOD getnextfindingid.
    SELECT MAX( Findingid )
        FROM  zics_data_exist
        INTO @DATA(lv_highest_findingid).

    IF sy-subrc = 4.
        findingID = 1.
    ELSE.
        findingID = lv_highest_findingid + 1.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
