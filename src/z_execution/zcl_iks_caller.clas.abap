"! <p class="shorttext synchronized" lang="en">Main Program for Centric IKS</p>
CLASS zcl_iks_caller DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
        tt_changed_infotypes     TYPE STANDARD TABLE OF zcl_rap_cloud_services=>tys_pa_changed WITH EMPTY KEY,
        tt_range_timestamp       TYPE RANGE OF timestamp,
        tt_range_relid           TYPE RANGE OF char2,
        tt_range_infotype        TYPE RANGE OF char4,
        tt_range_entityset_param TYPE RANGE OF string.

    CLASS-METHODS perform_iks_checks
         IMPORTING
             IM_ABKRS TYPE zcl_perform_iks_check=>ty_range_abkrs
             IM_BUKRS TYPE zcl_perform_iks_check=>ty_range_bukrs.

    CLASS-METHODS get_changed_infotypes
        IMPORTING
            IM_DESTINATION      TYPE sysuuid_x16
            IM_RANGE_LASTCHANGE TYPE tt_range_timestamp
            IM_RANGE_RELID      TYPE tt_range_relid
            IM_RANGE_INFOTYPE   TYPE tt_range_infotype
            IM_JUST_COUNT       TYPE abap_boolean
        CHANGING
            CT_table            TYPE tt_changed_infotypes
            CH_count            TYPE int8.

    CLASS-METHODS add_filter_node
        IMPORTING
            !it_range               TYPE STANDARD TABLE
            !property_path          TYPE /iwbep/if_cp_runtime_types=>ty_property_path
            !filter_factory         TYPE REF TO /iwbep/if_cp_filter_factory
        CHANGING
            !filter_root_node       TYPE REF TO /iwbep/if_cp_filter_node.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_IKS_CALLER IMPLEMENTATION.


    METHOD perform_iks_checks.

        "@TODO: Application Logging einbinden

        "1. Determine which rules are necessary for this range (if nothing, stop here)
        "   (must be implemented in Customizing views "Organizational delimitation")
        "   and check get_changed_infotypes with $count (if nothing, stop here)

        TYPES: BEGIN OF st_generics,
                classname TYPE string,
                infotype  TYPE string,
                checkKey  TYPE sysuuid_x16,
                destination  TYPE sysuuid_x16,
               END OF st_generics.

       TYPES: BEGIN OF st_destinations,
                destination  TYPE sysuuid_x16,
               END OF st_destinations.

        DATA: lt_data_existance TYPE STANDARD TABLE OF zics_data_exist,
              ls_data_existance TYPE zics_data_exist,

              lt_generic_rules TYPE STANDARD TABLE OF st_generics,
              ls_generic_rule LIKE LINE OF lt_generic_rules,

              lt_unique_destinations TYPE STANDARD TABLE OF st_destinations,
              ls_unique_destination  LIKE LINE OF lt_unique_destinations,

              lv_rules_lines TYPE int8.

        "Stellvertretend für alle Hinweis-Arten: Daten-Existenz-Check
        SELECT *
            FROM zics_data_exist
            WHERE validfrom <= @sy-datum    "valid
              AND validto   >= @sy-datum
              "AND systemtype = '01'         "Just SAP onPrem
              AND ( useinlinkedcheck = 1    "Just standalone
                 OR useinlinkedcheck = 3 )  "Standalone and linked
            INTO TABLE @lt_data_existance.

        If LINES( lt_data_existance ) < 1.
            "No suitable rules -->
            EXIT.
        ENDIF.

        ls_generic_rule-classname = 'ZCL_IKS_DATASET_EXISTENCECHECK'.
        LOOP AT lt_data_existance INTO ls_data_existance.
            ls_generic_rule-infotype = ls_data_existance-dataset.
            ls_generic_rule-checkKey = ls_data_existance-mykey.
            ls_generic_rule-destination = ls_data_existance-destination.
            APPEND ls_generic_rule TO lt_generic_rules.
            CLEAR: ls_generic_rule.

            ls_unique_destination-destination = ls_data_existance-destination.
            APPEND ls_unique_destination TO lt_unique_destinations.
            CLEAR: ls_unique_destination.
        ENDLOOP.

        DELETE ADJACENT DUPLICATES FROM lt_unique_destinations COMPARING destination.

        CLEAR: ls_generic_rule.
        "@TODO: Für jede Generik die gültigen Sätze zur Tabelle hinzufügen.

        "2. Get all persons in range with data change (work with $count in first instance)
        "   (Service, that returns number of changes in the last minute)

        DATA: lt_range_LASTCHANGE TYPE RANGE OF timestamp,
              ls_range_LASTCHANGE LIKE LINE OF lt_range_LASTCHANGE,

              lt_range_RELID TYPE RANGE OF char2,
              ls_range_RELID LIKE LINE OF lt_range_RELID,

              lt_range_INFOTYPE TYPE RANGE OF char4,
              ls_range_INFOTYPE LIKE LINE OF lt_range_INFOTYPE,

              lv_count TYPE int8,
              lt_changed_infotypes TYPE tt_changed_infotypes,
              ls_changed_infotypes LIKE LINE OF lt_changed_infotypes.

        LOOP AT lt_unique_destinations INTO ls_unique_destination.

            ls_range_INFOTYPE-Sign = 'I'.
            ls_range_INFOTYPE-option = 'EQ'.

            LOOP AT lt_data_existance INTO ls_data_existance
                WHERE destination = ls_unique_destination-destination.

                ls_range_INFOTYPE-low = ls_data_existance-dataset.
                APPEND ls_range_INFOTYPE TO lt_range_INFOTYPE.

            ENDLOOP.

            ls_range_LASTCHANGE-sign = 'I'.
            ls_range_LASTCHANGE-option = 'GT'.
            "@TODO: Timestamp variabel einfügen
            CONVERT DATE '20231106' TIME '100000' INTO TIME STAMP ls_range_LASTCHANGE-low TIME ZONE 'UTC'.
            APPEND ls_range_LASTCHANGE TO lt_range_LASTCHANGE.

            ls_range_RELID-sign = 'I'.
            ls_range_RELID-option = 'EQ'.
            ls_range_RELID-low = 'LA'.
            APPEND ls_range_RELID TO lt_range_RELID.

            zcl_iks_caller=>get_changed_infotypes( EXPORTING
                                                        im_destination = ls_unique_destination-destination
                                                        im_just_count = abap_false
                                                        im_range_infotype = lt_range_INFOTYPE
                                                        im_range_lastchange = lt_range_LASTCHANGE
                                                        im_range_relid = lt_range_RELID
                                                   CHANGING
                                                        ch_count = lv_count
                                                        ct_table = lt_changed_infotypes ).

            If lv_count < 1.
                "Nothing changed -->
                CONTINUE.
            ENDIF.

            TYPES: BEGIN OF tt_changed_infotypes_enriched,
                    line TYPE zcl_rap_cloud_services=>tys_pa_changed,
                    destination TYPE sysuuid_x16,
                  END OF tt_changed_infotypes_enriched.

            DATA: lt_changed_infotypes_enriched TYPE STANDARD TABLE OF tt_changed_infotypes_enriched,
                  ls_changed_infotypes_enriched LIKE LINE OF lt_changed_infotypes_enriched.

            LOOP AT lt_changed_infotypes INTO ls_changed_infotypes.
                "ls_changed_infotypes_enriched-line
                MOVE-CORRESPONDING ls_changed_infotypes TO ls_changed_infotypes_enriched-line.
                ls_changed_infotypes_enriched-destination = ls_unique_destination-destination.
                APPEND ls_changed_infotypes_enriched TO lt_changed_infotypes_enriched.
                CLEAR: ls_changed_infotypes_enriched.
            ENDLOOP.



        ENDLOOP.

        "3. Perform all checks (entityset existence check) for every person in range

        LOOP AT lt_changed_infotypes_enriched INTO ls_changed_infotypes_enriched.
            DATA: infotypeData TYPE REF TO DATA.

            zcl_helper_dataset_service=>get_infotype_data( EXPORTING
                                                             destination_key = ls_changed_infotypes_enriched-destination
                                                             pernr           = ls_changed_infotypes_enriched-line-pernr
                                                             infotype        = ls_changed_infotypes_enriched-line-infotype
                                                           CHANGING
                                                             infotypeData    = infotypeData ).

            LOOP AT lt_generic_rules INTO ls_generic_rule
                WHERE infotype    = ls_changed_infotypes_enriched-line-infotype
                  AND destination = ls_changed_infotypes_enriched-destination.

               "3.2 Perform check
               Data: lo_iks_check TYPE REF TO zcl_iks_check.

               CREATE OBJECT lo_iks_check
                    TYPE
                        (ls_generic_rule-classname)
                    EXPORTING
                        check_key    = ls_generic_rule-checkkey
                        infotype     = ls_changed_infotypes_enriched-line-infotype
                        pernr        = ls_changed_infotypes_enriched-line-pernr
                        infotypedata = infotypeData.

               lo_iks_check->execute(  ).

               CLEAR: lo_iks_check.

            ENDLOOP.

            CLEAR: infotypeData.

        ENDLOOP.

    ENDMETHOD.

    METHOD get_changed_infotypes.

        DATA:
          lt_business_data TYPE TABLE OF zcl_rap_cloud_services=>tys_pa_changed,
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
         lt_range_RELID TYPE RANGE OF char2,
         ls_range_RELID LIKE LINE OF lt_range_RELID.



         TRY.
         " Create http client
