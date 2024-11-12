CLASS zcl_rap_infotype_structure DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
          begin of abap_compdescr,
            length    type i,
            decimals  type i,
            type_kind type c LENGTH 1,
            name      type c LENGTH 30,
          end of abap_compdescr,

          t_infotype_structures TYPE TABLE OF zcl_rap_cloud_services=>tys_pa_infotype_structure,
          t_infotype TYPE TABLE OF zcl_rap_cloud_services=>tys_pa_infotype,
          t_changed TYPE TABLE of zcl_rap_cloud_services=>tys_pa_changed,
          t_fields TYPE TABLE of zcl_rap_cloud_services=>tys_pa_fields_structure.

    DATA: destination_key TYPE sysuuid_x16,
          destination_name TYPE string.

    METHODS CONSTRUCTOR
      IMPORTING
        destination_key TYPE sysuuid_x16.

    METHODS GET_INFOTYPE_DATASETS
      IMPORTING
        language TYPE c
      EXPORTING
        infotypes TYPE t_infotype_structures.

    METHODS GET_FIELDS_DATASETS
      IMPORTING
        infotype TYPE c OPTIONAL
        language TYPE c OPTIONAL
      EXPORTING
        fields TYPE t_fields.

    METHODS GET_INFOTYPE_STRUCTURE
      IMPORTING
        infotype TYPE c OPTIONAL
        language TYPE c OPTIONAL
      RETURNING
        value(structure_description) TYPE REF TO CL_ABAP_STRUCTDESCR.

    METHODS GET_INFOTYPE_DATA
      IMPORTING
        infotype TYPE c
        pernr    TYPE c
      EXPORTING
        infotypeData TYPE any.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS CALL_STRUCTURE_SERVICE
      IMPORTING
        filter_cond        TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top                TYPE i                                          OPTIONAL
        skip               TYPE i                                          OPTIONAL
        is_data_requested  TYPE abap_bool
        is_count_requested TYPE abap_bool
      EXPORTING
        business_data      TYPE t_infotype_structures
        count              TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .

    METHODS CALL_FIELDS_STRUCTURE_SERVICE
      IMPORTING
        filter_cond        TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top                TYPE i                                          OPTIONAL
        skip               TYPE i                                          OPTIONAL
        is_data_requested  TYPE abap_bool
        is_count_requested TYPE abap_bool
      EXPORTING
        business_data      TYPE t_fields
        count              TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .

    METHODS CALL_PA_INFOTYPE_SERVICE
      IMPORTING
        filter_cond        TYPE if_rap_query_filter=>tt_name_range_pairs   OPTIONAL
        top                TYPE i                                          OPTIONAL
        skip               TYPE i                                          OPTIONAL
        is_data_requested  TYPE abap_bool
        is_count_requested TYPE abap_bool
      EXPORTING
        business_data      TYPE t_infotype
        count              TYPE int8
      RAISING
        /iwbep/cx_cp_remote
        /iwbep/cx_gateway
        cx_web_http_client_error
        cx_http_dest_provider_error
      .
ENDCLASS.



