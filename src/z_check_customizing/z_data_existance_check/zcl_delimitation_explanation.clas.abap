CLASS zcl_delimitation_explanation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS isCheckInFindings
           IMPORTING key TYPE sysuuid_x16
           RETURNING VALUE(inFindings) TYPE abap_boolean.

    METHODS hasCheckNewerVersion
       IMPORTING key TYPE sysuuid_x16
       RETURNING VALUE(hasNewerVersion) TYPE abap_boolean.

    METHODS checkAlreadyGotProcessed
       IMPORTING key TYPE sysuuid_x16
       RETURNING VALUE(gotProcessed) TYPE abap_boolean.

ENDCLASS.



CLASS ZCL_DELIMITATION_EXPLANATION IMPLEMENTATION.


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


 METHOD if_sadl_exit_calc_element_read~calculate.

    " it_original_data -> data that comes from cds
    " lt_calculated_data -> data that you will manipulate

    " do your extra logic and append/update your cds view data

    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).

        READ TABLE ct_calculated_data INDEX sy-tabix ASSIGNING FIELD-SYMBOL(<fs_calculated_data>).

*        LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated_data>).
        ASSIGN COMPONENT 'DelimitationExplanation' OF STRUCTURE <fs_calculated_data> TO FIELD-SYMBOL(<fs_DelimitationExplanation>).
        ASSIGN COMPONENT 'DelimitationCriticality' OF STRUCTURE <fs_calculated_data> TO FIELD-SYMBOL(<fs_DelimitationCriticality>).
        ASSIGN COMPONENT 'FINDING_UUID' OF STRUCTURE <fs_original_data> TO FIELD-SYMBOL(<fs_key>).

        DATA(lv_isInFindings) = me->isCheckInFindings( <fs_key> ).
        DATA(lv_hasNewerVersion) = me->hasCheckNewerVersion( <fs_key> ).
        DATA(lv_isAlreadyProcessed) = me->checkAlreadyGotProcessed( <fs_key> ).

        IF lv_isInFindings = abap_true AND lv_hasNewerVersion = abap_false.
            "<fs_DelimitationExplanation> = 'Dieser Satz kann nicht bearbeitet bzw. gelöscht werden, da hierzu bereits Findings bestehen.'.
            <fs_DelimitationExplanation> = 'This record cannot be edited or deleted as findings already exist for this.'.
            <fs_DelimitationCriticality> = 2.

        ELSEIF lv_isInFindings = abap_true AND lv_hasNewerVersion = abap_true.
            "<fs_DelimitationExplanation> = 'Dieser Satz kann nicht bearbeitet bzw. gelöscht werden, da hierzu bereits Findings bestehen. Dieser Satz kann nicht abgegrenzt werden, da hierzu bereits eine neuere Version besteht.'.
            <fs_DelimitationExplanation> = 'This record cannot be edited or deleted as findings already exist for this. This record cannot be delimited as a newer version already exists.'.
            <fs_DelimitationCriticality> = 2.
        ELSEIF lv_isInFindings = abap_false AND lv_hasNewerVersion = abap_true.
            "<fs_DelimitationExplanation> = 'Dieser Satz kann nicht abgegrenzt werden, da hierzu bereits eine neuere Version besteht.'.
            <fs_DelimitationExplanation> = 'This record cannot be delimited as a newer version already exists.'.
            <fs_DelimitationCriticality> = 2.
        ELSEIF lv_isAlreadyProcessed = abap_true.
            "<fs_DelimitationExplanation> = 'Dieser Satz kann nicht bearbeitet bzw. gelöscht werden, da hierzu bereits eine Prüfung durchgeführt wurde'.
            <fs_DelimitationExplanation> = 'This record cannot be edited or deleted as a check has already been carried out.'.
            <fs_DelimitationCriticality> = 2.
        ELSE.
            "<fs_DelimitationExplanation> = 'Dieser Satz kann bearbeitet werden.'.
            <fs_DelimitationExplanation> = 'This record can be edited.'.
            <fs_DelimitationCriticality> = 3.
        ENDIF.

*        ENDLOOP.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.


  ENDMETHOD.
ENDCLASS.
