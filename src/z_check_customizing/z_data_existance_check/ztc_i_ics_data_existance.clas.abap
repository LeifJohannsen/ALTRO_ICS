CLASS ztc_i_ics_data_existance DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION SHORT
  .

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      cds_test_environment   TYPE REF TO if_cds_test_environment,
      sql_test_environment   TYPE REF TO if_osql_test_environment,
      begin_date             TYPE z_valid_from,
      end_date               TYPE z_valid_to,
      category_mock_data     TYPE STANDARD TABLE OF ZI_ICS_CATEGORY,
      findingtype_mock_data  TYPE STANDARD TABLE OF ZI_ICS_FINDING_TYPE,
      systemtypes_mock_data  TYPE STANDARD TABLE OF ZI_ICS_SYSTEMTYPES,
      dataset_mock_data      TYPE STANDARD TABLE OF ZI_ICS_DATASETS,
      checktypes_mock_data   TYPE STANDARD TABLE OF ZI_ICS_CHECK_TYPES,
      useinlinked_mock_data  TYPE STANDARD TABLE OF ZI_ICS_USEINLINKED,
      text_mock_data         TYPE STANDARD TABLE OF ZI_ICS_DATA_EXIST_CHECKTXT_2.

    CLASS-METHODS:
      class_setup,    " setup test double framework
      class_teardown. " stop test doubles
     METHODS:
      setup,          " reset test doubles
      teardown.       " rollback any changes

     METHODS:
      "CUT: create with different valid from/to dates and commit (save)
          "valid from is lower than calculated mindate
            create_fromdate_LT_mindate FOR TESTING RAISING cx_static_check,
          "valid from is greater than calculated maxdate
            create_fromdate_GT_maxdate FOR TESTING RAISING cx_static_check,
          "valid to is lower than calculated mindate
            create_todate_LT_mindate FOR TESTING RAISING cx_static_check,
          "valid from is lower than calculated mindate
            create_todate_GT_maxdate FOR TESTING RAISING cx_static_check,
          "All dates are just fine
            create_valid_dates FOR TESTING RAISING cx_static_check,

      "CUT: Delete with different occurrences in findings-protocol or ran in a findings check and commit (save)
          "There is already a finding-occurrence for this customizing
            delete_with_occ_in_finding FOR TESTING RAISING cx_static_check,
          "There is no finding-occurrence for this customizing
            delete_without_occ_in_finding FOR TESTING RAISING cx_static_check,
          "Delete a customizing, which already ran in a findings check
            delete_already_checked_cust FOR TESTING RAISING cx_static_check,
          "Delete a customizing, which did not run in a findings check
            delete_not_checked_cust FOR TESTING RAISING cx_static_check,

      "CUT: Edit with different occurrences in findings-protocol or ran in a findings check and commit (save)
          "There is already a finding-occurrence for this customizing
            edit_with_occ_in_finding FOR TESTING RAISING cx_static_check,
          "There is no finding-occurrence for this customizing
            edit_without_occ_in_finding FOR TESTING RAISING cx_static_check,
          "Edit a customizing, which already ran in a findings check
            edit_already_checked_cust FOR TESTING RAISING cx_static_check,
          "Edit a customizing, which did not run in a findings check
            edit_not_checked_cust FOR TESTING RAISING cx_static_check,

      "CUT: Delimit entry with different occurrences in findings-protocol and versions and commit (save)
          "There is already a finding-occurrence for this customizing
            delimit_with_occ_in_finding FOR TESTING RAISING cx_static_check,
          "There is no finding-occurrence for this customizing
            delimit_without_occ_in_finding FOR TESTING RAISING cx_static_check,
          "Delimit a customizing, which already ran in a findings check
            delimit_already_checked_cust FOR TESTING RAISING cx_static_check,
          "Delimit a customizing, which did not run in a findings check
            delimit_not_checked_cust FOR TESTING RAISING cx_static_check.

     TYPES:
      BEGIN OF ts_msgnos,
        msgno TYPE symsgno,
      END OF ts_msgnos.
     TYPES tt_msgnos TYPE STANDARD TABLE OF ts_msgnos WITH DEFAULT KEY.
     METHODS:
      "Helper
      get_msgno_from_reported
        IMPORTING
            reported TYPE ANY TABLE
        RETURNING VALUE(rt_msgnos) TYPE tt_msgnos.
ENDCLASS.



