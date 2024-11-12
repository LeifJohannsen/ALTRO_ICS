"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>ALTRO.CLOUD_SERVICES_SRV</em>
CLASS zcl_rap_cloud_services DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">PA_CHANGED</p>
      BEGIN OF tys_pa_changed,
        "! <em>Key property</em> Client
        client     TYPE c LENGTH 3,
        "! <em>Key property</em> Relid
        relid      TYPE c LENGTH 2,
        "! <em>Key property</em> Lastchange
        lastchange TYPE timestamp,
        "! <em>Key property</em> Pernr
        pernr      TYPE c LENGTH 8,
        "! <em>Key property</em> Infotype
        infotype   TYPE c LENGTH 4,
      END OF tys_pa_changed,
      "! <p class="shorttext synchronized">List of PA_CHANGED</p>
      tyt_pa_changed TYPE STANDARD TABLE OF tys_pa_changed WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">PA_FIELDS_STRUCTURE</p>
      BEGIN OF tys_pa_fields_structure,
        "! <em>Key property</em> Infotype
        infotype    TYPE c LENGTH 4,
        "! <em>Key property</em> Field
        field       TYPE c LENGTH 30,
        "! Language
        language    TYPE c LENGTH 1,
        "! Description
        description TYPE c LENGTH 60,
      END OF tys_pa_fields_structure,
      "! <p class="shorttext synchronized">List of PA_FIELDS_STRUCTURE</p>
      tyt_pa_fields_structure TYPE STANDARD TABLE OF tys_pa_fields_structure WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">PA_INFOTYPE</p>
      BEGIN OF tys_pa_infotype,
        "! <em>Key property</em> Client
        client        TYPE c LENGTH 3,
        "! <em>Key property</em> PerNr
        per_nr        TYPE c LENGTH 8,
        "! <em>Key property</em> BeginDate
        begin_date    TYPE timestamp,
        "! <em>Key property</em> EndDate
        end_date      TYPE timestamp,
        "! <em>Key property</em> ObjPs
        obj_ps        TYPE c LENGTH 2,
        "! <em>Key property</em> Sprps
        sprps         TYPE c LENGTH 1,
        "! <em>Key property</em> SeqNr
        seq_nr        TYPE c LENGTH 3,
        "! <em>Key property</em> Infotype
        infotype      TYPE c LENGTH 4,
        "! <em>Key property</em> Subtype
        subtype       TYPE c LENGTH 4,
        "! Origin
        origin        TYPE string,
        "! DataFound
        data_found    TYPE abap_bool,
        "! InfotypeData
        infotype_data TYPE string,
      END OF tys_pa_infotype,
      "! <p class="shorttext synchronized">List of PA_INFOTYPE</p>
      tyt_pa_infotype TYPE STANDARD TABLE OF tys_pa_infotype WITH DEFAULT KEY.

    TYPES:
      "! <p class="shorttext synchronized">PA_INFOTYPE_STRUCTURE</p>
      BEGIN OF tys_pa_infotype_structure,
        "! <em>Key property</em> Infotype
        infotype          TYPE c LENGTH 4,
        "! InfotypeName
        infotype_name     TYPE c LENGTH 35,
        "! InfotypeLanguage
        infotype_language TYPE c LENGTH 1,
        "! InfotypeMeta
        infotype_meta     TYPE string,
      END OF tys_pa_infotype_structure,
      "! <p class="shorttext synchronized">List of PA_INFOTYPE_STRUCTURE</p>
      tyt_pa_infotype_structure TYPE STANDARD TABLE OF tys_pa_infotype_structure WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! PA_CHANGEDSet
        "! <br/> Collection of type 'PA_CHANGED'
        pa_changedset            TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'PA_CHANGEDSET',
        "! PA_FIELDS_STRUCTURESet
        "! <br/> Collection of type 'PA_FIELDS_STRUCTURE'
        pa_fields_structureset   TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'PA_FIELDS_STRUCTURESET',
        "! PA_INFOTYPESet
        "! <br/> Collection of type 'PA_INFOTYPE'
        pa_infotypeset           TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'PA_INFOTYPESET',
        "! PA_INFOTYPE_STRUCTURESet
        "! <br/> Collection of type 'PA_INFOTYPE_STRUCTURE'
        pa_infotype_structureset TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'PA_INFOTYPE_STRUCTURESET',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for PA_CHANGED</p>
        "! See also structure type {@link ..tys_pa_changed}
        BEGIN OF pa_changed,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF pa_changed,
        "! <p class="shorttext synchronized">Internal names for PA_FIELDS_STRUCTURE</p>
        "! See also structure type {@link ..tys_pa_fields_structure}
        BEGIN OF pa_fields_structure,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF pa_fields_structure,
        "! <p class="shorttext synchronized">Internal names for PA_INFOTYPE</p>
        "! See also structure type {@link ..tys_pa_infotype}
        BEGIN OF pa_infotype,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF pa_infotype,
        "! <p class="shorttext synchronized">Internal names for PA_INFOTYPE_STRUCTURE</p>
        "! See also structure type {@link ..tys_pa_infotype_structure}
        BEGIN OF pa_infotype_structure,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF pa_infotype_structure,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define PA_CHANGED</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_pa_changed RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define PA_FIELDS_STRUCTURE</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_pa_fields_structure RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define PA_INFOTYPE</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_pa_infotype RAISING /iwbep/cx_gateway.

    "! <p class="shorttext synchronized">Define PA_INFOTYPE_STRUCTURE</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_pa_infotype_structure RAISING /iwbep/cx_gateway.

