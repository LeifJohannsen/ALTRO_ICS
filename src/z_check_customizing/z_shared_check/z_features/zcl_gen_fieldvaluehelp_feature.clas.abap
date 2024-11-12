CLASS zcl_gen_fieldvaluehelp_feature DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS GENERATE_NOT_OPERATORS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_SIGNS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_OPERATIONS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_CONJUNCTIONS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_executiontypes
        RETURNING
            value(output) TYPE string.

ENDCLASS.



CLASS ZCL_GEN_FIELDVALUEHELP_FEATURE IMPLEMENTATION.


  METHOD GENERATE_CONJUNCTIONS.
    DATA itab TYPE TABLE OF zdb_feat_conj.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = 'AND' )
      ( id = 'OR' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_conj.

*   insert the new table entries
    INSERT zdb_feat_conj FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zdb_feat_conj_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = 'AND' language = 'EN' conjunction_desc = 'and' )
      ( id = 'OR' language = 'EN' conjunction_desc = 'or' )
      ( id = 'AND' language = 'DE' conjunction_desc = 'und' )
      ( id = 'OR' language = 'DE' conjunction_desc = 'oder' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_conj_t.

*   insert the new table entries
    INSERT zdb_feat_conj_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD GENERATE_EXECUTIONTYPES.
    DATA itab TYPE TABLE OF zdb_feat_exety.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = 'SELOPT' )
      ( id = 'CLASS' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_exety.

*   insert the new table entries
    INSERT zdb_feat_exety FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zdb_feat_exety_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = 'SELOPT' language = 'EN' executiontype_desc = 'Select-Options' )
      ( id = 'CLASS' language = 'EN' executiontype_desc = 'ABAP Class' )
      ( id = 'SELOPT' language = 'DE' executiontype_desc = 'Select-Options' )
      ( id = 'CLASS' language = 'DE' executiontype_desc = 'ABAP Klasse' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_exety_t.

*   insert the new table entries
    INSERT zdb_feat_exety_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD GENERATE_NOT_OPERATORS.
    DATA itab TYPE TABLE OF zdb_feat_not_op.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = ' ' )
      ( id = 'NOT' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_not_op.

*   insert the new table entries
    INSERT zdb_feat_not_op FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zdb_feat_notop_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = ' ' language = 'EN' not_operation_desc = ' ' )
      ( id = 'NOT' language = 'EN' not_operation_desc = 'Not' )
      ( id = ' ' language = 'DE' not_operation_desc = ' ' )
      ( id = 'NOT' language = 'DE' not_operation_desc = 'Nicht' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_notop_t.

*   insert the new table entries
    INSERT zdb_feat_notop_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD GENERATE_OPERATIONS.
    DATA itab TYPE TABLE OF zdb_feat_oper.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = 'EQ' )
      ( id = 'NE' )
      ( id = 'GT' )
      ( id = 'LT' )
      ( id = 'GE' )
      ( id = 'LE' )
      ( id = 'BT' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_oper.

*   insert the new table entries
    INSERT zdb_feat_oper FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zdb_feat_oper_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = 'EQ' language = 'EN' operation_desc = 'equals' )
      ( id = 'NE' language = 'EN' operation_desc = 'not equals' )
      ( id = 'GT' language = 'EN' operation_desc = 'greater than' )
      ( id = 'LT' language = 'EN' operation_desc = 'lower than' )
      ( id = 'GE' language = 'EN' operation_desc = 'greater equals' )
      ( id = 'LE' language = 'EN' operation_desc = 'lower equals' )
      ( id = 'BT' language = 'EN' operation_desc = 'between' )
      ( id = 'EQ' language = 'DE' operation_desc = 'gleich' )
      ( id = 'NE' language = 'DE' operation_desc = 'ungleich' )
      ( id = 'GT' language = 'DE' operation_desc = 'größer als' )
      ( id = 'LT' language = 'DE' operation_desc = 'kleiner als' )
      ( id = 'GE' language = 'DE' operation_desc = 'größer gleich' )
      ( id = 'LE' language = 'DE' operation_desc = 'kleiner gleich' )
      ( id = 'BT' language = 'DE' operation_desc = 'zwischen' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_oper_t.

*   insert the new table entries
    INSERT zdb_feat_oper_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD GENERATE_SIGNS.
    DATA itab TYPE TABLE OF zdb_feat_sign.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = 'I' )
      ( id = 'E' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_sign.

*   insert the new table entries
    INSERT zdb_feat_sign FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zdb_feat_sign_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = 'I' language = 'EN' sign_desc = 'Include' )
      ( id = 'E' language = 'EN' sign_desc = 'Exclude' )
      ( id = 'I' language = 'DE' sign_desc = 'Einschließen' )
      ( id = 'E' language = 'DE' sign_desc = 'Ausschließen' )
    ).

*   delete existing entries in the database table
    DELETE FROM zdb_feat_sign_t.

*   insert the new table entries
    INSERT zdb_feat_sign_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.


   "out->write( me->GENERATE_NOT_OPERATORS( ) ).
   "out->write( me->GENERATE_SIGNS( ) ).
   "out->write( me->GENERATE_OPERATIONS( ) ).
   "out->write( me->GENERATE_CONJUNCTIONS( ) ).
    out->write( me->GENERATE_executiontypes( ) ).


  ENDMETHOD.
ENDCLASS.