CLASS ZTC_I_ICS_DATA_EXISTANCE IMPLEMENTATION.


  METHOD class_setup.
    " create the test doubles for the underlying CDS entities
   cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                     i_for_entities = VALUE #(
                       ( i_for_entity = 'ZI_ICS_DATA_EXISTANCE' ) ) ).

   " create test doubles for additional used tables.
   sql_test_environment = cl_osql_test_environment=>create(
   i_dependency_list = VALUE #( ( 'ZI_ICS_CATEGORY' )
                                ( 'ZI_ICS_FINDING_TYPE' )
                                ( 'ZI_ICS_SYSTEMTYPES' )
                                ( 'ZI_ICS_DATASETS' )
                                ( 'ZI_ICS_CHECK_TYPES' )
                                ( 'ZI_ICS_USEINLINKED' )
                                ( 'ZI_ICS_DATA_EXIST_CHECKTXT_2' )
                                ) ).

   " prepare the test data

   category_mock_data = VALUE #( ( CategoryID = '1' ) ).
   findingtype_mock_data = VALUE #( ( FindingTypeID = '1'  ) ).
   systemtypes_mock_data = VALUE #( ( SystemTypeID = '1' ) ).
   dataset_mock_data = VALUE #( ( DatasetID = '1' ) ).
   checktypes_mock_data = VALUE #( ( CheckTypeID = '1' ) ).
   useinlinked_mock_data = VALUE #( ( UseInLinkedID = '1' ) ).
   text_mock_data = VALUE #( ( DataExistanceUUID = '1' ) ).

  ENDMETHOD.


  METHOD class_teardown.
    " remove test doubles
    cds_test_environment->destroy(  ).
    sql_test_environment->destroy(  ).
  ENDMETHOD.


  METHOD create_todate_GT_maxdate.
    "Beginndatum ist größer als endedatum: FEHLER

    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = '99991231'.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed ) exp = 1 ).


    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.
    ls_msgno_exp-msgno = 001.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

  ENDMETHOD.


  METHOD get_msgno_from_reported.
    DATA: ls_msgno LIKE LINE OF rt_msgnos.
    FIELD-SYMBOLS: <ref_data> TYPE ref to data,
                   <lo_message> TYPE REF TO IF_ABAP_BEHV_MESSAGE.

    LOOP AT reported ASSIGNING FIELD-SYMBOL(<fs_reported>).
        ASSIGN COMPONENT 'entries' OF STRUCTURE <fs_reported> TO <ref_data>.

        field-symbols: <dref> type any.
        assign <ref_data>->* to <dref>.

        LOOP AT <dref> ASSIGNING FIELD-SYMBOL(<dref_Line>).
            ASSIGN COMPONENT '%MSG' OF STRUCTURE <dref_Line> TO <lo_message>.
            ls_msgno-msgno = <lo_message>->IF_T100_MESSAGE~T100KEY-MSGNO.
            APPEND ls_msgno TO rt_msgnos.

            CLEAR: ls_msgno.
            UNASSIGN: <lo_message>.
        ENDLOOP.

        UNASSIGN: <ref_data>, <dref>.
    ENDLOOP.
  ENDMETHOD.

  METHOD create_todate_LT_mindate.
    "endedatum ist kleiner als beginndatum: FEHLER

    begin_date = cl_abap_context_info=>get_system_date( ) + 31.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed ) exp = 1 ).


    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.

    ls_msgno_exp-msgno = 003.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

  ENDMETHOD.

  METHOD delete_with_occ_in_finding.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: ls_protocol TYPE zics_protocols,
          lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    try.
        ls_protocol-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
    catch cx_uuid_error into data(lo_x).
        "message lo_x->get_text( ) type 'E'.
    endtry.

    ls_protocol-client = sy-mandt.
    ls_protocol-employeeid = 12345678.
    ls_protocol-firstname = 'Edward'.
    ls_protocol-lastname = 'Wasserkopf'.
    ls_protocol-employee_subgroup = 'DB'.
    ls_protocol-findingid = '9999'.
    ls_protocol-findingtypeid = '02'.
    ls_protocol-checkclass = 'DataExistenceCheck'.
    ls_protocol-findingkey = lv_uuid_x16_cust.
    ls_protocol-furtherinformation = 'This is a test.'.
    ls_protocol-validfrom = cl_abap_context_info=>get_system_date( ) + 25.
    ls_protocol-validto = cl_abap_context_info=>get_system_date( ) + 25.
    GET TIME STAMP FIELD DATA(ts).
    ls_protocol-last_changed_at = ts.
    ls_protocol-created_at = ts.
    ls_protocol-last_changed_by = sy-uname.
    ls_protocol-created_by = sy-uname.

    INSERT zics_protocols FROM @ls_protocol.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

    "Try to delete the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        DELETE FROM
        VALUE #( ( mykey = lv_uuid_x16_cust ) )
        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_equals( act = lines( failed3-datasetexistancecheck ) exp = 1 ).
    READ TABLE failed3-datasetexistancecheck INDEX 1 INTO DATA(ls_failed3).
    cl_abap_unit_assert=>assert_equals( act = ls_failed3-%fail-cause exp = if_abap_behv=>cause-disabled ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_mapped3' act = mapped3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported3' act = reported3 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed3)
     REPORTED DATA(commit_reported3).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed3' act = commit_failed3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported3' act = commit_reported3 ).

    "Custom rollback for this case
    DELETE FROM zics_protocols WHERE MYKEY = @ls_protocol-mykey.
    COMMIT WORK.

  ENDMETHOD.


  METHOD edit_without_occ_in_finding.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: ls_protocol TYPE zics_protocols,
          lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to edit the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        UPDATE SET FIELDS WITH
        VALUE #( (
                   %key-mykey = lv_uuid_x16_cust
                   %Data-dataset = '0008'
                    ) )
        FAILED DATA(failed2)
        REPORTED DATA(reported2).


    cl_abap_unit_assert=>assert_initial( msg = 'delete_failed2' act = failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported2' act = reported2 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed2)
     REPORTED DATA(commit_reported2).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed2' act = commit_failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported2' act = commit_reported2 ).

  ENDMETHOD.


  METHOD delete_without_occ_in_finding.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: ls_protocol TYPE zics_protocols,
          lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to delete the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        DELETE FROM
        VALUE #( ( mykey = lv_uuid_x16_cust ) )
        MAPPED DATA(mapped2)
        FAILED DATA(failed2)
        REPORTED DATA(reported2).


    cl_abap_unit_assert=>assert_initial( msg = 'delete_mapped2' act = mapped2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_failed2' act = failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported2' act = reported2 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed2)
     REPORTED DATA(commit_reported2).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed2' act = commit_failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported2' act = commit_reported2 ).

  ENDMETHOD.


  METHOD edit_with_occ_in_finding.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: ls_protocol TYPE zics_protocols,
          lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    try.
        ls_protocol-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
    catch cx_uuid_error into data(lo_x).
        "message lo_x->get_text( ) type 'E'.
    endtry.

    ls_protocol-client = sy-mandt.
    ls_protocol-employeeid = 12345678.
    ls_protocol-firstname = 'Edward'.
    ls_protocol-lastname = 'Wasserkopf'.
    ls_protocol-employee_subgroup = 'DB'.
    ls_protocol-findingid = '9999'.
    ls_protocol-findingtypeid = '02'.
    ls_protocol-checkclass = 'DataExistenceCheck'.
    ls_protocol-findingkey = lv_uuid_x16_cust.
    ls_protocol-furtherinformation = 'This is a test.'.
    ls_protocol-validfrom = cl_abap_context_info=>get_system_date( ) + 25.
    ls_protocol-validto = cl_abap_context_info=>get_system_date( ) + 25.
    GET TIME STAMP FIELD DATA(ts).
    ls_protocol-last_changed_at = ts.
    ls_protocol-created_at = ts.
    ls_protocol-last_changed_by = sy-uname.
    ls_protocol-created_by = sy-uname.

    INSERT zics_protocols FROM @ls_protocol.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

    "Try to edit the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        UPDATE SET FIELDS WITH
        VALUE #( ( mykey = lv_uuid_x16_cust
                   dataset = '0008'
                    ) )
        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_equals( act = lines( failed3-datasetexistancecheck ) exp = 1 ).
    READ TABLE failed3-datasetexistancecheck INDEX 1 INTO DATA(ls_failed3).
    cl_abap_unit_assert=>assert_equals( act = ls_failed3-%fail-cause exp = if_abap_behv=>cause-disabled ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_mapped3' act = mapped3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported3' act = reported3 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed3)
     REPORTED DATA(commit_reported3).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed3' act = commit_failed3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported3' act = commit_reported3 ).

    "Custom rollback for this case
    DELETE FROM zics_protocols WHERE MYKEY = @ls_protocol-mykey.
    COMMIT WORK.

  ENDMETHOD.


  METHOD delete_already_checked_cust.

    "Create protocol-entry (finding)
    DATA: ls_dataexistance TYPE zics_data_exist.

    try.
        ls_dataexistance-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
    catch cx_uuid_error into data(lo_x).
        "message lo_x->get_text( ) type 'E'.
    endtry.

    begin_date = cl_abap_context_info=>get_system_date( ) - 4.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    ls_dataexistance-client = sy-mandt.
    ls_dataexistance-findingid      = '9999'.
    ls_dataexistance-categoryid    = category_mock_data[ 1 ]-CategoryID.
    ls_dataexistance-findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID.
    ls_dataexistance-validfrom       = begin_date.
    ls_dataexistance-validto   = end_date.
    ls_dataexistance-dataset    = dataset_mock_data[ 1 ]-DatasetID.
    ls_dataexistance-checktype  = checktypes_mock_data[ 1 ]-CheckTypeID.
    ls_dataexistance-useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID.
    GET TIME STAMP FIELD DATA(ts).
    ls_dataexistance-last_changed_at = ts.
    ls_dataexistance-created_at = ts.
    ls_dataexistance-last_changed_by = sy-uname.
    ls_dataexistance-created_by = sy-uname.
    ls_dataexistance-last_check = cl_abap_context_info=>get_system_date(  ) + 5.

    INSERT zics_data_exist FROM @ls_dataexistance.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

    "Try to delete the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        DELETE FROM
        VALUE #( ( mykey = ls_dataexistance-mykey ) )
        MAPPED DATA(mapped)
        FAILED DATA(failed)
        REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_equals( act = lines( failed-datasetexistancecheck ) exp = 1 ).
    READ TABLE failed-datasetexistancecheck INDEX 1 INTO DATA(ls_failed).
    cl_abap_unit_assert=>assert_equals( act = ls_failed-%fail-cause exp = if_abap_behv=>cause-disabled ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_mapped' act = mapped ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported' act = reported ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Custom rollback for this case
    DELETE FROM zics_data_exist WHERE MYKEY = @ls_dataexistance-mykey.
    COMMIT WORK.

  ENDMETHOD.


  METHOD edit_not_checked_cust.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    DATA: lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to edit the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        UPDATE SET FIELDS WITH
        VALUE #( (
                   %key-mykey = lv_uuid_x16_cust
                   %Data-dataset = '0008'
                    ) )
        FAILED DATA(failed2)
        REPORTED DATA(reported2).

    cl_abap_unit_assert=>assert_initial( msg = 'delete_failed2' act = failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported2' act = reported2 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed2)
     REPORTED DATA(commit_reported2).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed2' act = commit_failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported2' act = commit_reported2 ).

  ENDMETHOD.


  METHOD edit_already_checked_cust.

    "Create protocol-entry (finding)
    DATA: ls_dataexistance TYPE zics_data_exist.

    try.
        ls_dataexistance-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
    catch cx_uuid_error into data(lo_x).
        "message lo_x->get_text( ) type 'E'.
    endtry.

    begin_date = cl_abap_context_info=>get_system_date( ) - 4.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    ls_dataexistance-client = sy-mandt.
    ls_dataexistance-findingid      = '9999'.
    ls_dataexistance-categoryid    = category_mock_data[ 1 ]-CategoryID.
    ls_dataexistance-findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID.
    ls_dataexistance-validfrom       = begin_date.
    ls_dataexistance-validto   = end_date.
    ls_dataexistance-dataset    = dataset_mock_data[ 1 ]-DatasetID.
    ls_dataexistance-checktype  = checktypes_mock_data[ 1 ]-CheckTypeID.
    ls_dataexistance-useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID.
    GET TIME STAMP FIELD DATA(ts).
    ls_dataexistance-last_changed_at = ts.
    ls_dataexistance-created_at = ts.
    ls_dataexistance-last_changed_by = sy-uname.
    ls_dataexistance-created_by = sy-uname.
    ls_dataexistance-last_check = cl_abap_context_info=>get_system_date( ) + 5.

    INSERT zics_data_exist FROM @ls_dataexistance.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

    "Try to edit the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        UPDATE SET FIELDS WITH
        VALUE #( (
                   %key-mykey = ls_dataexistance-mykey
                   %Data-dataset = '0008'
                    ) )
        FAILED DATA(failed)
        REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_equals( act = lines( failed-datasetexistancecheck ) exp = 1 ).
    READ TABLE failed-datasetexistancecheck INDEX 1 INTO DATA(ls_failed).
    cl_abap_unit_assert=>assert_equals( act = ls_failed-%fail-cause exp = if_abap_behv=>cause-disabled ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported' act = reported ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Custom rollback for this case
    DELETE FROM zics_data_exist WHERE MYKEY = @ls_dataexistance-mykey.
    COMMIT WORK.

  ENDMETHOD.


  METHOD delete_not_checked_cust.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    DATA: lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to delete the created customizing-entry
    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        DELETE FROM
        VALUE #( ( mykey = lv_uuid_x16_cust ) )
        MAPPED DATA(mapped2)
        FAILED DATA(failed2)
        REPORTED DATA(reported2).


    cl_abap_unit_assert=>assert_initial( msg = 'delete_mapped2' act = mapped2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_failed2' act = failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delete_reported2' act = reported2 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed2)
     REPORTED DATA(commit_reported2).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed2' act = commit_failed2 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported2' act = commit_reported2 ).

  ENDMETHOD.


  METHOD teardown.
    " clean up any involved entity
    ROLLBACK ENTITIES.
  ENDMETHOD.


  METHOD create_fromdate_GT_maxdate.
    "Beginndatum ist größer als endedatum: FEHLER

    begin_date = cl_abap_context_info=>get_system_date( ) + 31.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed ) exp = 1 ).


    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.

    ls_msgno_exp-msgno = 003.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

  ENDMETHOD.

  METHOD create_fromdate_LT_mindate.
    "Satz wird in die Vergangenheit angelegt: FEHLER

    begin_date = cl_abap_context_info=>get_system_date( ) - 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    Types tt_reported TYPE TABLE FOR REPORTED zi_ics_data_existance.
    DATA: lt_reported TYPE tt_reported,
          ls_reported LIKE LINE OF lt_reported.

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed ) exp = 1 ).


    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.
    ls_msgno_exp-msgno = 004.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

  ENDMETHOD.


  METHOD create_valid_dates.
    "Satz wird in die Zukunft angelegt: KEIN FEHLER
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed'   act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

  ENDMETHOD.


  METHOD setup.
    " clear the test doubles per test
    cds_test_environment->clear_doubles(  ).
    sql_test_environment->clear_doubles(  ).
    " insert test data into test doubles
    sql_test_environment->insert_test_data( category_mock_data      ).
    sql_test_environment->insert_test_data( findingtype_mock_data   ).
    sql_test_environment->insert_test_data( systemtypes_mock_data   ).
    sql_test_environment->insert_test_data( dataset_mock_data       ).
    sql_test_environment->insert_test_data( checktypes_mock_data    ).
    sql_test_environment->insert_test_data( useinlinked_mock_data   ).
    sql_test_environment->insert_test_data( text_mock_data          ).
  ENDMETHOD.

  METHOD DELIMIT_WITHOUT_OCC_IN_FINDING.
    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = '99991231'."cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       "findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to edit the created customizing-entry
    DATA: delimitDate TYPE dats.

    delimitDate = cl_abap_context_info=>get_system_date( ) + 20.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        EXECUTE delimitEntry
            FROM VALUE #( (
                %cid = 'ROOT2'
                %key-mykey = lv_uuid_x16_cust
                %param-new_delimitation = delimitDate
                )
            )

        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_equals( act = lines( failed3-datasetexistancecheck ) exp = 2 ).
    READ TABLE failed3-datasetexistancecheck INDEX 1 INTO DATA(ls_failed).
    cl_abap_unit_assert=>assert_equals( act = ls_failed-%fail-cause exp = if_abap_behv=>cause-dependency ).
    READ TABLE failed3-datasetexistancecheck INDEX 2 INTO ls_failed.
    cl_abap_unit_assert=>assert_equals( act = ls_failed-%fail-cause exp = if_abap_behv=>cause-disabled ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_reported' act = reported3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_mapped' act = mapped3 ).

  ENDMETHOD.

  METHOD DELIMIT_WITH_OCC_IN_FINDING.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = '99991231'."cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck  )
      WITH VALUE #( (  %cid = 'ROOT1'
                       "findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: ls_protocol TYPE zics_protocols,
          lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    READ ENTITY zi_ics_data_existance\\DatasetExistanceCheck
        FROM VALUE #( ( %key-mykey = lv_uuid_x16_cust
                                 %control   = VALUE #( findingid = if_abap_behv=>mk-on
                                                       validfrom = if_abap_behv=>mk-on
                                                       validto   = if_abap_behv=>mk-on )
                               )
        )
        RESULT DATA(lt_dataExistanceResult).

    try.
        ls_protocol-mykey = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
    catch cx_uuid_error into data(lo_x).
        "message lo_x->get_text( ) type 'E'.
    endtry.

    ls_protocol-client = sy-mandt.
    ls_protocol-employeeid = 12345678.
    ls_protocol-firstname = 'Edward'.
    ls_protocol-lastname = 'Wasserkopf'.
    ls_protocol-employee_subgroup = 'DB'.
    ls_protocol-findingid = lt_dataExistanceResult[ 1 ]-findingid.
    ls_protocol-findingtypeid = '02'.
    ls_protocol-checkclass = 'DataExistenceCheck'.
    ls_protocol-findingkey = lv_uuid_x16_cust.
    ls_protocol-furtherinformation = 'This is a test.'.
    ls_protocol-validfrom = cl_abap_context_info=>get_system_date( ) + 25.
    ls_protocol-validto = cl_abap_context_info=>get_system_date( ) + 25.
    "GET TIME STAMP FIELD DATA(ts).

    CONVERT DATE ls_protocol-validfrom
        TIME '105936'
        INTO TIME STAMP DATA(ts) TIME ZONE sy-zonlo.

    ls_protocol-last_changed_at = ts.
    ls_protocol-created_at = ts.
    ls_protocol-last_changed_by = sy-uname.
    ls_protocol-created_by = sy-uname.

    INSERT zics_protocols FROM @ls_protocol.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

    "Try to edit the created customizing-entry
    DATA: delimitDate TYPE dats.

    delimitDate = cl_abap_context_info=>get_system_date( ) + 20.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        EXECUTE delimitEntry
            FROM VALUE #( (
                %cid = 'ROOT2'
                %key-mykey = lv_uuid_x16_cust
                %param-new_delimitation = delimitDate
                )
            )

        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_not_initial( msg = 'delimit_mapped3' act = mapped3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_failed3' act = failed3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_reported3' act = reported3 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed_3)
     REPORTED DATA(commit_reported_3).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed_3 ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported_3 ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed_3 ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported_3 ) exp = 1 ).

    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported_3 ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.

    ls_msgno_exp-msgno = 002.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

    ls_msgno_exp-msgno = 005.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

    ROLLBACK ENTITIES.

    "Custom rollback for this case

    DELETE FROM zics_protocols WHERE MYKEY = @ls_protocol-mykey.
    cl_abap_unit_assert=>assert_initial( msg = 'insert' act = sy-subrc ).

    COMMIT WORK.
    cl_abap_unit_assert=>assert_initial( msg = 'commit_work' act = sy-subrc ).

  ENDMETHOD.

  METHOD DELIMIT_ALREADY_CHECKED_CUST.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = '99991231'."cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck
                     )
      WITH VALUE #( (  %cid = 'ROOT1'
                       "findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    SELECT SINGLE * FROM zics_data_exist WHERE mykey = @lv_uuid_x16_cust INTO @DATA(ls_dataExist).

    ls_dataExist-last_check = cl_abap_context_info=>get_system_date( ) + 25.

    CONVERT DATE ls_dataExist-last_check
        TIME '105936'
        INTO TIME STAMP ls_dataExist-last_check TIME ZONE sy-zonlo.

    MODIFY zics_data_exist FROM @ls_dataExist.
    COMMIT WORK.

    "Try to edit the created customizing-entry
    DATA: delimitDate TYPE dats.

    delimitDate = cl_abap_context_info=>get_system_date( ) + 20.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        EXECUTE delimitEntry
            FROM VALUE #( (
                %cid = 'ROOT2'
                %key-mykey = lv_uuid_x16_cust
                %param-new_delimitation = delimitDate
                )
            )

        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_not_initial( msg = 'delimit_mapped3' act = mapped3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_failed3' act = failed3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_reported3' act = reported3 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed_3)
     REPORTED DATA(commit_reported_3).

    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_failed'   act = commit_failed_3 ).
    cl_abap_unit_assert=>assert_not_initial( msg = 'commit_reported' act = commit_reported_3 ).

    cl_abap_unit_assert=>assert_equals( act = lines( commit_failed_3 ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( commit_reported_3 ) exp = 1 ).

    DATA(lt_msgnos) = me->get_msgno_from_reported( commit_reported_3 ).

    DATA: ls_msgno_exp LIKE LINE OF lt_msgnos.

    ls_msgno_exp-msgno = 003.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

    ls_msgno_exp-msgno = 005.

    cl_abap_unit_assert=>assert_table_contains( table = lt_msgnos line = ls_msgno_exp ).

    ROLLBACK ENTITIES.

  ENDMETHOD.

  METHOD DELIMIT_NOT_CHECKED_CUST.

    "Create customizing-entry
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = '99991231'."cl_abap_context_info=>get_system_date( ) + 30.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
    ENTITY DatasetExistanceCheck
    CREATE FIELDS ( categoryid
                    findingtypeid
                    validfrom
                    validto
                    destination
                    featureid
                    dataset
                    checktype
                    useinlinkedcheck
                     )
      WITH VALUE #( (  %cid = 'ROOT1'
                       "findingid      = '9999'
                       categoryid    = category_mock_data[ 1 ]-CategoryID
                       findingtypeid     = findingtype_mock_data[ 1 ]-FindingTypeID
                       validfrom       = begin_date
                       validto   = end_date
                       destination = 'FA404551BC361EEE98F18BF021725012'
                       featureid = 'ACTIVES'
                       dataset    = dataset_mock_data[ 1 ]-DatasetID
                       checktype  = checktypes_mock_data[ 1 ]-CheckTypeID
                       useinlinkedcheck = useinlinked_mock_data[ 1 ]-UseInLinkedID
                    ) )
      MAPPED   DATA(mapped)
      FAILED   DATA(failed)
      REPORTED DATA(reported).

    cl_abap_unit_assert=>assert_initial( msg = 'create_failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'create_reported' act = reported ).
    cl_abap_unit_assert=>assert_equals( act = lines( mapped-datasetexistancecheck ) exp = 1 ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed)
     REPORTED DATA(commit_reported).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed' act = commit_failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported ).

    "Create protocol-entry (finding)
    DATA: lv_uuid_x16_cust TYPE sysuuid_x16.

    READ TABLE mapped-datasetexistancecheck INDEX 1 INTO DATA(ls_mapped).
    lv_uuid_x16_cust = ls_mapped-mykey.

    "Try to edit the created customizing-entry
    DATA: delimitDate TYPE dats.

    delimitDate = cl_abap_context_info=>get_system_date( ) + 20.

    MODIFY ENTITIES OF ZI_ICS_DATA_EXISTANCE
        ENTITY DatasetExistanceCheck
        EXECUTE delimitEntry
            FROM VALUE #( (
                %cid = 'ROOT2'
                %key-mykey = lv_uuid_x16_cust
                %param-new_delimitation = delimitDate
                )
            )

        MAPPED DATA(mapped3)
        FAILED DATA(failed3)
        REPORTED DATA(reported3).

    cl_abap_unit_assert=>assert_initial( msg = 'delimit_mapped3' act = mapped3 ).

    cl_abap_unit_assert=>assert_not_initial( msg = 'delimit_failed3' act = failed3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'delimit_reported3' act = reported3 ).

    cl_abap_unit_assert=>assert_equals( act = lines( failed3-datasetexistancecheck ) exp = 2 ).
    READ TABLE failed3-datasetexistancecheck INDEX 1 INTO DATA(ls_failed3).
    cl_abap_unit_assert=>assert_equals( act = ls_failed3-%fail-cause exp = if_abap_behv=>cause-dependency ).
    READ TABLE failed3-datasetexistancecheck INDEX 2 INTO ls_failed3.
    cl_abap_unit_assert=>assert_equals( act = ls_failed3-%fail-cause exp = if_abap_behv=>cause-disabled ).

    COMMIT ENTITIES RESPONSES
     FAILED   DATA(commit_failed_3)
     REPORTED DATA(commit_reported_3).

    cl_abap_unit_assert=>assert_initial( msg = 'commit_failed'   act = commit_failed_3 ).
    cl_abap_unit_assert=>assert_initial( msg = 'commit_reported' act = commit_reported_3 ).

  ENDMETHOD.

ENDCLASS.
