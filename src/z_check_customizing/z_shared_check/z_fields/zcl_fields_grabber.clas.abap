CLASS ZCL_FIELDS_GRABBER DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    TYPES ty_langu TYPE c LENGTH 1.

    TYPES ty_range_langu TYPE RANGE OF ty_langu.

    CLASS-METHODS GET_FIELDS_FOR_ALL_DEST
        IMPORTING
            s_languages TYPE ty_range_langu.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-METHODS GENERATE_ONPREM_FIELDS
        IMPORTING
            language        TYPE sy-langu
            destination_key TYPE sysuuid_x16.
ENDCLASS.



CLASS ZCL_FIELDS_GRABBER IMPLEMENTATION.


  METHOD GET_FIELDS_FOR_ALL_DEST.

    SELECT * FROM ZDB_DESTINATION INTO TABLE @DATA(lt_destinations).

    LOOP AT lt_destinations INTO DATA(ls_destination).
        LOOP AT s_languages INTO DATA(ls_languages).
            CASE ls_destination-systemtype.
                WHEN '01'. "HCM
                    "@TODO: multiple languages at once
                    ZCL_FIELDS_GRABBER=>GENERATE_ONPREM_FIELDS( language = ls_languages-low destination_key = ls_destination-id ).
                WHEN '02'. "SF
                    "not implemented.
*                    DATA: datasets TYPE TABLE OF zics_datasets,
*                          dataset LIKE LINE OF datasets,
*                          datasetTexts TYPE TABLE OF zics_datasetstxt,
*                          datasetText like line of datasetTexts.
*
*                    dataset-destination = ls_destination-id.
*                    dataset-dataset = 'EmpJob'.
*
*                    SELECT SINGLE * FROM zics_datasets WHERE destination = @ls_destination-id
*                                             AND dataset     = @dataset-dataset
*                                            INTO @DATA(Dummy).
*                    IF sy-subrc = 4.
*                        "Dataset not found --> Append
*                        APPEND dataset TO datasets.
*                    ENDIF.
*
*                    datasetText-destination = ls_destination-id.
*                    datasetText-dataset = 'EmpJob'.
*                    datasetText-language = ls_languages-low.
*                    datasetText-dataset_desc = 'Employee Job'.
*
*                    SELECT SINGLE * FROM zics_datasetstxt WHERE destination = @ls_destination-id
*                                                AND dataset     = @datasetText-dataset
*                                                AND language    = @datasetText-language
*                                               INTO @DATA(Dummy2).
*                    IF sy-subrc = 4.
*                        "DatasetText not found --> Append
*                        APPEND datasetText TO datasetTexts.
*                    ENDIF.
*
*                    INSERT zics_datasets FROM TABLE @datasets.
*                    INSERT zics_datasetstxt FROM TABLE @datasetTexts.
                WHEN OTHERS.
                    "not implemented.
            ENDCASE.
        ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    DATA: lt_languages TYPE ty_range_langu,
          ls_language LIKE LINE OF lt_languages.

    ls_language-sign = 'I'.
    ls_language-option = 'EQ'.
    ls_language-low = 'D'.

    APPEND ls_language TO lt_languages.

    ls_language-sign = 'I'.
    ls_language-option = 'EQ'.
    ls_language-low = 'E'.

    APPEND ls_language TO lt_languages.

    ZCL_FIELDS_GRABBER=>get_fields_for_all_dest( s_languages = lt_languages ).

  ENDMETHOD.


  METHOD GENERATE_ONPREM_FIELDS.

    DATA: lo_structures TYPE REF TO zcl_rap_infotype_structure,
          lo_structure_description TYPE REF TO CL_ABAP_STRUCTDESCR,
          lo_table_type TYPE REF TO cl_abap_tabledescr,
          dataref TYPE REF TO data.

    lo_structures = NEW #( destination_key ).

    DATA: fields TYPE zcl_rap_infotype_structure=>t_fields.

    SELECT * FROM zc_ics_datasets WHERE DestinationID = @destination_key INTO TABLE @DATA(lt_datasets).

    LOOP AT lt_datasets INTO DATA(ls_dataset).

        lo_structures->GET_FIELDS_DATASETS(
            EXPORTING
                infotype = ls_dataset-DatasetID
                language = language
            IMPORTING
                fields = fields ).

        FIELD-SYMBOLS: <field> Like line of fields.
        DATA: lt_fields TYPE TABLE OF zics_fields,
              ls_fields LIKE LINE OF lt_fields,
              lt_fields_text TYPE TABLE OF zics_fieldstxt,
              ls_fields_text like line of lt_fields_text.

        LOOP AT fields ASSIGNING <field>.
            ls_fields-client = sy-mandt.
            ls_fields-destination = destination_key.
            ls_fields-dataset = <field>-infotype.
            ls_fields-fieldname = <field>-field.

            ls_fields_text-client = sy-mandt.
            ls_fields_text-destination = destination_key.
            ls_fields_text-dataset = <field>-infotype.
            ls_fields_text-fieldname = <field>-field.
            ls_fields_text-language = <field>-language.
            ls_fields_text-field_desc = <field>-description.

            SELECT SINGLE * FROM zics_fields WHERE destination = @destination_key
                                                 AND dataset     = @ls_fields-dataset
                                                 AND fieldname   = @ls_fields-fieldname
                                                INTO @DATA(Dummy).
            IF sy-subrc = 4.
                "Dataset not found --> Append
                APPEND ls_fields TO lt_fields.
            ENDIF.

            SELECT SINGLE * FROM zics_fieldstxt WHERE destination = @destination_key
                                                    AND dataset     = @ls_fields_text-dataset
                                                    AND fieldname   = @ls_fields_text-fieldname
                                                    AND language    = @ls_fields_text-language
                                                   INTO @DATA(Dummy2).
            IF sy-subrc = 4.
                "DatasetText not found --> Append
                APPEND ls_fields_text TO lt_fields_text.
            ENDIF.

            CLEAR: ls_fields, ls_fields_text.

        ENDLOOP.

*       insert the new table entries
        INSERT zics_fields FROM TABLE @lt_fields.
        INSERT zics_fieldstxt FROM TABLE @lt_fields_text.

        CLEAR: lt_fields, lt_fields_text.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
