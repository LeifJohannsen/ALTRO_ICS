CLASS zcl_get_distinct_features DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
        BEGIN OF tt_distinct_features_ret,
            FeatureID TYPE z_feature_id,
            ValidFrom TYPE z_valid_from,
            ValidTo TYPE z_valid_to,
            Destinationid TYPE sysuuid_x16,
            DestinationName TYPE c LENGTH 255,
        END OF tt_distinct_features_ret.
    TYPES: ty_distinct_features_ret TYPE STANDARD TABLE OF tt_distinct_features_ret.

    CLASS-METHODS:
        GET_DISTINCT_FEATURES
            IMPORTING
                skip    TYPE int8
                top     TYPE int8
                filter  TYPE REF TO if_rap_query_filter
            EXPORTING
                distinct_combined_features TYPE zcl_get_distinct_features=>ty_distinct_features_ret,

        GET_FILTER_PARAMETERS
            IMPORTING
                sql_query TYPE string
            EXPORTING
                validto TYPE z_valid_to
                validfrom TYPE z_valid_from
                destinationid TYPE sysuuid_x16
                unknown_param type abap_boolean.

ENDCLASS.



CLASS ZCL_GET_DISTINCT_FEATURES IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA lo_filter TYPE REF TO if_rap_query_filter.
    "CREATE OBJECT lo_filter.
    zcl_get_distinct_features=>get_distinct_features(
        EXPORTING
            skip                        = if_rap_query_paging=>page_size_unlimited
            top                         = if_rap_query_paging=>page_size_unlimited
            filter                      = lo_filter
        IMPORTING
            distinct_combined_features  = DATA(Business_data) ).

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    DATA distinct_combined_features TYPE TABLE OF zcl_get_distinct_features=>tt_distinct_features_ret.
    DATA(top)     = io_request->get_paging( )->get_page_size( ).
    DATA(skip)    = io_request->get_paging( )->get_offset( ).
    DATA(requested_fields)  = io_request->get_requested_elements( ).
    DATA(sort_order)    = io_request->get_sort_elements( ).
    DATA(filters)       = io_request->get_filter(  ).

    zcl_get_distinct_features=>get_distinct_features(
        EXPORTING
            skip                        = skip
            top                         = top
            filter                      = filters
        IMPORTING
            distinct_combined_features  = distinct_combined_features ).

    io_response->set_total_number_of_records( lines( distinct_combined_features ) ).
    io_response->set_data( distinct_combined_features ).
  ENDMETHOD.


  METHOD get_distinct_features.
    TYPES:
        BEGIN OF tt_distinct_features,
            FeatureID TYPE z_feature_id,
            Destinationid TYPE sysuuid_x16,
        END OF tt_distinct_features.

    "DATA business_data TYPE TABLE OF zcl_get_distinct_features=>tt_distinct_features_ret.
    DATA ls_distinct_combined_features LIKE LINE OF distinct_combined_features.
    DATA distinct_features TYPE TABLE OF tt_distinct_features.

    DATA lv_top TYPE int8.

    IF top = if_rap_query_paging=>page_size_unlimited.
        lv_top = 0.
    ELSE.
        lv_top = top.
    ENDIF.

    zcl_get_distinct_features=>get_filter_parameters(
        EXPORTING
            sql_query = filter->get_as_sql_string(  )
        IMPORTING
            destinationid = DATA(lv_destinationID)
            validfrom = DATA(lv_validfrom)
            validto = DATA(lv_validto)
            unknown_param = DATA(lv_unknown_param)
            ).

    SELECT DISTINCT featureid, Destinationid
        FROM zdb_feature_head
        WHERE destinationid = @lv_destinationID
        INTO CORRESPONDING FIELDS OF TABLE @distinct_features
        UP TO @lv_top ROWS.

        "@TODO: Offset (skip) einbauen

    LOOP AT distinct_features INTO DATA(ls_distinct_features).

        ls_distinct_combined_features-featureid = ls_distinct_features-featureid.
        ls_distinct_combined_features-Destinationid = ls_distinct_features-Destinationid.

        SELECT SINGLE destinationkey
            FROM zdb_destination
            WHERE id = @ls_distinct_features-Destinationid
            INTO @ls_distinct_combined_features-destinationname.

        SELECT MIN( ValidFrom )
            FROM zdb_feature_head
            WHERE featureid = @ls_distinct_features-featureid
            INTO @ls_distinct_combined_features-validfrom.

        SELECT MAX( Validto )
            FROM zdb_feature_head
            WHERE featureid = @ls_distinct_features-featureid
            INTO @ls_distinct_combined_features-Validto.

        IF     lv_validto <= ls_distinct_combined_features-Validto
           AND lv_validfrom >= ls_distinct_combined_features-Validfrom.
            APPEND ls_distinct_combined_features TO distinct_combined_features.
        ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD GET_FILTER_PARAMETERS.

    SPLIT sql_query AT 'AND' INTO TABLE DATA(lt_filters).
    unknown_param = abap_false.
    LOOP AT lt_filters INTO DATA(ls_filter).

     IF to_upper( ls_filter )  CS 'DESTINATIONID'.
        SPLIT ls_filter AT '''' INTO ls_filter DATA(str_destinationid)..
        destinationid = str_destinationid+0(32).
        CONTINUE.
     ENDIF.

     IF to_upper( ls_filter )  CS 'VALIDTO'.
        SPLIT ls_filter AT '''' INTO ls_filter validto.
        validto = validto+0(8).
        CONTINUE.
     ENDIF.

     IF to_upper( ls_filter )  CS 'VALIDFROM'.
        SPLIT ls_filter AT '''' INTO ls_filter validfrom.
        validfrom = validfrom+0(8).
        CONTINUE.
     ENDIF.

     unknown_param = abap_true.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
