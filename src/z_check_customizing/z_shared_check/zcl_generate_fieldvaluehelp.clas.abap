CLASS zcl_generate_fieldvaluehelp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.

  PRIVATE SECTION.

    METHODS MANIPULATE_FINDING
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_FINDING_TYPES
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_FINDING_STATUSES
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_DATA_EXIST_CHECKTYPES
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_DATAEXISTTRANSLATIONS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_SYSTEM_TYPES
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_USEINLINKED
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_EE_SUBGROUPS
        RETURNING
            value(output) TYPE string.

    METHODS GENERATE_CATEGORIES
        RETURNING
            value(output) TYPE string.


ENDCLASS.



CLASS ZCL_GENERATE_FIELDVALUEHELP IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    DATA(lv_zero) = 0.
*    DATA(lv_one) = 1.
*    DATA(lv_error) = lv_one / lv_zero.




    out->write( me->manipulate_finding( ) ).
    "out->write( me->GENERATE_CATEGORIES( ) ).
    "out->write( me->GENERATE_DATA_EXIST_CHECKTYPES( ) ).
    "out->write( me->GENERATE_FINDING_STATUSES( ) ).
    "out->write( me->GENERATE_EE_SUBGROUPS( ) ).
    "out->write( me->GENERATE_FINDING_TYPES( ) ).
    "out->write( me->GENERATE_SYSTEM_TYPES( ) ).
    "out->write( me->GENERATE_USEINLINKED( ) ).
    "out->write( me->GENERATE_MOCKING_ENTRIES( ) ).
    "out->write( me->GENERATE_DATASETS( ) ).
    "out->write( me->GENERATE_DATAEXISTTRANSLATIONS( ) ).
    "out->write( me->GENERATE_ONPREM_DATASETS( 'E' ) ).
    "out->write( me->GENERATE_ONPREM_DATASETS( 'D' ) ).

  ENDMETHOD.


  METHOD GENERATE_CATEGORIES.
    DATA itab TYPE TABLE OF zics_category.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( mykey = '0000000000000000' validfrom = '18000101' validto = '99991231')
      ( mykey = '0000000000000001' validfrom = '18000101' validto = '99991231')
      ( mykey = '0000000000000002' validfrom = '18000101' validto = '99991231')
      ( mykey = '0000000000000003' validfrom = '18000101' validto = '99991231')
      ( mykey = '0000000000000004' validfrom = '18000101' validto = '99991231')
    ).

*   delete existing entries in the database table
    DELETE FROM zics_category.

*   insert the new table entries
    INSERT zics_category FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zics_category_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( mykey = '0000000000000000' validfrom = '18000101' validto = '99991231' language = 'DE' category_desc = '-')
      ( mykey = '0000000000000001' validfrom = '18000101' validto = '99991231' language = 'DE' category_desc = 'Allgemeine Findings')
      ( mykey = '0000000000000002' validfrom = '18000101' validto = '99991231' language = 'DE' category_desc = 'Altersteilzeit')
      ( mykey = '0000000000000003' validfrom = '18000101' validto = '99991231' language = 'DE' category_desc = 'Ausgetretene Mitarbeiter')
      ( mykey = '0000000000000004' validfrom = '18000101' validto = '99991231' language = 'DE' category_desc = 'Rentner')
      ( mykey = '0000000000000000' validfrom = '18000101' validto = '99991231' language = 'EN' category_desc = '-')
      ( mykey = '0000000000000001' validfrom = '18000101' validto = '99991231' language = 'EN' category_desc = 'General Findings')
      ( mykey = '0000000000000002' validfrom = '18000101' validto = '99991231' language = 'EN' category_desc = 'Part-time retirement')
      ( mykey = '0000000000000003' validfrom = '18000101' validto = '99991231' language = 'EN' category_desc = 'Resigned employees')
      ( mykey = '0000000000000004' validfrom = '18000101' validto = '99991231' language = 'EN' category_desc = 'Pensioners')
    ).

*   delete existing entries in the database table
    DELETE FROM zics_category_t.

*   insert the new table entries
    INSERT zics_category_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD manipulate_finding.

