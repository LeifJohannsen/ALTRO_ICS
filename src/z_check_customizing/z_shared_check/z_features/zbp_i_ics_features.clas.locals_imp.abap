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

  METHOD translate.

    DATA: lt_translations TYPE STANDARD TABLE OF ycl_cds_function=>ty_translations WITH DEFAULT KEY,
          ls_translation LIKE LINE OF lt_translations,
          lv_target_language TYPE string.

    "Just single select possible by app
    READ TABLE keys INDEX 1 INTO DATA(key).

    READ ENTITIES OF zi_ics_features
        ENTITY feature
        BY \_Text
        ALL FIELDS WITH VALUE #( ( %key-Id = key-Id ) )
        RESULT DATA(lt_texts)
        FAILED DATA(lt_failed).

    "Language field is a key field (this works like a SELECT SINGLE)
    READ TABLE lt_texts WITH KEY Language = key-Language INTO DATA(ls_pre_translation).

    ls_translation-translation_index = 1.
    ls_translation-pre_translation = ls_pre_translation-feature_desc.
    APPEND ls_translation TO lt_translations.

    CLEAR: ls_translation.
    ls_translation-translation_index = 2.
    ls_translation-pre_translation = ls_pre_translation-feature_long_desc.
    APPEND ls_translation TO lt_translations.

    lv_target_language = key-%param-new_language.

    ycl_cds_function=>TRANSLATE_TEXTS( EXPORTING iv_target_lang = lv_target_language CHANGING ct_translations = lt_translations ).

    READ TABLE lt_translations WITH KEY translation_index = 1 INTO DATA(ls_short_description_transl).
    READ TABLE lt_translations WITH KEY translation_index = 2 INTO DATA(ls_long_description_transl).

    MODIFY ENTITIES OF ZI_ICS_FEATURES
                ENTITY feature
                CREATE BY  \_Text
                FROM VALUE #( ( Id = key-Id
                %is_draft = '01'
                %target = VALUE #( ( %cid = 'CID_DUMMY'
                                     Id                             = key-Id
                                     Language                       = lv_target_language
                                     feature_desc                   = ls_short_description_transl-post_translation
                                     feature_long_desc              = ls_long_description_transl-post_translation
                                     %is_draft                      = '01'
                                     %control = VALUE #(
                                         Id                             = if_abap_behv=>mk-on
                                         Language                       = if_abap_behv=>mk-on
                                         feature_desc                   = if_abap_behv=>mk-on
                                         feature_long_desc              = if_abap_behv=>mk-on
                                     )
                                   )
                                 )
                            ) )
                MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).


  ENDMETHOD.

ENDCLASS.

CLASS lhc_expression DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.

    constants:
    "! Constants for line number calculation
    begin of lnc,
      "! to determine create before action
      before type ABP_BEHV_FLAG value '00',
      "! to determine create after action
      after  type ABP_BEHV_FLAG value '01',
    end of lnc.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
          IMPORTING keys REQUEST requested_authorizations FOR Expression RESULT result.
    METHODS create_before FOR MODIFY
      IMPORTING keys FOR ACTION expression~create_before RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR expression RESULT result.
    METHODS create_after FOR MODIFY
      IMPORTING keys FOR ACTION expression~create_after RESULT result.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE expression.
    METHODS validateexpressionconjunctions FOR VALIDATE ON SAVE
      IMPORTING keys FOR expression~validateexpressionconjunctions.

    METHODS validateexpressionparenthesis FOR VALIDATE ON SAVE
      IMPORTING keys FOR expression~validateexpressionparenthesis.
    CLASS-METHODS get_line_number
        IMPORTING id                    TYPE sysuuid_x16
                  exp_id                TYPE sysuuid_x16
                  before_or_after       TYPE ABP_BEHV_FLAG
        RETURNING VALUE(rv_line_number) TYPE int8.

ENDCLASS.

