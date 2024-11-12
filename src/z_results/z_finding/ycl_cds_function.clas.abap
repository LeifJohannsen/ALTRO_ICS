CLASS ycl_cds_function DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES: if_sadl_exit_calc_element_read.

    TYPES: BEGIN OF ty_translations,
            translation_index TYPE char2,
            pre_translation TYPE z_ics_description_test,
            detected_lang TYPE string,
            post_translation TYPE z_ics_description_test,
           END OF ty_translations.
    DATA: lt_translations TYPE STANDARD TABLE OF ty_translations.
    CLASS-METHODS:
    TRANSLATE_TEXTS
                IMPORTING
                    iv_target_lang TYPE string OPTIONAL
                CHANGING
                    !ct_translations LIKE lt_translations.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS:
            GET_TRANSLATION_NUMBER
                IMPORTING
                    !iv_component_name TYPE string
                RETURNING VALUE(rv_number) TYPE string,

            PREPARE_STRING_TO_TRANSLATE
                IMPORTING
                    !iv_source_text TYPE z_ics_description_test
                RETURNING VALUE(rv_target_text) TYPE string,

            DELETE_IGNORE_TAGS
                CHANGING
                    !cv_text TYPE z_ics_description_test,

            TRANSLATE_TEXT
                IMPORTING
                    !iv_source_text TYPE z_ics_description_test
                RETURNING VALUE(rv_target_text) TYPE z_ics_description_test.
ENDCLASS.



CLASS YCL_CDS_FUNCTION IMPLEMENTATION.


 METHOD if_sadl_exit_calc_element_read~calculate.

    " it_original_data -> data that comes from cds
    " lt_calculated_data -> data that you will manipulate

    " do your extra logic and append/update your cds view data

    DATA: lt_translations TYPE STANDARD TABLE OF ty_translations WITH DEFAULT KEY,
          ls_translation LIKE LINE OF lt_translations,
          lv_index TYPE sy-tabix.

    LOOP AT it_original_data ASSIGNING FIELD-SYMBOL(<fs_preData>).
        READ TABLE ct_calculated_data
            ASSIGNING FIELD-SYMBOL(<fs_postData>)
            INDEX sy-tabix.
            lv_index = sy-tabix.

        LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_requestedElements>).
            "@TODO: Implement check
            ASSIGN COMPONENT <fs_requestedElements>
                OF STRUCTURE <fs_postData>
                TO FIELD-SYMBOL(<fs_postTranslate>).

            ASSIGN COMPONENT 'preTranslation_' && ycl_cds_function=>GET_TRANSLATION_NUMBER( <fs_requestedElements> )
                OF STRUCTURE <fs_preData>
                TO FIELD-SYMBOL(<fs_preTranslate>).

            "@TODO: make one request with all to_translate texts
            "<fs_postTranslate> = ycl_cds_function=>TRANSLATE_TEXT( <fs_preTranslate> ).
            ls_translation-translation_index = ycl_cds_function=>GET_TRANSLATION_NUMBER( <fs_requestedElements> ).
            ls_translation-pre_translation = <fs_preTranslate>.
            INSERT ls_translation INTO lt_translations INDEX lv_index.
        ENDLOOP.
    ENDLOOP.

    ycl_cds_function=>TRANSLATE_TEXTS( CHANGING ct_translations = lt_translations ).

    LOOP AT lt_translations INTO ls_translation.
        READ TABLE ct_calculated_data
            ASSIGNING FIELD-SYMBOL(<fs_postData2>)
            INDEX sy-tabix.
        ASSIGN COMPONENT 'postTranslation_' && ls_translation-translation_index
                OF STRUCTURE <fs_postData2>
                TO FIELD-SYMBOL(<fs_postTranslate2>).

        <fs_postTranslate2> = ls_translation-post_translation.

    ENDLOOP.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.


  ENDMETHOD.


  METHOD GET_TRANSLATION_NUMBER.

    SPLIT iv_component_name AT '_' INTO DATA(lv_dummy) rv_number.

  ENDMETHOD.


  METHOD PREPARE_STRING_TO_TRANSLATE.

    "Hier auf Customizing-Tabelle abfragen welche Begriffe nicht übersetzt werden sollen
    SPLIT iv_source_text AT 'Finding' INTO DATA(pre_dummy) DATA(post_dummy).
    IF pre_dummy <> iv_source_text. "( Only if PATTERN is found )
        rv_target_text = pre_dummy && '<x>Finding</x>' && post_dummy.
    ELSE.
        rv_target_text = iv_source_text.
    ENDIF.

  ENDMETHOD.


  METHOD DELETE_IGNORE_TAGS.

    REPLACE ALL OCCURRENCES OF '<x>' IN cv_text WITH ''.
    REPLACE ALL OCCURRENCES OF '</x>' IN cv_text WITH ''.

  ENDMETHOD.


  METHOD TRANSLATE_TEXTS.

        DATA(http_destination)    = cl_http_destination_provider=>create_by_url( 'https://api-free.deepl.com/v2/translate' ).
        DATA(lo_http_client_url)  = cl_web_http_client_manager=>create_by_http_destination( http_destination ).

        lo_http_client_url->get_http_request( )->set_header_field( i_name = 'Authorization' i_value = 'DeepL-Auth-Key 9350cb7b-a6fa-4291-a1c0-e2531c4d96ee:fx' ).
        lo_http_client_url->get_http_request( )->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
        lo_http_client_url->get_http_request( )->set_header_field( i_name = 'Accept' i_value = 'application/json' ).

        DATA target_lang TYPE string.
        IF iv_target_lang IS INITIAL.
            SELECT SINGLE LanguageISOCode FROM I_Language WHERE Language = @sy-langu INTO @target_lang.
        ELSE.
            SELECT SINGLE LanguageISOCode FROM I_Language WHERE Language = @iv_target_lang INTO @target_lang.
        ENDIF.

        "lo_http_client_url->get_http_request( )->set_formfield_encoding( 2 ).

