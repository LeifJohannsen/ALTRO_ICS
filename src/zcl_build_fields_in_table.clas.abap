CLASS zcl_build_fields_in_table DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS refresh_all_tables
        IMPORTING
            !im_name_pattern   TYPE clike
            !im_super_package  TYPE sxco_ar_object_name.

    CLASS-METHODS refresh_table
        IMPORTING
            !im_table          TYPE REF TO IF_XCO_DATABASE_TABLE.

    CLASS-METHODS get_table_object
        IMPORTING
            !im_table_name     TYPE string
        RETURNING VALUE(ret_table_object) TYPE REF TO IF_XCO_DATABASE_TABLE.

    CLASS-METHODS get_all_subpackages
        IMPORTING
            !im_name_pattern   TYPE clike
            !im_super_package  TYPE sxco_ar_object_name
        CHANGING
            ch_subpackages    TYPE sxco_t_packages.
ENDCLASS.



CLASS zcl_build_fields_in_table IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    zcl_build_fields_in_table=>refresh_all_tables( im_name_pattern = 'Z_%' im_super_package = 'Z_HALO_IKS' ).

    zcl_build_fields_in_table=>refresh_table( zcl_build_fields_in_table=>get_table_object( 'ZDB_FEATURE_HEAD' ) ).

  ENDMETHOD.

  METHOD refresh_all_tables.

    DATA: lt_subpackages TYPE sxco_t_packages,
          lt_database_tables TYPE sxco_t_database_tables.

    zcl_build_fields_in_table=>get_all_subpackages( EXPORTING
                                                        im_name_pattern  = im_name_pattern
                                                        im_super_package = im_super_package
                                                    CHANGING
                                                        ch_subpackages   = lt_subpackages
                                                  ).

    LOOP AT lt_subpackages INTO DATA(lo_subpackages).
        DATA(lt_database_tables_tmp) = xco_cp_abap_repository=>objects->tabl->database_tables->all->in( lo_subpackages )->get( ).
        APPEND LINES OF lt_database_tables_tmp TO lt_database_tables.
    ENDLOOP.

    LOOP AT lt_database_tables INTO DATA(lo_database_table).
        zcl_build_fields_in_table=>refresh_table( lo_database_table ).
    ENDLOOP.

  ENDMETHOD.

  METHOD refresh_table.

    IF im_table IS INITIAL.
        EXIT.
    ENDIF.

    DATA: ls_fields_in_table TYPE zdb_fieldsintabl.

    DATA(lt_fields) = im_table->fields->all->get( ).

    DELETE FROM zdb_fieldsintabl WHERE tabname = @im_table->name.

    LOOP AT lt_fields INTO DATA(lo_field).
        CLEAR: ls_fields_in_table.

        DATA(lo_field_content) = lo_field->content( ).

        ls_fields_in_table-tabname = im_table->name.
        ls_fields_in_table-fieldname = lo_field->name.
        ls_fields_in_table-pos = 1.
        ls_fields_in_table-keyflag = lo_field_content->get_key_indicator( ).
        ls_fields_in_table-mandatory = lo_field_content->get_not_null( ).

        IF lo_field_content->get_type( )->is_data_element( ).
            ls_fields_in_table-data_element = lo_field_content->get_type( )->get_data_element(  )->name.
        ENDIF.

        IF lo_field_content->get_type( )->is_built_in_type(  ).
            ls_fields_in_table-type = lo_field_content->get_type( )->get_built_in_type(  )->type.
            ls_fields_in_table-length = lo_field_content->get_type( )->get_built_in_type(  )->length.
            ls_fields_in_table-z_decimals = lo_field_content->get_type( )->get_built_in_type(  )->decimals.
        ENDIF.
        INSERT zdb_fieldsintabl FROM @ls_fields_in_table.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_table_object.
    DATA(lo_name_filter) = xco_cp_abap_repository=>object_name->get_filter( xco_cp_abap_sql=>constraint->equal( im_table_name ) ).

    DATA(lt_objects) = xco_cp_abap_repository=>objects->tabl->database_tables->where( VALUE #(
      ( lo_name_filter )
    ) )->in( xco_cp_abap=>repository )->get( ).

    IF LINES( lt_objects ) = 1.
        READ TABLE lt_objects INDEX 1 INTO ret_table_object.
    ELSE.
        "Error
    ENDIF.

  ENDMETHOD.

  METHOD get_all_subpackages.
    DATA: lt_subpackages TYPE sxco_t_packages.

    DATA(lo_packages_name)   = xco_cp_abap_sql=>constraint->contains_pattern( im_name_pattern ).
    DATA(lo_packages_filter) = xco_cp_abap_repository=>object_name->get_filter( lo_packages_name ).
    DATA(lo_packages)        = xco_cp_abap_repository=>objects->devc->where( it_filters = VALUE #( ( lo_packages_filter ) ) ).

    lt_subpackages     = lo_packages->in( xco_cp_abap=>repository )->get( ).

    DATA: lv_superpackage TYPE sxco_ar_object_name,
          lo_super_package TYPE REF TO if_xco_package.

    LOOP AT lt_subpackages INTO DATA(lo_package).
      CLEAR: lv_superpackage, lo_super_package.
      lo_super_package = lo_package->read( )-property-super_package.
      IF lo_super_package IS NOT INITIAL.
          lv_superpackage = lo_package->read( )-property-super_package->if_xco_ar_object~name->value.
      ENDIF.
      IF lv_superpackage <> im_super_package.
        DELETE lt_subpackages.
      ELSE.
        zcl_build_fields_in_table=>get_all_subpackages( EXPORTING
                                                            im_name_pattern  = im_name_pattern
                                                            im_super_package = CONV sxco_ar_object_name( lo_package->name )
                                                        CHANGING
                                                            ch_subpackages   = ch_subpackages ).
      ENDIF.
    ENDLOOP.

    APPEND LINES OF lt_subpackages TO ch_subpackages.

  ENDMETHOD.

ENDCLASS.