CLASS lhc_expression IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(key).
      APPEND VALUE #(
           %tky = key-%tky
           %action-create_before      = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>perm-o-unauthorized )
           %action-create_after       = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>perm-o-unauthorized )
                     ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_before.

    LOOP AT keys INTO DATA(key).

        DATA(lv_line_number) = lhc_expression=>get_line_number( before_or_after = lhc_expression=>lnc-before id = key-Id exp_id = key-Exp_ID ).

        MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
                    ENTITY feature
                    CREATE BY  \_Expression
                    FROM VALUE #( ( id = key-Id
                    %is_draft = key-%is_draft
                    %target = VALUE #( ( %cid = 'Expression'
                                         %is_draft = key-%is_draft
                                         line = lv_line_number
                                         %control = VALUE #(
                                             line = if_abap_behv=>mk-on
                                         )
                                       )
                                     )
                                ) )
                    MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).
    ENDLOOP.

  ENDMETHOD.

  METHOD create_after.

    LOOP AT keys INTO DATA(key).

        DATA(lv_line_number) = lhc_expression=>get_line_number( before_or_after = lhc_expression=>lnc-after id = key-Id exp_id = key-Exp_ID ).

        MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
                    ENTITY feature
                    CREATE BY  \_Expression
                    FROM VALUE #( ( id = key-Id
                    %is_draft = key-%is_draft
                    %target = VALUE #( ( %cid = 'Expression'
                                         %is_draft = key-%is_draft
                                         line = lv_line_number
                                         %control = VALUE #(
                                             line = if_abap_behv=>mk-on
                                         )
                                       )
                                     )
                                ) )
                    MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).
    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    LOOP AT keys INTO DATA(key).
      APPEND VALUE #(
           %tky = key-%tky
           %action-create_before      = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
           %action-create_after       = COND #( WHEN key-%is_draft = if_abap_behv=>mk-on
                                                            THEN if_abap_behv=>fc-o-enabled
                                                            ELSE if_abap_behv=>fc-o-disabled )
                     ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_line_number.
    DATA: lv_line_number            TYPE int8,
          lv_max_before_line_number TYPE int8,
          lv_min_after_line_number  TYPE int8,
          lv_line_difference        TYPE int8.

    lv_line_number = 0.

    SELECT SINGLE line FROM ZDB_FEATURE_E_D
        WHERE
            id = @id AND
            exp_id = @exp_id
        INTO @lv_line_number.

    CASE before_or_after.
        WHEN lhc_expression=>lnc-before.
            SELECT MAX( line ) FROM ZDB_FEATURE_E_D
                WHERE
                    id = @id AND
                    line < @lv_line_number
                INTO @lv_max_before_line_number.

            lv_line_difference = ( ( lv_line_number - lv_max_before_line_number ) / 2 ) * -1.
        WHEN lhc_expression=>lnc-after.
            SELECT MIN( line ) FROM ZDB_FEATURE_E_D
                WHERE
                    id = @id AND
                    line > @lv_line_number
                INTO @lv_min_after_line_number.

            if lv_min_after_line_number IS INITIAL.
                "Last entry selected
                lv_line_difference = 1000.
            ELSE.
                "Not last entry selected
                lv_line_difference = ( lv_min_after_line_number - lv_line_number ) / 2.
            ENDIF.
    ENDCASE.

    IF lv_line_difference IS NOT INITIAL.
        rv_line_number = lv_line_number + lv_line_difference.
    ENDIF.

  ENDMETHOD.

  METHOD precheck_update.

    READ TABLE entities INDEX 1 INTO DATA(expression).

    READ ENTITIES OF zc_ics_features
        ENTITY feature
        BY \_Expression
        ALL FIELDS WITH VALUE #( ( %tky-Id = expression-Id %is_draft ='01' ) )
        RESULT DATA(lt_expressions)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

    READ TABLE lt_expressions WITH KEY Exp_ID = expression-Exp_ID ASSIGNING FIELD-SYMBOL(<fs_current_expression>). "INTO DATA(current_expression).

    MOVE-CORRESPONDING expression TO <fs_current_expression>.

    DATA: lv_parenthesis TYPE string.

    IF expression-Left_Parenthesis IS NOT INITIAL.

        lv_parenthesis = expression-Left_Parenthesis.

        IF lv_parenthesis CN '('.

            APPEND VALUE #( %key = expression-%key
                              %update = if_abap_behv=>mk-on ) TO failed-expression.
              APPEND VALUE #( %key = expression-%key
                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text = 'Only ''('' allowed.' )
                              %update = if_abap_behv=>mk-on
                              %element-Left_Parenthesis = if_abap_behv=>mk-on
                             ) TO reported-expression.

         ENDIF.

    ENDIF.

    IF expression-Right_Parenthesis IS NOT INITIAL.

        lv_parenthesis = expression-Right_Parenthesis.

        IF lv_parenthesis CN ')'.

            APPEND VALUE #( %key = expression-%key
                              %update = if_abap_behv=>mk-on ) TO failed-expression.
              APPEND VALUE #( %key = expression-%key
                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text = 'Only '')'' allowed.' )
                              %update = if_abap_behv=>mk-on
                              %element-Right_Parenthesis = if_abap_behv=>mk-on
                             ) TO reported-expression.

         ENDIF.

    ENDIF.