ENDCLASS.


CLASS zcl_rap_cloud_services IMPLEMENTATION.

  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'ALTRO.CLOUD_SERVICES_SRV' ) ##NO_TEXT.

    def_pa_changed( ).
    def_pa_fields_structure( ).
    def_pa_infotype( ).
    def_pa_infotype_structure( ).

  ENDMETHOD.


  METHOD def_pa_changed.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'PA_CHANGED'
                                    is_structure              = VALUE tys_pa_changed( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'PA_CHANGED' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'PA_CHANGEDSET' ).
    lo_entity_set->set_edm_name( 'PA_CHANGEDSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'CLIENT' ).
    lo_primitive_property->set_edm_name( 'Client' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RELID' ).
    lo_primitive_property->set_edm_name( 'Relid' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LASTCHANGE' ).
    lo_primitive_property->set_edm_name( 'Lastchange' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PERNR' ).
    lo_primitive_property->set_edm_name( 'Pernr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE' ).
    lo_primitive_property->set_edm_name( 'Infotype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

  ENDMETHOD.


  METHOD def_pa_fields_structure.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'PA_FIELDS_STRUCTURE'
                                    is_structure              = VALUE tys_pa_fields_structure( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'PA_FIELDS_STRUCTURE' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'PA_FIELDS_STRUCTURESET' ).
    lo_entity_set->set_edm_name( 'PA_FIELDS_STRUCTURESet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE' ).
    lo_primitive_property->set_edm_name( 'Infotype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FIELD' ).
    lo_primitive_property->set_edm_name( 'Field' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'Language' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'Description' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 60 ) ##NUMBER_OK.

  ENDMETHOD.


  METHOD def_pa_infotype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'PA_INFOTYPE'
                                    is_structure              = VALUE tys_pa_infotype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'PA_INFOTYPE' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'PA_INFOTYPESET' ).
    lo_entity_set->set_edm_name( 'PA_INFOTYPESet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'CLIENT' ).
    lo_primitive_property->set_edm_name( 'Client' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PER_NR' ).
    lo_primitive_property->set_edm_name( 'PerNr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 8 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BEGIN_DATE' ).
    lo_primitive_property->set_edm_name( 'BeginDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'END_DATE' ).
    lo_primitive_property->set_edm_name( 'EndDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'OBJ_PS' ).
    lo_primitive_property->set_edm_name( 'ObjPs' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 2 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SPRPS' ).
    lo_primitive_property->set_edm_name( 'Sprps' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SEQ_NR' ).
    lo_primitive_property->set_edm_name( 'SeqNr' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE' ).
    lo_primitive_property->set_edm_name( 'Infotype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SUBTYPE' ).
    lo_primitive_property->set_edm_name( 'Subtype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORIGIN' ).
    lo_primitive_property->set_edm_name( 'Origin' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DATA_FOUND' ).
    lo_primitive_property->set_edm_name( 'DataFound' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Boolean' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE_DATA' ).
    lo_primitive_property->set_edm_name( 'InfotypeData' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


  METHOD def_pa_infotype_structure.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'PA_INFOTYPE_STRUCTURE'
                                    is_structure              = VALUE tys_pa_infotype_structure( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'PA_INFOTYPE_STRUCTURE' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'PA_INFOTYPE_STRUCTURESET' ).
    lo_entity_set->set_edm_name( 'PA_INFOTYPE_STRUCTURESet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE' ).
    lo_primitive_property->set_edm_name( 'Infotype' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE_NAME' ).
    lo_primitive_property->set_edm_name( 'InfotypeName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE_LANGUAGE' ).
    lo_primitive_property->set_edm_name( 'InfotypeLanguage' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ) ##NUMBER_OK.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INFOTYPE_META' ).
    lo_primitive_property->set_edm_name( 'InfotypeMeta' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.

  ENDMETHOD.


ENDCLASS.