*        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'target_lang' i_value = target_lang ).
        lo_http_client_url->get_http_request( )->append_text( '{' ).
        lo_http_client_url->get_http_request( )->append_text( '"target_lang": "' && target_lang && '",' ).

        lo_http_client_url->get_http_request( )->append_text( '"text": [' ).
        LOOP AT ct_translations INTO DATA(ls_translation).
            Data(to_translate) = ycl_cds_function=>PREPARE_STRING_TO_TRANSLATE( ls_translation-pre_translation ).
*            lo_http_client_url->get_http_request( )->set_form_field( i_name = 'text' i_value = to_translate ).
            lo_http_client_url->get_http_request( )->append_text( '"' && to_translate && '"' ).
            IF sy-tabix < lines( ct_translations ).
                lo_http_client_url->get_http_request( )->append_text( ',' ).
            ENDIF.
        ENDLOOP.
        lo_http_client_url->get_http_request( )->append_text( '],' ).

        lo_http_client_url->get_http_request( )->append_text( '"tag_handling": "xml",' ).
*        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'tag_handling' i_value = 'xml' ).
        lo_http_client_url->get_http_request( )->append_text( '"ignore_tags": ["x"]' ).
*        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'ignore_tags'  i_value = 'x'   ).
        lo_http_client_url->get_http_request( )->append_text( '}' ).

        DATA(lo_http_response_url) = lo_http_client_url->execute( if_web_http_client=>post ).

        DATA(http_status_code_url)   = lo_http_response_url->get_status( ).
        DATA(http_response_body_url) =  lo_http_response_url->get_text( ).

        TYPES:
        BEGIN OF ty_results,
         detected_source_language   TYPE string,
         text                       TYPE string,
        END OF ty_results.

        DATA lt_results   TYPE STANDARD TABLE OF ty_results WITH DEFAULT KEY.

        TYPES:
        BEGIN OF ty_translations,
         translations LIKE lt_results,
        END OF ty_translations.

        DATA: translations TYPE ty_translations,
              ls_result TYPE ty_results.

        FIELD-SYMBOLS: <fs_translation> TYPE ty_translations.

        /ui2/cl_json=>deserialize(
          EXPORTING
          json = http_response_body_url
          CHANGING
          data = translations
          ).

        "READ TABLE translations-translations INDEX 1 INTO ls_result.

        LOOP AT ct_translations INTO DATA(ls_translation_2).
            READ TABLE translations-translations INDEX sy-tabix INTO ls_result.

            ls_translation_2-post_translation = ls_result-text.

            ycl_cds_function=>DELETE_IGNORE_TAGS( CHANGING cv_text = ls_translation_2-post_translation ).
            ls_translation_2-detected_lang = ls_result-detected_source_language.
            MODIFY ct_translations FROM ls_translation_2.
        ENDLOOP.

  ENDMETHOD.


  METHOD TRANSLATE_TEXT.

        DATA(http_destination)    = cl_http_destination_provider=>create_by_url( 'https://api-free.deepl.com/v2/translate' ).
        DATA(lo_http_client_url)  = cl_web_http_client_manager=>create_by_http_destination( http_destination ).

        lo_http_client_url->get_http_request( )->set_header_field( i_name = 'Authorization' i_value = 'DeepL-Auth-Key 9350cb7b-a6fa-4291-a1c0-e2531c4d96ee:fx' ).

        "DATA to_translate TYPE string.
        "to_translate = iv_source_text.

        DATA target_lang TYPE string.
        SELECT SINGLE LanguageISOCode FROM I_Language WHERE Language = @sy-langu INTO @target_lang.
        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'target_lang' i_value = target_lang ).

        Data(to_translate) = ycl_cds_function=>PREPARE_STRING_TO_TRANSLATE( iv_source_text ).
        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'text' i_value = to_translate ).
        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'tag_handling' i_value = 'xml' ).
        lo_http_client_url->get_http_request( )->set_form_field( i_name = 'ignore_tags' i_value = 'x' ).

        DATA(lo_http_response_url) = lo_http_client_url->execute( if_web_http_client=>post ).

        DATA(http_status_code_url) = lo_http_response_url->get_status( ).
        DATA(http_response_body_url) =  lo_http_response_url->get_text( ).

        TYPES:
        BEGIN OF ty_results,
         detected_source_language   TYPE string,
         text                       TYPE string,
        END OF ty_results.

        DATA lt_results   TYPE STANDARD TABLE OF ty_results WITH DEFAULT KEY.

        TYPES:
        BEGIN OF ty_translations,
         translations LIKE lt_results,
        END OF ty_translations.

        DATA: translations TYPE ty_translations,
              ls_result TYPE ty_results.

        /ui2/cl_json=>deserialize(
          EXPORTING
          json = http_response_body_url
          CHANGING
          data = translations
          ).

        READ TABLE translations-translations INDEX 1 INTO ls_result.

        rv_target_text = ls_result-text.

        ycl_cds_function=>DELETE_IGNORE_TAGS( CHANGING cv_text = rv_target_text ).

  ENDMETHOD.
ENDCLASS.