*    SELECT SINGLE * FROM zics_protocols WHERE mykey = '12345678900000000000000000000000' INTO @Data(ls_finding).
*
*    ls_finding-checkclass = 'DataExistenceCheck'.
*
*
*    MODIFY zics_protocols FROM @ls_finding.

    DATA: ls_destination TYPE zdb_destination.

    ls_destination-client = sy-mandt.
    ls_destination-id = '0000000000000000'.
    ls_destination-systemtype = '1'.
    ls_destination-destinationkey = '-'.
    ls_destination-purpose = 'keine Verbinung'.

    INSERT zdb_destination FROM @ls_destination.


  ENDMETHOD.


  METHOD GENERATE_FINDING_TYPES.
    DATA itab TYPE TABLE OF zics_findingtype.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( findingtype = '00' display_category = '0' )
      ( findingtype = '01' display_category = '2' )
      ( findingtype = '02' display_category = '1' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_findingtype.

*   insert the new table entries
    INSERT zics_findingtype FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zics_findtype_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( findingtype = '00' language = 'EN' finding_type_desc = 'Information' )
      ( findingtype = '01' language = 'EN' finding_type_desc = 'Warning' )
      ( findingtype = '02' language = 'EN' finding_type_desc = 'Error' )
      ( findingtype = '00' language = 'DE' finding_type_desc = 'Information' )
      ( findingtype = '01' language = 'DE' finding_type_desc = 'Warnung' )
      ( findingtype = '02' language = 'DE' finding_type_desc = 'Fehler' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_findtype_t.

*   insert the new table entries
    INSERT zics_findtype_t FROM TABLE @itab2.
  ENDMETHOD.


  METHOD GENERATE_DATA_EXIST_CHECKTYPES.

    DATA itab TYPE TABLE OF zics_checktype0.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( checktype = '1' )
      ( checktype = '2' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_checktype0.

*   insert the new table entries
    INSERT zics_checktype0 FROM TABLE @itab.

*   output the result as a console message
    output = |{ sy-dbcnt } Check types inserted successfully!|.

    DATA itab2 TYPE TABLE OF zics_checktype0t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( checktype = '1' language = 'EN' checktype_desc = 'Dataset does not exist' )
      ( checktype = '1' language = 'DE' checktype_desc = 'Dataset existiert nicht' )
      ( checktype = '2' language = 'EN' checktype_desc = 'Dataset exists' )
      ( checktype = '2' language = 'DE' checktype_desc = 'Dataset existiert' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_checktype0t.

*   insert the new table entries
    INSERT zics_checktype0t FROM TABLE @itab2.

*   output the result as a console message
    output = |{ sy-dbcnt } Check types inserted successfully!|.

  ENDMETHOD.


  METHOD GENERATE_SYSTEM_TYPES.

    DATA itab TYPE TABLE OF zics_systemtypes.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( systemtypeid = '01' )
      ( systemtypeid = '02' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_systemtypes.

*   insert the new table entries
    INSERT zics_systemtypes FROM TABLE @itab.

*   output the result as a console message
    output = |{ sy-dbcnt } System types inserted successfully!|.

    DATA itab2 TYPE TABLE OF zics_systypes_T.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( systemtypeid = '01' language = 'E' systemteype_desc = 'SAP HCM' )
      ( systemtypeid = '01' language = 'D' systemteype_desc = 'SAP HCM' )
      ( systemtypeid = '02' language = 'E' systemteype_desc = 'Success Factors' )
      ( systemtypeid = '02' language = 'D' systemteype_desc = 'Success Factors' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_systypes_T.

*   insert the new table entries
    INSERT zics_systypes_T FROM TABLE @itab2.

*   output the result as a console message
    output = |{ sy-dbcnt } System types inserted successfully!|.

  ENDMETHOD.


  METHOD GENERATE_USEINLINKED.

    DATA itab TYPE TABLE OF zics_useinlinked.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = '1' )
      ( id = '2' )
      ( id = '3' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_useinlinked.

*   insert the new table entries
    INSERT zics_useinlinked FROM TABLE @itab.

*   output the result as a console message
    output = |{ sy-dbcnt } Use in linked check entries inserted successfully!|.

    DATA itab2 TYPE TABLE OF zics_useinlink_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = '1' language = 'E' description = 'Just use as standalone check' )
      ( id = '1' language = 'D' description = 'Nur alleinstehend prüfen' )
      ( id = '2' language = 'E' description = 'Just use in linked check' )
      ( id = '2' language = 'D' description = 'Nur verknüpft prüfen' )
      ( id = '3' language = 'E' description = 'Use as standalone and linked check' )
      ( id = '3' language = 'D' description = 'Alleinstehend und verknüpft prüfen' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_useinlink_t.

*   insert the new table entries
    INSERT zics_useinlink_t FROM TABLE @itab2.

*   output the result as a console message
    output = |{ sy-dbcnt } Use in linked check entries inserted successfully!|.

  ENDMETHOD.


  METHOD GENERATE_DATAEXISTTRANSLATIONS.
    DATA itab TYPE TABLE OF zics_dataexisttx.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( mykey = 'FAC3DADAE0A31EEE9B83C0FF48A29F96' language = 'DE' dataexist_desc = 'IT 0001 nicht vorhanden.')
      "( mykey = '1' language = 'DE' description = 'IT 0001 nicht vorhanden.')
      ( mykey = 'FAC3DADAE0A31EEE9B83C0FF48A29F96' language = 'EN' dataexist_desc = 'IT 0001 not available.')
      "( mykey = '1' language = 'EN' description = 'IT 0001 not available.')
    ).

*   delete existing entries in the database table
    DELETE FROM zics_dataexisttx.

*   insert the new table entries
    INSERT zics_dataexisttx FROM TABLE @itab.

  ENDMETHOD.


  METHOD GENERATE_EE_SUBGROUPS.
    DATA itab TYPE TABLE OF zics_ee_subgroup.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( employee_subgroup_id = 'DA' )
      ( employee_subgroup_id = 'DB' )
      ( employee_subgroup_id = 'DC' )
      ( employee_subgroup_id = 'DE' )
      ( employee_subgroup_id = 'DF' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_ee_subgroup.

*   insert the new table entries
    INSERT zics_ee_subgroup FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zics_ee_sbgrp_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( employee_subgroup_id = 'DA' language = 'EN' employee_subgroup_desc = 'Temp industrial empl' )
      ( employee_subgroup_id = 'DB' language = 'EN' employee_subgroup_desc = 'Temp commercial empl' )
      ( employee_subgroup_id = 'DC' language = 'EN' employee_subgroup_desc = 'Apprentices' )
      ( employee_subgroup_id = 'DE' language = 'EN' employee_subgroup_desc = 'Industrial trainee' )
      ( employee_subgroup_id = 'DF' language = 'EN' employee_subgroup_desc = 'Commercial trainee' )
      ( employee_subgroup_id = 'DA' language = 'DE' employee_subgroup_desc = 'Aushilfen gew.' )
      ( employee_subgroup_id = 'DB' language = 'DE' employee_subgroup_desc = 'Aushilfen kfm.' )
      ( employee_subgroup_id = 'DC' language = 'DE' employee_subgroup_desc = 'Praktikanten' )
      ( employee_subgroup_id = 'DE' language = 'DE' employee_subgroup_desc = 'Auszubildende gew.' )
      ( employee_subgroup_id = 'DF' language = 'DE' employee_subgroup_desc = 'Auszubildende kfm.' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_ee_sbgrp_t.

*   insert the new table entries
    INSERT zics_ee_sbgrp_t FROM TABLE @itab2.

  ENDMETHOD.


  METHOD GENERATE_FINDING_STATUSES.

    DATA itab TYPE TABLE OF zics_findstat.

*   fill internal travel table (itab)
    itab = VALUE #(
      ( id = '00' display_category = '1' )
      ( id = '01' display_category = '2' )
      ( id = '02' display_category = '2' )
      ( id = '03' display_category = '0' )
      ( id = '04' display_category = '3' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_findstat.

*   insert the new table entries
    INSERT zics_findstat FROM TABLE @itab.

    DATA itab2 TYPE TABLE OF zics_findstat_t.

*   fill internal travel table (itab)
    itab2 = VALUE #(
      ( id = '00' language = 'EN' finding_status_desc = 'Open' )
      ( id = '01' language = 'EN' finding_status_desc = 'In progress' )
      ( id = '02' language = 'EN' finding_status_desc = 'Forwarded' )
      ( id = '03' language = 'EN' finding_status_desc = 'Hidden' )
      ( id = '04' language = 'EN' finding_status_desc = 'Done' )
      ( id = '00' language = 'DE' finding_status_desc = 'Offen' )
      ( id = '01' language = 'DE' finding_status_desc = 'In arbeit' )
      ( id = '02' language = 'DE' finding_status_desc = 'Weitergeleitet' )
      ( id = '03' language = 'DE' finding_status_desc = 'Ausgeblendet' )
      ( id = '04' language = 'DE' finding_status_desc = 'Erledigt' )
    ).

*   delete existing entries in the database table
    DELETE FROM zics_findstat_t.

*   insert the new table entries
    INSERT zics_findstat_t FROM TABLE @itab2.


  ENDMETHOD.
ENDCLASS.