CLASS ZCL_RAP_INFOTYPE_STRUCTURE IMPLEMENTATION.

  METHOD CALL_STRUCTURE_SERVICE.

    DATA: filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          filter_node      TYPE REF TO /iwbep/if_cp_filter_node,
          root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA: http_client        TYPE REF TO if_web_http_client,
          odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
          read_list_request  TYPE REF TO /iwbep/if_cp_request_read_list,
          read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA service_consumption_name TYPE cl_web_odata_client_factory=>ty_service_definition_name.

    DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = me->destination_name
                                                                                        i_authn_mode = if_a4c_cp_service=>service_specific ).
    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    service_consumption_name = to_upper( 'ZSC_RAP_CLOUD_SERVICES' ).

    odata_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
      EXPORTING
        iv_service_definition_name = service_consumption_name
        io_http_client             = http_client
        iv_relative_service_root   = '' ).

    " Navigate to the resource and create a request for the read operation
    read_list_request = odata_client_proxy->create_resource_for_entity_set( 'PA_INFOTYPE_STRUCTURESET' )->create_request_for_read( ).

    " Create the filter tree
    filter_factory = read_list_request->create_filter_factory( ).
    LOOP AT  filter_cond  INTO DATA(filter_condition).
      filter_node  = filter_factory->create_by_range( iv_property_path     = filter_condition-name
                                                              it_range     = filter_condition-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      read_list_request->set_filter( root_filter_node ).
    ENDIF.

    IF is_data_requested = abap_true.
      read_list_request->set_skip( skip ).
      IF top > 0 .
        read_list_request->set_top( top ).
      ENDIF.
    ENDIF.

    IF is_count_requested = abap_true.
      read_list_request->request_count(  ).
    ENDIF.

    IF is_data_requested = abap_false.
      read_list_request->request_no_business_data(  ).
    ENDIF.

    " Execute the request and retrieve the business data and count if requested
    read_list_response = read_list_request->execute( ).
    IF is_data_requested = abap_true.
      read_list_response->get_business_data( IMPORTING et_business_data = business_data ).
    ENDIF.
    IF is_count_requested = abap_true.
      count = read_list_response->get_count(  ).
    ENDIF.

  ENDMETHOD.

  METHOD CALL_FIELDS_STRUCTURE_SERVICE.

    DATA: filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          filter_node      TYPE REF TO /iwbep/if_cp_filter_node,
          root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA: http_client        TYPE REF TO if_web_http_client,
          odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
          read_list_request  TYPE REF TO /iwbep/if_cp_request_read_list,
          read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA service_consumption_name TYPE cl_web_odata_client_factory=>ty_service_definition_name.

    DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = me->destination_name
                                                                                        i_authn_mode = if_a4c_cp_service=>service_specific ).
    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    service_consumption_name = to_upper( 'ZSC_RAP_CLOUD_SERVICES' ).