*    IF expression-Conjunction IS INITIAL.
*
*            APPEND VALUE #( %key = expression-%key
*                              %update = if_abap_behv=>mk-on ) TO failed-expression.
*            APPEND VALUE #( %key = expression-%key
*                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                                            text = 'There has to be a conjunction.' )
*                              %update = if_abap_behv=>mk-on
*                              %element-conjunction = if_abap_behv=>mk-on
*                             ) TO reported-expression.
*
*    ENDIF.

  ENDMETHOD.

  METHOD validateExpressionConjunctions.

    "READ TABLE keys INDEX 1 INTO DATA(expression).

    READ ENTITIES OF zc_ics_features
        ENTITY feature
        BY \_Expression
        FIELDS ( line conjunction )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_expressions)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

    SORT lt_expressions BY Line DESCENDING.

    LOOP AT lt_expressions INTO DATA(ls_expression).

        IF ls_expression-Conjunction IS INITIAL AND sy-tabix NE 1.

            APPEND VALUE #( %key = ls_expression-%key
                            %update = if_abap_behv=>mk-on
                          ) TO failed-expression.

            APPEND VALUE #( %key = ls_expression-%key
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                              text = 'There has to be a conjunction in every line (except the last one).' )
                            %update = if_abap_behv=>mk-on
                            %element-conjunction = if_abap_behv=>mk-on
                          ) TO reported-expression.

        ENDIF.

    ENDLOOP.


  ENDMETHOD.

  METHOD validateExpressionParenthesis.

    READ TABLE keys INDEX 1 INTO DATA(expression).

    READ ENTITIES OF zc_ics_features
        ENTITY feature
        BY \_Expression
        ALL FIELDS WITH VALUE #( ( %tky-Id = expression-Id %is_draft ='00' ) )
        RESULT DATA(lt_expressions)
        FAILED DATA(lt_failed)
        REPORTED DATA(lt_reported).

    DATA: left_parenthesis_len TYPE n,
          right_parenthesis_len TYPE n.

    LOOP AT lt_expressions INTO DATA(ls_expression).

        left_parenthesis_len = left_parenthesis_len + strlen( ls_expression-Left_Parenthesis ).
        right_parenthesis_len = right_parenthesis_len + strlen( ls_expression-Right_Parenthesis ).

    ENDLOOP.


    IF left_parenthesis_len <> right_parenthesis_len.

        APPEND VALUE #( %key = expression-%key
                        %update = if_abap_behv=>mk-on ) TO failed-expression.

        APPEND VALUE #( %key = expression-%key
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Unequal number of parenthesises.' )
                        %update = if_abap_behv=>mk-on
                        %element-Right_parenthesis = if_abap_behv=>mk-on
                      ) TO reported-expression.

    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_features DEFINITION CREATE PRIVATE
    INHERITING FROM cl_abap_behavior_handler.
    PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
          IMPORTING keys REQUEST requested_authorizations FOR feature RESULT result.

    METHODS setdefaultvalues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR feature~setdefaultvalues.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR feature~validatedates.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR feature RESULT result.

    METHODS delimitentry FOR MODIFY
      IMPORTING keys FOR ACTION feature~delimitentry.

    CLASS-METHODS get_line_number
        IMPORTING parent_id             TYPE sysuuid_x16
                  id                    TYPE sysuuid_x16
                  before_or_after       TYPE string
                  is_draft              TYPE abp_behv_flag
                  internal_last_number  TYPE int8
        RETURNING VALUE(rv_line_number) TYPE int8.

    METHODS isCheckInFindings
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(inFindings) TYPE abap_boolean.

    METHODS checkAlreadyGotProcessed
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(gotProcessed) TYPE abap_boolean.

    METHODS hasCheckNewerVersion
       IMPORTING key TYPE sysuuid_x16
       RETURNING VALUE(hasNewerVersion) TYPE abap_boolean.