*        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
*                                                     comm_scenario  = '<Comm Scenario>'
*                                                     comm_system_id = '<Comm System Id>'
*                                                     service_id     = '<Service Id>' ).
*        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        DATA: lv_destination_name TYPE string.
        SELECT SINGLE DestinationKey FROM zdb_destination WHERE id = @IM_DESTINATION INTO @lv_destination_name.

        DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination( i_name = lv_destination_name
                                                                                            i_authn_mode = if_a4c_cp_service=>service_specific ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( i_destination = http_destination ).

         lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
           EXPORTING
              is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                  proxy_model_id      = 'ZSC_RAP_CLOUD_SERVICES'
                                                  proxy_model_version = '0001' )
             io_http_client             = lo_http_client
             iv_relative_service_root   = '' ). "/sap/opu/odata/ALTRO/CLOUD_SERVICES_SRV

             ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'PA_CHANGEDSET' )->create_request_for_read( ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).


        zcl_iks_caller=>add_filter_node( EXPORTING it_range = IM_RANGE_LASTCHANGE
                                                   property_path = 'LASTCHANGE'
                                                   filter_factory = lo_filter_factory
                                         CHANGING  filter_root_node = lo_filter_node_root ).

        zcl_iks_caller=>add_filter_node( EXPORTING it_range = IM_RANGE_RELID
                                                   property_path = 'RELID'
                                                   filter_factory = lo_filter_factory
                                         CHANGING  filter_root_node = lo_filter_node_root ).

        zcl_iks_caller=>add_filter_node( EXPORTING it_range = IM_RANGE_INFOTYPE
                                                   property_path = 'INFOTYPE'
                                                   filter_factory = lo_filter_factory
                                         CHANGING  filter_root_node = lo_filter_node_root ).

        lo_request->set_filter( lo_filter_node_root ).

        IF IM_JUST_COUNT = abap_true.
            lo_request = lo_request->request_no_business_data(  ).
            lo_request = lo_request->request_count( ).
        ELSE.
            lo_request->set_top( 50 )->set_skip( 0 ).
            lo_request = lo_request->request_count( ).
        ENDIF.

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).

        IF IM_JUST_COUNT = abap_true.
            CH_count = lo_response->get_count(  ).
        ELSE.
            CH_count = lo_response->get_count(  ).
            lo_response->get_business_data( IMPORTING et_business_data = CT_table ).
        ENDIF.
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


  METHOD add_filter_node.
    DATA:
         lo_filter_node    TYPE REF TO /iwbep/if_cp_filter_node.

    IF it_range IS NOT INITIAL.
        lo_filter_node  = filter_factory->create_by_range( iv_property_path     = property_path
                                                                it_range             = it_range ).
        IF filter_root_node IS NOT INITIAL.
            filter_root_node = filter_root_node->and( lo_filter_node ).
        ELSE.
            filter_root_node = lo_filter_node.
        ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