*    odata_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
*      EXPORTING
*        iv_service_definition_name = service_consumption_name
*        io_http_client             = http_client
*        iv_relative_service_root   = '' ).

    odata_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
       EXPORTING
          is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                              proxy_model_id      = service_consumption_name
                                              proxy_model_version = '0001' )
         io_http_client             = http_client
         iv_relative_service_root   = '' ).

     ASSERT http_client IS BOUND.

    " Navigate to the resource and create a request for the read operation
    read_list_request = odata_client_proxy->create_resource_for_entity_set( 'PA_FIELDS_STRUCTURESET' )->create_request_for_read( ).

    " Create the filter tree
    filter_factory = read_list_request->create_filter_factory( ).
    LOOP AT  filter_cond  INTO DATA(filter_condition).
      filter_node  = filter_factory->create_by_range( iv_property_path     = filter_condition-name
                                                              it_range     = filter_condition-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      read_list_request->set_filter( root_filter_node ).
    ENDIF.

    IF is_data_requested = abap_true.
      read_list_request->set_skip( skip ).
      IF top > 0 .
        read_list_request->set_top( top ).
      ENDIF.
    ENDIF.

    IF is_count_requested = abap_true.
      read_list_request->request_count(  ).
    ENDIF.

    IF is_data_requested = abap_false.
      read_list_request->request_no_business_data(  ).
    ENDIF.

    " Execute the request and retrieve the business data and count if requested
    read_list_response = read_list_request->execute( ).
    IF is_data_requested = abap_true.
      read_list_response->get_business_data( IMPORTING et_business_data = business_data ).
    ENDIF.
    IF is_count_requested = abap_true.
      count = read_list_response->get_count(  ).
    ENDIF.

  ENDMETHOD.

  METHOD GET_INFOTYPE_DATASETS.
    "DATA infotype_structures TYPE t_infotype_structures.
    DATA count TYPE int8.

    "Prepare filter for OData-Call
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .

    IF language IS NOT INITIAL.
        ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = language ) ).
        filter_conditions = VALUE #( ( name = 'INFOTYPELANGUAGE'  range = ranges_table ) ).
    ENDIF.

    TRY.
        me->CALL_STRUCTURE_SERVICE(
          EXPORTING
            filter_cond        = filter_conditions
            top                = 3
            skip               = 1
            is_count_requested = abap_true
            is_data_requested  = abap_true
          IMPORTING
            business_data  = infotypes
            count          = count
          ) .
    CATCH cx_root INTO DATA(exception).

    ENDTRY.
  ENDMETHOD.

  METHOD GET_FIELDS_DATASETS.
    "DATA infotype_structures TYPE t_infotype_structures.
    DATA count TYPE int8.

    "Prepare filter for OData-Call
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA filter_condition   LIKE LINE OF  filter_conditions.
    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .

    IF infotype IS NOT INITIAL.
        ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = infotype ) ).
        filter_condition =  VALUE #( name = 'INFOTYPE'  range = ranges_table ).
        APPEND filter_condition TO filter_conditions.
    ENDIF.

    IF language IS NOT INITIAL.
        ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = language ) ).
        filter_conditions = VALUE #( ( name = 'LANGUAGE'  range = ranges_table ) ).
        APPEND filter_condition TO filter_conditions.
    ENDIF.

    TRY.
        me->CALL_FIELDS_STRUCTURE_SERVICE(
          EXPORTING
            filter_cond        = filter_conditions
            top                = 3
            skip               = 1
            is_count_requested = abap_true
            is_data_requested  = abap_true
          IMPORTING
            business_data  = fields
            count          = count
          ) .
    CATCH cx_root INTO DATA(exception).

    ENDTRY.
  ENDMETHOD.


  METHOD GET_INFOTYPE_STRUCTURE.

    DATA infotype_structures TYPE t_infotype_structures.
    DATA count TYPE int8.

    "Prepare filter for OData-Call
    DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
    DATA filter_condition   LIKE LINE OF  filter_conditions.

    DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .
    IF infotype IS NOT INITIAL.
        ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = infotype ) ).
        filter_condition =  VALUE #( name = 'INFOTYPE'  range = ranges_table ).
        APPEND filter_condition TO filter_conditions.
    ENDIF.

    IF language IS NOT INITIAL.
        ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = language ) ).
        filter_condition = VALUE #( name = 'INFOTYPELANGUAGE'  range = ranges_table ).
        APPEND filter_condition TO filter_conditions.
    ENDIF.

    TRY.
        me->CALL_STRUCTURE_SERVICE(
          EXPORTING
            filter_cond        = filter_conditions
            top                = 3
            skip               = 1
            is_count_requested = abap_true
            is_data_requested  = abap_true
          IMPORTING
            business_data  = infotype_structures
            count          = count
          ) .

        DATA: component_descriptions type standard table of abap_compdescr WITH DEFAULT KEY.

        LOOP AT infotype_structures INTO DATA(infotype_structure).

            CALL TRANSFORMATION id
                SOURCE XML infotype_structure-infotype_meta
                RESULT values = component_descriptions[].

            DATA:  struct_type TYPE REF TO cl_abap_structdescr, "Structure
                   table_type TYPE REF TO cl_abap_tabledescr,   "Table type
                   dataref TYPE REF TO data.                    "Dynamic data

            DATA:  comp_tab TYPE cl_abap_structdescr=>component_table,
                   comp_wa   LIKE LINE OF comp_tab.

            FIELD-SYMBOLS: <t_table> TYPE STANDARD TABLE,
                           <s_table> TYPE ANY.

            LOOP AT component_descriptions INTO DATA(component_description).

                DATA:
                lo_len TYPE REF TO data.

                DATA(lv_length) = component_description-length / 2.
                CASE component_description-type_kind.
                    WHEN 'D'.
                        CREATE DATA lo_len TYPE D.
                    WHEN 'P'.
                        CREATE DATA lo_len TYPE P LENGTH component_description-length DECIMALS component_description-Decimals.
                    WHEN OTHERS.
                        CREATE DATA lo_len TYPE (component_description-type_kind) LENGTH lv_length.
                ENDCASE.

                comp_wa-name = component_description-name.
                comp_wa-type ?= cl_abap_datadescr=>describe_by_data( lo_len->* ).
                APPEND comp_wa TO comp_tab.
            ENDLOOP.

*           Create Dynamic table using component table
            struct_type = cl_abap_structdescr=>create( comp_tab ).
            structure_description = cl_abap_structdescr=>create( comp_tab ).
            table_type  = cl_abap_tabledescr=>create( p_line_type = struct_type ).