ENDCLASS.

CLASS lhc_features IMPLEMENTATION.

    METHOD get_instance_authorizations.


    ENDMETHOD.

*  METHOD earlynumbering_cba_Expression.
*
*    DATA: lv_number TYPE int8,
*          lv_last_number TYPE int8.
*    Data(lt_entities) = entities.
*
*    lv_last_number = -1.
*
*    LOOP AT lt_entities INTO DATA(ls_entities).
*        LOOP AT ls_entities-%target ASSIGNING FIELD-SYMBOL(<ls_account_create>).
*
**            lv_number = lhc_features=>get_next_line_number( parent_id = ls_entities-Id
**                                                            is_draft = ls_entities-%is_draft
**                                                            internal_last_number = lv_last_number ).
**            lv_last_number = lv_number.
*            APPEND VALUE #( %cid = <ls_account_create>-%cid
*                            %is_draft = ls_entities-%is_draft
*                            id = ls_entities-Id
*                            line = <ls_account_create>-Line )
**                            line = lv_number )
*                            TO mapped-expression.
*        ENDLOOP.
*    endloop.
*  ENDMETHOD.

  METHOD get_line_number.
    DATA: lv_line_number TYPE int8.

    lv_line_number = 0.

    CASE is_draft.
        WHEN '01'.
            SELECT SINGLE line FROM ZDB_FEATURE_E_D WHERE id = @parent_id INTO @lv_line_number.
        WHEN '00'.
            SELECT SINGLE line  FROM ZDB_FEATURE_EXP WHERE id = @parent_id INTO @lv_line_number.
        WHEN OTHERS.
            lv_line_number = -1.
    ENDCASE.

    lv_line_number = nmax( val1 = lv_line_number val2 = internal_last_number ).

    rv_line_number = lv_line_number + 100.
  ENDMETHOD.

  METHOD setDefaultValues.

    READ ENTITIES OF zi_ics_features IN LOCAL MODE
      ENTITY feature
        FIELDS ( validfrom validto )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_features).


    MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
    ENTITY feature
      UPDATE FIELDS ( validfrom validto )
      WITH VALUE #( FOR ls_feature IN lt_features (
                         %key      = ls_feature-%key
                         %is_draft = ls_feature-%is_draft
                         validfrom  = COND #( WHEN ls_feature-validfrom IS INITIAL
                                                                    THEN cl_abap_context_info=>get_system_date( )
                                                                    ELSE ls_feature-validfrom
                                                               )


                         validto = COND #( WHEN ls_feature-validto IS INITIAL
                                                                    THEN '99991231'
                                                                    ELSE ls_feature-validto
                                                               )
                          ) )
  REPORTED DATA(lt_reported).


  ENDMETHOD.

  METHOD validateDates.

    READ ENTITY ZI_ICS_FEATURES\\feature FROM VALUE #(
        FOR <root_key> IN keys ( %key-Id = <root_key>-Id
                                 %control   = VALUE #( FeatureID = if_abap_behv=>mk-on
                                                       validfrom = if_abap_behv=>mk-on
                                                       validto   = if_abap_behv=>mk-on )
                               )
        )
        RESULT DATA(lt_FeatureResult).

    DATA: lo_dateValidator TYPE REF TO zcl_shared_behavior,
          lv_key                         TYPE string,
          lv_groupID                     TYPE string,
          lv_where_cond_finding_interval TYPE string,
          lv_where_cond_overlap_cust     TYPE string.

    CREATE OBJECT lo_dateValidator
            EXPORTING
                draftTableName    = 'zdb_feature_h_d' "'ZI_ICS_FEATURES'
                linesCount        = LINES( lt_FeatureResult ).

    "---- start new
    LOOP AT lt_FeatureResult INTO DATA(ls_FeatureResult).

        lv_key = CONV string( ls_FeatureResult-id ).
        lv_groupID = CONV string( ls_FeatureResult-FeatureID ).

        CONCATENATE 'featureid = ''' lv_groupID ''' AND created_at >= ''' ls_FeatureResult-validFrom '000000'' AND created_at <= ''' ls_FeatureResult-validto '235959'''
                    INTO lv_where_cond_finding_interval RESPECTING BLANKS.

        CONCATENATE 'featureID = ''' lv_groupID ''' AND Id <> ''' lv_key ''''
                    INTO lv_where_cond_overlap_cust RESPECTING BLANKS.

        lo_dateValidator->changeparameters(
                whereconditionfindinginterval = lv_where_cond_finding_interval
                whereconditionoverlappcust    = lv_where_cond_overlap_cust
                validFrom                     = ls_FeatureResult-validfrom
                validto                       = ls_FeatureResult-validto
        ).

        DATA(error_message) = lo_dateValidator->validatedates( ).

        IF error_message IS NOT INITIAL.
            APPEND VALUE #( %key        = ls_FeatureResult-%key
                            id          = ls_FeatureResult-Id ) TO failed-feature.

            APPEND VALUE #( %key     = ls_FeatureResult-%key
                            %msg     = error_message

                            %element-validfrom = if_abap_behv=>mk-on
                            %element-validto   = if_abap_behv=>mk-on ) TO reported-feature.

        ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITY zi_ics_features FROM VALUE #( FOR keyval IN keys
                                                    (  %key               = keyval-%key
                                                       %control-Id        = if_abap_behv=>mk-on
                                                       %control-FeatureID = if_abap_behv=>mk-on
                                                    )
                                                  )
                            RESULT DATA(lt_features_result).

    "DATA: lv_findingid TYPE z_finding_id.
    LOOP AT lt_features_result ASSIGNING FIELD-SYMBOL(<fs_features_result>).

      APPEND INITIAL LINE TO result ASSIGNING FIELD-SYMBOL(<fs_result>).
      <fs_result> = CORRESPONDING #( <fs_features_result> ).

    "DelimitEntry nur anzeigen, wenn noch kein Nachfolgesatz existiert
    "Edit nur, wenn noch keine Prüfungen mit dem Customizing durchgeführt wurden
      IF me->isCheckInFindings( <fs_features_result>-Id ) = abap_true
         OR me->checkAlreadyGotProcessed( <fs_features_result>-id ) = abap_true
           .
        <fs_result>-%features-%update = if_abap_behv=>fc-o-disabled.
        <fs_result>-%action-Edit = if_abap_behv=>fc-o-disabled.
        <fs_result>-%features-%delete = if_abap_behv=>fc-o-disabled.

        "lv_findingid = <fs_features_result>-findingid.
        IF me->hasCheckNewerVersion( <fs_features_result>-Id ) = abap_true.
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

  ENDMETHOD.

  METHOD delimitEntry.

    DATA: lt_features TYPE TABLE FOR CREATE zi_ics_features.

    DATA: lv_date TYPE dats.

    "Delimit selected entry
    lv_date = keys[ 1 ]-%param-new_delimitation.

    MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
                ENTITY feature
                   UPDATE FROM VALUE #( FOR key IN keys (
                                           id                       = key-id
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
    READ ENTITIES OF zi_ics_features IN LOCAL MODE
        ENTITY feature
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(features)
        FAILED failed.


    LOOP AT features ASSIGNING FIELD-SYMBOL(<lfs_feature>).

        <lfs_feature>-validfrom = lv_date + 1.
        <lfs_feature>-validto = '99991231'.

        APPEND VALUE #( %cid = keys[ KEY entity %key = <lfs_feature>-%key ]-%cid
                        %data = CORRESPONDING #( <lfs_feature> EXCEPT id )
                      ) TO lt_features ASSIGNING FIELD-SYMBOL(<lfs_newFeature>).

    ENDLOOP.

    MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
        ENTITY feature
        CREATE FIELDS ( FeatureID validfrom validto Destinationid Executiontype created_by created_at
                        last_changed_by last_changed_at )
        WITH lt_features
        MAPPED DATA(mapped_feature_create).

    mapped-feature = mapped_feature_create-feature.

    "Duplicate old entrys texts
    DATA: featureTexts TYPE STANDARD TABLE OF zdb_feature_text.

    DATA(key1) = keys[ 1 ].
    SELECT * FROM zdb_feature_text
        WHERE id = @key1-Id
        INTO TABLE @featureTexts.

    LOOP AT mapped_feature_create-feature ASSIGNING FIELD-SYMBOL(<lfs_mapped_create_feature>).
        LOOP AT featureTexts INTO DATA(featureText).

            MODIFY ENTITIES OF zi_ics_features IN LOCAL MODE
                ENTITY feature
                CREATE BY  \_Text
                FROM VALUE #( ( Id = <lfs_mapped_create_feature>-Id
                %target = VALUE #( ( %cid = 'CID_DUMMY'
                                     Id                             = <lfs_mapped_create_feature>-Id
                                     Language                       = featureText-language
                                     feature_desc                   = featureText-feature_desc
                                     feature_long_desc              = featureText-feature_long_desc
                                     %control = VALUE #(
                                         Id = if_abap_behv=>mk-on
                                         Language = if_abap_behv=>mk-on
                                         feature_desc = if_abap_behv=>mk-on
                                         feature_long_desc = if_abap_behv=>mk-on
                                     )
                                   )
                                 )
                            ) )
                MAPPED DATA(ls_mapped) FAILED DATA(ls_failed) REPORTED DATA(ls_reported).

        ENDLOOP.
     ENDLOOP.

  ENDMETHOD.

  METHOD ischeckinfindings.

    DATA: lt_findings TYPE STANDARD TABLE OF zics_protocols,
          lt_dataexistance TYPE STANDARD TABLE OF zics_data_exist,
          lv_feature_id TYPE z_feature_id.

    SELECT SINGLE *
        FROM zdb_feature_head
        WHERE id = @key
        INTO @DATA(ls_feature)."@lv_feature_id


    SELECT *
        FROM zics_data_exist
        WHERE featureid = @ls_feature-featureid "@lv_feature_id
        INTO TABLE @lt_dataexistance.

    LOOP AT lt_dataexistance INTO DATA(ls_dataexistance).
        DATA: lv_validfrom TYPE zics_protocols-created_at,
              lv_validto TYPE zics_protocols-created_at.

        CONVERT DATE ls_feature-validfrom TIME '000000'
        INTO TIME STAMP lv_validfrom TIME ZONE sy-zonlo.

        CONVERT DATE ls_feature-validto TIME '235959'
        INTO TIME STAMP lv_validto TIME ZONE sy-zonlo.

        SELECT *
            FROM zics_protocols
            WHERE FINDINGKEY = @ls_dataexistance-mykey
              AND CHECKCLASS = 'DataExistenceCheck'
              AND created_at >= @lv_validfrom
              AND created_at <= @lv_validto
              "AND validfrom >= @ls_feature-validfrom
              "AND validto <= @ls_feature-validto
            INTO TABLE @lt_findings.

        IF sy-subrc = 4.
            inFindings = abap_false.
        ELSE.
            inFindings = abap_true.
            CONTINUE.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD checkalreadygotprocessed.

    DATA: lt_dataexistance TYPE STANDARD TABLE OF zics_data_exist.

    SELECT SINGLE *
        FROM zdb_feature_head
        WHERE id = @key
        INTO @DATA(ls_feature).

    SELECT *
        FROM zics_data_exist
            WHERE featureid = @ls_feature-featureid
              AND validfrom >= @ls_feature-validfrom
              AND validto <= @ls_feature-validto
            INTO TABLE @lt_dataexistance.

    LOOP AT lt_dataexistance INTO DATA(ls_dataexistance).
        IF ls_dataexistance-last_check IS NOT INITIAL.
            gotProcessed = abap_true.
            CONTINUE.
        ELSE.
            gotProcessed = abap_false.
        ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD haschecknewerversion.

    DATA: lv_next_from TYPE z_valid_to,
          lv_dummy_key TYPE sysuuid_x16.

    DATA: ls_feature TYPE zdb_feature_head.

    SELECT SINGLE *
        FROM zdb_feature_head
            WHERE id = @key
            INTO @ls_feature.

    lv_next_from =  ls_feature-validto + 1.

    SELECT SINGLE id
        FROM zdb_feature_head
            WHERE featureid = @ls_feature-featureid
              AND id <> @ls_feature-id
              AND validfrom = @lv_next_from
            INTO @lv_dummy_key.

    IF sy-subrc = 4.
        hasNewerVersion = abap_false.
    ELSE.
        hasNewerVersion = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
