CLASS z_test_call DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
  TYPES tt_za_bankdetails TYPE STANDARD TABLE OF z_1234rap_pa_infotypechanged=>tys_pa_changed WITH EMPTY KEY.
    METHODS get_changed_infotypes
       RETURNING
        VALUE(rt_table) TYPE tt_za_bankdetails.
        "VALUE(rv_count) TYPE int8.

ENDCLASS.



CLASS Z_TEST_CALL IMPLEMENTATION.


  METHOD get_changed_infotypes.

    DATA:
      lt_business_data TYPE TABLE OF z_1234rap_pa_infotypechanged=>tys_pa_changed,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
     lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
     lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
     lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
     lo_filter_node_3    TYPE REF TO /iwbep/if_cp_filter_node,
     lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
     lt_range_LASTCHANGE TYPE RANGE OF timestamp,
     ls_range_LASTCHANGE LIKE LINE OF lt_range_LASTCHANGE,
     lt_range_RELID TYPE RANGE OF char2,
     ls_range_RELID LIKE LINE OF lt_range_RELID,

     lt_range_INFOTYPE TYPE RANGE OF char4,
     ls_range_INFOTYPE LIKE LINE OF lt_range_INFOTYPE.



         TRY.
         " Create http client
*    DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                                 comm_scenario  = '<Comm Scenario>'
*                                                 comm_system_id = '<Comm System Id>'
*                                                 service_id     = '<Service Id>' ).
*    lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

    DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = 'E14_100_LJ'           "@TODO: Variabel einfügen
                                                                                        i_authn_mode = if_a4c_cp_service=>service_specific ).

    lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

     lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
       EXPORTING
          is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                              proxy_model_id      = 'ZSC_RAP_PA_INFOTYPECHANGED'
                                              proxy_model_version = '0001' )
         io_http_client             = lo_http_client
         iv_relative_service_root   = '' ). "/sap/opu/odata/ALTRO/CLOUD_SERVICES_SRV

         ASSERT lo_http_client IS BOUND.


    " Navigate to the resource and create a request for the read operation
    lo_request = lo_client_proxy->create_resource_for_entity_set( 'PA_CHANGEDSET' )->create_request_for_read( ).

    " Create the filter tree
    lo_filter_factory = lo_request->create_filter_factory( ).

    ls_range_LASTCHANGE-sign = 'I'.
    ls_range_LASTCHANGE-option = 'GT'.
    CONVERT DATE '20231106' TIME '100000' INTO TIME STAMP ls_range_LASTCHANGE-low TIME ZONE 'UTC'.
    APPEND ls_range_LASTCHANGE TO lt_range_LASTCHANGE.

    lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'LASTCHANGE'
                                                            it_range             = lt_range_LASTCHANGE ).


    ls_range_RELID-sign = 'I'.
    ls_range_RELID-option = 'EQ'.
    ls_range_RELID-low = 'LA'.
    APPEND ls_range_RELID TO lt_range_RELID.

    lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'RELID'
                                                            it_range             = lt_range_RELID ).

    ls_range_INFOTYPE-sign = 'I'.
    ls_range_INFOTYPE-option = 'EQ'.
    ls_range_INFOTYPE-low = '0006'.
    APPEND ls_range_INFOTYPE TO lt_range_INFOTYPE.

    lo_filter_node_3  = lo_filter_factory->create_by_range( iv_property_path     = 'INFOTYPE'
                                                            it_range             = lt_range_INFOTYPE ).

    lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2->and( lo_filter_node_3 ) ).
    "lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
    lo_request->set_filter( lo_filter_node_root ).

    lo_request->set_top( 50 )->set_skip( 0 ).

    " Execute the request and retrieve the business data
    "lo_request = lo_request->request_no_business_data(  ).
    "lo_request = lo_request->request_count( ).
    lo_response = lo_request->execute( ).
    "rv_count = lo_response->get_count(  ).
    lo_response->get_business_data( IMPORTING et_business_data = rt_table ).

    CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
    " Handle remote Exception
    " It contains details about the problems of your http(s) connection

    CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
    " Handle Exception

    CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
    " Handle Exception
    RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

     DATA: infotypeData TYPE REF TO DATA,
           lv_pernr TYPE n LENGTH 8.

           lv_pernr = 10000022.



     zcl_helper_dataset_service=>get_infotype_data( EXPORTING
                                                        infotype = '0006'
                                                        pernr = lv_pernr
                                                    CHANGING
                                                        infotypeData = infotypeData ).

     FIELD-SYMBOLS: <ls_infotypeData> TYPE any.
     ASSIGN infotypedata->* TO <ls_infotypeData>.

*    DATA: lo_iks_check TYPE REF TO zcl_iks_check.
*    DATA: lo_iks_dataexistencecheck TYPE REF TO zcl_iks_dataset_existencecheck.
*
*    DATA: lv_classname TYPE string.
*
*    lv_classname = 'ZCL_IKS_DATASET_EXISTENCECHECK'.
*
*    CREATE OBJECT lo_iks_dataexistencecheck
*        EXPORTING
*            check_key = '123'
*            infotype = '0001'
*            pernr = 12345678.
*
*    CREATE OBJECT lo_iks_check
*        TYPE (lv_classname)
*        EXPORTING
*            check_key = '123'
*            infotype = '0001'
*            pernr = 12345678.
*
*    lo_iks_dataexistencecheck->execute(  ).
*    lo_iks_check->execute(  ).
*    "out->write( get_changed_infotypes( ) ).



  ENDMETHOD.
ENDCLASS.