*            Create  Dynamic Internal table and work area
            CREATE DATA dataref TYPE HANDLE table_type.
            ASSIGN dataref->* TO <t_table>.   "Dynamic table
            CREATE DATA dataref TYPE HANDLE struct_type.
            ASSIGN dataref->* TO <s_table>. "Dyanmic Structure

        ENDLOOP.

      CATCH cx_root INTO DATA(exception).
        "out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.


  ENDMETHOD.


  METHOD CALL_PA_INFOTYPE_SERVICE.

    DATA: filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
          filter_node      TYPE REF TO /iwbep/if_cp_filter_node,
          root_filter_node TYPE REF TO /iwbep/if_cp_filter_node.

    DATA: http_client        TYPE REF TO if_web_http_client,
          odata_client_proxy TYPE REF TO /iwbep/if_cp_client_proxy,
          read_list_request  TYPE REF TO /iwbep/if_cp_request_read_list,
          read_list_response TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA service_consumption_name TYPE cl_web_odata_client_factory=>ty_service_definition_name.

    DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = me->destination_name
                                                                                        i_authn_mode = if_a4c_cp_service=>service_specific ).
    http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

    service_consumption_name = to_upper( 'ZSC_RAP_CLOUD_SERVICES' ).

    odata_client_proxy = cl_web_odata_client_factory=>create_v2_remote_proxy(
      EXPORTING
        iv_service_definition_name = service_consumption_name
        io_http_client             = http_client
        iv_relative_service_root   = '' ).

    " Navigate to the resource and create a request for the read operation
    read_list_request = odata_client_proxy->create_resource_for_entity_set( 'PA_INFOTYPESET' )->create_request_for_read( ).

    " Create the filter tree
    filter_factory = read_list_request->create_filter_factory( ).
    LOOP AT  filter_cond  INTO DATA(filter_condition).
      filter_node  = filter_factory->create_by_range( iv_property_path     = filter_condition-name
                                                              it_range     = filter_condition-range ).
      IF root_filter_node IS INITIAL.
        root_filter_node = filter_node.
      ELSE.
        root_filter_node = root_filter_node->and( filter_node ).
      ENDIF.
    ENDLOOP.

    IF root_filter_node IS NOT INITIAL.
      read_list_request->set_filter( root_filter_node ).
    ENDIF.

    IF is_data_requested = abap_true.
      read_list_request->set_skip( skip ).
      IF top > 0 .
        read_list_request->set_top( top ).
      ENDIF.
    ENDIF.

    IF is_count_requested = abap_true.
      read_list_request->request_count(  ).
    ENDIF.

    IF is_data_requested = abap_false.
      read_list_request->request_no_business_data(  ).
    ENDIF.

    " Execute the request and retrieve the business data and count if requested
    read_list_response = read_list_request->execute( ).
    IF is_data_requested = abap_true.
      read_list_response->get_business_data( IMPORTING et_business_data = business_data ).
    ENDIF.
    IF is_count_requested = abap_true.
      count = read_list_response->get_count(  ).
    ENDIF.

  ENDMETHOD.


  METHOD GET_INFOTYPE_DATA.

    DATA infotype_data TYPE t_infotype.
    DATA count TYPE int8.

    "Prepare filter for OData-Call
    DATA: filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs,
          filter_condition LIKE LINE OF filter_conditions,
          ranges_table TYPE if_rap_query_filter=>tt_range_option.

    ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = infotype ) ).
    filter_condition-name = 'INFOTYPE'.
    filter_condition-range = ranges_table.
    APPEND filter_condition TO filter_conditions.

    ranges_table = VALUE #( (  sign = 'I' option = 'EQ' low = pernr ) ).
    filter_condition-name = 'PERNR'.
    filter_condition-range = ranges_table.
    APPEND filter_condition TO filter_conditions.

    TRY.
        me->CALL_PA_INFOTYPE_SERVICE(
          EXPORTING
            filter_cond        = filter_conditions
            top                = 3
            skip               = 1
            is_count_requested = abap_true
            is_data_requested  = abap_true
          IMPORTING
            business_data  = infotype_data
            count          = count
          ) .

          LOOP AT infotype_data INTO DATA(infotype_data_line).

            CALL TRANSFORMATION id
                SOURCE XML infotype_data_line-infotype_data
                RESULT values = infotypeData.
          ENDLOOP.


      CATCH cx_root INTO DATA(exception).
        "out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
    ENDTRY.


  ENDMETHOD.


  METHOD CONSTRUCTOR.
    me->destination_key = destination_key.
    SELECT SINGLE DestinationKey FROM zdb_destination WHERE id = @destination_key INTO @me->destination_name.
  ENDMETHOD.

ENDCLASS.
